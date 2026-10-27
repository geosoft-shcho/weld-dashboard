import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/entities/tool_run.dart';
import '../../../domain/use_cases/get_asset_lookup_use_case.dart';
import '../../../domain/use_cases/list_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/update_asset_use_case.dart';

class AssetLookupDetailViewModel extends ChangeNotifier {
  AssetLookupDetailViewModel({
    required this.assetId,
    required GetAssetLookupUseCase getAssetLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ListEquipmentLookupUseCase listEquipmentLookupUseCase,
    required UpdateAssetUseCase updateAssetUseCase,
    required ToolRunUseCase toolRunUseCase,
  }) : _getAssetLookupUseCase = getAssetLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _listEquipmentLookupUseCase = listEquipmentLookupUseCase,
       _updateAssetUseCase = updateAssetUseCase,
       _toolRunUseCase = toolRunUseCase;

  final String assetId;
  final GetAssetLookupUseCase _getAssetLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ListEquipmentLookupUseCase _listEquipmentLookupUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;
  final ToolRunUseCase _toolRunUseCase;

  AssetLookupRow? _asset;
  List<WorkHistoryItem> _jobs = const [];
  List<Equipment> _equipment = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  AssetLookupRow? get asset => _asset;
  List<WorkHistoryItem> get jobs => _jobs;
  bool get isLoading => _isLoading;
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
