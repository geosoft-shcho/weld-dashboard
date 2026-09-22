import 'package:flutter/foundation.dart';

import '../../../domain/entities/joint.dart';
import '../../../domain/entities/work_history_board.dart';
import '../../../domain/entities/work_history_catalog.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/load_work_history_catalog_use_case.dart';
import '../../../domain/use_cases/query_work_history_use_case.dart';

class WorkHistoryViewModel extends ChangeNotifier {
  WorkHistoryViewModel({
    required LoadWorkHistoryCatalogUseCase loadWorkHistoryCatalogUseCase,
    required QueryWorkHistoryUseCase queryWorkHistoryUseCase,
  }) : _loadWorkHistoryCatalogUseCase = loadWorkHistoryCatalogUseCase,
       _queryWorkHistoryUseCase = queryWorkHistoryUseCase;

  final LoadWorkHistoryCatalogUseCase _loadWorkHistoryCatalogUseCase;
  final QueryWorkHistoryUseCase _queryWorkHistoryUseCase;

  WorkHistoryQuery _query = WorkHistoryQuery.initial();
  WorkHistoryQuery? _loadedQuery;
  WorkHistoryCatalog? _catalog;
  WorkHistoryBoard? _board;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;

  WorkHistoryQuery get query => _query;
  WorkHistoryBoard? get board => _board;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get doesHaveInvalidDateRange => _query.doesHaveInvalidDateRange;

  bool get doesHavePendingFilters {
    final loaded = _loadedQuery;
    if (loaded == null) {
      return false;
    }
    return !_query.matchesDeferredFilters(loaded);
  }

  /// draft 작업지시 기준 조인트 옵션(표는 마지막 조회 결과 유지).
  List<Joint> get jointOptions {
    final catalog = _catalog;
    if (catalog == null) {
      return const [];
    }
    final workOrderId = _query.workOrderId;
    if (workOrderId.isEmpty) {
      return catalog.joints;
    }
    return [
      for (final joint in catalog.joints)
        if (joint.workOrderId == workOrderId) joint,
    ];
  }

  Future<void> loadBoard() async {
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final catalog = await _loadWorkHistoryCatalogUseCase.execute(
        query: _query,
      );
      if (version != _loadVersion) {
        return;
      }
      _catalog = catalog;
      _loadedQuery = _query;
      _applyQuery();
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _board = null;
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void didChangeCommonKey(String commonKey) {
    _editFilters((query) => query.copyWith(commonKey: commonKey));
  }

  void didSelectWorkOrder(String workOrderId) {
    _editFilters(
      (query) => query.copyWith(workOrderId: workOrderId, jointId: ''),
    );
  }

  void didSelectJoint(String jointId) {
    _editFilters((query) => query.copyWith(jointId: jointId));
  }

  void didSelectWorker(String workerId) {
    _editFilters((query) => query.copyWith(workerId: workerId));
  }

  void didSelectEquipment(String equipmentId) {
    _editFilters((query) => query.copyWith(equipmentId: equipmentId));
  }

  void didSelectFromDate(DateTime? date) {
    _editFilters(
      (query) => query.copyWith(fromDate: date, clearFromDate: date == null),
    );
  }

  void didSelectToDate(DateTime? date) {
    _editFilters(
      (query) => query.copyWith(toDate: date, clearToDate: date == null),
    );
  }

  void didClearEquipment() {
    didSelectEquipment('');
  }

  void didTapQuery() {
    _query = _query.copyWith(visibleCount: WorkHistoryQuery.BATCH_SIZE);
    loadBoard();
  }

  void didTapReset() {
    _query = WorkHistoryQuery.initial();
    loadBoard();
  }

  void didApplyIncomingFilter({
    required String equipmentId,
    required String workerId,
  }) {
    _query = WorkHistoryQuery.initial().copyWith(
      equipmentId: equipmentId,
      workerId: workerId,
    );
    loadBoard();
  }

  void didSelectRow(String historyId) {
    _query = _query.copyWith(selectedHistoryId: historyId);
    _applyQuery();
  }

  void didScrollNearEnd() {
    final board = _board;
    if (board == null || !board.doesHaveMore || _isLoading) {
      return;
    }
    _query = _query.copyWith(
      visibleCount: _query.visibleCount + WorkHistoryQuery.BATCH_SIZE,
    );
    _applyQuery();
  }

  void didTapReload() {
    loadBoard();
  }

  void _editFilters(WorkHistoryQuery Function(WorkHistoryQuery query) edit) {
    _query = edit(_query);
    notifyListeners();
  }

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    // 표·페이지는 마지막 조회 필터. draft는 칩·드롭다운만 바꾼다.
    final filterQuery = _loadedQuery ?? _query;
    final boardQuery = filterQuery.copyWith(
      selectedHistoryId: _query.selectedHistoryId,
      visibleCount: _query.visibleCount,
    );
    _board = _queryWorkHistoryUseCase.execute(
      catalog: catalog,
      query: boardQuery,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _loadVersion++;
    super.dispose();
  }
}
