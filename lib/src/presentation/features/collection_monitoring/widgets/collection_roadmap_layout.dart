import '../../../../domain/entities/collection_event.dart';

const double ROADMAP_CARD_WIDTH = 168;
const double ROADMAP_CARD_HEIGHT = 52;
const double ROADMAP_LANE_GAP = 4;

class RoadmapMilestone {
  const RoadmapMilestone({
    required this.event,
    required this.startMinutes,
    required this.lane,
    required this.isAbove,
    required this.rank,
  });

  final CollectionEvent event;
  final int startMinutes;
  final int lane;
  final bool isAbove;
  final int rank;
}

/// Ports prototype `layoutRoadmapMilestones` (greedy lanes, above/below).
List<RoadmapMilestone> layoutRoadmapMilestones({
  required List<CollectionEvent> events,
  required int rangeStartMinutes,
  required double pixelsPerMinute,
}) {
  final sorted = List<CollectionEvent>.of(events)
    ..sort((a, b) => a.eventAt.compareTo(b.eventAt));
  final laneEnds = <double>[];
  final laid = <RoadmapMilestone>[];

  for (final event in sorted) {
    final startMinutes = _minutesFromDayStart(event.eventAt);
    final x0 = (startMinutes - rangeStartMinutes) * pixelsPerMinute;
    final x1 = x0 + ROADMAP_CARD_WIDTH;
    var lane = laneEnds.indexWhere((end) => end + ROADMAP_LANE_GAP <= x0);
    if (lane < 0) {
      lane = laneEnds.length;
      laneEnds.add(x1);
    } else {
      laneEnds[lane] = x1;
    }
    laid.add(
      RoadmapMilestone(
        event: event,
        startMinutes: startMinutes,
        lane: lane,
        isAbove: lane.isEven,
        rank: lane ~/ 2,
      ),
    );
  }
  return laid;
}

int roadmapMinutesFromDayStart(DateTime at) => _minutesFromDayStart(at);

int _minutesFromDayStart(DateTime at) => at.hour * 60 + at.minute;
