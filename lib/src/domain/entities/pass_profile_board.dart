import 'channel_compare_stats.dart';
import 'pass_joint_context.dart';
import 'quality_link.dart';
import 'weld_pass.dart';
import 'waveform_channel_compare_summary.dart';
import 'waveform_series_bundle.dart';

class PassProfileBoard {
  const PassProfileBoard({
    required this.commonKey,
    required this.jobId,
    required this.context,
    required this.passes,
    required this.selectedPass,
    required this.mastersForPass,
    required this.selectedMasterProfileId,
    required this.series,
    required this.links,
    required this.compareStats,
    this.compareSummary = const [],
    required this.banners,
  });

  final String commonKey;
  final String jobId;
  final PassJointContext? context;
  final List<WeldPass> passes;
  final WeldPass? selectedPass;
  final List<String> mastersForPass;
  final String selectedMasterProfileId;
  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final ChannelCompareStats compareStats;
  final List<WaveformChannelCompareSummary> compareSummary;
  final List<String> banners;

  bool get doesHaveCommonKey => commonKey.isNotEmpty;
  bool get doesHavePasses => passes.isNotEmpty;
  bool get doesHaveSeries => series.doesHaveAnySeries;
}
