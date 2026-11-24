import '../entities/collected_node.dart';
import '../entities/collection_board.dart';
import '../entities/collection_board_query.dart';
import '../entities/collection_event.dart';
import '../entities/collection_resource_depth.dart';
import '../entities/collection_timeline.dart';
import '../entities/collection_timeline_resource.dart';
import '../entities/connection_status.dart';
import '../entities/time_sync_status.dart';
import '../entities/timeline_view_kind.dart';

class PresentCollectionNodesUseCase {
  CollectionBoard execute({
    required List<CollectedNode> nodes,
    required CollectionBoardQuery query,
    CollectionKpi kpi = CollectionKpi.empty,
  }) {
    final rows = [for (final node in nodes) _rowFrom(node)];
    final events = query.doesHaveInvalidTimeRange
        ? const <CollectionEvent>[]
        : [for (final node in nodes) ..._eventsFrom(node, query)];
    final focused = _focused(query.selectedEquipmentId, rows);
    final viewKind = _viewKind(query.viewKind);
    final canvasEvents = viewKind == TimelineViewKind.day && focused.isNotEmpty
        ? events.where((event) => event.equipmentId == focused).toList()
        : events;
    return CollectionBoard(
      query: query.copyWith(selectedEquipmentId: focused),
      kpi: kpi,
      rows: rows,
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
          for (final node in nodes)
            if (rows.any((row) => row.equipmentId == node.nodeKey))
              CollectionTimelineResource(
                resourceId: CollectionTimelineResource.equipmentResourceId(
                  node.nodeKey,
                ),
                label: node.label.isEmpty ? '미지정' : node.label,
                subtitle: _rowSubtitle(node),
                selectionKey: node.nodeKey,
              ),
        ],
        resourceIdsByEventId: {
          for (final event in canvasEvents)
            event.eventId: CollectionTimelineResource.equipmentResourceId(
              event.equipmentId,
            ),
        },
        equipmentRows: rows,
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
      workerName: '',
    );
  }

  List<CollectionEvent> _eventsFrom(
    CollectedNode node,
    CollectionBoardQuery query,
  ) {
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
    final ranges = node.segments.isNotEmpty
        ? node.segments
        : [
            CollectedTimeRange(
              startedAt: node.startedAt,
              endedAt: node.endedAt,
            ),
          ];
    final events = <CollectionEvent>[];
    final assetCount = node.assetCount ?? 0;
    for (var index = 0; index < ranges.length; index++) {
      final startedAt = ranges[index].startedAt;
      final endedAt = ranges[index].endedAt;
      if (startedAt == null || endedAt == null) {
        continue;
      }
      final isPoint = !endedAt.isAfter(startedAt);
      // 점은 창으로 끌어올리지 않는다. 원본 시각이 [windowStart, windowEnd)일 때만.
      if (isPoint) {
        if (startedAt.isBefore(windowStart) ||
            !startedAt.isBefore(windowEnd)) {
          continue;
        }
        events.add(
          CollectionEvent(
            eventId: '${node.nodeKey}/$index',
            equipmentId: node.nodeKey,
            equipmentName: node.label.isEmpty ? '미지정' : node.label,
            lineName: '',
            eventAt: startedAt,
            durationSec: 0,
            connectionStatus: assetCount > 0
                ? ConnectionStatus.connected
                : ConnectionStatus.disconnected,
            receivedCount: assetCount,
            windowLabel: _segmentWindowLabel(
              startedAt: startedAt,
              endedAt: endedAt,
              isPoint: true,
            ),
            lossRatePercent: null,
            timeSyncStatus: TimeSyncStatus.synced,
            clockOffsetMs: null,
          ),
        );
        continue;
      }
      final visibleStart = startedAt.isBefore(windowStart)
          ? windowStart
          : startedAt;
      final visibleEnd = endedAt.isAfter(windowEnd) ? windowEnd : endedAt;
      if (!visibleStart.isBefore(visibleEnd)) {
        continue;
      }
      events.add(
        CollectionEvent(
          eventId: '${node.nodeKey}/$index',
          equipmentId: node.nodeKey,
          equipmentName: node.label.isEmpty ? '미지정' : node.label,
          lineName: '',
          eventAt: visibleStart,
          durationSec: visibleEnd.difference(visibleStart).inSeconds,
          connectionStatus: assetCount > 0
              ? ConnectionStatus.connected
              : ConnectionStatus.disconnected,
          receivedCount: assetCount,
          windowLabel: _segmentWindowLabel(
            startedAt: startedAt,
            endedAt: endedAt,
            isPoint: false,
          ),
          lossRatePercent: null,
          timeSyncStatus: TimeSyncStatus.synced,
          clockOffsetMs: null,
        ),
      );
    }
    return events;
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
    return _levelName(nodes.first.path.level);
  }

  String _rowSubtitle(CollectedNode node) {
    if (node.contentUrl.isNotEmpty) {
      return '파일';
    }
    return _levelName(node.path.level);
  }

  String _levelName(CollectedNodeLevel level) {
    return switch (level) {
      CollectedNodeLevel.project => '공사',
      CollectedNodeLevel.item => '품목',
      CollectedNodeLevel.job => '작업',
      CollectedNodeLevel.unspecified => '수집',
    };
  }

  String _windowLabel(CollectedNode node) {
    final startedAt = node.firstRecordedAt ?? node.startedAt;
    final endedAt = node.lastRecordedAt ?? node.endedAt;
    if (startedAt == null || endedAt == null) {
      return node.label;
    }
    return _segmentWindowLabel(
      startedAt: startedAt,
      endedAt: endedAt,
      isPoint: !endedAt.isAfter(startedAt),
    );
  }

  /// segment 시각만으로 막대·접근성 문구를 만든다. 긴 node.label을 쓰지 않는다.
  String _segmentWindowLabel({
    required DateTime startedAt,
    required DateTime endedAt,
    required bool isPoint,
  }) {
    if (isPoint) {
      return _dateClock(startedAt);
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
