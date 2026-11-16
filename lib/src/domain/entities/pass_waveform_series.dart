import 'waveform_channel_compare_summary.dart';
import 'waveform_row.dart';

class PassWaveformSeries {
  const PassWaveformSeries({
    required this.rows,
    this.compareSummary = const [],
    this.notice = '',
    this.didFallBackToRaw = false,
  });

  final List<WaveformRow> rows;
  final List<WaveformChannelCompareSummary> compareSummary;
  final String notice;
  final bool didFallBackToRaw;
}
