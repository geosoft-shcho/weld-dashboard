import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/get_asset_lookup_use_case.dart';
import '../../../domain/use_cases/list_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';

class AssetLookupDetailViewModel extends ChangeNotifier {
  AssetLookupDetailViewModel({
    required this.assetId,
    required GetAssetLookupUseCase getAssetLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ListEquipmentLookupUseCase listEquipmentLookupUseCase,
  }) : _getAssetLookupUseCase = getAssetLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _listEquipmentLookupUseCase = listEquipmentLookupUseCase;

  final String assetId;
  final GetAssetLookupUseCase _getAssetLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ListEquipmentLookupUseCase _listEquipmentLookupUseCase;

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
        return item.equipmentName.isEmpty ? item.equipmentCode : item.equipmentName;
      }
    }
    return equipmentId;
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
