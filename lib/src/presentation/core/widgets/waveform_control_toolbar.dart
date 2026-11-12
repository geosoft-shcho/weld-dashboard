import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/comparison_job_candidate.dart';
import '../themes/app_theme.dart';
import 'comparison_job_normalize_bar.dart';
import 'pass_legend_toolbar.dart';

/// 비교 작업·파형 기준 + 범례를 한 패널로 묶는다. 패스·품질 공유.
class WaveformControlToolbar extends StatelessWidget {
  const WaveformControlToolbar({
    super.key,
    required this.jobs,
    required this.selectedJobId,
    required this.normalize,
    required this.comparisonError,
    required this.onOpenJobs,
    required this.onSelectJob,
    required this.onSelectNormalize,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.mastersForPass,
    required this.selectedMasterProfileId,
    required this.onToggleMaster,
    required this.onToggleBeginner,
    required this.onToggleRobot,
    required this.onSelectMasterProfile,
    this.notice = '',
    this.legendIsEmpty = false,
  });

  final List<ComparisonJobCandidate> jobs;
  final String selectedJobId;
  final String normalize;
  final String comparisonError;
  final String notice;
  final VoidCallback onOpenJobs;
  final ValueChanged<String> onSelectJob;
  final ValueChanged<String> onSelectNormalize;

  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final List<String> mastersForPass;
  final String selectedMasterProfileId;
  final ValueChanged<bool> onToggleMaster;
  final ValueChanged<bool> onToggleBeginner;
  final ValueChanged<bool> onToggleRobot;
  final ValueChanged<String> onSelectMasterProfile;
  final bool legendIsEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ComparisonJobNormalizeBar(
            jobs: jobs,
            selectedJobId: selectedJobId,
            normalize: normalize,
            comparisonError: comparisonError,
            notice: notice,
            includeStatus: false,
            onOpenJobs: onOpenJobs,
            onSelectJob: onSelectJob,
            onSelectNormalize: onSelectNormalize,
          ),
          const SizedBox(height: 12),
          PassLegendToolbar(
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            mastersForPass: mastersForPass,
            selectedMasterProfileId: selectedMasterProfileId,
            onToggleMaster: onToggleMaster,
            onToggleBeginner: onToggleBeginner,
            onToggleRobot: onToggleRobot,
            onSelectMasterProfile: onSelectMasterProfile,
            isEmpty: legendIsEmpty,
          ),
          if (notice.isNotEmpty) ...[
            const SizedBox(height: 8),
            InfoBar(title: Text(notice), severity: InfoBarSeverity.info),
          ],
          if (comparisonError.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              comparisonError,
              style: const TextStyle(color: AppTheme.STATUS_ERROR),
            ),
          ],
        ],
      ),
    );
  }
}
