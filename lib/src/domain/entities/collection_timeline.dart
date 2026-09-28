import 'collection_board_row.dart';
import 'collection_event.dart';
import 'collection_resource_depth.dart';
import 'collection_timeline_resource.dart';
import 'timeline_view_kind.dart';

class CollectionTimeline {
  const CollectionTimeline({
    required this.viewKind,
    required this.events,
    required this.eventCount,
    required this.depth,
    required this.resourceHeaderLabel,
    required this.resources,
    required this.resourceIdsByEventId,
    required this.equipmentRows,
    required this.selectedEventId,
    required this.focusedEquipmentId,
    required this.canShowDayView,
    required this.selectedProjectName,
    required this.selectedWorkerName,
  });

  final TimelineViewKind viewKind;
  final List<CollectionEvent> events;
  final int eventCount;
  final CollectionResourceDepth depth;
  final String resourceHeaderLabel;
  final List<CollectionTimelineResource> resources;
  final Map<String, String> resourceIdsByEventId;
  final List<CollectionBoardRow> equipmentRows;
  final String selectedEventId;
  final String focusedEquipmentId;
  final bool canShowDayView;
  final String selectedProjectName;
  final String selectedWorkerName;

  CollectionEvent? get selectedEvent {
    for (final event in events) {
      if (event.eventId == selectedEventId) {
        return event;
      }
    }
    return null;
  }

  CollectionBoardRow? get focusedRow {
    for (final row in equipmentRows) {
      if (row.equipmentId == focusedEquipmentId) {
        return row;
      }
    }
    return null;
  }

  int get equipmentCount => equipmentRows.length;

  String resourceIdOf(CollectionEvent event) {
    return resourceIdsByEventId[event.eventId] ??
        CollectionTimelineResource.equipmentResourceId(event.equipmentId);
  }
}
