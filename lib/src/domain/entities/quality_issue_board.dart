import 'pass_joint_context.dart';
import 'quality_link.dart';
import 'quality_result_group.dart';
import 'weld_pass.dart';
import 'waveform_series_bundle.dart';

class QualityIssueBoard {
  const QualityIssueBoard({
    required this.commonKey,
    required this.historyId,
    required this.context,
    required this.passes,
    required this.selectedPass,
    required this.groups,
    required this.selectedGroup,
    required this.links,
    required this.allLinks,
    required this.selectedLink,
    required this.series,
  });

  final String commonKey;
  final String historyId;
  final PassJointContext? context;
  final List<WeldPass> passes;
  final WeldPass? selectedPass;
  final List<QualityResultGroup> groups;
  final QualityResultGroup? selectedGroup;
  /// Pass-filtered links for chart bands.
  final List<QualityLink> links;
  /// All links for the common key (table).
  final List<QualityLink> allLinks;
  final QualityLink? selectedLink;
  final WaveformSeriesBundle series;

  bool get doesHaveCommonKey => commonKey.isNotEmpty;
  bool get doesHavePasses => passes.isNotEmpty;
  bool get doesHaveLinks => allLinks.isNotEmpty;
  bool get doesHaveGroup => selectedGroup != null;
}
