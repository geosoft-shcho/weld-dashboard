import '../../../domain/entities/job_timeline.dart';

/// 타임라인에 펼칠 수 있는 차트 종류. GetClip과 별개로 파형 UI만 해당.
enum ClipChartKind { audio, timeseries }

const double TIMELINE_TIMESERIES_CHART_HEIGHT = 240;
const double TIMELINE_AUDIO_CHART_HEIGHT = 60;

ClipChartKind? clipChartKindOf(TimelineClipKind kind) {
  return switch (kind) {
    TimelineClipKind.audio => ClipChartKind.audio,
    TimelineClipKind.timeseries => ClipChartKind.timeseries,
    _ => null,
  };
}

extension ClipChartKindX on ClipChartKind {
  TimelineClipKind get timelineKind => switch (this) {
    ClipChartKind.audio => TimelineClipKind.audio,
    ClipChartKind.timeseries => TimelineClipKind.timeseries,
  };

  double get expandedHeight => switch (this) {
    ClipChartKind.audio => TIMELINE_AUDIO_CHART_HEIGHT,
    ClipChartKind.timeseries => TIMELINE_TIMESERIES_CHART_HEIGHT,
  };
}
