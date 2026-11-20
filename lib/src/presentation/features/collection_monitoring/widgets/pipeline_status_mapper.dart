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

/// 3D 흐름 상태 키: pending|running|done|warning|error|skipped
String pipelineFlowStatus(PipelineNodeVisual visual) {
  switch (visual) {
    case PipelineNodeVisual.idle:
      return 'pending';
    case PipelineNodeVisual.active:
    case PipelineNodeVisual.running:
      return 'running';
    case PipelineNodeVisual.queued:
      return 'warning';
    case PipelineNodeVisual.done:
      return 'done';
    case PipelineNodeVisual.failed:
      return 'error';
    case PipelineNodeVisual.skipped:
      return 'skipped';
  }
}

/// 연결선 상태: 양끝 visual + path live.
String pipelineEdgeFlowStatus({
  required PipelineNodeVisual fromVisual,
  required PipelineNodeVisual toVisual,
  required bool pathLive,
}) {
  if (fromVisual == PipelineNodeVisual.failed ||
      toVisual == PipelineNodeVisual.failed) {
    return 'error';
  }
  if (pathLive ||
      fromVisual == PipelineNodeVisual.running ||
      fromVisual == PipelineNodeVisual.active ||
      toVisual == PipelineNodeVisual.running ||
      toVisual == PipelineNodeVisual.active) {
    return 'running';
  }
  if (fromVisual == PipelineNodeVisual.queued ||
      toVisual == PipelineNodeVisual.queued) {
    return 'warning';
  }
  if (fromVisual == PipelineNodeVisual.skipped ||
      toVisual == PipelineNodeVisual.skipped) {
    return 'skipped';
  }
  if (fromVisual == PipelineNodeVisual.done &&
      toVisual == PipelineNodeVisual.done) {
    return 'done';
  }
  return 'pending';
}
