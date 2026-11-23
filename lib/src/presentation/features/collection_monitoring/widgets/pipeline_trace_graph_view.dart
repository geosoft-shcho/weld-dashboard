import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_node_icons.dart';
import 'pipeline_stage_chips.dart';
import 'pipeline_status_mapper.dart';

/// DataFlow식 캔버스: 가로 레일 Stage·노드 + path 연결.
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
    with TickerProviderStateMixin {
  late final AnimationController _pulse;

  /// 탭으로 포커스한 이벤트 노드. 여정 선택과는 별개.
  String? _focusedNodeId;

  /// 완료·대기 Stage를 사용자가 수동으로 펼친 id.
  final Set<String> _manualExpanded = {};

  /// Stage별 펼침 진행(0=접힘, 1=펼침).
  final Map<String, AnimationController> _expandCtrls = {};

  static const double _headerBand = 28;
  static const double _padX = 24;
  static const double _padY = 16;
  static const double _nodeRadius = 18;
  static const double _compactRadius = 14;
  static const double _nodePitch = 76;
  static const double _collapsedWidth = 96;
  static const double _stageGap = 36;
  static const Duration _expandDuration = Duration(milliseconds: 240);

  /// 실패·진행 계열은 항상 펼침. 완료·대기는 접힘(수동 펼침 가능).
  static bool _autoExpand(PipelineNodeVisual visual) {
    switch (visual) {
      case PipelineNodeVisual.failed:
      case PipelineNodeVisual.running:
      case PipelineNodeVisual.queued:
      case PipelineNodeVisual.active:
        return true;
      case PipelineNodeVisual.done:
      case PipelineNodeVisual.skipped:
      case PipelineNodeVisual.idle:
        return false;
    }
  }

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
    for (final ctrl in _expandCtrls.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  AnimationController _expandCtrl(String stageId, {required bool expanded}) {
    final existing = _expandCtrls[stageId];
    if (existing != null) {
      return existing;
    }
    final ctrl =
        AnimationController(
          vsync: this,
          duration: _expandDuration,
          value: expanded ? 1 : 0,
        )..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
    _expandCtrls[stageId] = ctrl;
    return ctrl;
  }

  void _syncExpandAnimations(
    List<PipelineStageDef> stages,
    Set<String> expandedIds,
  ) {
    for (final stage in stages) {
      final want = expandedIds.contains(stage.id);
      final ctrl = _expandCtrl(stage.id, expanded: want);
      if (want) {
        if (ctrl.status != AnimationStatus.completed &&
            ctrl.status != AnimationStatus.forward) {
          ctrl.forward();
        }
      } else if (ctrl.status != AnimationStatus.dismissed &&
          ctrl.status != AnimationStatus.reverse) {
        ctrl.reverse();
      }
    }
  }

  Map<String, double> _expandProgress(List<PipelineStageDef> stages) {
    return {
      for (final stage in stages)
        stage.id: Curves.easeInOut.transform(
          _expandCtrls[stage.id]?.value ?? 0,
        ),
    };
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

    final active = pipelineActivePathEdges(
      selected: selected,
      traces: traces,
      stages: stages,
    );

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Builder(
                  builder: (_) {
                    final stageVisuals = <String, PipelineNodeVisual>{
                      for (final stage in stages)
                        stage.id: pipelineStageVisual(
                          stageId: stage.id,
                          selected: selected,
                          traces: traces,
                        ),
                    };
                    final expandedIds = <String>{
                      for (final stage in stages)
                        if (_autoExpand(stageVisuals[stage.id]!) ||
                            _manualExpanded.contains(stage.id))
                          stage.id,
                    };
                    for (final stage in stages) {
                      _expandCtrl(
                        stage.id,
                        expanded: expandedIds.contains(stage.id),
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) {
                        return;
                      }
                      _syncExpandAnimations(stages, expandedIds);
                    });
                    final expandT = _expandProgress(stages);
                    final layout = _RailLayout.fromStages(
                      stages: stages,
                      expandT: expandT,
                      nodeRadius: radius,
                    );
                    return FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: layout.canvasSize.width,
                        height: layout.canvasSize.height,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomPaint(
                              size: layout.canvasSize,
                              painter: _PipelineFlowPainter(
                                positions: layout.positions,
                                railPoints: layout.railPoints,
                                active: active,
                                selected: selected,
                                traces: traces,
                                pulse: _pulse.value,
                                nodeRadius: layout.radius,
                              ),
                            ),
                            for (final stage in stages)
                              Positioned(
                                left: layout.stageLeft[stage.id]!,
                                top: layout.headerTop,
                                width: layout.stageWidth[stage.id]!,
                                child: GestureDetector(
                                  onTap: () {
                                    final visual = stageVisuals[stage.id]!;
                                    if (_autoExpand(visual)) {
                                      return;
                                    }
                                    setState(() {
                                      if (_manualExpanded.contains(stage.id)) {
                                        _manualExpanded.remove(stage.id);
                                      } else {
                                        _manualExpanded.add(stage.id);
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${stage.label} · '
                                          '${viewModel.stageCounts[stage.id] ?? 0}',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: pipelineStageAccent(
                                              stage.id,
                                            ),
                                            fontSize: widget.compact ? 11 : 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Transform.rotate(
                                        angle:
                                            (expandT[stage.id] ?? 0) *
                                            (math.pi / 2),
                                        child: Icon(
                                          FluentIcons.chevron_right,
                                          size: 10,
                                          color: pipelineStageAccent(stage.id),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            for (final stage in stages)
                              if ((expandT[stage.id] ?? 0) < 0.98)
                                _buildCollapsedStage(
                                  stage: stage,
                                  center: layout.stageCenters[stage.id]!,
                                  width: layout.stageWidth[stage.id]!,
                                  radius: layout.radius,
                                  visual: stageVisuals[stage.id]!,
                                  opacity: (1.0 - (expandT[stage.id] ?? 0.0))
                                      .clamp(0.0, 1.0)
                                      .toDouble(),
                                  onTap: () {
                                    setState(() {
                                      _manualExpanded.add(stage.id);
                                    });
                                  },
                                ),
                            for (final entry in layout.positions.entries)
                              _buildNode(
                                nodeId: entry.key,
                                center: entry.value,
                                radius: layout.radius,
                                labelWidth: _nodePitch - 8,
                                stageId: pipelineStageOf(entry.key),
                                visual: pipelineNodeVisual(
                                  nodeId: entry.key,
                                  selected: selected,
                                  traces: traces,
                                ),
                                opacity:
                                    (expandT[pipelineStageOf(entry.key)] ?? 0.0)
                                        .clamp(0.0, 1.0)
                                        .toDouble(),
                                onTap: () => _didTapNode(entry.key),
                              ),
                          ],
                        ),
                      ),
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
    double opacity = 1,
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
      child: IgnorePointer(
        ignoring: opacity < 0.2,
        child: Opacity(
          opacity: opacity,
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
        ),
      ),
    );
  }

  Widget _buildCollapsedStage({
    required PipelineStageDef stage,
    required Offset center,
    required double width,
    required double radius,
    required PipelineNodeVisual visual,
    required VoidCallback onTap,
    double opacity = 1,
  }) {
    final accent = pipelineStageAccent(stage.id);
    final fill = pipelineStatusFill(visual, accent);
    final border = pipelineStatusBorder(visual, accent);
    final ink = pipelineStatusInk(visual);
    final status = pipelineStatusShortLabel(visual);
    return Positioned(
      left: center.dx - width / 2,
      top: center.dy - radius - 2,
      width: width,
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: radius * 2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      visual == PipelineNodeVisual.done
                          ? FluentIcons.check_mark
                          : FluentIcons.more,
                      size: radius * 0.9,
                      color: ink,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${stage.nodeIds.length}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ink,
                          fontSize: widget.compact ? 10 : 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stage.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: visual == PipelineNodeVisual.idle
                      ? AppTheme.INK.withValues(alpha: 0.5)
                      : AppTheme.INK,
                  fontSize: widget.compact ? 9 : 10,
                  fontWeight: FontWeight.w600,
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

/// 가로 레일: Stage 좌→우, 펼친 Stage의 nodeIds도 좌→우.
class _RailLayout {
  const _RailLayout({
    required this.radius,
    required this.canvasSize,
    required this.positions,
    required this.stageCenters,
    required this.stageLeft,
    required this.stageWidth,
    required this.railPoints,
    required this.headerTop,
  });

  final double radius;
  final Size canvasSize;
  final Map<String, Offset> positions;
  final Map<String, Offset> stageCenters;
  final Map<String, double> stageLeft;
  final Map<String, double> stageWidth;
  final List<Offset> railPoints;
  final double headerTop;

  factory _RailLayout.fromStages({
    required List<PipelineStageDef> stages,
    required Map<String, double> expandT,
    required double nodeRadius,
  }) {
    final radius = nodeRadius.clamp(12.0, 22.0);
    final railY = _PipelineTraceGraphViewState._headerBand + radius + 18;
    final positions = <String, Offset>{};
    final stageCenters = <String, Offset>{};
    final stageLeft = <String, double>{};
    final stageWidth = <String, double>{};
    final railPoints = <Offset>[];

    var cursor = _PipelineTraceGraphViewState._padX;
    for (var i = 0; i < stages.length; i++) {
      final stage = stages[i];
      final t = (expandT[stage.id] ?? 0).clamp(0.0, 1.0);
      final collapsedW = _PipelineTraceGraphViewState._collapsedWidth;
      final expandedW = math.max(
        collapsedW,
        stage.nodeIds.length * _PipelineTraceGraphViewState._nodePitch,
      );
      final width = collapsedW + (expandedW - collapsedW) * t;
      stageLeft[stage.id] = cursor;
      stageWidth[stage.id] = width;
      final centerX = cursor + width / 2;
      stageCenters[stage.id] = Offset(centerX, railY);

      final n = math.max(1, stage.nodeIds.length);
      final pitch = width / n;
      for (var ni = 0; ni < stage.nodeIds.length; ni++) {
        final expandedCx = cursor + pitch * (ni + 0.5);
        final cx = centerX + (expandedCx - centerX) * t;
        final p = Offset(cx, railY);
        positions[stage.nodeIds[ni]] = p;
        if (t > 0.08) {
          railPoints.add(p);
        }
      }
      if (t <= 0.08) {
        railPoints.add(Offset(centerX, railY));
      }

      cursor += width;
      if (i < stages.length - 1) {
        cursor += _PipelineTraceGraphViewState._stageGap;
      }
    }

    final canvasWidth = cursor + _PipelineTraceGraphViewState._padX;
    final canvasHeight =
        railY + radius + 52 + _PipelineTraceGraphViewState._padY;

    return _RailLayout(
      radius: radius,
      canvasSize: Size(canvasWidth, canvasHeight),
      positions: positions,
      stageCenters: stageCenters,
      stageLeft: stageLeft,
      stageWidth: stageWidth,
      railPoints: railPoints,
      headerTop: 6,
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
    required this.railPoints,
    required this.active,
    required this.selected,
    required this.traces,
    required this.pulse,
    required this.nodeRadius,
  });

  final Map<String, Offset> positions;
  final List<Offset> railPoints;
  final List<PipelineTraceEdge> active;
  final TraceSnapshot? selected;
  final List<TraceSnapshot> traces;
  final double pulse;
  final double nodeRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // 가로 레일 골격: 연속 앵커를 잇는다.
    for (var i = 0; i < railPoints.length - 1; i++) {
      _drawBezier(
        canvas,
        railPoints[i],
        railPoints[i + 1],
        color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
        strokeWidth: 1.6,
        live: false,
      );
    }

    // 펼쳐진 노드 사이 active path (양 끝 좌표가 있을 때만).
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
        oldDelegate.selected != selected ||
        oldDelegate.traces != traces ||
        oldDelegate.positions != positions ||
        oldDelegate.railPoints != railPoints ||
        oldDelegate.active != active;
  }
}
