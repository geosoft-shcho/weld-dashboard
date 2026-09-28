import '../entities/collection_assignment.dart';
import '../entities/collection_board.dart';
import '../entities/collection_board_query.dart';
import '../entities/collection_catalog.dart';
import '../entities/collection_event.dart';
import '../entities/collection_resource_depth.dart';
import '../entities/collection_status.dart';
import '../entities/collection_timeline.dart';
import '../entities/collection_timeline_resource.dart';
import '../entities/connection_status.dart';
import '../entities/equipment.dart';
import '../entities/kpi_card_kind.dart';
import '../entities/time_sync_status.dart';
import '../entities/timeline_view_kind.dart';

class QueryCollectionBoardUseCase {
  static const int LOSS_WARNING_PERCENT = 10;

  CollectionBoard execute({
    required CollectionCatalog catalog,
    required CollectionBoardQuery query,
  }) {
    final sanitized = _sanitize(catalog, query);
    final options = _drilldownOptions(catalog, sanitized);
    final snapshotRows = _snapshotRows(catalog, sanitized);
    final kpi = _kpiFrom(snapshotRows);
    var tableRows = _applyCard(snapshotRows, sanitized.selectedKpiCard);
    if (sanitized.doesShowDisconnectedOrErrorOnly) {
      tableRows = tableRows.where((row) => row.isDisconnectedOrError).toList();
    }
    var selectedEquipmentId = sanitized.selectedEquipmentId;
    if (tableRows.isEmpty) {
      selectedEquipmentId = '';
    } else if (selectedEquipmentId.isEmpty ||
        !tableRows.any((row) => row.equipmentId == selectedEquipmentId)) {
      selectedEquipmentId = tableRows.first.equipmentId;
    }
    final timeline = _timeline(
      catalog: catalog,
      query: sanitized,
      tableRows: tableRows,
      snapshotRows: snapshotRows,
      selectedEquipmentId: selectedEquipmentId,
    );
    return CollectionBoard(
      query: sanitized,
      kpi: kpi,
      rows: tableRows,
      options: options,
      selectedEquipmentId: selectedEquipmentId,
      timeline: timeline,
    );
  }

  CollectionBoardQuery _sanitize(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
  ) {
    if (query.isUnassignedOnly) {
      final workerIds = _retainWorkerIds(
        catalog,
        query.copyWith(projectIds: const []),
      );
      final lineNames = _retainLineNames(
        catalog,
        query.copyWith(projectIds: const [], workerIds: workerIds),
      );
      final equipmentIds = _retainEquipmentIds(
        catalog,
        query.copyWith(
          projectIds: const [],
          workerIds: workerIds,
          lineNames: lineNames,
        ),
      );
      return query.copyWith(
        projectIds: const [],
        isUnassignedOnly: true,
        workerIds: workerIds,
        lineNames: lineNames,
        equipmentIds: equipmentIds,
        zoomHours: _sanitizeZoom(query.zoomHours),
      );
    }
    final projectIds = query.projectIds
        .where((id) => catalog.projectById(id) != null)
        .toList();
    final withProjects = query.copyWith(projectIds: projectIds);
    final workerIds = _retainWorkerIds(catalog, withProjects);
    final withWorkers = withProjects.copyWith(workerIds: workerIds);
    final lineNames = _retainLineNames(catalog, withWorkers);
    final withLines = withWorkers.copyWith(lineNames: lineNames);
    final equipmentIds = _retainEquipmentIds(catalog, withLines);
    return withLines.copyWith(
      equipmentIds: equipmentIds,
      isUnassignedOnly: false,
      zoomHours: _sanitizeZoom(query.zoomHours),
    );
  }

  List<String> _retainWorkerIds(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
  ) {
    final options = _drilldownOptions(
      catalog,
      query.copyWith(lineNames: const []),
    );
    return query.workerIds
        .where((id) => options.workers.any((worker) => worker.workerId == id))
        .toList();
  }

  List<String> _retainLineNames(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
  ) {
    final options = _drilldownOptions(
      catalog,
      query.copyWith(lineNames: const []),
    );
    return query.lineNames
        .where((name) => options.lineNames.contains(name))
        .toList();
  }

  List<String> _retainEquipmentIds(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
  ) {
    final options = _drilldownOptions(catalog, query);
    return query.equipmentIds
        .where(
          (id) => options.equipments.any(
            (equipment) => equipment.equipmentId == id,
          ),
        )
        .toList();
  }

  CollectionFilterOptions _drilldownOptions(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
  ) {
    final dayAssignments = _assignmentsOnDate(catalog, query.selectedDate);
    if (query.isUnassignedOnly) {
      final equipment = catalog.equipments
          .where(
            (item) => !_hasDayAssignment(
              catalog,
              item.equipmentId,
              query.selectedDate,
            ),
          )
          .toList();
      final scoped = query.lineNames.isEmpty
          ? equipment
          : equipment
                .where((item) => query.lineNames.contains(item.lineName))
                .toList();
      final lineNames = [
        ...{for (final item in equipment) item.lineName},
      ];
      return CollectionFilterOptions(
        projects: [
          for (final project in catalog.projects)
            (projectId: project.projectId, projectName: project.projectName),
        ],
        workers: const [],
        lineNames: lineNames,
        equipments: [
          for (final item in scoped)
            (equipmentId: item.equipmentId, equipmentName: item.equipmentName),
        ],
      );
    }
    // Project → Line → Equipment → Worker 순서로 필터링
    // 1. Project 필터 적용 - assignments에서 projectId로 필터링
    var filteredAssignments = query.projectIds.isEmpty
        ? dayAssignments
        : dayAssignments
              .where(
                (assignment) => query.projectIds.contains(assignment.projectId),
              )
              .toList();

    // 2. Line 필터 적용 (Project 필터 후) - filteredAssignments에서 equipment를 통해 lineName 확인
    final availableLineNames = <String>{};
    for (final assignment in filteredAssignments) {
      final equipment = catalog.equipmentById(assignment.equipmentId);
      if (equipment != null) {
        availableLineNames.add(equipment.lineName);
      }
    }
    final lineNames = availableLineNames.toList();

    if (query.lineNames.isNotEmpty) {
      filteredAssignments = filteredAssignments.where((assignment) {
        final equipment = catalog.equipmentById(assignment.equipmentId);
        return equipment != null &&
            query.lineNames.contains(equipment.lineName);
      }).toList();
    }

    // 3. Equipment 필터 적용 (Project + Line 필터 후)
    final availableEquipmentIds = <String>{};
    for (final assignment in filteredAssignments) {
      availableEquipmentIds.add(assignment.equipmentId);
    }
    final scopedEquipment = catalog.equipments
        .where((item) => availableEquipmentIds.contains(item.equipmentId))
        .toList();

    final filteredEquipments = query.lineNames.isEmpty
        ? scopedEquipment
        : scopedEquipment
              .where((item) => query.lineNames.contains(item.lineName))
              .toList();

    // 4. Worker 필터 적용 (Project + Line + Equipment 필터 후)
    final workerIds = <String>{};
    for (final assignment in filteredAssignments) {
      if (query.equipmentIds.isEmpty ||
          query.equipmentIds.contains(assignment.equipmentId)) {
        workerIds.add(assignment.workerId);
      }
    }
    final workers = [
      for (final workerId in workerIds)
        if (catalog.workerById(workerId) != null)
          (
            workerId: workerId,
            workerName: catalog.workerById(workerId)!.workerName,
          ),
    ];

    return CollectionFilterOptions(
      projects: [
        for (final project in catalog.projects)
          (projectId: project.projectId, projectName: project.projectName),
      ],
      workers: workers,
      lineNames: lineNames,
      equipments: [
        for (final item in filteredEquipments)
          (equipmentId: item.equipmentId, equipmentName: item.equipmentName),
      ],
    );
  }

  List<CollectionBoardRow> _snapshotRows(
    CollectionCatalog catalog,
    CollectionBoardQuery query, {
    bool doesApplyConnectionFilter = true,
  }) {
    var rows = [
      for (final equipment in catalog.equipments)
        if (catalog.statusByEquipmentId(equipment.equipmentId) != null)
          _rowFrom(
            catalog,
            equipment,
            catalog.statusByEquipmentId(equipment.equipmentId)!,
            query.snapshotAt,
          ),
    ];
    if (query.lineNames.isNotEmpty) {
      rows = rows
          .where((row) => query.lineNames.contains(row.lineName))
          .toList();
    }
    if (query.equipmentIds.isNotEmpty) {
      rows = rows
          .where((row) => query.equipmentIds.contains(row.equipmentId))
          .toList();
    }
    if (doesApplyConnectionFilter && query.connectionStatuses.isNotEmpty) {
      rows = rows
          .where(
            (row) => query.connectionStatuses.contains(row.connectionStatus),
          )
          .toList();
    }
    if (!catalog.isServerFiltered &&
        (query.isUnassignedOnly ||
            query.projectIds.isNotEmpty ||
            query.workerIds.isNotEmpty)) {
      rows = rows
          .where(
            (row) => _matchesAssignmentFilter(catalog, row.equipmentId, query),
          )
          .toList();
    }
    return rows;
  }

  CollectionBoardRow _rowFrom(
    CollectionCatalog catalog,
    Equipment equipment,
    CollectionStatus status,
    DateTime snapshotAt,
  ) {
    final assignment = _assignmentAt(
      catalog,
      equipment.equipmentId,
      snapshotAt,
    );
    return CollectionBoardRow(
      equipmentId: equipment.equipmentId,
      equipmentName: equipment.equipmentName,
      lineName: equipment.lineName,
      connectionStatus: status.connectionStatus,
      receivedCount: status.receivedCount,
      windowLabel: status.windowLabel,
      lossRatePercent: status.lossRatePercent,
      timeSyncStatus: status.timeSyncStatus,
      clockOffsetMs: status.clockOffsetMs,
      lastReceivedAt: status.lastReceivedAt,
      projectName: assignment == null
          ? ''
          : catalog.projectById(assignment.projectId)?.projectName ?? '',
      workerName: assignment == null
          ? ''
          : catalog.workerById(assignment.workerId)?.workerName ?? '',
    );
  }

  bool _matchesAssignmentFilter(
    CollectionCatalog catalog,
    String equipmentId,
    CollectionBoardQuery query,
  ) {
    if (query.isUnassignedOnly) {
      if (query.workerIds.isNotEmpty) {
        return false;
      }
      return !_hasDayAssignment(catalog, equipmentId, query.selectedDate);
    }
    final dayStart = DateTime(
      query.selectedDate.year,
      query.selectedDate.month,
      query.selectedDate.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));
    return catalog.assignmentsForEquipment(equipmentId).any((assignment) {
      if (!assignment.overlaps(dayStart, dayEnd)) {
        return false;
      }
      if (query.projectIds.isNotEmpty &&
          !query.projectIds.contains(assignment.projectId)) {
        return false;
      }
      if (query.workerIds.isNotEmpty &&
          !query.workerIds.contains(assignment.workerId)) {
        return false;
      }
      return true;
    });
  }

  CollectionAssignment? _assignmentAt(
    CollectionCatalog catalog,
    String equipmentId,
    DateTime instant,
  ) {
    for (final assignment in catalog.assignmentsForEquipment(equipmentId)) {
      if (assignment.contains(instant)) {
        return assignment;
      }
    }
    return null;
  }

  bool _hasDayAssignment(
    CollectionCatalog catalog,
    String equipmentId,
    DateTime date,
  ) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return catalog
        .assignmentsForEquipment(equipmentId)
        .any((assignment) => assignment.overlaps(dayStart, dayEnd));
  }

  List<CollectionAssignment> _assignmentsOnDate(
    CollectionCatalog catalog,
    DateTime date,
  ) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return catalog.assignments
        .where((assignment) => assignment.overlaps(dayStart, dayEnd))
        .toList();
  }

  CollectionKpi _kpiFrom(List<CollectionBoardRow> rows) {
    final lossRates = [
      for (final row in rows)
        if (row.lossRatePercent != null) row.lossRatePercent!,
    ];
    return CollectionKpi(
      equipmentCount: rows.length,
      connectedCount: rows
          .where((row) => row.connectionStatus == ConnectionStatus.connected)
          .length,
      disconnectedCount: rows
          .where((row) => row.connectionStatus == ConnectionStatus.disconnected)
          .length,
      errorCount: rows
          .where((row) => row.connectionStatus == ConnectionStatus.error)
          .length,
      receivedCount: rows.fold(0, (sum, row) => sum + row.receivedCount),
      windowLabel: rows.isEmpty ? '' : rows.first.windowLabel,
      lossRateAverage: lossRates.isEmpty
          ? null
          : lossRates.reduce((a, b) => a + b) / lossRates.length,
      lossWarningCount: rows
          .where(
            (row) =>
                row.lossRatePercent != null &&
                row.lossRatePercent! >= LOSS_WARNING_PERCENT,
          )
          .length,
      syncedCount: rows
          .where((row) => row.timeSyncStatus == TimeSyncStatus.synced)
          .length,
      delayedCount: rows
          .where((row) => row.timeSyncStatus == TimeSyncStatus.delayed)
          .length,
      unsyncedCount: rows
          .where((row) => row.timeSyncStatus == TimeSyncStatus.unsynced)
          .length,
    );
  }

  List<CollectionBoardRow> _applyCard(
    List<CollectionBoardRow> rows,
    KpiCardKind card,
  ) {
    switch (card) {
      case KpiCardKind.connection:
        return rows.where((row) => row.isDisconnectedOrError).toList();
      case KpiCardKind.loss:
        return rows.where((row) => row.isLossWarning).toList();
      case KpiCardKind.sync:
        return rows
            .where((row) => row.timeSyncStatus != TimeSyncStatus.synced)
            .toList();
      case KpiCardKind.reception:
      case KpiCardKind.none:
        return rows;
    }
  }

  CollectionTimeline _timeline({
    required CollectionCatalog catalog,
    required CollectionBoardQuery query,
    required List<CollectionBoardRow> tableRows,
    required List<CollectionBoardRow> snapshotRows,
    required String selectedEquipmentId,
  }) {
    var events = _eventsFiltered(catalog, query);
    events = _applyCardToEvents(events, snapshotRows, query.selectedKpiCard);
    if (query.doesHaveInvalidTimeRange) {
      events = const [];
    } else {
      events = _eventsOverlap(events, query.startMinutes, query.endMinutes);
    }
    final viewKind = _resolveViewKind(query);
    final focusedEquipmentId = _focusedEquipmentId(
      query: query,
      tableRows: tableRows,
      selectedEquipmentId: selectedEquipmentId,
    );
    final canvasEvents = viewKind == TimelineViewKind.day
        ? events
              .where((event) => event.equipmentId == focusedEquipmentId)
              .toList()
        : events;
    final selectedEvent = _pickedEvent(
      events: canvasEvents.isEmpty ? events : canvasEvents,
      selectedEventId: query.selectedEventId,
      focusedEquipmentId: focusedEquipmentId,
    );
    final assignmentInstant = selectedEvent?.eventAt ?? DateTime.now();
    final assignment = focusedEquipmentId.isEmpty
        ? null
        : _assignmentAt(catalog, focusedEquipmentId, assignmentInstant);
    final depth = CollectionResourceDepth.of(query);
    final scopeRows = _applyCard(
      _snapshotRows(
        catalog,
        query,
        doesApplyConnectionFilter: false,
      ),
      query.selectedKpiCard,
    );
    final resources = _resources(
      catalog: catalog,
      query: query,
      scopeRows: scopeRows,
      depth: depth,
    );
    return CollectionTimeline(
      viewKind: viewKind,
      events: canvasEvents,
      eventCount: canvasEvents.length,
      depth: depth,
      resourceHeaderLabel: depth.headerLabel,
      resources: resources,
      resourceIdsByEventId: {
        for (final event in canvasEvents)
          event.eventId: _resourceIdOfEvent(
            catalog: catalog,
            depth: depth,
            event: event,
          ),
      },
      equipmentRows: scopeRows,
      selectedEventId: selectedEvent?.eventId ?? '',
      focusedEquipmentId: focusedEquipmentId,
      canShowDayView: query.equipmentIds.length == 1 || tableRows.length == 1,
      selectedProjectName: assignment == null
          ? ''
          : catalog.projectById(assignment.projectId)?.projectName ?? '',
      selectedWorkerName: assignment == null
          ? ''
          : catalog.workerById(assignment.workerId)?.workerName ?? '',
    );
  }

  List<CollectionTimelineResource> _resources({
    required CollectionCatalog catalog,
    required CollectionBoardQuery query,
    required List<CollectionBoardRow> scopeRows,
    required CollectionResourceDepth depth,
  }) {
    switch (depth) {
      case CollectionResourceDepth.project:
        return _projectResources(catalog, query, scopeRows);
      case CollectionResourceDepth.line:
        return _lineResources(query, scopeRows);
      case CollectionResourceDepth.equipment:
        return _equipmentResources(scopeRows);
    }
  }

  List<CollectionTimelineResource> _projectResources(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
    List<CollectionBoardRow> scopeRows,
  ) {
    final rowsByProject = <String, List<CollectionBoardRow>>{};
    for (final row in scopeRows) {
      final assignment = _assignmentAt(
        catalog,
        row.equipmentId,
        query.snapshotAt,
      );
      final key =
          assignment?.projectId ??
          CollectionTimelineResource.UNASSIGNED_PROJECT_ID;
      if (query.projectIds.isNotEmpty && !query.projectIds.contains(key)) {
        continue;
      }
      rowsByProject.putIfAbsent(key, () => []).add(row);
    }
    final keys = query.projectIds.isEmpty
        ? [
            for (final project in catalog.projects)
              if (rowsByProject.containsKey(project.projectId))
                project.projectId,
            if (rowsByProject.containsKey(
              CollectionTimelineResource.UNASSIGNED_PROJECT_ID,
            ))
              CollectionTimelineResource.UNASSIGNED_PROJECT_ID,
          ]
        : [
            for (final project in catalog.projects)
              if (query.projectIds.contains(project.projectId))
                project.projectId,
          ];
    return [
      for (final key in keys)
        CollectionTimelineResource(
          resourceId: CollectionTimelineResource.projectResourceId(key),
          label: key == CollectionTimelineResource.UNASSIGNED_PROJECT_ID
              ? '미배정'
              : catalog.projectById(key)?.projectName ?? key,
          subtitle: '${rowsByProject[key]?.length ?? 0}대',
          selectionKey: key,
        ),
    ];
  }

  List<CollectionTimelineResource> _lineResources(
    CollectionBoardQuery query,
    List<CollectionBoardRow> scopeRows,
  ) {
    final rowsByLine = <String, List<CollectionBoardRow>>{};
    for (final row in scopeRows) {
      final lineName = row.lineName.isEmpty ? '—' : row.lineName;
      if (query.lineNames.isNotEmpty && !query.lineNames.contains(lineName)) {
        continue;
      }
      rowsByLine.putIfAbsent(lineName, () => []).add(row);
    }
    final lineNames = query.lineNames.isEmpty
        ? (rowsByLine.keys.toList()..sort())
        : ([...query.lineNames]..sort());
    return [
      for (final lineName in lineNames)
        CollectionTimelineResource(
          resourceId: CollectionTimelineResource.lineResourceId(lineName),
          label: lineName,
          subtitle: '${rowsByLine[lineName]?.length ?? 0}대',
          selectionKey: lineName,
        ),
    ];
  }

  List<CollectionTimelineResource> _equipmentResources(
    List<CollectionBoardRow> scopeRows,
  ) {
    final rows = [...scopeRows]..sort(
      (left, right) => left.equipmentName.compareTo(right.equipmentName),
    );
    return [
      for (final row in rows)
        CollectionTimelineResource(
          resourceId: CollectionTimelineResource.equipmentResourceId(
            row.equipmentId,
          ),
          label: row.equipmentName,
          subtitle: '${row.equipmentId} · ${row.lineName}',
          selectionKey: row.equipmentId,
        ),
    ];
  }

  String _resourceIdOfEvent({
    required CollectionCatalog catalog,
    required CollectionResourceDepth depth,
    required CollectionEvent event,
  }) {
    switch (depth) {
      case CollectionResourceDepth.equipment:
        return CollectionTimelineResource.equipmentResourceId(
          event.equipmentId,
        );
      case CollectionResourceDepth.line:
        return CollectionTimelineResource.lineResourceId(event.lineName);
      case CollectionResourceDepth.project:
        final assignment = _assignmentAt(
          catalog,
          event.equipmentId,
          event.eventAt,
        );
        final projectId =
            assignment?.projectId ??
            CollectionTimelineResource.UNASSIGNED_PROJECT_ID;
        return CollectionTimelineResource.projectResourceId(projectId);
    }
  }

  TimelineViewKind _resolveViewKind(CollectionBoardQuery query) {
    if (query.viewKind == TimelineViewKind.roadmap) {
      return TimelineViewKind.roadmap;
    }
    if (query.viewKind == TimelineViewKind.resource) {
      return TimelineViewKind.resource;
    }
    if (query.viewKind == TimelineViewKind.day ||
        query.equipmentIds.length == 1) {
      return TimelineViewKind.day;
    }
    return TimelineViewKind.resource;
  }

  String _focusedEquipmentId({
    required CollectionBoardQuery query,
    required List<CollectionBoardRow> tableRows,
    required String selectedEquipmentId,
  }) {
    if (query.equipmentIds.length == 1) {
      return query.equipmentIds.first;
    }
    if (tableRows.length == 1) {
      return tableRows.first.equipmentId;
    }
    return selectedEquipmentId;
  }

  CollectionEvent? _pickedEvent({
    required List<CollectionEvent> events,
    required String selectedEventId,
    required String focusedEquipmentId,
  }) {
    if (selectedEventId.isNotEmpty) {
      for (final event in events) {
        if (event.eventId == selectedEventId) {
          return event;
        }
      }
    }
    return _latestEventFor(events, focusedEquipmentId) ??
        (events.isEmpty ? null : events.first);
  }

  CollectionEvent? _latestEventFor(
    List<CollectionEvent> events,
    String equipmentId,
  ) {
    CollectionEvent? latest;
    for (final event in events) {
      if (event.equipmentId != equipmentId) {
        continue;
      }
      if (latest == null || !event.eventAt.isBefore(latest.eventAt)) {
        latest = event;
      }
    }
    return latest;
  }

  List<CollectionEvent> _eventsFiltered(
    CollectionCatalog catalog,
    CollectionBoardQuery query,
  ) {
    final dateKey = _dateKey(query.selectedDate);
    var events = [
      for (final event in catalog.events)
        if (_dateKey(event.eventAt) == dateKey) event,
    ];
    if (query.lineNames.isNotEmpty) {
      events = events
          .where((event) => query.lineNames.contains(event.lineName))
          .toList();
    }
    if (query.equipmentIds.isNotEmpty) {
      events = events
          .where((event) => query.equipmentIds.contains(event.equipmentId))
          .toList();
    }
    if (query.connectionStatuses.isNotEmpty) {
      events = events
          .where(
            (event) =>
                query.connectionStatuses.contains(event.connectionStatus),
          )
          .toList();
    }
    if (!catalog.isServerFiltered &&
        (query.isUnassignedOnly ||
            query.projectIds.isNotEmpty ||
            query.workerIds.isNotEmpty)) {
      events = events
          .where(
            (event) => _eventMatchesAssignmentFilter(catalog, event, query),
          )
          .toList();
    }
    events.sort((a, b) {
      final byTime = a.eventAt.compareTo(b.eventAt);
      if (byTime != 0) {
        return byTime;
      }
      return a.equipmentId.compareTo(b.equipmentId);
    });
    return events;
  }

  List<CollectionEvent> _applyCardToEvents(
    List<CollectionEvent> events,
    List<CollectionBoardRow> snapshotRows,
    KpiCardKind card,
  ) {
    switch (card) {
      case KpiCardKind.connection:
        return events
            .where(
              (event) => event.connectionStatus != ConnectionStatus.connected,
            )
            .toList();
      case KpiCardKind.loss:
      case KpiCardKind.sync:
        final ids = {
          for (final row in _applyCard(snapshotRows, card)) row.equipmentId,
        };
        return events
            .where((event) => ids.contains(event.equipmentId))
            .toList();
      case KpiCardKind.reception:
      case KpiCardKind.none:
        return events;
    }
  }

  List<CollectionEvent> _eventsOverlap(
    List<CollectionEvent> events,
    int startMinutes,
    int endMinutes,
  ) {
    return [
      for (final event in events)
        if (event.startMinutes < endMinutes &&
            event.startMinutes +
                    (event.durationMinutes < 1 ? 1 : event.durationMinutes) >
                startMinutes)
          event,
    ];
  }

  bool _eventMatchesAssignmentFilter(
    CollectionCatalog catalog,
    CollectionEvent event,
    CollectionBoardQuery query,
  ) {
    if (query.isUnassignedOnly) {
      if (query.workerIds.isNotEmpty) {
        return false;
      }
      return !_hasDayAssignment(catalog, event.equipmentId, query.selectedDate);
    }
    if (query.projectIds.isEmpty && query.workerIds.isEmpty) {
      return true;
    }
    return catalog.assignmentsForEquipment(event.equipmentId).any((assignment) {
      if (!assignment.overlaps(event.eventAt, event.endedAt)) {
        return false;
      }
      if (query.projectIds.isNotEmpty &&
          !query.projectIds.contains(assignment.projectId)) {
        return false;
      }
      if (query.workerIds.isNotEmpty &&
          !query.workerIds.contains(assignment.workerId)) {
        return false;
      }
      return true;
    });
  }

  double _sanitizeZoom(double zoomHours) {
    if (zoomHours == 0.25 ||
        zoomHours == 1 ||
        zoomHours == 4 ||
        zoomHours == 24) {
      return zoomHours;
    }
    return 24;
  }

  String _dateKey(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
