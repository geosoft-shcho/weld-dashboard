import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/waveform_point.dart';
import '../../../../domain/entities/waveform_series_bundle.dart';
import '../../../core/widgets/waveform_channel_charts.dart';
import '../timeline_playhead_clock.dart';
import 'multimodal_studio_palette.dart';

/// 타임라인 클립 자리에 넣는 시계열 차트.
class TimeseriesClipChart extends StatelessWidget {
  const TimeseriesClipChart({
    super.key,
    required this.series,
    required this.isLoading,
    required this.errorMessage,
    required this.durationMs,
    this.selectedTimeMs,
    this.selectedTimeLabel = '',
    this.onTimeTapMs,
  });

  final WaveformSeriesBundle series;
  final bool isLoading;
  final String errorMessage;
  final int durationMs;
  final int? selectedTimeMs;
  final String selectedTimeLabel;
  final WaveformTimeTapHandler? onTimeTapMs;

  @override
  Widget build(BuildContext context) {
    final selected = selectedTimeMs;
    return ColoredBox(
      color: MultimodalStudioPalette.SAND_0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading) const ProgressBar(),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: MultimodalStudioPalette.PERSIMMON_300,
                  fontSize: 11,
                ),
              ),
            ),
          if (!isLoading &&
              errorMessage.isEmpty &&
              !series.doesHaveAnySeries)
            const Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                '파형 데이터 없음',
                style: TextStyle(
                  color: MultimodalStudioPalette.SAND_600,
                  fontSize: 11,
                ),
              ),
            ),
          if (selected != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
              child: Text(
                _readoutLabel(
                  series.robot,
                  selected,
                  timeLabel: selectedTimeLabel.isNotEmpty
                      ? selectedTimeLabel
                      : formatPlayheadClock(selected / 1000.0),
                ),
                style: const TextStyle(
                  color: MultimodalStudioPalette.SAND_700,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: WaveformChannelCharts(
                series: series,
                links: const [],
                showMaster: false,
                showBeginner: false,
                showRobot: true,
                selectedTimeMs: selectedTimeMs,
                selectedTimeLabel: selectedTimeLabel,
                onTimeTapMs: onTimeTapMs,
                doesStartAtZero: true,
                showAxisTitles: false,
                axisMaxXMs: durationMs,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _readoutLabel(
    List<WaveformPoint> points,
    int timeMs, {
    required String timeLabel,
  }) {
    final point = _nearestPoint(points, timeMs);
    return '$timeLabel'
        ' | I=${_formatValue(point?.currentA)} A'
        ' | V=${_formatValue(point?.voltageV)} V'
        ' | v=${_formatValue(point?.speedValue)} m/min'
        ' | rpm=${_formatValue(point?.rotationSpeedRpm)}';
  }

  static WaveformPoint? _nearestPoint(List<WaveformPoint> points, int timeMs) {
    if (points.isEmpty) {
      return null;
    }
    WaveformPoint best = points.first;
    var bestDelta = (best.timeMs - timeMs).abs();
    for (final point in points) {
      final delta = (point.timeMs - timeMs).abs();
      if (delta < bestDelta) {
        best = point;
        bestDelta = delta;
      }
    }
    return best;
  }

  static String _formatValue(double? value) {
    if (value == null) {
      return '—';
    }
    return value.toStringAsFixed(1);
  }
}
