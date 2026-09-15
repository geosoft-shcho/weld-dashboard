import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_event.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart' show AppTheme;
import '../collection_monitoring_view_model.dart';
import 'collection_event_timeline_mapper.dart';
import 'neon_timeline_material_scope.dart';

class CollectionRoadmapView extends StatefulWidget {
  const CollectionRoadmapView({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  State<CollectionRoadmapView> createState() => _CollectionRoadmapViewState();
}

class _CollectionRoadmapViewState extends State<CollectionRoadmapView> {
  late final TimelineController<CollectionEvent> _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimelineController<CollectionEvent>();
    _syncSelection();
  }

  @override
  void didUpdateWidget(CollectionRoadmapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.board.timeline.selectedEventId !=
        widget.board.timeline.selectedEventId) {
      _syncSelection();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncSelection() {
    final selectedEventId = widget.board.timeline.selectedEventId;
    if (selectedEventId.isEmpty) {
      _controller.clearSelection();
      return;
    }
    _controller.selectOnly(selectedEventId);
  }

  @override
  Widget build(BuildContext context) {
    final timeline = widget.board.timeline;
    if (timeline.events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('이 날짜의 수집 이벤트가 없습니다'),
      );
    }
    final entries = [
      for (final event in timeline.events)
        CollectionEventTimelineMapper.entryOf(event),
    ];
    return NeonTimelineMaterialScope(
      child: ClipRect(
        child: RoadmapView<CollectionEvent>(
          entries: entries,
          timelineController: _controller,
          itemExtent: 280,
          onEntryTap: _handleEntryTap,
          oppositeBuilder: (context, details) {
            return Text(
              DashboardFormatters.clockTime(details.entry.start),
              style: TextStyle(
                color: TimelineTheme.of(context).mutedTextColor,
                fontWeight: FontWeight.w700,
              ),
            );
          },
          itemBuilder: (context, details) {
            final event = details.entry.value;
            final isSelected =
                details.entry.id == widget.board.timeline.selectedEventId;
            final color = details.entry.color ?? AppTheme.STATUS_OK;
            return DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.SURFACE_RAISED,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? AppTheme.ACCENT_STEEL : color,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${event.connectionStatus.label} · ${event.equipmentName}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.INK,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.equipmentId} · ${event.windowLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: TimelineTheme.of(context).mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleEntryTap(
    BuildContext context,
    TimelineEntryDetails<CollectionEvent> details,
  ) {
    final event = details.entry.value;
    widget.viewModel.didSelectEvent(event.eventId, event.equipmentId);
  }
}
