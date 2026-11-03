import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/entities/tool_run.dart';
import '../../../domain/use_cases/get_asset_lookup_use_case.dart';
import '../../../domain/use_cases/list_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/retry_asset_postprocess_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/update_asset_use_case.dart';

/// 후처리 다시 걸기 끝난 뒤 `displayInfoBar`에 넘길 알림.
class AssetPostprocessRetryNotice {
  const AssetPostprocessRetryNotice({
    required this.title,
    required this.message,
    required this.severity,
  });

  final String title;
  final String message;
  final InfoBarSeverity severity;
}

class AssetLookupDetailViewModel extends ChangeNotifier {
  AssetLookupDetailViewModel({
    required this.assetId,
    required GetAssetLookupUseCase getAssetLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ListEquipmentLookupUseCase listEquipmentLookupUseCase,
    required UpdateAssetUseCase updateAssetUseCase,
    required RetryAssetPostprocessUseCase retryAssetPostprocessUseCase,
    required ToolRunUseCase toolRunUseCase,
  }) : _getAssetLookupUseCase = getAssetLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _listEquipmentLookupUseCase = listEquipmentLookupUseCase,
       _updateAssetUseCase = updateAssetUseCase,
       _retryAssetPostprocessUseCase = retryAssetPostprocessUseCase,
       _toolRunUseCase = toolRunUseCase;

  final String assetId;
  final GetAssetLookupUseCase _getAssetLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ListEquipmentLookupUseCase _listEquipmentLookupUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;
  final RetryAssetPostprocessUseCase _retryAssetPostprocessUseCase;
  final ToolRunUseCase _toolRunUseCase;

  AssetLookupRow? _asset;
  List<WorkHistoryItem> _jobs = const [];
  List<Equipment> _equipment = const [];
  bool _isLoading = false;
  bool _isRetryingPostprocess = false;
  bool _hasError = false;
  String _errorMessage = '';

  AssetLookupRow? get asset => _asset;
  List<WorkHistoryItem> get jobs => _jobs;
  bool get isLoading => _isLoading;
  bool get isRetryingPostprocess => _isRetryingPostprocess;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  String equipmentNameOf(String equipmentId) {
    if (equipmentId.isEmpty) {
      return '모름';
    }
    for (final item in _equipment) {
      if (item.equipmentId == equipmentId) {
        return item.equipmentName.isEmpty
            ? item.equipmentCode
            : item.equipmentName;
      }
    }
    return equipmentId;
  }

  Future<String> readContent({required String url}) {
    return _getAssetLookupUseCase.readContent(url: url);
  }

  Future<void> updateSubjectSituation({
    required String subject,
    required String situation,
    DateTime? recordedAt,
  }) async {
    final current = _asset;
    if (current == null) {
      return;
    }
    final changedFields = [
      if (subject != current.subject) 'subject',
      if (situation != current.situation) 'situation',
      if (recordedAt != null && recordedAt != current.recordedAt) 'recorded_at',
    ];
    if (changedFields.isEmpty) {
      throw ArgumentError('바뀐 칸이 없습니다.');
    }
    final replaceRunId = await _updateAssetUseCase.execute(
      assetId: assetId,
      subject: subject,
      situation: situation,
      recordedAt: recordedAt,
      changedFields: changedFields,
    );
    if (replaceRunId.isNotEmpty) {
      await _waitReplaceRun(replaceRunId);
    }
    await load();
  }

  Future<void> _waitReplaceRun(String runId) async {
    while (true) {
      final run = await _toolRunUseCase.getRun(runId: runId);
      if (run.status == ToolRunStatus.succeeded) {
        return;
      }
      if (run.status == ToolRunStatus.failed) {
        throw StateError(
          run.errorMessage.isEmpty ? '시각 다시 놓기에 실패했습니다.' : run.errorMessage,
        );
      }
      if (run.status == ToolRunStatus.canceled) {
        throw StateError('시각 다시 놓기가 취소되었습니다.');
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  Future<AssetPostprocessRetryNotice?> retryPostprocess() async {
    final current = _asset;
    if (current == null || !current.postprocess.isFailed) {
      return null;
    }
    if (_isRetryingPostprocess) {
      return null;
    }
    _isRetryingPostprocess = true;
    notifyListeners();
    try {
      final runId = await _retryAssetPostprocessUseCase.execute(
        assetId: assetId,
      );
      final run = await _waitPostprocessRun(runId);
      await load();
      return _noticeFrom(run: run, reloaded: _asset?.postprocess);
    } catch (error) {
      return AssetPostprocessRetryNotice(
        title: '후처리 다시 걸기 실패',
        message: error.toString(),
        severity: InfoBarSeverity.error,
      );
    } finally {
      _isRetryingPostprocess = false;
      notifyListeners();
    }
  }

  Future<ToolRunSnapshot> _waitPostprocessRun(String runId) async {
    while (true) {
      final run = await _toolRunUseCase.getRun(runId: runId);
      if (run.status == ToolRunStatus.succeeded ||
          run.status == ToolRunStatus.failed ||
          run.status == ToolRunStatus.canceled) {
        return run;
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  AssetPostprocessRetryNotice _noticeFrom({
    required ToolRunSnapshot run,
    required AssetPostprocessSummary? reloaded,
  }) {
    final statusLabel = AssetPostprocessStatusOption.labelOf(
      reloaded?.statusCode.isNotEmpty == true
          ? reloaded!.statusCode
          : _statusCodeOf(run.status),
    );
    final reason = run.errorMessage.isNotEmpty
        ? run.errorMessage
        : (reloaded?.errorMessage ?? '');
    final lines = <String>[
      '실행 ${run.runId}',
      'GetRun · ${_runStatusLabel(run.status)}',
      '재조회 · $statusLabel',
      if (reason.isNotEmpty) '사유 · $reason',
    ];
    switch (run.status) {
      case ToolRunStatus.succeeded:
        return AssetPostprocessRetryNotice(
          title: '후처리 완료',
          message: lines.join('\n'),
          severity: InfoBarSeverity.success,
        );
      case ToolRunStatus.failed:
        return AssetPostprocessRetryNotice(
          title: '후처리 실패',
          message: lines.join('\n'),
          severity: InfoBarSeverity.error,
        );
      case ToolRunStatus.canceled:
        return AssetPostprocessRetryNotice(
          title: '후처리 취소',
          message: lines.join('\n'),
          severity: InfoBarSeverity.error,
        );
      case ToolRunStatus.queued:
      case ToolRunStatus.running:
        return AssetPostprocessRetryNotice(
          title: '후처리 진행',
          message: lines.join('\n'),
          severity: InfoBarSeverity.info,
        );
    }
  }

  String _statusCodeOf(ToolRunStatus status) {
    switch (status) {
      case ToolRunStatus.queued:
        return 'queued';
      case ToolRunStatus.running:
        return 'running';
      case ToolRunStatus.succeeded:
        return 'succeeded';
      case ToolRunStatus.failed:
        return 'failed';
      case ToolRunStatus.canceled:
        return 'canceled';
    }
  }

  String _runStatusLabel(ToolRunStatus status) {
    return AssetPostprocessStatusOption.labelOf(_statusCodeOf(status));
  }

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _equipment = await _listEquipmentLookupUseCase.execute();
      final asset = await _getAssetLookupUseCase.execute(assetId: assetId);
      _asset = asset;
      if (asset == null) {
        _hasError = true;
        _errorMessage = '에셋을 찾지 못했습니다.';
        _jobs = const [];
        return;
      }
      final page = await _listWorkHistoryPageUseCase.execute(
        query: WorkHistoryQuery.initial().copyWith(assetId: assetId),
        pageSize: 50,
        pageToken: '',
      );
      _jobs = page.items;
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _asset = null;
      _jobs = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
