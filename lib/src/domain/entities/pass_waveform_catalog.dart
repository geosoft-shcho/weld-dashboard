import 'quality_link.dart';
import 'pass_joint_context.dart';
import 'quality_result_group.dart';
import 'weld_pass.dart';
import 'waveform_row.dart';
import 'work_history_item.dart';
import 'worker.dart';

class PassWaveformCatalog {
  const PassWaveformCatalog({
    required this.passes,
    required this.waveformRows,
    required this.links,
    required this.qualityGroups,
    required this.historyItems,
    required this.workers,
    this.context,
  });

  final List<WeldPass> passes;
  final List<WaveformRow> waveformRows;
  final List<QualityLink> links;
  final List<QualityResultGroup> qualityGroups;
  final List<WorkHistoryItem> historyItems;
  final List<Worker> workers;
  final PassJointContext? context;
}
