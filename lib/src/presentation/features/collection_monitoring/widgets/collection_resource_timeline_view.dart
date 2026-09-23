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
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _controller = TimelineController<CollectionEvent>();
    _horizontalController = ScrollController()..addListener(_didScroll);
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
    _horizontalController.removeListener(_didScroll);
    _horizontalController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _didScroll() => setState(() {});

  void _syncSelection() {
    final selectedEventId = widget.board.timeline.selectedEventId;
    if (selectedEventId.isEmpty) {
      _controller.clearSelection();
      return;
    }
    _controller.selectOnly(selectedEventId);
  }

  /// 선택 일자 축에 벽시계 시각을 올려 «지금» 선을 그린다.
  DateTime _nowOnSelectedDate(DateTime selectedDate) {
    final now = DateTime.now();
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
  }

  double? _nowLineLeft({
    required int startHour,
    required int endHour,
    required double pixelsPerMinute,
    required double resourceColumnWidth,
    required double viewportWidth,
  }) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final rangeStart = startHour * 60;
    final rangeEnd = endHour * 60;
    if (nowMinutes < rangeStart || nowMinutes >= rangeEnd) {
      return null;
    }
    final scroll = _horizontalController.hasClients
        ? _horizontalController.offset
        : 0.0;
    final left =
        resourceColumnWidth +
        (nowMinutes - rangeStart) * pixelsPerMinute -
        scroll;
    if (left < resourceColumnWidth - 1 || left > viewportWidth) {
      return null;
    }
    return left;
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
    final nowOnDate = _nowOnSelectedDate(query.selectedDate);
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
          final nowLeft = constraints.maxWidth.isFinite
              ? _nowLineLeft(
                  startHour: startHour,
                  endHour: endHour,
                  pixelsPerMinute: pixelsPerMinute,
                  resourceColumnWidth: resourceColumnWidth,
                  viewportWidth: constraints.maxWidth,
                )
              : null;
          return Stack(
            children: [
              ResourceTimelineView<CollectionEvent>(
                resources: resources,
                entries: entries,
                selectedDate: query.selectedDate,
                now: nowOnDate,
                timelineController: _controller,
                horizontalController: _horizontalController,
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
              ),
              if (nowLeft != null)
                Positioned(
                  left: nowLeft - 6,
                  top: 0,
                  bottom: 0,
                  width: 12,
                  child: const IgnorePointer(
                    child: _NowMarker(),
                  ),
                ),
            ],
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

/// «지금» 세로선 + 상단 역삼각형(현재 시각 표시).
class _NowMarker extends StatelessWidget {
  const _NowMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: const Size(12, 8),
          painter: const _NowCaretPainter(color: AppTheme.ACCENT_STEEL),
        ),
        Expanded(
          child: Center(
            child: Container(width: 2, color: AppTheme.ACCENT_STEEL),
          ),
        ),
      ],
    );
  }
}

class _NowCaretPainter extends CustomPainter {
  const _NowCaretPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _NowCaretPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
