import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/pipeline_trace_graph.dart';
import '../../../domain/entities/tool_run.dart';
import '../../../domain/entities/upload_trace.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/trace_use_case.dart';

class PipelineTraceViewModel extends ChangeNotifier {
  PipelineTraceViewModel({
    required TraceUseCase traceUseCase,
    required ToolRunUseCase toolRunUseCase,
  }) : _traceUseCase = traceUseCase,
       _toolRunUseCase = toolRunUseCase;

  /// ListTraces 최근 창 크기. page_token 페이지네이션 없음.
  static const int recentPageSize = 80;

  final TraceUseCase _traceUseCase;
  final ToolRunUseCase _toolRunUseCase;

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
  ToolRunQueue? _selectedQueue;
  String _queueError = '';
  String _queueEmptyMessage = '';

  List<TraceSnapshot> get traces => List.unmodifiable(_traces);
  TraceSnapshot? get selected => _selected;
  UploadTraceStatus? get statusFilter => _statusFilter;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  ToolRunQueue? get selectedQueue => _selectedQueue;
  List<ToolRunSnapshot> get queueFrontRuns =>
      List.unmodifiable(_selectedQueue?.runs ?? const []);
  String get queueError => _queueError;
  String get queueEmptyMessage => _queueEmptyMessage;
  /// 선택 runId. 미선택이면 RUNNING+queue 첫 줄의 runId(앞줄 ● 강조).
  String get selectedRunId => _queueFocusTrace?.run?.runId ?? '';
  bool get doesShowQueueFront => _queueNameForFront.isNotEmpty;

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

  bool get doesShowEmbedStage => pipelineListHasEmbedStage(visibleTraces);

  List<PipelineStageDef> get visibleStages {
    return [
      for (final stage in pipelineStages)
        if ((stage.id != 'tool' || doesShowToolStage) &&
            (stage.id != 'embed' || doesShowEmbedStage))
          stage,
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
        _debugLogLitCells(enriched);
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
      final queueChanged = await _refreshQueueFront(version: version);
      didChange = didChange || queueChanged;

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
    await _refreshQueueFront(version: version);
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
    unawaited(refresh());
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

  /// 선택(우선) 또는 RUNNING+queue 첫 줄. ● 강조용. 없으면 null.
  TraceSnapshot? get _queueFocusTrace {
    final selectedQueue = _selected?.run?.queue.trim() ?? '';
    if (_selected != null && selectedQueue.isNotEmpty) {
      return _selected;
    }
    for (final trace in _traces) {
      if (trace.status != UploadTraceStatus.running) {
        continue;
      }
      if ((trace.run?.queue.trim() ?? '').isEmpty) {
        continue;
      }
      return trace;
    }
    return null;
  }

  /// 포커스 queue가 없으면 postprocess를 기본으로 앞줄을 유지한다.
  static const String _defaultQueueName = 'postprocess';

  String get _queueNameForFront {
    final focused = _queueFocusTrace?.run?.queue.trim() ?? '';
    if (focused.isNotEmpty) {
      return focused;
    }
    return _defaultQueueName;
  }

  /// [_queueNameForFront]로 GetQueue 앞줄을 맞춘다. 바뀌었으면 true.
  Future<bool> _refreshQueueFront({required int version}) async {
    final queueName = _queueNameForFront;
    try {
      final queues = await _toolRunUseCase.getQueue();
      if (version != _pollVersion) {
        return false;
      }
      final matched = toolRunQueueMatching(queues, queueName);
      final nextError = '';
      final nextEmpty = matched == null ? '같은 이름의 대기열이 없습니다.' : '';
      final sameQueue = _selectedQueue?.queue == matched?.queue &&
          _selectedQueue?.workers == matched?.workers &&
          _selectedQueue?.running == matched?.running &&
          _selectedQueue?.waiting == matched?.waiting &&
          _queueRunsSignature(_selectedQueue?.runs) ==
              _queueRunsSignature(matched?.runs);
      if (sameQueue &&
          _queueError == nextError &&
          _queueEmptyMessage == nextEmpty) {
        return false;
      }
      _selectedQueue = matched;
      _queueError = nextError;
      _queueEmptyMessage = nextEmpty;
      return true;
    } catch (error) {
      if (version != _pollVersion) {
        return false;
      }
      final message = error.toString().trim().isEmpty
          ? '대기열을 불러오지 못했습니다.'
          : error.toString();
      final nextMessage =
          message.contains('대기열') ? message : '대기열을 불러오지 못했습니다.';
      if (_queueError == nextMessage && _selectedQueue == null) {
        return false;
      }
      _selectedQueue = null;
      _queueEmptyMessage = '';
      _queueError = nextMessage;
      return true;
    }
  }

  String _queueRunsSignature(List<ToolRunSnapshot>? runs) {
    if (runs == null || runs.isEmpty) {
      return '';
    }
    return [
      for (final run in runs) run.pollSignature,
    ].join('\n');
  }

  String _signatureOfTraces(List<TraceSnapshot> traces) {
    return [
      for (final trace in traces) trace.pollSignature,
    ].join('\n');
  }

  void _debugLogLitCells(List<TraceSnapshot> traces) {
    if (!kDebugMode) {
      return;
    }
    for (final trace in traces) {
      if (trace.status != UploadTraceStatus.running &&
          _selected?.traceId != trace.traceId) {
        continue;
      }
      final events = [
        for (final event in trace.events) '${event.name}:${event.status}',
      ].join(',');
      debugPrint(
        '[pipeline] id=${trace.traceId} status=${trace.status.name} '
        'last=${trace.lastEvent} stage=${trace.stageId} events=[$events]',
      );
    }
    final lit = <String>[];
    final failedByStage = <String, List<String>>{};
    for (final stage in visibleStages) {
      final visual = pipelineStageVisual(
        stageId: stage.id,
        selected: _selected,
        traces: traces,
      );
      if (visual == PipelineNodeVisual.idle) {
        continue;
      }
      lit.add('${stage.id}:${visual.name}');
      if (visual != PipelineNodeVisual.failed) {
        continue;
      }
      failedByStage[stage.id] = [
        for (final trace in traces)
          if (trace.status == UploadTraceStatus.failed &&
              trace.stageId == stage.id)
            trace.traceId,
      ];
    }
    if (lit.isNotEmpty) {
      debugPrint('[pipeline] cells ${lit.join(' ')}');
    }
    for (final entry in failedByStage.entries) {
      if (entry.value.isEmpty) {
        continue;
      }
      debugPrint(
        '[pipeline] ${entry.key}:failed by id=${entry.value.join(',')}',
      );
    }
  }
}
