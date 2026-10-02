import '../entities/collected_node.dart';
import '../entities/collection_board.dart';
import '../entities/collection_board_query.dart';
import '../entities/collection_event.dart';
import '../entities/collection_resource_depth.dart';
import '../entities/collection_timeline.dart';
import '../entities/collection_timeline_resource.dart';
import '../entities/connection_status.dart';
import '../entities/kpi_card_kind.dart';
import '../entities/time_sync_status.dart';
import '../entities/timeline_view_kind.dart';

class PresentCollectionNodesUseCase {
  CollectionBoard execute({
    required List<CollectedNode> nodes,
    required CollectionBoardQuery query,
  }) {
    final rows = [for (final node in nodes) _rowFrom(node)];
    final events = query.doesHaveInvalidTimeRange
        ? const <CollectionEvent>[]
        : [
            for (final node in nodes)
              ?_eventFrom(node, query),
          ];
    final kpi = _kpiFrom(rows);
    final shownRows = _applyCard(rows, query.selectedKpiCard);
    final shownEvents = _applyCardToEvents(events, shownRows);
    final focused = _focused(query.selectedEquipmentId, shownRows);
    final viewKind = _viewKind(query.viewKind);
    final canvasEvents = viewKind == TimelineViewKind.day && focused.isNotEmpty
        ? shownEvents.where((event) => event.equipmentId == focused).toList()
        : shownEvents;
    return CollectionBoard(
      query: query.copyWith(selectedEquipmentId: focused),
      kpi: kpi,
      rows: shownRows,
      options: const CollectionFilterOptions(
        projects: [],
        workers: [],
        lineNames: [],
        equipments: [],
      ),
      selectedEquipmentId: focused,
      timeline: CollectionTimeline(
        viewKind: viewKind,
        events: canvasEvents,
        eventCount: canvasEvents.length,
        depth: CollectionResourceDepth.equipment,
        resourceHeaderLabel: _header(nodes),
        resources: [
          for (final row in shownRows)
            CollectionTimelineResource(
              resourceId: CollectionTimelineResource.equipmentResourceId(
                row.equipmentId,
              ),
              label: row.equipmentName,
              subtitle: row.receivedCount == 0 ? '' : '${row.receivedCount}건',
              selectionKey: row.equipmentId,
            ),
        ],
        resourceIdsByEventId: {
          for (final event in canvasEvents)
            event.eventId: CollectionTimelineResource.equipmentResourceId(
              event.equipmentId,
            ),
        },
        equipmentRows: shownRows,
        selectedEventId: query.selectedEventId,
        focusedEquipmentId: focused,
        canShowDayView: focused.isNotEmpty,
        selectedProjectName: '',
        selectedWorkerName: '',
      ),
    );
  }

  CollectionBoardRow _rowFrom(CollectedNode node) {
    final assetCount = node.assetCount ?? 0;
    return CollectionBoardRow(
      equipmentId: node.nodeKey,
      equipmentName: node.label.isEmpty ? '미지정' : node.label,
      lineName: '',
      connectionStatus: assetCount > 0
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected,
      receivedCount: assetCount,
      windowLabel: _windowLabel(node),
      lossRatePercent: null,
      timeSyncStatus: node.startedAt != null && node.endedAt != null
          ? TimeSyncStatus.synced
          : TimeSyncStatus.unsynced,
      clockOffsetMs: null,
      lastReceivedAt: node.lastCollectedAt ?? node.lastRecordedAt,
      projectName: node.path.projectNo,
      workerName: node.path.workerId,
    );
  }

  CollectionEvent? _eventFrom(CollectedNode node, CollectionBoardQuery query) {
    final startedAt = node.startedAt;
    final endedAt = node.endedAt;
    if (startedAt == null || endedAt == null || !endedAt.isAfter(startedAt)) {
      return null;
    }
    final windowStart = DateTime(
      query.selectedDate.year,
      query.selectedDate.month,
      query.selectedDate.day,
    ).add(Duration(minutes: query.startMinutes));
    final endMinutes = query.endMinutes >= 1440 ? 1440 : query.endMinutes;
    final windowEnd = DateTime(
      query.selectedDate.year,
      query.selectedDate.month,
      query.selectedDate.day,
    ).add(Duration(minutes: endMinutes));
    final visibleStart = startedAt.isBefore(windowStart) ? windowStart : startedAt;
    final visibleEnd = endedAt.isAfter(windowEnd) ? windowEnd : endedAt;
    if (!visibleStart.isBefore(visibleEnd)) {
      return null;
    }
    final assetCount = node.assetCount ?? 0;
    return CollectionEvent(
      eventId: node.nodeKey,
      equipmentId: node.nodeKey,
      equipmentName: node.label.isEmpty ? '미지정' : node.label,
      lineName: '',
      eventAt: visibleStart,
      durationSec: visibleEnd.difference(visibleStart).inSeconds,
      connectionStatus: assetCount > 0
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected,
      receivedCount: assetCount,
      windowLabel: _windowLabel(node),
      lossRatePercent: null,
      timeSyncStatus: TimeSyncStatus.synced,
      clockOffsetMs: null,
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

  List<CollectionEvent> _applyCardToEvents(
    List<CollectionEvent> events,
    List<CollectionBoardRow> rows,
  ) {
    final keys = {for (final row in rows) row.equipmentId};
    return events.where((event) => keys.contains(event.equipmentId)).toList();
  }

  String _focused(String selectedId, List<CollectionBoardRow> rows) {
    if (selectedId.isNotEmpty &&
        rows.any((row) => row.equipmentId == selectedId)) {
      return selectedId;
    }
    return '';
  }

  TimelineViewKind _viewKind(TimelineViewKind viewKind) {
    switch (viewKind) {
      case TimelineViewKind.roadmap:
        return TimelineViewKind.roadmap;
      case TimelineViewKind.day:
        return TimelineViewKind.day;
      case TimelineViewKind.resource:
      case TimelineViewKind.auto:
        return TimelineViewKind.resource;
    }
  }

  String _header(List<CollectedNode> nodes) {
    if (nodes.isNotEmpty && nodes.every((node) => node.contentUrl.isNotEmpty)) {
      return '파일';
    }
    if (nodes.isEmpty) {
      return '수집';
    }
    return switch (nodes.first.path.level) {
      CollectedNodeLevel.equipment => '장비',
      CollectedNodeLevel.worker => '작업자',
      CollectedNodeLevel.project => '공사',
      CollectedNodeLevel.job => '작업',
      CollectedNodeLevel.pass => '패스',
      CollectedNodeLevel.unspecified => '수집',
    };
  }

  CollectionKpi _kpiFrom(List<CollectionBoardRow> rows) {
    return CollectionKpi(
      equipmentCount: rows.length,
      connectedCount: rows
          .where((row) => row.connectionStatus == ConnectionStatus.connected)
          .length,
      disconnectedCount: rows
          .where(
            (row) => row.connectionStatus == ConnectionStatus.disconnected,
          )
          .length,
      errorCount: rows
          .where((row) => row.connectionStatus == ConnectionStatus.error)
          .length,
      receivedCount: rows.fold(0, (sum, row) => sum + row.receivedCount),
      windowLabel: rows.isEmpty ? '' : rows.first.windowLabel,
      lossRateAverage: null,
      lossWarningCount: 0,
      syncedCount: rows
          .where((row) => row.timeSyncStatus == TimeSyncStatus.synced)
          .length,
      delayedCount: 0,
      unsyncedCount: rows
          .where((row) => row.timeSyncStatus == TimeSyncStatus.unsynced)
          .length,
    );
  }

  String _windowLabel(CollectedNode node) {
    final startedAt = node.firstRecordedAt ?? node.startedAt;
    final endedAt = node.lastRecordedAt ?? node.endedAt;
    if (startedAt == null || endedAt == null) {
      return node.label;
    }
    final doesSpanDays =
        startedAt.year != endedAt.year ||
        startedAt.month != endedAt.month ||
        startedAt.day != endedAt.day;
    if (!doesSpanDays) {
      return '${_clock(startedAt)}–${_clock(endedAt)}';
    }
    return '${_dateClock(startedAt)}–${_dateClock(endedAt)}';
  }

  String _dateClock(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$month/$day ${_clock(value)}';
  }

  String _clock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
