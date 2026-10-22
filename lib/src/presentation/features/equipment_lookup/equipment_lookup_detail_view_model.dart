import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/get_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';

class EquipmentLookupDetailViewModel extends ChangeNotifier {
  EquipmentLookupDetailViewModel({
    required this.equipmentId,
    required GetEquipmentLookupUseCase getEquipmentLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ListAssetLookupPageUseCase listAssetLookupPageUseCase,
  }) : _getEquipmentLookupUseCase = getEquipmentLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _listAssetLookupPageUseCase = listAssetLookupPageUseCase;

  final String equipmentId;
  final GetEquipmentLookupUseCase _getEquipmentLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ListAssetLookupPageUseCase _listAssetLookupPageUseCase;

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
