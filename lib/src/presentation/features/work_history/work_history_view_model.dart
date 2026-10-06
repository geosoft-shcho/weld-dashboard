import 'package:flutter/foundation.dart';

import '../../../domain/entities/work_history_board.dart';
import '../../../domain/entities/work_history_catalog.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_project_filter.dart';
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
  String _nextPageToken = '';
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

  List<WorkHistoryUnitFilter> get unitOptions {
    final projectNo = _query.projectNo;
    if (projectNo.isEmpty) {
      return const [];
    }
    for (final project
        in _masters?.projects ?? const <WorkHistoryProjectFilter>[]) {
      if (project.projectNo == projectNo) {
        return project.units;
      }
    }
    return const [];
  }

  List<String> get itemCodes {
    final unitNo = _query.unitNo;
    if (unitNo.isEmpty) {
      return const [];
    }
    for (final unit in unitOptions) {
      if (unit.unitNo == unitNo) {
        return unit.itemCodes;
      }
    }
    return const [];
  }

  List<String> get jointNos {
    final itemCode = _query.itemCode;
    if (itemCode.isEmpty) {
      return const [];
    }
    for (final unit in unitOptions) {
      if (unit.unitNo != _query.unitNo) {
        continue;
      }
      for (final item in unit.items) {
        if (item.itemCode == itemCode) {
          return item.jointNos;
        }
      }
    }
    return const [];
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
        _nextPageToken = '';
        _loadedQuery = _query;
        _rebuildBoard();
        return;
      }
      final page = await _listWorkHistoryPageUseCase.execute(
        query: _query,
        pageSize: WorkHistoryQuery.BATCH_SIZE,
        pageToken: '',
      );
      if (version != _loadVersion) {
        return;
      }
      _loadedItems = page.items;
      _totalCount = page.totalCount;
      _nextPageToken = page.nextPageToken;
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

  void didSelectProject(String projectNo) {
    _editFilters(
      (query) => query.copyWith(
        projectNo: projectNo,
        unitNo: '',
        itemCode: '',
        jointNo: '',
      ),
    );
  }

  void didSelectUnit(String unitNo) {
    _editFilters(
      (query) => query.copyWith(unitNo: unitNo, itemCode: '', jointNo: ''),
    );
  }

  void didSelectItem(String itemCode) {
    _editFilters((query) => query.copyWith(itemCode: itemCode, jointNo: ''));
  }

  void didSelectJoint(String jointNo) {
    _editFilters((query) => query.copyWith(jointNo: jointNo));
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
    final pageToken = _nextPageToken;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _listWorkHistoryPageUseCase.execute(
        query: loadedQuery,
        pageSize: WorkHistoryQuery.BATCH_SIZE,
        pageToken: pageToken,
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
      _nextPageToken = page.nextPageToken;
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
    _board = WorkHistoryBoard(
      query: filterQuery.copyWith(selectedHistoryId: _query.selectedHistoryId),
      visibleRows: _loadedItems,
      totalCount: _totalCount,
      nextPageToken: _nextPageToken,
      projects: masters.projects,
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
