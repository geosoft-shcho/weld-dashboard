import 'series_role.dart';

class WaveformRow {
  const WaveformRow({
    required this.seriesId,
    required this.passId,
    required this.commonKey,
    required this.seriesRole,
    required this.masterProfileId,
    required this.workerId,
    required this.robotId,
    required this.timeMs,
    this.currentA,
    this.voltageV,
    this.speedValue,
  });

  final String seriesId;
  final String passId;
  final String commonKey;
  final SeriesRole seriesRole;
  final String masterProfileId;
  final String workerId;
  final String robotId;
  final int timeMs;
  final double? currentA;
  final double? voltageV;
  final double? speedValue;
}
