import 'waveform_series_bundle.dart';

/// TIMESERIES Asset CSV 로드 결과(디버그·표시용).
class TimeseriesWaveformLoad {
  const TimeseriesWaveformLoad({
    required this.series,
    required this.bodyLength,
    required this.lineCount,
    required this.headers,
    required this.pointCount,
    required this.rawPointCount,
    this.matchedTimeHeader = '',
    this.matchedCurrentHeader = '',
    this.matchedVoltageHeader = '',
    this.matchedSpeedHeader = '',
    this.matchedRpmHeader = '',
  });

  static const empty = TimeseriesWaveformLoad(
    series: WaveformSeriesBundle(
      masterProfileId: '',
      master: [],
      beginner: [],
      robot: [],
    ),
    bodyLength: 0,
    lineCount: 0,
    headers: [],
    pointCount: 0,
    rawPointCount: 0,
  );

  final WaveformSeriesBundle series;
  final int bodyLength;
  final int lineCount;
  final List<String> headers;
  final int pointCount;
  final int rawPointCount;
  final String matchedTimeHeader;
  final String matchedCurrentHeader;
  final String matchedVoltageHeader;
  final String matchedSpeedHeader;
  final String matchedRpmHeader;
}
