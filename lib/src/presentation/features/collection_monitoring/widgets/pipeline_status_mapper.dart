import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../core/themes/app_theme.dart';

/// [PipelineNodeVisual] → 2D/3D 공용 색·라벨.
Color pipelineStatusFill(PipelineNodeVisual visual, Color accent) {
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

Color pipelineStatusBorder(PipelineNodeVisual visual, Color accent) {
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

String pipelineStatusShortLabel(PipelineNodeVisual visual) {
  return pipelineNodeStatusLabel(visual);
}

Color pipelineStatusInk(PipelineNodeVisual visual) {
  return visual == PipelineNodeVisual.idle
      ? AppTheme.INK.withValues(alpha: 0.45)
      : AppTheme.INK;
}
