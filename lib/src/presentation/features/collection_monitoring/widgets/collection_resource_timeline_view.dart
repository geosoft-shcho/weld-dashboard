import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_event.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart' show AppTheme;
import '../collection_monitoring_view_model.dart';
import 'collection_event_timeline_mapper.dart';
import 'neon_timeline_material_scope.dart';

class CollectionResourceTimelineView extends StatefulWidget {
  const CollectionResourceTimelineView({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  State<CollectionResourceTimelineView> createState() =>
      _CollectionResourceTimelineViewState();
}

class _CollectionResourceTimelineViewState
    extends State<CollectionResourceTimelineView> {
  late final TimelineController<CollectionEvent> _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimelineController<CollectionEvent>();
    _syncSelection();
  }

  @override
  void didUpdateWidget(CollectionResourceTimelineView oldWidget) {
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
    final query = widget.board.query;
    if (query.doesHaveInvalidTimeRange) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('시간 범위를 확인하세요'),
      );
    }
    if (timeline.resources.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          timeline.eventCount == 0 ? '이 날짜의 수집 이벤트가 없습니다' : '조건에 맞는 장비가 없습니다',
        ),
      );
    }
    final resources = [
      for (final row in timeline.resources)
        CollectionEventTimelineMapper.resourceOf(row),
    ];
    final entries = [
      for (final event in timeline.events)
        CollectionEventTimelineMapper.entryOf(event),
    ];
    const resourceColumnWidth = 176.0;
    final startHour = CollectionEventTimelineMapper.startHourOf(query);
    final endHour = CollectionEventTimelineMapper.endHourOf(query);
    return NeonTimelineMaterialScope(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final canvasBudget = constraints.maxWidth.isFinite
              ? constraints.maxWidth - resourceColumnWidth
              : 0.0;
          final pixelsPerMinute =
              CollectionEventTimelineMapper.pixelsPerMinuteForViewport(
                zoomHours: query.zoomHours,
                canvasBudget: canvasBudget,
                startHour: startHour,
                endHour: endHour,
              );
          return ResourceTimelineView<CollectionEvent>(
            resources: resources,
            entries: entries,
            selectedDate: query.selectedDate,
            now: query.snapshotAt,
            timelineController: _controller,
            dataRevision: Object.hash(
              query.snapshotAt,
              query.zoomHours,
              timeline.eventCount,
              timeline.selectedEventId,
              constraints.maxWidth.isFinite
                  ? constraints.maxWidth.round()
                  : 0,
              pixelsPerMinute,
            ),
            startHour: startHour,
            endHour: endHour,
            pixelsPerMinute: pixelsPerMinute,
            rowHeight: 64,
            resourceColumnWidth: resourceColumnWidth,
            showCapacityConflicts: false,
            interactions: const TimelineInteractionConfig(
              enableDragging: false,
              enableResizing: false,
              enableKeyboard: false,
            ),
            resourceHeaderLabel: '장비',
            resourceHeaderBuilder: _buildResourceHeader,
            onEntryTap: _handleEntryTap,
            itemBuilder: _buildEntry,
          );
        },
      ),
    );
  }

  Widget _buildResourceHeader(BuildContext context, TimelineResource resource) {
    final equipmentId = resource.id.toString();
    final isFocused = equipmentId == widget.board.timeline.focusedEquipmentId;
    return GestureDetector(
      onTap: () => widget.viewModel.didSelectRow(equipmentId),
      onDoubleTap: () => widget.viewModel.didDoubleTapEquipment(equipmentId),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isFocused
              ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                resource.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                resource.subtitle ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: TimelineTheme.of(context).mutedTextColor,
                ),
              ),
            ],
          ),
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

  Widget _buildEntry(
    BuildContext context,
    TimelineResourceEntryDetails<CollectionEvent> details,
  ) {
    final event = details.entryDetails.entry.value;
    final isSelected =
        details.entryDetails.entry.id == widget.board.timeline.selectedEventId;
    final color = details.entryDetails.entry.color ?? AppTheme.STATUS_OK;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? AppTheme.ACCENT_STEEL : color,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${event.connectionStatus.label} · ${DashboardFormatters.durationLabel(event.durationSec)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppTheme.INK),
          ),
        ),
      ),
    );
  }
}
