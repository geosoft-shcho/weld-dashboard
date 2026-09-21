import 'package:flutter/material.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_event.dart';
import '../../../../domain/entities/connection_status.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart' show AppTheme;
import '../collection_monitoring_view_model.dart';
import 'collection_event_timeline_mapper.dart';
import 'collection_roadmap_layout.dart';

class CollectionRoadmapView extends StatelessWidget {
  const CollectionRoadmapView({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    final timeline = board.timeline;
    if (timeline.events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('이 날짜의 수집 이벤트가 없습니다'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            '로드맵 · 가로 이정표, 길이는 안 그림',
            style: TextStyle(fontSize: 12, color: Color(0xFFB0B6C0)),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _RoadmapCanvas(
                board: board,
                viewportWidth: constraints.maxWidth,
                onSelect: viewModel.didSelectEvent,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RoadmapCanvas extends StatelessWidget {
  const _RoadmapCanvas({
    required this.board,
    required this.viewportWidth,
    required this.onSelect,
  });

  final CollectionBoard board;
  final double viewportWidth;
  final void Function(String eventId, String equipmentId) onSelect;

  static const double _headerHeight = 28;

  @override
  Widget build(BuildContext context) {
    final query = board.query;
    final t0 = query.startMinutes;
    final t1 = query.endMinutes <= t0 ? t0 + 1 : query.endMinutes;
    final winMin = t1 - t0;
    final zoomPpm = CollectionEventTimelineMapper.pixelsPerMinute(
      query.zoomHours,
    );
    final fitPpm = viewportWidth / winMin;
    final pixelsPerMinute =
        query.zoomHours >= 24 ? fitPpm : (zoomPpm > fitPpm ? zoomPpm : fitPpm);
    final canvasWidth = winMin * pixelsPerMinute;

    final milestones = layoutRoadmapMilestones(
      events: board.timeline.events,
      rangeStartMinutes: t0,
      pixelsPerMinute: pixelsPerMinute,
    );
    final aboveCount = _laneCount(milestones, above: true);
    final belowCount = _laneCount(milestones, above: false);
    final spineTop =
        12 + aboveCount * (ROADMAP_CARD_HEIGHT + ROADMAP_LANE_GAP) + 8;
    final trackHeight =
        spineTop + 10 + belowCount * (ROADMAP_CARD_HEIGHT + ROADMAP_LANE_GAP) + 16;

    final snapMin = roadmapMinutesFromDayStart(query.snapshotAt);
    final nowX = snapMin >= t0 && snapMin <= t1
        ? (snapMin - t0) * pixelsPerMinute
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: ColoredBox(
        color: AppTheme.SURFACE,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: canvasWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _headerHeight,
                    width: canvasWidth,
                    child: CustomPaint(
                      painter: _RoadmapAxisPainter(
                        rangeStartMinutes: t0,
                        rangeEndMinutes: t1,
                        pixelsPerMinute: pixelsPerMinute,
                        nowX: nowX,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: trackHeight,
                    width: canvasWidth,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: spineTop,
                          child: Container(
                            height: 2,
                            color: const Color(0xFF3E424A),
                          ),
                        ),
                        if (nowX != null)
                          Positioned(
                            left: nowX - 1,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              color: AppTheme.ACCENT_STEEL,
                            ),
                          ),
                        for (final m in milestones)
                          ..._milestoneLayers(
                            m,
                            t0: t0,
                            pixelsPerMinute: pixelsPerMinute,
                            spineTop: spineTop,
                            selectedId: board.timeline.selectedEventId,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _milestoneLayers(
    RoadmapMilestone m, {
    required int t0,
    required double pixelsPerMinute,
    required double spineTop,
    required String selectedId,
  }) {
    final left = (m.startMinutes - t0) * pixelsPerMinute;
    final top = m.isAbove
        ? spineTop - 10 - ROADMAP_CARD_HEIGHT - m.rank * (ROADMAP_CARD_HEIGHT + ROADMAP_LANE_GAP)
        : spineTop + 12 + m.rank * (ROADMAP_CARD_HEIGHT + ROADMAP_LANE_GAP);
    final stemTop = m.isAbove ? top + ROADMAP_CARD_HEIGHT : spineTop + 2;
    final stemHeight = m.isAbove
        ? (spineTop - (top + ROADMAP_CARD_HEIGHT)).clamp(8.0, 200.0)
        : (top - spineTop - 2).clamp(8.0, 200.0);
    final color = CollectionEventTimelineMapper.colorOf(m.event);
    final selected = m.event.eventId == selectedId;

    return [
      Positioned(
        left: left + 2,
        top: stemTop,
        child: Container(width: 1, height: stemHeight, color: color.withValues(alpha: 0.7)),
      ),
      Positioned(
        left: left - 3,
        top: spineTop - 3,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
      Positioned(
        left: left,
        top: top,
        width: ROADMAP_CARD_WIDTH,
        height: ROADMAP_CARD_HEIGHT,
        child: _RoadmapCard(
          event: m.event,
          isSelected: selected,
          onTap: () => onSelect(m.event.eventId, m.event.equipmentId),
        ),
      ),
    ];
  }

  static int _laneCount(List<RoadmapMilestone> milestones, {required bool above}) {
    var count = 1;
    for (final m in milestones) {
      if (m.isAbove == above && m.rank + 1 > count) {
        count = m.rank + 1;
      }
    }
    return count;
  }
}

class _RoadmapCard extends StatelessWidget {
  const _RoadmapCard({
    required this.event,
    required this.isSelected,
    required this.onTap,
  });

  final CollectionEvent event;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = CollectionEventTimelineMapper.colorOf(event);
    final label = event.isLossWarning
        ? '${event.connectionStatus.label} · 유실 ${DashboardFormatters.percent(event.lossRatePercent)}'
        : event.connectionStatus.label;
    final offset = event.clockOffsetMs == null ? '' : ' · ${event.clockOffsetMs}ms';
    final meta =
        '${DashboardFormatters.clockTime(event.eventAt)} · 수신 ${DashboardFormatters.count(event.receivedCount)} · ${event.timeSyncStatus.label}$offset';
    final bg = switch (event.connectionStatus) {
      ConnectionStatus.connected => AppTheme.SURFACE_RAISED,
      ConnectionStatus.disconnected => const Color(0xFF32363C),
      ConnectionStatus.error => const Color(0xFF3A2A2A),
    };

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: event.isLossWarning ? color.withValues(alpha: 0.18) : bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppTheme.ACCENT_STEEL : color,
            width: isSelected ? 2 : 1,
            style: event.isDesynced ? BorderStyle.none : BorderStyle.solid,
          ),
        ),
        child: CustomPaint(
          painter: event.isDesynced
              ? _DashedBorderPainter(color: isSelected ? AppTheme.ACCENT_STEEL : color)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${event.equipmentId} · ${event.lineName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: Color(0xFFB0B6C0)),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.INK,
                  ),
                ),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: Color(0xFFB0B6C0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoadmapAxisPainter extends CustomPainter {
  const _RoadmapAxisPainter({
    required this.rangeStartMinutes,
    required this.rangeEndMinutes,
    required this.pixelsPerMinute,
    required this.nowX,
  });

  final int rangeStartMinutes;
  final int rangeEndMinutes;
  final double pixelsPerMinute;
  final double? nowX;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF3E424A)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height - 1), Offset(size.width, size.height - 1), line);

    final textStyle = const TextStyle(color: Color(0xFFB0B6C0), fontSize: 10);
    final step = rangeEndMinutes - rangeStartMinutes > 6 * 60 ? 60 : 30;
    final first = ((rangeStartMinutes + step - 1) ~/ step) * step;
    for (var m = first; m <= rangeEndMinutes; m += step) {
      final x = (m - rangeStartMinutes) * pixelsPerMinute;
      canvas.drawLine(Offset(x, size.height - 6), Offset(x, size.height), line);
      final h = m ~/ 60;
      final min = m % 60;
      final label = '${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + 2, 4));
    }

    if (nowX != null) {
      final nowPaint = Paint()
        ..color = AppTheme.ACCENT_STEEL
        ..strokeWidth = 2;
      canvas.drawLine(Offset(nowX!, 0), Offset(nowX!, size.height), nowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoadmapAxisPainter oldDelegate) {
    return oldDelegate.rangeStartMinutes != rangeStartMinutes ||
        oldDelegate.rangeEndMinutes != rangeEndMinutes ||
        oldDelegate.pixelsPerMinute != pixelsPerMinute ||
        oldDelegate.nowX != nowX;
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(4)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + 4;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
