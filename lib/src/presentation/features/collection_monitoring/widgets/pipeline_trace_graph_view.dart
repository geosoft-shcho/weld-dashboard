import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_node_icons.dart';
import 'pipeline_stage_chips.dart';
import 'pipeline_status_mapper.dart';

/// DataFlow식 캔버스: 단계 열·이벤트 노드 + 골격/path 연결. 줌·팬.
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
  final TransformationController _transform = TransformationController();

  /// 탭으로 포커스한 이벤트 노드. 여정 선택과는 별개.
  String? _focusedNodeId;

  /// 초기 fit을 다시 잡을 때 비교하는 뷰포트·캔버스 크기.
  Size? _fitViewport;
  Size? _fitCanvas;

  /// 노드·라벨이 겹치지 않는 최소 셀.
  static const double _minColumnWidth = 128;
  static const double _minRowHeight = 96;
  static const double _headerBand = 28;
  static const double _padX = 24;
  static const double _padY = 16;
  static const double _nodeRadius = 18;
  static const double _compactRadius = 14;
  static const double _minScale = 0.4;
  static const double _maxScale = 2.5;
  static const double _zoomStep = 1.2;

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
    _transform.dispose();
    super.dispose();
  }

  void _scheduleFitIfNeeded(Size viewport, Size canvas) {
    if (_fitViewport == viewport && _fitCanvas == canvas) {
      return;
    }
    _fitViewport = viewport;
    _fitCanvas = canvas;
    final sx = canvas.width <= 0 ? 1.0 : viewport.width / canvas.width;
    final sy = canvas.height <= 0 ? 1.0 : viewport.height / canvas.height;
    final fit = math.min(1.0, math.min(sx, sy)).clamp(_minScale, _maxScale);
    final matrix = Matrix4.identity()..scaleByDouble(fit, fit, 1, 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _transform.value = matrix;
    });
  }

  void _zoomBy(double factor) {
    final m = _transform.value.clone();
    final current = m.getMaxScaleOnAxis();
    final next = (current * factor).clamp(_minScale, _maxScale);
    if ((next - current).abs() < 1e-6) {
      return;
    }
    final ratio = next / current;
    // 뷰포트 중심 기준으로 확대·축소.
    final vp = _fitViewport;
    if (vp == null || vp.isEmpty) {
      m.scaleByDouble(ratio, ratio, 1, 1);
      _transform.value = m;
      return;
    }
    final focal = Offset(vp.width / 2, vp.height / 2);
    m.translateByDouble(focal.dx, focal.dy, 0, 1);
    m.scaleByDouble(ratio, ratio, 1, 1);
    m.translateByDouble(-focal.dx, -focal.dy, 0, 1);
    _transform.value = m;
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
                compact: widget.compact,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final viewport = constraints.biggest;
                    final layout = _CellLayout.fromViewport(
                      stages: stages,
                      viewport: viewport,
                      nodeRadius: radius,
                    );
                    _scheduleFitIfNeeded(viewport, layout.canvasSize);
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
                          for (
                            var stageIndex = 0;
                            stageIndex < stages.length;
                            stageIndex++
                          )
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
                              onTap: () => _didTapNode(entry.key),
                            ),
                        ],
                      ),
                    );

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: InteractiveViewer(
                            transformationController: _transform,
                            minScale: _minScale,
                            maxScale: _maxScale,
                            constrained: false,
                            boundaryMargin: const EdgeInsets.all(48),
                            child: canvas,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: '축소',
                                child: IconButton(
                                  icon: const Icon(
                                    FluentIcons.remove,
                                    size: 12,
                                  ),
                                  onPressed: () => _zoomBy(1 / _zoomStep),
                                ),
                              ),
                              Tooltip(
                                message: '확대',
                                child: IconButton(
                                  icon: const Icon(FluentIcons.add, size: 12),
                                  onPressed: () => _zoomBy(_zoomStep),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (_focusedNodeId != null) ...[
                const SizedBox(height: 6),
                _FocusedNodeEventStrip(
                  nodeId: _focusedNodeId!,
                  selected: selected,
                  onDismiss: () {
                    setState(() {
                      _focusedNodeId = null;
                    });
                  },
                ),
              ],
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
    final fill = pipelineStatusFill(visual, accent);
    final border = pipelineStatusBorder(visual, accent);
    final ink = pipelineStatusInk(visual);
    final status = pipelineStatusShortLabel(visual);
    final live = pipelineNodeIsLive(visual);
    const ringPad = 4.0;
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
              width: radius * 2 + (live ? ringPad * 2 : 0),
              height: radius * 2 + (live ? ringPad * 2 : 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (live) ...[
                    Container(
                      width: radius * 2 + ringPad * 2,
                      height: radius * 2 + ringPad * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: border.withValues(alpha: 0.45),
                          width: 2,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size(
                        radius * 2 + ringPad * 2,
                        radius * 2 + ringPad * 2,
                      ),
                      painter: _LiveNodeArcPainter(
                        color: border,
                        progress: _pulse.value,
                      ),
                    ),
                  ],
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
                    ),
                    child: Icon(
                      visual == PipelineNodeVisual.done
                          ? FluentIcons.check_mark
                          : pipelineNodeIconData(nodeId),
                      size: radius,
                      color: ink,
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

  void _didTapNode(String nodeId) {
    setState(() {
      if (_focusedNodeId == nodeId) {
        _focusedNodeId = null;
      } else {
        _focusedNodeId = nodeId;
      }
    });
  }
}

/// 포커스 노드의 이벤트 요약. 선택 Trace.events에서 name 매칭.
class _FocusedNodeEventStrip extends StatelessWidget {
  const _FocusedNodeEventStrip({
    required this.nodeId,
    required this.selected,
    required this.onDismiss,
  });

  final String nodeId;
  final TraceSnapshot? selected;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final label = pipelineEventLabel(nodeId);
    final body = _bodyText(label);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3E424A)),
        borderRadius: BorderRadius.circular(4),
        color: AppTheme.SURFACE_RAISED.withValues(alpha: 0.65),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              body,
              style: const TextStyle(color: AppTheme.INK, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(FluentIcons.chrome_close, size: 12),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }

  String _bodyText(String label) {
    final selected = this.selected;
    if (selected == null) {
      return '$label · 목록에서 여정을 선택하면 이 노드 이벤트를 볼 수 있습니다.';
    }
    final matched = traceEventNamed(selected.events, nodeId);
    if (matched == null) {
      return '$label · 이 여정에 이 이벤트 기록이 없습니다.';
    }
    final parts = <String>[
      label,
      if (matched.status.isNotEmpty) matched.status,
      if (matched.at != null) _formatAt(matched.at!),
      if (matched.runId.isNotEmpty) 'run ${matched.runId}',
      if (matched.errorMessage.isNotEmpty) matched.errorMessage,
    ];
    return parts.join(' · ');
  }

  String _formatAt(DateTime at) {
    final local = at.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    return '$month-$day $hour:$minute:$second';
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
    required this.headerTop,
  });

  final double columnWidth;
  final double rowHeight;
  final double radius;
  final Size canvasSize;
  final Map<String, Offset> positions;
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

    final availW = math.max(
      1.0,
      viewport.width - 2 * _PipelineTraceGraphViewState._padX,
    );
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
    final canvasHeight =
        _PipelineTraceGraphViewState._headerBand +
        _PipelineTraceGraphViewState._padY +
        maxRows * rowHeight;

    final radius = math
        .min(nodeRadius, math.min(columnWidth * 0.22, rowHeight * 0.22))
        .clamp(12.0, nodeRadius);

    final positions = <String, Offset>{};
    for (var stageIndex = 0; stageIndex < stages.length; stageIndex++) {
      final nodeIds = stages[stageIndex].nodeIds;
      for (var row = 0; row < nodeIds.length; row++) {
        // 원 중심: 셀 상단 쪽에 두어 아래 라벨 공간을 확보.
        final cx =
            _PipelineTraceGraphViewState._padX +
            stageIndex * columnWidth +
            columnWidth / 2;
        final cy =
            _PipelineTraceGraphViewState._headerBand +
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
      headerTop: 6,
    );
  }
}

class _LiveStatusSummary extends StatelessWidget {
  const _LiveStatusSummary({
    required this.running,
    required this.done,
    required this.failed,
    required this.compact,
  });

  final int running;
  final int done;
  final int failed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('진행 $running', AppTheme.ACCENT_STEEL, emphasize: running > 0),
        const SizedBox(width: 8),
        _chip('완료 $done', AppTheme.STATUS_OK),
        const SizedBox(width: 8),
        _chip('실패 $failed', AppTheme.STATUS_ERROR, emphasize: failed > 0),
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

  Widget _chip(String label, Color color, {bool emphasize = false}) {
    final size = emphasize ? 10.0 : 8.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: emphasize
                ? Border.all(
                    color: AppTheme.INK.withValues(alpha: 0.55),
                    width: 1,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.INK,
            fontSize: compact ? 11 : 12,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// live 노드: 고정 링 위에 진행 아크만(sine wobble 없음).
class _LiveNodeArcPainter extends CustomPainter {
  _LiveNodeArcPainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final start = -math.pi / 2 + progress * math.pi * 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      math.pi * 0.55,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LiveNodeArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
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

  static const int _liveParticleCount = 3;

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
      // 좌→우 current: dash phase가 진행 방향으로 흐름(선형).
      _drawDashedPath(canvas, path, paint, phase: pulse);
      for (final metric in path.computeMetrics()) {
        if (metric.length <= 0) {
          continue;
        }
        final particlePaint = Paint()..color = color;
        for (var i = 0; i < _liveParticleCount; i++) {
          final t = (pulse + i / _liveParticleCount) % 1.0;
          final tangent = metric.getTangentForOffset(metric.length * t);
          if (tangent == null) {
            continue;
          }
          canvas.drawCircle(tangent.position, 3.2, particlePaint);
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

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double phase,
  }) {
    const dash = 6.0;
    const gap = 4.0;
    final period = dash + gap;
    // phase 증가 → dash가 from→to 방향으로 이동.
    final offset = (phase % 1.0) * period;
    for (final metric in path.computeMetrics()) {
      var distance = -offset;
      var draw = true;
      while (distance < metric.length) {
        final segment = draw ? dash : gap;
        final next = math.min(distance + segment, metric.length);
        if (draw && next > 0) {
          final start = math.max(0.0, distance);
          if (start < next) {
            canvas.drawPath(metric.extractPath(start, next), paint);
          }
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
