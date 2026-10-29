import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/delete_equipment_use_case.dart';
import '../../../domain/use_cases/get_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/update_equipment_use_case.dart';

class EquipmentLookupDetailViewModel extends ChangeNotifier {
  EquipmentLookupDetailViewModel({
    required this.equipmentId,
    required GetEquipmentLookupUseCase getEquipmentLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ListAssetLookupPageUseCase listAssetLookupPageUseCase,
    required UpdateEquipmentUseCase updateEquipmentUseCase,
    required DeleteEquipmentUseCase deleteEquipmentUseCase,
  }) : _getEquipmentLookupUseCase = getEquipmentLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _listAssetLookupPageUseCase = listAssetLookupPageUseCase,
       _updateEquipmentUseCase = updateEquipmentUseCase,
       _deleteEquipmentUseCase = deleteEquipmentUseCase;

  final String equipmentId;
  final GetEquipmentLookupUseCase _getEquipmentLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ListAssetLookupPageUseCase _listAssetLookupPageUseCase;
  final UpdateEquipmentUseCase _updateEquipmentUseCase;
  final DeleteEquipmentUseCase _deleteEquipmentUseCase;

  Equipment? _equipment;
  List<WorkHistoryItem> _jobs = const [];
  List<AssetLookupRow> _assets = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  Equipment? get equipment => _equipment;
  List<WorkHistoryItem> get jobs => _jobs;
  List<AssetLookupRow> get assets => _assets;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> updateEquipment({
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
  }) async {
    final current = _equipment;
    if (current == null) {
      return;
    }
    final changedFields = [
      if (equipmentName != current.equipmentName) 'equipment_name',
      if (equipmentCode != current.equipmentCode) 'equipment_code',
      if (description != current.description) 'description',
      if (isInactive != current.isInactive) 'inactive',
    ];
    if (changedFields.isEmpty) {
      throw _FormFailure('바뀐 칸이 없습니다.');
    }
    await _updateEquipmentUseCase.execute(
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      equipmentCode: equipmentCode,
      description: description,
      isInactive: isInactive,
      changedFields: changedFields,
    );
    await load();
  }

  Future<void> deleteEquipment() {
    return _deleteEquipmentUseCase.execute(equipmentId: equipmentId);
  }

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _equipment = await _getEquipmentLookupUseCase.execute(
        equipmentId: equipmentId,
      );
      if (_equipment == null) {
        _hasError = true;
        _errorMessage = '장비를 찾지 못했습니다.';
        _jobs = const [];
        _assets = const [];
        return;
      }
      final jobsPage = await _listWorkHistoryPageUseCase.execute(
        query: WorkHistoryQuery.initial().copyWith(equipmentId: equipmentId),
        pageSize: 50,
        pageToken: '',
      );
      _jobs = jobsPage.items;
      final assetsPage = await _listAssetLookupPageUseCase.execute(
        kindCode: '',
        query: '',
        equipmentId: equipmentId,
        unattachedOnly: false,
        pageSize: 50,
        pageToken: '',
      );
      _assets = assetsPage.rows;
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _equipment = null;
      _jobs = const [];
      _assets = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class _FormFailure implements Exception {
  _FormFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
