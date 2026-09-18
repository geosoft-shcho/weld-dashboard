import 'channel_compare_stats.dart';
import 'pass_joint_context.dart';
import 'quality_link.dart';
import 'weld_pass.dart';
import 'waveform_series_bundle.dart';

class PassProfileBoard {
  const PassProfileBoard({
    required this.commonKey,
    required this.historyId,
    required this.context,
    required this.passes,
    required this.selectedPass,
    required this.mastersForPass,
    required this.selectedMasterProfileId,
    required this.series,
    required this.links,
    required this.compareStats,
    required this.banners,
  });

  final String commonKey;
  final String historyId;
  final PassJointContext? context;
  final List<WeldPass> passes;
  final WeldPass? selectedPass;
  final List<String> mastersForPass;
  final String selectedMasterProfileId;
  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final ChannelCompareStats compareStats;
  final List<String> banners;

  bool get doesHaveCommonKey => commonKey.isNotEmpty;
  bool get doesHavePasses => passes.isNotEmpty;
  bool get doesHaveSeries => series.doesHaveAnySeries;
}
