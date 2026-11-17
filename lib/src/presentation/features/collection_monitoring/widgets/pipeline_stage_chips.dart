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
    final stages = [
      for (final stage in pipelineStages)
        if (stage.id != 'tool' || viewModel.doesShowToolStage) stage,
    ];
    return SingleChildScrollView(
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
