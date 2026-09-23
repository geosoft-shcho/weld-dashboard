import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_event.dart';
import '../collection_monitoring_view_model.dart';
import 'collection_event_timeline_mapper.dart';
import 'neon_timeline_material_scope.dart';

class CollectionDayTimelineView extends StatelessWidget {
  const CollectionDayTimelineView({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    final timeline = board.timeline;
    final query = board.query;
    final wallClock = DateTime.now();
    final events = <CollectionEvent>[
      for (final event in timeline.events)
        if (event.equipmentId == timeline.focusedEquipmentId) event,
    ];
    return NeonTimelineMaterialScope(
      child: ClipRect(
        child: NeonPlannerDayTimeline<CollectionEvent>(
          entries: events,
          adapter: CollectionEventTimelineMapper.PLANNER_ADAPTER,
          selectedDate: query.selectedDate,
          currentTime: DateTime(
            query.selectedDate.year,
            query.selectedDate.month,
            query.selectedDate.day,
            wallClock.hour,
            wallClock.minute,
            wallClock.second,
          ),
          currentTimeLabel: '지금',
          dragActivation: NeonPlannerDragActivation.disabled,
          enableResize: false,
          enableKeyboardMovement: false,
          showBuiltInUndo: false,
          showGrabber: false,
          showHeader: false,
          showMetrics: false,
          showTimeScrubber: false,
          showAdaptiveTimeLens: false,
          showMoveConfirmation: false,
          showResizeConfirmation: false,
          showCurrentTimeIndicator: true,
          borderRadius: 4,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          density: NeonPlannerDayDensity.comfortable,
          fit: NeonPlannerDayFit.scroll,
          theme: NeonTimelineMaterialScope.plannerTheme(),
          emptyTitle: '이벤트 없음',
          emptySubtitle: '이 장비의 수집 이벤트가 없습니다.',
          gapBuilder: (duration, index, previous, next) {
            final minutes = duration.inMinutes;
            final title = minutes >= 60
                ? '${(minutes / 60).round()}시간 간격'
                : '${minutes < 1 ? 1 : minutes}분 간격';
            return NeonPlannerCompressedGap(title: title, icon: Icons.schedule);
          },
          onEntryTap: (event) =>
              viewModel.didSelectEvent(event.eventId, event.equipmentId),
        ),
      ),
    );
  }

  NeonPlannerDayDensity _densityOf(double zoomHours) {
    if (zoomHours <= 0.25) {
      return NeonPlannerDayDensity.spacious;
    }
    if (zoomHours <= 1) {
      return NeonPlannerDayDensity.comfortable;
    }
    return NeonPlannerDayDensity.compact;
  }
}
