import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/pipeline_trace_graph.dart';
import '../../../domain/entities/upload_trace.dart';
import '../../../domain/use_cases/trace_use_case.dart';

class PipelineTraceViewModel extends ChangeNotifier {
  PipelineTraceViewModel({
    required TraceUseCase traceUseCase,
  }) : _traceUseCase = traceUseCase;

  /// ListTraces 최근 창 크기. page_token 페이지네이션 없음.
  static const int recentPageSize = 80;

  final TraceUseCase _traceUseCase;

  Timer? _pollTimer;
  int _pollVersion = 0;

  List<TraceSnapshot> _traces = const [];
  TraceSnapshot? _selected;
  /// null = 전체(ListTraces status 비움).
  UploadTraceStatus? _statusFilter;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _tracesSignature = '';
  String _selectionSignature = '';

  List<TraceSnapshot> get traces => List.unmodifiable(_traces);
  TraceSnapshot? get selected => _selected;
  UploadTraceStatus? get statusFilter => _statusFilter;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  /// ListTraces 응답 순서(새것부터). 상태별 재정렬하지 않는다.
  List<TraceSnapshot> get visibleTraces => List.unmodifiable(_traces);

  int get runningCount {
    var n = 0;
    for (final trace in _traces) {
      if (trace.status == UploadTraceStatus.running) {
        n++;
      }
    }
    return n;
  }

  int get doneCount {
    var n = 0;
    for (final trace in _traces) {
      if (trace.status == UploadTraceStatus.done) {
        n++;
      }
    }
    return n;
  }

  int get failedCount {
    var n = 0;
    for (final trace in _traces) {
      if (trace.status == UploadTraceStatus.failed) {
        n++;
      }
    }
    return n;
  }

  Map<String, int> get stageCounts => pipelineStageCounts(visibleTraces);

  Map<String, bool> get stageHasFailed => pipelineStageHasFailed(visibleTraces);

  bool get doesShowToolStage => pipelineListHasToolStage(visibleTraces);

  List<PipelineStageDef> get visibleStages {
    return [
      for (final stage in pipelineStages)
        if (stage.id != 'tool' || doesShowToolStage) stage,
    ];
  }

  /// 커맨드바 「새로고침 주기」와 동일. [intervalSeconds]≤0이면 자동 폴링 중지.
  void applyRefreshInterval(int intervalSeconds) {
    stopPolling();
    unawaited(refresh());
    if (intervalSeconds <= 0) {
      return;
    }
    _pollTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) {
      unawaited(refresh());
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }

  Future<void> refresh() async {
    final version = ++_pollVersion;
    final showLoading = _traces.isEmpty;
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      final listed = await _traceUseCase.listTraces(
        pageSize: recentPageSize,
        status: _statusFilter,
      );
      if (version != _pollVersion) {
        return;
      }
      final enriched = await _enrichListedWithGetTrace(listed, version: version);
      if (version != _pollVersion) {
        return;
      }
      final nextTracesSignature = _signatureOfTraces(enriched);
      var didChange = nextTracesSignature != _tracesSignature;
      if (didChange) {
        _traces = enriched;
        _tracesSignature = nextTracesSignature;
      }
      _hasError = false;
      _errorMessage = '';

      final selectedId = _selected?.traceId ?? '';
      if (selectedId.isNotEmpty) {
        TraceSnapshot? preloaded;
        for (final trace in enriched) {
          if (trace.traceId == selectedId && trace.events.isNotEmpty) {
            preloaded = trace;
            break;
          }
        }
        final selectionChanged = await _loadSelection(
          selectedId,
          version: version,
          preloaded: preloaded,
        );
        didChange = didChange || selectionChanged;
      }

      if (version != _pollVersion) {
        return;
      }
      if (showLoading) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      if (didChange) {
        notifyListeners();
      }
    } catch (error) {
      if (version != _pollVersion) {
        return;
      }
      final message = error.toString();
      if (!_hasError || _errorMessage != message || showLoading) {
        _hasError = true;
        _errorMessage = message;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> didSelectTrace(String traceId) async {
    if (traceId.isEmpty) {
      return;
    }
    if (_selected?.traceId == traceId) {
      return;
    }
    final version = _pollVersion;
    TraceSnapshot? preloaded;
    for (final trace in _traces) {
      if (trace.traceId == traceId && trace.events.isNotEmpty) {
        preloaded = trace;
        break;
      }
    }
    await _loadSelection(traceId, version: version, preloaded: preloaded);
    notifyListeners();
  }

  Future<void> didSelectStatusFilter(UploadTraceStatus? status) async {
    if (_statusFilter == status) {
      return;
    }
    _statusFilter = status;
    notifyListeners();
    await refresh();
  }

  void didClearSelection() {
    if (_selected == null) {
      return;
    }
    _selected = null;
    _selectionSignature = '';
    notifyListeners();
  }

  /// ListTraces 요약에 RUNNING(+선택) GetTrace events를 붙인다.
  Future<List<TraceSnapshot>> _enrichListedWithGetTrace(
    List<TraceSnapshot> listed, {
    required int version,
  }) async {
    final selectedId = _selected?.traceId ?? '';
    final ids = <String>{};
    for (final trace in listed) {
      if (trace.status == UploadTraceStatus.running) {
        ids.add(trace.traceId);
      }
    }
    if (selectedId.isNotEmpty) {
      ids.add(selectedId);
    }

    final details = <String, TraceSnapshot>{};
    if (ids.isNotEmpty) {
      await Future.wait([
        for (final id in ids)
          _fetchTraceDetail(id).then((detail) {
            if (detail != null) {
              details[id] = detail;
            }
          }),
      ]);
    }
    if (version != _pollVersion) {
      return listed;
    }

    return [
      for (final listedTrace in listed)
        details[listedTrace.traceId] ??
            _listedWithPriorEvents(listedTrace),
    ];
  }

  Future<TraceSnapshot?> _fetchTraceDetail(String traceId) async {
    try {
      return await _traceUseCase.getTrace(traceId: traceId);
    } catch (_) {
      return null;
    }
  }

  /// GetTrace를 안 부른 DONE/FAILED는 직전 폴링 events를 유지한다.
  TraceSnapshot _listedWithPriorEvents(TraceSnapshot listed) {
    if (listed.events.isNotEmpty) {
      return listed;
    }
    TraceSnapshot? prior;
    for (final trace in _traces) {
      if (trace.traceId == listed.traceId) {
        prior = trace;
        break;
      }
    }
    if (prior == null || prior.events.isEmpty) {
      return listed;
    }
    return TraceSnapshot(
      traceId: listed.traceId,
      fileName: listed.fileName,
      lastEvent: listed.lastEvent,
      status: listed.status,
      errorMessage: listed.errorMessage,
      progressPercent: listed.progressPercent,
      run: listed.run ?? prior.run,
      events: prior.events,
    );
  }

  /// 선택이 바뀌었으면 true. [preloaded]가 있으면 GetTrace를 다시 치지 않는다.
  Future<bool> _loadSelection(
    String traceId, {
    required int version,
    TraceSnapshot? preloaded,
  }) async {
    try {
      final detail =
          preloaded ?? await _traceUseCase.getTrace(traceId: traceId);
      if (version != _pollVersion) {
        return false;
      }
      final nextSignature = detail.pollSignature;
      if (nextSignature == _selectionSignature) {
        return false;
      }
      _selected = detail;
      _selectionSignature = nextSignature;
      return true;
    } catch (_) {
      if (version != _pollVersion) {
        return false;
      }
      if (_selected == null) {
        return false;
      }
      _selected = null;
      _selectionSignature = '';
      return true;
    }
  }

  String _signatureOfTraces(List<TraceSnapshot> traces) {
    return [
      for (final trace in traces) trace.pollSignature,
    ].join('\n');
  }
}
