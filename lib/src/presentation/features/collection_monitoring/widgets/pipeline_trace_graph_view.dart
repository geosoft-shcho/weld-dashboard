import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_node_icons.dart';
import 'pipeline_stage_chips.dart';

/// 가로 스테퍼: 단계(큰 원) + 세부 이벤트 라벨. 너비에 맞춰 분배해 가로 스크롤을 줄인다.
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
    final stagePath = pipelineHighlightStageIds(
      selected: selected,
      traces: traces,
      stages: stages,
    );
    final stageRadius = widget.compact ? 16.0 : 22.0;

    if (stages.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < stages.length; i++) ...[
                    Expanded(
                      child: _StageColumn(
                        stage: stages[i],
                        radius: stageRadius,
                        compact: widget.compact,
                        visual: pipelineStageVisual(
                          stageId: stages[i].id,
                          selected: selected,
                          traces: traces,
                        ),
                        count: viewModel.stageCounts[stages[i].id] ?? 0,
                        selected: selected,
                        traces: traces,
                        pulse: _pulse.value,
                        onStageTap: () => _selectStage(
                          viewModel: viewModel,
                          stageId: stages[i].id,
                        ),
                        onDetailTap: (nodeId) => _selectNear(
                          viewModel: viewModel,
                          nodeId: nodeId,
                          stageId: stages[i].id,
                        ),
                      ),
                    ),
                    if (i < stages.length - 1)
                      _StageConnector(
                        fromId: stages[i].id,
                        toId: stages[i + 1].id,
                        stagePath: stagePath,
                        fromVisual: pipelineStageVisual(
                          stageId: stages[i].id,
                          selected: selected,
                          traces: traces,
                        ),
                        toVisual: pipelineStageVisual(
                          stageId: stages[i + 1].id,
                          selected: selected,
                          traces: traces,
                        ),
                        pulse: _pulse.value,
                        height: stageRadius * 2,
                      ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectStage({
    required PipelineTraceViewModel viewModel,
    required String stageId,
  }) {
    final candidates = [
      for (final trace in viewModel.visibleTraces)
        if (pipelineStageOf(trace.lastEvent) == stageId) trace,
    ];
    if (candidates.isNotEmpty) {
      viewModel.didSelectTrace(candidates.first.traceId);
      return;
    }
    if (viewModel.visibleTraces.isNotEmpty) {
      viewModel.didSelectTrace(viewModel.visibleTraces.first.traceId);
    }
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
        _summaryChip(
          label: '진행 $running',
          color: AppTheme.ACCENT_STEEL,
          pulse: running > 0 ? glow : 0,
        ),
        const SizedBox(width: 8),
        _summaryChip(label: '완료 $done', color: AppTheme.STATUS_OK, pulse: 0),
        const SizedBox(width: 8),
        _summaryChip(
          label: '실패 $failed',
          color: AppTheme.STATUS_ERROR,
          pulse: failed > 0 ? 0.35 + 0.2 * math.sin(pulse * math.pi * 2) : 0,
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

  Widget _summaryChip({
    required String label,
    required Color color,
    required double pulse,
  }) {
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

class _StageColumn extends StatelessWidget {
  const _StageColumn({
    required this.stage,
    required this.radius,
    required this.compact,
    required this.visual,
    required this.count,
    required this.selected,
    required this.traces,
    required this.pulse,
    required this.onStageTap,
    required this.onDetailTap,
  });

  final PipelineStageDef stage;
  final double radius;
  final bool compact;
  final PipelineNodeVisual visual;
  final int count;
  final TraceSnapshot? selected;
  final List<TraceSnapshot> traces;
  final double pulse;
  final VoidCallback onStageTap;
  final ValueChanged<String> onDetailTap;

  @override
  Widget build(BuildContext context) {
    final accent = pipelineStageAccent(stage.id);
    final fill = _fillOf(visual, accent);
    final border = _borderOf(visual, accent);
    final status = pipelineNodeStatusLabel(visual);
    final live = pipelineNodeIsLive(visual);
    final ring = live ? 2.5 + 1.5 * math.sin(pulse * math.pi * 2) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onStageTap,
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
                            color: border.withValues(alpha: 0.5),
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
                        border: Border.all(color: border, width: live ? 3 : 2),
                      ),
                      child: Icon(
                        visual == PipelineNodeVisual.done
                            ? FluentIcons.check_mark
                            : pipelineNodeIconData(stage.nodeIds.first),
                        size: radius,
                        color: visual == PipelineNodeVisual.idle
                            ? AppTheme.INK.withValues(alpha: 0.5)
                            : AppTheme.INK,
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
                  color: accent,
                  fontSize: compact ? 11 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$count건',
                style: TextStyle(
                  color: AppTheme.INK.withValues(alpha: 0.75),
                  fontSize: 10,
                ),
              ),
              if (status.isNotEmpty) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: border.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: border.withValues(alpha: 0.7)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: border,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stage.nodeIds.length; i++) ...[
              if (i > 0) const SizedBox(height: 4),
              _DetailEventLabel(
                nodeId: stage.nodeIds[i],
                visual: pipelineNodeVisual(
                  nodeId: stage.nodeIds[i],
                  selected: selected,
                  traces: traces,
                ),
                accent: accent,
                pulse: pulse,
                compact: compact,
                onTap: () => onDetailTap(stage.nodeIds[i]),
              ),
            ],
          ],
        ),
      ],
    );
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

/// 세부 이벤트: 상태 점 + 한글 라벨(+상태). 점만으로 요약하지 않는다.
class _DetailEventLabel extends StatelessWidget {
  const _DetailEventLabel({
    required this.nodeId,
    required this.visual,
    required this.accent,
    required this.pulse,
    required this.compact,
    required this.onTap,
  });

  final String nodeId;
  final PipelineNodeVisual visual;
  final Color accent;
  final double pulse;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final live = pipelineNodeIsLive(visual);
    final status = pipelineNodeStatusLabel(visual);
    final label = pipelineEventLabel(nodeId);
    final color = switch (visual) {
      PipelineNodeVisual.idle => AppTheme.STATUS_OFF.withValues(alpha: 0.55),
      PipelineNodeVisual.failed => AppTheme.STATUS_ERROR,
      PipelineNodeVisual.queued => AppTheme.STATUS_WARN,
      PipelineNodeVisual.active || PipelineNodeVisual.running => accent,
      PipelineNodeVisual.done => accent.withValues(alpha: 0.9),
      PipelineNodeVisual.skipped => AppTheme.STATUS_OFF,
    };
    final glow = live ? 0.55 + 0.45 * math.sin(pulse * math.pi * 2) : 0.0;
    final fontSize = compact ? 9.0 : 10.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 5 : 6,
          vertical: compact ? 2 : 3,
        ),
        decoration: BoxDecoration(
          color: visual == PipelineNodeVisual.idle
              ? AppTheme.STATUS_OFF.withValues(alpha: 0.12)
              : color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: live
                ? AppTheme.INK.withValues(alpha: 0.55 + 0.35 * glow)
                : color.withValues(alpha: 0.75),
            width: live ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: live ? 6 + 1.5 * glow : 6,
              height: live ? 6 + 1.5 * glow : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: live
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4 + 0.3 * glow),
                          blurRadius: 3,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: visual == PipelineNodeVisual.idle
                      ? AppTheme.INK.withValues(alpha: 0.55)
                      : AppTheme.INK,
                  fontSize: fontSize,
                  fontWeight: live || visual == PipelineNodeVisual.failed
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
              ),
            ),
            if (status.isNotEmpty) ...[
              const SizedBox(width: 3),
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize - 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StageConnector extends StatelessWidget {
  const _StageConnector({
    required this.fromId,
    required this.toId,
    required this.stagePath,
    required this.fromVisual,
    required this.toVisual,
    required this.pulse,
    required this.height,
  });

  final String fromId;
  final String toId;
  final List<String> stagePath;
  final PipelineNodeVisual fromVisual;
  final PipelineNodeVisual toVisual;
  final double pulse;
  final double height;

  @override
  Widget build(BuildContext context) {
    final onPath = stagePath.contains(fromId) && stagePath.contains(toId);
    final live = pipelineNodeIsLive(fromVisual) || pipelineNodeIsLive(toVisual);
    return SizedBox(
      width: 28,
      height: height + 8,
      child: CustomPaint(
        painter: _ConnectorPainter(
          active: onPath,
          live: live && onPath,
          pulse: pulse,
        ),
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  _ConnectorPainter({
    required this.active,
    required this.live,
    required this.pulse,
  });

  final bool active;
  final bool live;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final a = Offset(0, y);
    final b = Offset(size.width, y);
    final guide = Paint()
      ..color = AppTheme.STATUS_OFF.withValues(alpha: 0.25)
      ..strokeWidth = 1.2;
    canvas.drawLine(a, b, guide);
    if (!active) {
      return;
    }
    final paint = Paint()
      ..color = live ? AppTheme.INK : AppTheme.ACCENT_STEEL
      ..strokeWidth = live ? 2.4 : 2
      ..style = PaintingStyle.stroke;
    if (live) {
      const dash = 5.0;
      const gap = 3.0;
      final distance = size.width;
      var drawn = 0.0;
      while (drawn < distance) {
        final start = Offset(drawn, y);
        final end = Offset(math.min(drawn + dash, distance), y);
        canvas.drawLine(start, end, paint);
        drawn += dash + gap;
      }
      final t = pulse % 1.0;
      canvas.drawCircle(
        Offset(size.width * t, y),
        3.2,
        Paint()..color = AppTheme.INK,
      );
    } else {
      canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter oldDelegate) {
    return oldDelegate.pulse != pulse ||
        oldDelegate.active != active ||
        oldDelegate.live != live;
  }
}
