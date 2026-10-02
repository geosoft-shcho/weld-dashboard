import 'package:flutter/material.dart';

import '../../../../domain/entities/collected_node.dart';
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
                nodes: viewModel.nodes,
                viewportWidth: constraints.maxWidth,
                viewportHeight: constraints.maxHeight,
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
    required this.nodes,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.onSelect,
  });

  final CollectionBoard board;
  final List<CollectedNode> nodes;
  final double viewportWidth;
  final double viewportHeight;
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
    final pixelsPerMinute = query.zoomHours >= 24
        ? fitPpm
        : (zoomPpm > fitPpm ? zoomPpm : fitPpm);
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
        spineTop +
        10 +
        belowCount * (ROADMAP_CARD_HEIGHT + ROADMAP_LANE_GAP) +
        16;

    final nowMinutes = roadmapMinutesFromDayStart(DateTime.now());
    final nowX = nowMinutes >= t0 && nowMinutes <= t1
        ? (nowMinutes - t0) * pixelsPerMinute
        : null;
    final contentHeight = _headerHeight + trackHeight;
    final bodyHeight = viewportHeight > contentHeight
        ? viewportHeight
        : contentHeight;

    return Container(
      width: viewportWidth,
      height: viewportHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.SURFACE,
        borderRadius: BorderRadius.circular(6),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: SizedBox(
            width: canvasWidth,
            height: bodyHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: _headerHeight,
                  child: CustomPaint(
                    painter: _RoadmapAxisPainter(
                      rangeStartMinutes: t0,
                      rangeEndMinutes: t1,
                      pixelsPerMinute: pixelsPerMinute,
                      nowX: nowX,
                    ),
                  ),
                ),
                Expanded(
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
        ? spineTop -
              10 -
              ROADMAP_CARD_HEIGHT -
              m.rank * (ROADMAP_CARD_HEIGHT + ROADMAP_LANE_GAP)
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
        child: Container(
          width: 1,
          height: stemHeight,
          color: color.withValues(alpha: 0.7),
        ),
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
          node: _nodeOf(m.event),
          isSelected: selected,
          onTap: () => onSelect(m.event.eventId, m.event.equipmentId),
        ),
      ),
    ];
  }

  CollectedNode? _nodeOf(CollectionEvent event) {
    for (final node in nodes) {
      if (node.nodeKey == event.eventId) {
        return node;
      }
    }
    return null;
  }

  static int _laneCount(
    List<RoadmapMilestone> milestones, {
    required bool above,
  }) {
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
    required this.node,
    required this.isSelected,
    required this.onTap,
  });

  final CollectionEvent event;
  final CollectedNode? node;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = CollectionEventTimelineMapper.colorOf(event);
    final hasFiles = _doesHaveFiles(node, event);
    final bg = hasFiles ? AppTheme.SURFACE_RAISED : const Color(0xFF32363C);
    final name = node == null
        ? event.equipmentName
        : (node!.label.isEmpty ? '미지정' : node!.label);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppTheme.ACCENT_STEEL : color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.INK,
                ),
              ),
              Text(
                _summaryOf(node),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xFFB0B6C0)),
              ),
              Text(
                _spanOf(node, event),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xFFB0B6C0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _doesHaveFiles(CollectedNode? node, CollectionEvent event) {
    if (node == null) {
      return event.connectionStatus == ConnectionStatus.connected;
    }
    return (node.assetCount ?? 0) > 0 || node.contentUrl.isNotEmpty;
  }

  String _summaryOf(CollectedNode? node) {
    if (node == null) {
      return '—';
    }
    final parts = <String>[
      if (node.assetCount != null)
        '파일 ${DashboardFormatters.count(node.assetCount!)}',
      if (node.totalSizeBytes != null) _sizeLabel(node.totalSizeBytes!),
      if (node.jobCount != null)
        '작업 ${DashboardFormatters.count(node.jobCount!)}',
      if (node.workDurationSeconds != null)
        _workDurationLabel(node.workDurationSeconds!),
    ];
    if (parts.isEmpty && node.contentUrl.isNotEmpty) {
      return node.contentUrl;
    }
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  String _spanOf(CollectedNode? node, CollectionEvent event) {
    final startedAt = node?.startedAt ?? event.eventAt;
    final endedAt = node?.endedAt;
    if (endedAt == null) {
      return _stamp(startedAt);
    }
    return '${_stamp(startedAt)}–${_stamp(endedAt)}';
  }

  String _stamp(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }

  String _sizeLabel(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex += 1;
    }
    if (unitIndex == 0) {
      return '${DashboardFormatters.count(bytes)} B';
    }
    final digits = size >= 100 ? 0 : 1;
    return '${size.toStringAsFixed(digits)} ${units[unitIndex]}';
  }

  String _workDurationLabel(int seconds) {
    if (seconds < 60) {
      return '$seconds초';
    }
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (days > 0) {
      return '$days일 $hours시간';
    }
    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
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
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      line,
    );

    final textStyle = const TextStyle(color: Color(0xFFB0B6C0), fontSize: 10);
    final step = rangeEndMinutes - rangeStartMinutes > 6 * 60 ? 60 : 30;
    final first = ((rangeStartMinutes + step - 1) ~/ step) * step;
    for (var m = first; m <= rangeEndMinutes; m += step) {
      final x = (m - rangeStartMinutes) * pixelsPerMinute;
      canvas.drawLine(Offset(x, size.height - 6), Offset(x, size.height), line);
      final h = m ~/ 60;
      final min = m % 60;
      final label =
          '${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
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
