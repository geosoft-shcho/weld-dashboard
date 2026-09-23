class WaveformPoint {
  const WaveformPoint({
    required this.timeMs,
    this.currentA,
    this.voltageV,
    this.speedValue,
    this.rotationSpeedRpm,
  });

  final int timeMs;
  final double? currentA;
  final double? voltageV;
  final double? speedValue;
  final double? rotationSpeedRpm;
}
