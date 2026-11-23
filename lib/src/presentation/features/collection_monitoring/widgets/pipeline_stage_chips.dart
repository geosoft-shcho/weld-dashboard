import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';

Color pipelineStageAccent(String stageId) {
  switch (stageId) {
    case 'collect':
      return const Color(0xFF6B9E78);
    case 'receive':
      return const Color(0xFF5CB8B2);
    case 'register':
      return const Color(0xFF9B7EDE);
    case 'postprocess':
      return AppTheme.STATUS_WARN;
    case 'tool':
      return AppTheme.ACCENT_STEEL;
    case 'embed':
      return const Color(0xFF8B6CCF);
    case 'done':
      return AppTheme.STATUS_OK;
    default:
      return AppTheme.STATUS_OFF;
  }
}

/// 진행·완료·실패 요약 + Stage 건수 칩을 한 줄에 표시한다.
class PipelineStageChips extends StatelessWidget {
  const PipelineStageChips({
    super.key,
    required this.viewModel,
    this.compact = false,
  });

  final PipelineTraceViewModel viewModel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final counts = viewModel.stageCounts;
    final failed = viewModel.stageHasFailed;
    final running = viewModel.runningCount;
    final done = viewModel.doneCount;
    final failedCount = viewModel.failedCount;
    final stages = [
      for (final stage in pipelineStages)
        if ((stage.id != 'tool' || viewModel.doesShowToolStage) &&
            (stage.id != 'embed' || viewModel.doesShowEmbedStage))
          stage,
    ];
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final stage in stages) ...[
                  _StageChip(
                    label: stage.label,
                    count: counts[stage.id] ?? 0,
                    accent: pipelineStageAccent(stage.id),
                    hasFailed: failed[stage.id] == true,
                    compact: compact,
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ),

        Text(
          running > 0 ? '실시간 반영 중' : '대기',
          style: TextStyle(
            color: AppTheme.INK.withValues(alpha: 0.65),
            fontSize: compact ? 11 : 12,
          ),
        ),
        const SizedBox(width: 16),
        _StatusDot(
          label: '진행 $running',
          color: AppTheme.ACCENT_STEEL,
          emphasize: running > 0,
          compact: compact,
        ),
        SizedBox(width: compact ? 6 : 8),
        _StatusDot(
          label: '완료 $done',
          color: AppTheme.STATUS_OK,
          compact: compact,
        ),
        SizedBox(width: compact ? 6 : 8),
        _StatusDot(
          label: '실패 $failedCount',
          color: AppTheme.STATUS_ERROR,
          emphasize: failedCount > 0,
          compact: compact,
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    required this.label,
    required this.color,
    required this.compact,
    this.emphasize = false,
  });

  final String label;
  final Color color;
  final bool compact;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
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

class _StageChip extends StatelessWidget {
  const _StageChip({
    required this.label,
    required this.count,
    required this.accent,
    required this.hasFailed,
    required this.compact,
  });

  final String label;
  final int count;
  final Color accent;
  final bool hasFailed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasFailed
              ? AppTheme.STATUS_ERROR
              : accent.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FluentIcons.circle_fill, size: 10, color: accent),
          const SizedBox(width: 6),
          Text(
            '$label $count개',
            style: TextStyle(
              color: AppTheme.INK,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
