import 'waveform_row.dart';

class PassWaveformSeries {
  const PassWaveformSeries({
    required this.rows,
    this.notice = '',
    this.didFallBackToRaw = false,
  });

  final List<WaveformRow> rows;
  final String notice;
  final bool didFallBackToRaw;
}
