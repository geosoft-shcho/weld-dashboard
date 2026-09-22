import 'package:flutter/foundation.dart';

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
      if (version != _loadVersion) return;
      _catalog = catalog;
      _applyQuery();
    } catch (error) {
      if (version != _loadVersion) return;
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
    _query = _query.copyWith(commonKey: commonKey);
  }

  void didSelectWorkOrder(String workOrderId) {
    _query = _query.copyWith(
      workOrderId: workOrderId,
      jointId: '',
      visibleCount: WorkHistoryQuery.BATCH_SIZE,
    );
    loadBoard();
  }

  void didSelectJoint(String jointId) {
    _query = _query.copyWith(
      jointId: jointId,
      visibleCount: WorkHistoryQuery.BATCH_SIZE,
    );
    loadBoard();
  }

  void didSelectWorker(String workerId) {
    _query = _query.copyWith(
      workerId: workerId,
      visibleCount: WorkHistoryQuery.BATCH_SIZE,
    );
    loadBoard();
  }

  void didSelectEquipment(String equipmentId) {
    _query = _query.copyWith(
      equipmentId: equipmentId,
      visibleCount: WorkHistoryQuery.BATCH_SIZE,
    );
    loadBoard();
  }

  void didSelectFromDate(DateTime? date) {
    _query = _query.copyWith(
      fromDate: date,
      clearFromDate: date == null,
      visibleCount: WorkHistoryQuery.BATCH_SIZE,
    );
    loadBoard();
  }

  void didSelectToDate(DateTime? date) {
    _query = _query.copyWith(
      toDate: date,
      clearToDate: date == null,
      visibleCount: WorkHistoryQuery.BATCH_SIZE,
    );
    loadBoard();
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

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    _board = _queryWorkHistoryUseCase.execute(catalog: catalog, query: _query);
    notifyListeners();
  }

  @override
  void dispose() {
    _loadVersion++;
    super.dispose();
  }
}
