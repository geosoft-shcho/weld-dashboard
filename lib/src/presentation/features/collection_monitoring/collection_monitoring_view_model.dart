import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/collection_board.dart';
import '../../../domain/entities/collection_board_query.dart';
import '../../../domain/entities/collection_catalog.dart';
import '../../../domain/entities/collection_timeline.dart';
import '../../../domain/entities/connection_status.dart';
import '../../../domain/entities/kpi_card_kind.dart';
import '../../../domain/entities/timeline_view_kind.dart';
import '../../../domain/use_cases/load_collection_catalog_use_case.dart';
import '../../../domain/use_cases/query_collection_board_use_case.dart';

class CollectionMonitoringViewModel extends ChangeNotifier {
  CollectionMonitoringViewModel({
    required LoadCollectionCatalogUseCase loadCollectionCatalogUseCase,
    required QueryCollectionBoardUseCase queryCollectionBoardUseCase,
    this.onAfterBoardLoaded,
  }) : _loadCollectionCatalogUseCase = loadCollectionCatalogUseCase,
       _queryCollectionBoardUseCase = queryCollectionBoardUseCase;

  final LoadCollectionCatalogUseCase _loadCollectionCatalogUseCase;
  final QueryCollectionBoardUseCase _queryCollectionBoardUseCase;
  final ValueChanged<DateTime>? onAfterBoardLoaded;

  CollectionBoardQuery _query = CollectionBoardQuery.initial();
  CollectionCatalog? _catalog;
  CollectionBoard? _board;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  Timer? _refreshTimer;

  CollectionBoardQuery get query => _query;
  CollectionBoard? get board => _board;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get doesHaveInvalidTimeRange => _query.doesHaveInvalidTimeRange;
  bool get isAutoRefreshOn =>
      _query.refreshIntervalSeconds == 5 || _query.refreshIntervalSeconds == 60;

  Future<void> loadBoard() async {
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final catalog = await _loadCollectionCatalogUseCase.execute(
        query: _query,
      );
      if (version != _loadVersion) return;
      _catalog = catalog;
      _query = _query.copyWith(snapshotAt: catalog.snapshotAt);
      _applyQuery();
      onAfterBoardLoaded?.call(DateTime.now());
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

  void didTapPreviousDate() {
    _query = _query.copyWith(
      selectedDate: _query.selectedDate.subtract(const Duration(days: 1)),
    );
    loadBoard();
  }

  void didTapNextDate() {
    _query = _query.copyWith(
      selectedDate: _query.selectedDate.add(const Duration(days: 1)),
    );
    loadBoard();
  }

  void didSelectDate(DateTime date) {
    _query = _query.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
    loadBoard();
  }

  void didSelectStartTime(DateTime time) {
    _query = _query.copyWith(startMinutes: time.hour * 60 + time.minute);
    notifyListeners();
  }

  void didSelectEndTime(DateTime time) {
    final minutes = time.hour * 60 + time.minute;
    _query = _query.copyWith(endMinutes: minutes == 0 ? 1440 : minutes);
    notifyListeners();
  }

  void didToggleProject(String projectId) {
    if (_query.isUnassignedOnly) {
      _query = _query.copyWith(
        isUnassignedOnly: false,
        projectIds: [projectId],
      );
    } else {
      _query = _query.copyWith(
        projectIds: _toggled(_query.projectIds, projectId),
        isUnassignedOnly: false,
      );
    }
    notifyListeners();
  }

  void didToggleUnassigned() {
    _query = _query.copyWith(
      isUnassignedOnly: !_query.isUnassignedOnly,
      projectIds: const [],
    );
    notifyListeners();
  }

  void didToggleLine(String lineName) {
    _query = _query.copyWith(lineNames: _toggled(_query.lineNames, lineName));
    notifyListeners();
  }

  void didToggleWorker(String workerId) {
    _query = _query.copyWith(workerIds: _toggled(_query.workerIds, workerId));
    notifyListeners();
  }

  void didToggleEquipment(String equipmentId) {
    _query = _query.copyWith(
      equipmentIds: _toggled(_query.equipmentIds, equipmentId),
    );
    notifyListeners();
  }

  void didToggleConnection(ConnectionStatus status) {
    final statuses = [..._query.connectionStatuses];
    if (statuses.contains(status)) {
      statuses.remove(status);
    } else {
      statuses.add(status);
    }
    _query = _query.copyWith(connectionStatuses: statuses);
    notifyListeners();
  }

  void didSelectRefreshInterval(int seconds) {
    _query = _query.copyWith(refreshIntervalSeconds: seconds);
    _restartTimer();
    notifyListeners();
  }

  void didTapQuery() {
    loadBoard();
  }

  void didTapReset() {
    _query = CollectionBoardQuery.initial();
    _restartTimer();
    loadBoard();
  }

  void didTapReload() {
    loadBoard();
  }

  void didTapKpiCard(KpiCardKind kind) {
    _query = _query.copyWith(
      selectedKpiCard: _query.selectedKpiCard == kind ? KpiCardKind.none : kind,
    );
    _applyQuery();
  }

  void didToggleDisconnectedOrErrorOnly(bool isChecked) {
    _query = _query.copyWith(doesShowDisconnectedOrErrorOnly: isChecked);
    _applyQuery();
  }

  void didSelectRow(String equipmentId) {
    _query = _query.copyWith(selectedEquipmentId: equipmentId);
    _applyQuery();
  }

  void didSelectTimelineView(TimelineViewKind viewKind) {
    _query = _query.copyWith(viewKind: viewKind);
    _applyQuery();
  }

  void didSelectZoom(double zoomHours) {
    _query = _query.copyWith(zoomHours: zoomHours);
    _applyQuery();
  }

  void didSelectEvent(String eventId, String equipmentId) {
    _query = _query.copyWith(
      selectedEventId: eventId,
      selectedEquipmentId: equipmentId,
    );
    _applyQuery();
  }

  void didDoubleTapEquipment(String equipmentId) {
    _query = _query.copyWith(
      equipmentIds: [equipmentId],
      selectedEquipmentId: equipmentId,
      viewKind: TimelineViewKind.auto,
    );
    _applyQuery();
  }

  void didTapProjectSection(String projectId) {
    if (projectId == TimelineSection.UNASSIGNED_PROJECT_ID) {
      _query = _query.copyWith(
        isUnassignedOnly: true,
        projectIds: const [],
        lineNames: const [],
        equipmentIds: const [],
      );
    } else {
      _query = _query.copyWith(
        isUnassignedOnly: false,
        projectIds: [projectId],
        lineNames: const [],
        equipmentIds: const [],
      );
    }
    notifyListeners();
  }

  void didTapLineSection(String lineName) {
    if (_query.lineNames.isNotEmpty) {
      return;
    }
    _query = _query.copyWith(lineNames: [lineName], equipmentIds: const []);
    notifyListeners();
  }

  void didTapOpenDayView() {
    final equipmentId = _board?.timeline.focusedEquipmentId ?? '';
    if (equipmentId.isEmpty) {
      return;
    }
    _query = _query.copyWith(
      equipmentIds: [equipmentId],
      selectedEquipmentId: equipmentId,
      viewKind: TimelineViewKind.day,
    );
    _applyQuery();
  }

  void didTapFactoryCrumb() {
    _query = _query.copyWith(
      projectIds: const [],
      isUnassignedOnly: false,
      workerIds: const [],
      lineNames: const [],
      equipmentIds: const [],
    );
    notifyListeners();
  }

  void didTapProjectCrumb() {
    _query = _query.copyWith(lineNames: const [], equipmentIds: const []);
    notifyListeners();
  }

  void didTapLineCrumb() {
    _query = _query.copyWith(equipmentIds: const []);
    notifyListeners();
  }

  void didClearWorker(String workerId) {
    final workerIds = [..._query.workerIds]..remove(workerId);
    _query = _query.copyWith(workerIds: workerIds);
    notifyListeners();
  }

  @override
  void dispose() {
    _loadVersion++;
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    _board = _queryCollectionBoardUseCase.execute(
      catalog: catalog,
      query: _query,
    );
    _query = _board!.query.copyWith(
      selectedEquipmentId: _board!.selectedEquipmentId,
      selectedEventId: _board!.timeline.selectedEventId,
    );
    notifyListeners();
  }

  void _restartTimer() {
    _refreshTimer?.cancel();
    if (!isAutoRefreshOn) {
      return;
    }
    _refreshTimer = Timer.periodic(
      Duration(seconds: _query.refreshIntervalSeconds),
      (_) => loadBoard(),
    );
  }

  List<String> _toggled(List<String> values, String value) {
    final next = [...values];
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next;
  }
}
