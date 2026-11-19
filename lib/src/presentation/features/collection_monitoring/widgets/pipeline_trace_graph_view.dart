import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_node_icons.dart';
import 'pipeline_stage_chips.dart';

/// DataFlow식 캔버스: 단계 열·이벤트 노드 + 골격/path 연결. 줌 없음.
class PipelineTraceGraphView extends StatefulWidget {
  const PipelineTraceGraphView({
    super.key,
    required this.viewModel,
    this.compact = false,
  });

  final PipelineTraceViewModel viewModel;
  final bool compact;

  @override
  State<PipelineTraceGraphView> createState() => _PipelineTraceGraphViewState();
}

class _PipelineTraceGraphViewState extends State<PipelineTraceGraphView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  /// 노드·라벨이 겹치지 않는 최소 셀.
  static const double _minColumnWidth = 128;
  static const double _minRowHeight = 96;
  static const double _headerBand = 28;
  static const double _padX = 24;
  static const double _padY = 16;
  static const double _nodeRadius = 18;
  static const double _compactRadius = 14;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final stages = viewModel.visibleStages;
    final selected = viewModel.selected;
    final traces = viewModel.visibleTraces;
    final radius = widget.compact ? _compactRadius : _nodeRadius;

    if (stages.isEmpty) {
      return const SizedBox.shrink();
    }

    final skeleton = pipelineSkeletonEdges(stages);
    final active = pipelineActivePathEdges(
      selected: selected,
      traces: traces,
      stages: stages,
    );
    final activeKeys = {for (final edge in active) edge.key};

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LiveStatusSummary(
                running: viewModel.runningCount,
                done: viewModel.doneCount,
                failed: viewModel.failedCount,
                pulse: _pulse.value,
                compact: widget.compact,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final layout = _CellLayout.fromViewport(
                      stages: stages,
                      viewport: constraints.biggest,
                      nodeRadius: radius,
                    );
                    final canvas = SizedBox(
                      width: layout.canvasSize.width,
                      height: layout.canvasSize.height,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomPaint(
                            size: layout.canvasSize,
                            painter: _PipelineFlowPainter(
                              positions: layout.positions,
                              skeleton: skeleton,
                              active: active,
                              activeKeys: activeKeys,
                              selected: selected,
                              traces: traces,
                              pulse: _pulse.value,
                              nodeRadius: layout.radius,
                            ),
                          ),
                          for (var stageIndex = 0;
                              stageIndex < stages.length;
                              stageIndex++)
                            Positioned(
                              left: layout.columnLeft(stageIndex),
                              top: layout.headerTop,
                              width: layout.columnWidth,
                              child: Text(
                                '${stages[stageIndex].label} · '
                                '${viewModel.stageCounts[stages[stageIndex].id] ?? 0}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: pipelineStageAccent(
                                    stages[stageIndex].id,
                                  ),
                                  fontSize: widget.compact ? 10 : 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          for (final entry in layout.positions.entries)
                            _buildNode(
                              nodeId: entry.key,
                              center: entry.value,
                              radius: layout.radius,
                              labelWidth: layout.columnWidth - 8,
                              stageId: pipelineStageOf(entry.key),
                              visual: pipelineNodeVisual(
                                nodeId: entry.key,
                                selected: selected,
                                traces: traces,
                              ),
                              onTap: () => _selectNear(
                                viewModel: viewModel,
                                nodeId: entry.key,
                                stageId: pipelineStageOf(entry.key),
                              ),
                            ),
                        ],
                      ),
                    );

                    if (layout.needsScroll) {
                      // Scrollbar+PrimaryScrollController는 이중 스크롤에서
                      // ScrollPosition 미연결 예외가 난다. 스크롤만 둔다.
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: canvas,
                        ),
                      );
                    }
                    return canvas;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNode({
    required String nodeId,
    required Offset center,
    required double radius,
    required double labelWidth,
    required String stageId,
    required PipelineNodeVisual visual,
    required VoidCallback onTap,
  }) {
    final accent = pipelineStageAccent(stageId);
    final fill = _fillOf(visual, accent);
    final border = _borderOf(visual, accent);
    final status = pipelineNodeStatusLabel(visual);
    final live = pipelineNodeIsLive(visual);
    final ring = live ? 2.0 + 1.2 * math.sin(_pulse.value * math.pi * 2) : 0.0;
    final label = pipelineEventLabel(nodeId);
    // 원 중심이 center, 라벨은 원 아래 셀 안에만.
    final blockTop = center.dy - radius;
    return Positioned(
      left: center.dx - labelWidth / 2,
      top: blockTop,
      width: labelWidth,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: radius * 2 + ring * 2,
              height: radius * 2 + ring * 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (live)
                    Container(
                      width: radius * 2 + ring * 2,
                      height: radius * 2 + ring * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: border.withValues(alpha: 0.45),
                          width: 2,
                        ),
                      ),
                    ),
                  Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fill,
                      border: Border.all(
                        color: border,
                        width: live ? 2.5 : 1.5,
                      ),
                      boxShadow: live
                          ? [
                              BoxShadow(
                                color: border.withValues(alpha: 0.35),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      visual == PipelineNodeVisual.done
                          ? FluentIcons.check_mark
                          : pipelineNodeIconData(nodeId),
                      size: radius,
                      color: visual == PipelineNodeVisual.idle
                          ? AppTheme.INK.withValues(alpha: 0.45)
                          : AppTheme.INK,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: visual == PipelineNodeVisual.idle
                    ? AppTheme.INK.withValues(alpha: 0.5)
                    : AppTheme.INK,
                fontSize: widget.compact ? 9 : 10,
                fontWeight: live || visual == PipelineNodeVisual.failed
                    ? FontWeight.w700
                    : FontWeight.w600,
              ),
            ),
            if (status.isNotEmpty)
              Text(
                status,
                style: TextStyle(
                  color: border,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _selectNear({
    required PipelineTraceViewModel viewModel,
    required String nodeId,
    required String stageId,
  }) {
    final candidates = [
      for (final trace in viewModel.visibleTraces)
        if (trace.lastEvent == nodeId ||
            pipelineStageOf(trace.lastEvent) == stageId)
          trace,
    ];
    if (candidates.isEmpty && viewModel.visibleTraces.isNotEmpty) {
      viewModel.didSelectTrace(viewModel.visibleTraces.first.traceId);
      return;
    }
    if (candidates.isNotEmpty) {
      viewModel.didSelectTrace(candidates.first.traceId);
    }
  }

  Color _fillOf(PipelineNodeVisual visual, Color accent) {
    switch (visual) {
      case PipelineNodeVisual.idle:
        return AppTheme.STATUS_OFF.withValues(alpha: 0.28);
      case PipelineNodeVisual.done:
        return accent.withValues(alpha: 0.85);
      case PipelineNodeVisual.active:
      case PipelineNodeVisual.running:
        return accent;
      case PipelineNodeVisual.queued:
        return AppTheme.STATUS_WARN.withValues(alpha: 0.85);
      case PipelineNodeVisual.failed:
        return AppTheme.STATUS_ERROR.withValues(alpha: 0.9);
      case PipelineNodeVisual.skipped:
        return AppTheme.STATUS_OFF.withValues(alpha: 0.4);
    }
  }

  Color _borderOf(PipelineNodeVisual visual, Color accent) {
    switch (visual) {
      case PipelineNodeVisual.idle:
        return AppTheme.STATUS_OFF.withValues(alpha: 0.55);
      case PipelineNodeVisual.done:
        return accent;
      case PipelineNodeVisual.active:
      case PipelineNodeVisual.running:
        return AppTheme.INK;
      case PipelineNodeVisual.queued:
        return AppTheme.STATUS_WARN;
      case PipelineNodeVisual.failed:
        return AppTheme.STATUS_ERROR;
      case PipelineNodeVisual.skipped:
        return AppTheme.STATUS_OFF;
    }
  }
}

/// viewport에 맞춰 셀을 나누되 최소 폭·높이로 겹침을 막는다.
class _CellLayout {
  const _CellLayout({
    required this.columnWidth,
    required this.rowHeight,
    required this.radius,
    required this.canvasSize,
    required this.positions,
    required this.needsScroll,
    required this.headerTop,
  });

  final double columnWidth;
  final double rowHeight;
  final double radius;
  final Size canvasSize;
  final Map<String, Offset> positions;
  final bool needsScroll;
  final double headerTop;

  double columnLeft(int stageIndex) =>
      _PipelineTraceGraphViewState._padX + stageIndex * columnWidth;

  factory _CellLayout.fromViewport({
    required List<PipelineStageDef> stages,
    required Size viewport,
    required double nodeRadius,
  }) {
    final stageCount = math.max(1, stages.length);
    var maxRows = 1;
    for (final stage in stages) {
      maxRows = math.max(maxRows, stage.nodeIds.length);
    }

    final availW =
        math.max(1.0, viewport.width - 2 * _PipelineTraceGraphViewState._padX);
    final availH = math.max(
      1.0,
      viewport.height -
          _PipelineTraceGraphViewState._headerBand -
          _PipelineTraceGraphViewState._padY,
    );

    final columnWidth = math.max(
      _PipelineTraceGraphViewState._minColumnWidth,
      availW / stageCount,
    );
    final rowHeight = math.max(
      _PipelineTraceGraphViewState._minRowHeight,
      availH / maxRows,
    );

    final canvasWidth =
        2 * _PipelineTraceGraphViewState._padX + stageCount * columnWidth;
    final canvasHeight = _PipelineTraceGraphViewState._headerBand +
        _PipelineTraceGraphViewState._padY +
        maxRows * rowHeight;
    final needsScroll =
        canvasWidth > viewport.width + 0.5 || canvasHeight > viewport.height + 0.5;

    final radius = math.min(
      nodeRadius,
      math.min(columnWidth * 0.22, rowHeight * 0.22),
    ).clamp(12.0, nodeRadius);

    final positions = <String, Offset>{};
    for (var stageIndex = 0; stageIndex < stages.length; stageIndex++) {
      final nodeIds = stages[stageIndex].nodeIds;
      for (var row = 0; row < nodeIds.length; row++) {
        // 원 중심: 셀 상단 쪽에 두어 아래 라벨 공간을 확보.
        final cx = _PipelineTraceGraphViewState._padX +
            stageIndex * columnWidth +
            columnWidth / 2;
        final cy = _PipelineTraceGraphViewState._headerBand +
            row * rowHeight +
            radius +
            8;
        positions[nodeIds[row]] = Offset(cx, cy);
      }
    }

    return _CellLayout(
      columnWidth: columnWidth,
      rowHeight: rowHeight,
      radius: radius,
      canvasSize: Size(canvasWidth, canvasHeight),
      positions: positions,
      needsScroll: needsScroll,
      headerTop: 6,
    );
  }
}

class _LiveStatusSummary extends StatelessWidget {
  const _LiveStatusSummary({
    required this.running,
    required this.done,
    required this.failed,
    required this.pulse,
    required this.compact,
  });

  final int running;
  final int done;
  final int failed;
  final double pulse;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final glow = 0.55 + 0.45 * math.sin(pulse * math.pi * 2);
    return Row(
      children: [
        _chip('진행 $running', AppTheme.ACCENT_STEEL, running > 0 ? glow : 0),
        const SizedBox(width: 8),
        _chip('완료 $done', AppTheme.STATUS_OK, 0),
        const SizedBox(width: 8),
        _chip(
          '실패 $failed',
          AppTheme.STATUS_ERROR,
          failed > 0 ? 0.35 + 0.2 * math.sin(pulse * math.pi * 2) : 0,
        ),
        const Spacer(),
        Text(
          running > 0 ? '실시간 반영 중' : '대기',
          style: TextStyle(
            color: AppTheme.INK.withValues(alpha: 0.65),
            fontSize: compact ? 10 : 11,
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, Color color, double pulse) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: pulse > 0
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: pulse),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.INK,
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PipelineFlowPainter extends CustomPainter {
  _PipelineFlowPainter({
    required this.positions,
    required this.skeleton,
    required this.active,
    required this.activeKeys,
    required this.selected,
    required this.traces,
    required this.pulse,
    required this.nodeRadius,
  });

  final Map<String, Offset> positions;
  final List<PipelineTraceEdge> skeleton;
  final List<PipelineTraceEdge> active;
  final Set<String> activeKeys;
  final TraceSnapshot? selected;
  final List<TraceSnapshot> traces;
  final double pulse;
  final double nodeRadius;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in skeleton) {
      final from = positions[edge.fromId];
      final to = positions[edge.toId];
      if (from == null || to == null) {
        continue;
      }
      if (activeKeys.contains(edge.key)) {
        continue;
      }
      _drawBezier(
        canvas,
        from,
        to,
        color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
        strokeWidth: 1.4,
        live: false,
      );
    }

    for (final edge in active) {
      final from = positions[edge.fromId];
      final to = positions[edge.toId];
      if (from == null || to == null) {
        continue;
      }
      final live = pipelineEdgeIsLive(
        fromId: edge.fromId,
        toId: edge.toId,
        selected: selected,
        traces: traces,
      );
      _drawBezier(
        canvas,
        from,
        to,
        color: live ? AppTheme.INK : AppTheme.ACCENT_STEEL,
        strokeWidth: live ? 2.6 : 2.2,
        live: live,
      );
    }
  }

  void _drawBezier(
    Canvas canvas,
    Offset from,
    Offset to, {
    required Color color,
    required double strokeWidth,
    required bool live,
  }) {
    final path = _bezierPath(from, to);
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    if (live) {
      _drawDashedPath(canvas, path, paint);
      final metrics = path.computeMetrics().toList();
      if (metrics.isNotEmpty) {
        final metric = metrics.first;
        final t = pulse % 1.0;
        final tangent = metric.getTangentForOffset(metric.length * t);
        if (tangent != null) {
          canvas.drawCircle(
            tangent.position,
            3.4,
            Paint()..color = color,
          );
        }
      }
    } else {
      canvas.drawPath(path, paint);
    }
    _drawArrow(canvas, from, to, color);
  }

  Path _bezierPath(Offset from, Offset to) {
    final dx = to.dx - from.dx;
    final path = Path()..moveTo(from.dx, from.dy);
    if (dx.abs() < 8) {
      path.lineTo(to.dx, to.dy);
      return path;
    }
    final c1 = Offset(from.dx + dx * 0.45, from.dy);
    final c2 = Offset(to.dx - dx * 0.45, to.dy);
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, to.dx, to.dy);
    return path;
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 6.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final next = math.min(
          distance + (draw ? dash : gap),
          metric.length,
        );
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, next), paint);
        }
        distance = next;
        draw = !draw;
      }
    }
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Color color) {
    final angle = math.atan2(to.dy - from.dy, to.dx - from.dx);
    const size = 7.0;
    final tip = Offset(
      to.dx - math.cos(angle) * (nodeRadius + 2),
      to.dy - math.sin(angle) * (nodeRadius + 2),
    );
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(
        tip.dx - size * math.cos(angle - 0.45),
        tip.dy - size * math.sin(angle - 0.45),
      )
      ..lineTo(
        tip.dx - size * math.cos(angle + 0.45),
        tip.dy - size * math.sin(angle + 0.45),
      )
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _PipelineFlowPainter oldDelegate) {
    return oldDelegate.pulse != pulse ||
        oldDelegate.activeKeys != activeKeys ||
        oldDelegate.selected != selected ||
        oldDelegate.traces != traces ||
        oldDelegate.positions != positions;
  }
}
