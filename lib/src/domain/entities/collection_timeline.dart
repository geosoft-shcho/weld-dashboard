import 'collection_board_row.dart';
import 'collection_event.dart';
import 'timeline_view_kind.dart';

class TimelineSection {
  const TimelineSection({
    required this.kind,
    required this.sectionKey,
    required this.label,
    required this.rows,
  });

  static const String PROJECT_KIND = 'project';
  static const String LINE_KIND = 'line';
  static const String UNASSIGNED_PROJECT_ID = 'none';

  final String kind;
  final String sectionKey;
  final String label;
  final List<CollectionBoardRow> rows;

  bool get isProject => kind == PROJECT_KIND;
  bool get isUnassigned => sectionKey == UNASSIGNED_PROJECT_ID;
}

class CollectionTimeline {
  const CollectionTimeline({
    required this.viewKind,
    required this.events,
    required this.eventCount,
    required this.resources,
    required this.sections,
    required this.selectedEventId,
    required this.focusedEquipmentId,
    required this.canShowDayView,
    required this.isLineSectionLocked,
    required this.isFactoryOverview,
    required this.selectedProjectName,
    required this.selectedWorkerName,
  });

  final TimelineViewKind viewKind;
  final List<CollectionEvent> events;
  final int eventCount;
  final List<CollectionBoardRow> resources;
  final List<TimelineSection> sections;
  final String selectedEventId;
  final String focusedEquipmentId;
  final bool canShowDayView;
  final bool isLineSectionLocked;
  final bool isFactoryOverview;
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
    for (final row in resources) {
      if (row.equipmentId == focusedEquipmentId) {
        return row;
      }
    }
    return null;
  }

  int get equipmentCount => resources.length;
}
