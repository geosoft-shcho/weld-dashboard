import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_event.dart';
import '../../../../domain/entities/collection_resource_depth.dart';
import '../../../../domain/entities/collection_timeline_resource.dart';
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
  static const double _rowHeight = 64;
  static const double _timeHeaderHeight = 48;

  late final TimelineController<CollectionEvent> _controller;
  late final ScrollController _horizontalController;
  late final ScrollController _verticalController;
  late final ScrollController _stickyVerticalController;
  bool _isSyncingVertical = false;

  @override
  void initState() {
    super.initState();
    _controller = TimelineController<CollectionEvent>();
    _horizontalController = ScrollController()..addListener(_didScroll);
    _verticalController = ScrollController()
      ..addListener(_syncStickyFromTimeline);
    _stickyVerticalController = ScrollController()
      ..addListener(_syncTimelineFromSticky);
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
    _verticalController.removeListener(_syncStickyFromTimeline);
    _stickyVerticalController.removeListener(_syncTimelineFromSticky);
    _horizontalController.dispose();
    _verticalController.dispose();
    _stickyVerticalController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _didScroll() => setState(() {});

  void _syncStickyFromTimeline() {
    _jumpVertical(
      source: _verticalController,
      target: _stickyVerticalController,
    );
  }

  void _syncTimelineFromSticky() {
    _jumpVertical(
      source: _stickyVerticalController,
      target: _verticalController,
    );
  }

  void _jumpVertical({
    required ScrollController source,
    required ScrollController target,
  }) {
    if (_isSyncingVertical || !source.hasClients || !target.hasClients) {
      return;
    }
    if (target.offset == source.offset) {
      return;
    }
    _isSyncingVertical = true;
    target.jumpTo(source.offset);
    _isSyncingVertical = false;
  }

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
        child: Text(_emptyLabel(timeline.depth, timeline.eventCount)),
      );
    }
    final resources = [
      for (final row in timeline.resources)
        CollectionEventTimelineMapper.resourceOf(row),
    ];
    final entries = [
      for (final event in timeline.events)
        CollectionEventTimelineMapper.entryOf(
          event,
          resourceId: timeline.resourceIdOf(event),
        ),
    ];
    final resourceColumnWidth = CollectionEventTimelineMapper.columnWidthOf(
      timeline.depth,
    );
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
                verticalController: _verticalController,
                dataRevision: Object.hash(
                  query.snapshotAt,
                  query.zoomHours,
                  timeline.depth,
                  timeline.eventCount,
                  timeline.selectedEventId,
                  timeline.resources.length,
                  constraints.maxWidth.isFinite
                      ? constraints.maxWidth.round()
                      : 0,
                  pixelsPerMinute,
                ),
                startHour: startHour,
                endHour: endHour,
                pixelsPerMinute: pixelsPerMinute,
                rowHeight: _rowHeight,
                resourceColumnWidth: resourceColumnWidth,
                timeHeaderHeight: _timeHeaderHeight,
                showCapacityConflicts: false,
                interactions: const TimelineInteractionConfig(
                  enableDragging: false,
                  enableResizing: false,
                  enableKeyboard: false,
                ),
                resourceHeaderLabel: timeline.resourceHeaderLabel,
                resourceHeaderBuilder: _buildEmptyResourceHeader,
                onEntryTap: _handleEntryTap,
                itemBuilder: _buildEntry,
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: resourceColumnWidth,
                child: _StickyResourceColumn(
                  label: timeline.resourceHeaderLabel,
                  timeHeaderHeight: _timeHeaderHeight,
                  rowHeight: _rowHeight,
                  verticalController: _stickyVerticalController,
                  resources: resources,
                  headerBuilder: _buildResourceHeader,
                ),
              ),
              if (nowLeft != null)
                Positioned(
                  left: nowLeft - 6,
                  top: 0,
                  bottom: 0,
                  width: 12,
                  child: const IgnorePointer(child: _NowMarker()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyResourceHeader(
    BuildContext context,
    TimelineResource resource,
  ) {
    return const SizedBox.expand();
  }

  Widget _buildResourceHeader(BuildContext context, TimelineResource resource) {
    final row = _resourceById(resource.id.toString());
    if (row == null) {
      return const SizedBox.shrink();
    }
    final focusedId = widget.board.timeline.focusedEquipmentId;
    final isFocused = focusedId.isNotEmpty && row.selectionKey == focusedId;
    return GestureDetector(
      onTap: () => widget.viewModel.didTapTimelineNode(row.selectionKey),
      onDoubleTap: () => widget.viewModel.didTapTimelineNode(row.selectionKey),
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
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 12,
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

  CollectionTimelineResource? _resourceById(String resourceId) {
    for (final resource in widget.board.timeline.resources) {
      if (resource.resourceId == resourceId) {
        return resource;
      }
    }
    return null;
  }

  String _emptyLabel(CollectionResourceDepth depth, int eventCount) {
    switch (depth) {
      case CollectionResourceDepth.project:
        return '조건에 맞는 공사가 없습니다';
      case CollectionResourceDepth.line:
        return '조건에 맞는 라인이 없습니다';
      case CollectionResourceDepth.equipment:
        return eventCount == 0 ? '이 날짜의 수집 이벤트가 없습니다' : '조건에 맞는 장비가 없습니다';
    }
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

class _StickyResourceColumn extends StatelessWidget {
  const _StickyResourceColumn({
    required this.label,
    required this.timeHeaderHeight,
    required this.rowHeight,
    required this.verticalController,
    required this.resources,
    required this.headerBuilder,
  });

  final String label;
  final double timeHeaderHeight;
  final double rowHeight;
  final ScrollController verticalController;
  final List<TimelineResource> resources;
  final TimelineResourceHeaderBuilder headerBuilder;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.SURFACE_RAISED,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: timeHeaderHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF3E424A)),
                  right: BorderSide(color: Color(0xFF3E424A)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.INK,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFF3E424A))),
              ),
              child: ListView.builder(
                controller: verticalController,
                itemExtent: rowHeight,
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  return headerBuilder(context, resources[index]);
                },
              ),
            ),
          ),
        ],
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
