import 'package:flutter/foundation.dart';

import '../../../domain/entities/joint.dart';
import '../../../domain/entities/work_history_board.dart';
import '../../../domain/entities/work_history_catalog.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';

class WorkHistoryViewModel extends ChangeNotifier {
  WorkHistoryViewModel({
    required LoadWorkHistoryMastersUseCase loadWorkHistoryMastersUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
  }) : _loadWorkHistoryMastersUseCase = loadWorkHistoryMastersUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase;

  final LoadWorkHistoryMastersUseCase _loadWorkHistoryMastersUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;

  WorkHistoryQuery _query = WorkHistoryQuery.initial();
  WorkHistoryQuery? _loadedQuery;
  WorkHistoryCatalog? _masters;
  List<WorkHistoryItem> _loadedItems = const [];
  int _totalCount = 0;
  WorkHistoryBoard? _board;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  int _moreVersion = 0;

  WorkHistoryQuery get query => _query;
  WorkHistoryBoard? get board => _board;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
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
    final masters = _masters;
    if (masters == null) {
      return const [];
    }
    final workOrderId = _query.workOrderId;
    if (workOrderId.isEmpty) {
      return masters.joints;
    }
    return [
      for (final joint in masters.joints)
        if (joint.workOrderId == workOrderId) joint,
    ];
  }

  Future<void> loadBoard() async {
    final version = ++_loadVersion;
    _moreVersion++;
    _isLoading = true;
    _isLoadingMore = false;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final masters = await _loadWorkHistoryMastersUseCase.execute();
      if (version != _loadVersion) {
        return;
      }
      _masters = masters;
      if (_query.doesHaveInvalidDateRange) {
        _loadedItems = const [];
        _totalCount = 0;
        _loadedQuery = _query;
        _rebuildBoard();
        return;
      }
      final page = await _listWorkHistoryPageUseCase.execute(
        query: _query,
        limit: WorkHistoryQuery.BATCH_SIZE,
        offset: 0,
      );
      if (version != _loadVersion) {
        return;
      }
      _loadedItems = page.items;
      _totalCount = page.totalCount;
      _loadedQuery = _query;
      _rebuildBoard();
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
    if (_query.commonKey == commonKey) {
      return;
    }
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
    _rebuildBoard();
  }

  Future<void> didScrollNearEnd() async {
    final loadedQuery = _loadedQuery;
    final board = _board;
    if (loadedQuery == null ||
        board == null ||
        !board.doesHaveMore ||
        _isLoading ||
        _isLoadingMore) {
      return;
    }
    final version = ++_moreVersion;
    final loadVersionAtStart = _loadVersion;
    final offset = _loadedItems.length;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _listWorkHistoryPageUseCase.execute(
        query: loadedQuery,
        limit: WorkHistoryQuery.BATCH_SIZE,
        offset: offset,
      );
      if (version != _moreVersion || loadVersionAtStart != _loadVersion) {
        return;
      }
      final existingIds = {for (final item in _loadedItems) item.historyId};
      _loadedItems = [
        ..._loadedItems,
        for (final item in page.items)
          if (!existingIds.contains(item.historyId)) item,
      ];
      _totalCount = page.totalCount;
      _rebuildBoard();
    } catch (_) {
      // 기존 목록 유지. more 실패는 치명적이지 않음.
    } finally {
      if (version == _moreVersion) {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  void didTapReload() {
    loadBoard();
  }

  void _editFilters(WorkHistoryQuery Function(WorkHistoryQuery query) edit) {
    _query = edit(_query);
    notifyListeners();
  }

  void _rebuildBoard() {
    final masters = _masters;
    if (masters == null) {
      return;
    }
    final filterQuery = _loadedQuery ?? _query;
    final joints = filterQuery.workOrderId.isEmpty
        ? masters.joints
        : [
            for (final joint in masters.joints)
              if (joint.workOrderId == filterQuery.workOrderId) joint,
          ];
    _board = WorkHistoryBoard(
      query: filterQuery.copyWith(
        selectedHistoryId: _query.selectedHistoryId,
      ),
      visibleRows: _loadedItems,
      totalCount: _totalCount,
      workOrders: masters.workOrders,
      joints: joints,
      workers: masters.workers,
      equipments: masters.equipments,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _loadVersion++;
    _moreVersion++;
    super.dispose();
  }
}
