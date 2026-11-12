import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/comparison_job_candidate.dart';
import '../formatters/dashboard_formatters.dart';
import '../themes/app_theme.dart';

/// 비교 작업 Combo + 파형 기준(raw/dtw). 패스·품질 화면 공유.
class ComparisonJobNormalizeBar extends StatelessWidget {
  const ComparisonJobNormalizeBar({
    super.key,
    required this.jobs,
    required this.selectedJobId,
    required this.normalize,
    required this.comparisonError,
    required this.onOpenJobs,
    required this.onSelectJob,
    required this.onSelectNormalize,
    this.notice = '',
    this.includeStatus = true,
  });

  final List<ComparisonJobCandidate> jobs;
  final String selectedJobId;
  final String normalize;
  final String comparisonError;
  final String notice;
  final bool includeStatus;
  final VoidCallback onOpenJobs;
  final ValueChanged<String> onSelectJob;
  final ValueChanged<String> onSelectNormalize;

  @override
  Widget build(BuildContext context) {
    final knownIds = {for (final job in jobs) job.jobId};
    final comparisonValue = knownIds.contains(selectedJobId)
        ? selectedJobId
        : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('비교', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Expanded(
              child: ComboBox<String>(
                value: comparisonValue,
                isExpanded: true,
                items: [
                  const ComboBoxItem(value: '', child: Text('비교 없음')),
                  for (final job in jobs)
                    ComboBoxItem(
                      value: job.jobId,
                      child: Text(
                        comparisonJobLabel(job),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onTap: onOpenJobs,
                onChanged: (value) {
                  if (value != null) {
                    onSelectJob(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            const Text('파형 기준'),
            const SizedBox(width: 8),
            SizedBox(
              width: 160,
              child: ComboBox<String>(
                value: normalize,
                items: const [
                  ComboBoxItem(value: 'raw', child: Text('원본')),
                  ComboBoxItem(value: 'dtw', child: Text('DTW 정규화')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onSelectNormalize(value);
                  }
                },
              ),
            ),
          ],
        ),
        if (includeStatus && notice.isNotEmpty) ...[
          const SizedBox(height: 8),
          InfoBar(title: Text(notice), severity: InfoBarSeverity.info),
        ],
        if (includeStatus && comparisonError.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            comparisonError,
            style: const TextStyle(color: AppTheme.STATUS_ERROR),
          ),
        ],
      ],
    );
  }
}

String comparisonJobLabel(ComparisonJobCandidate job) {
  final worker = job.workerName.isEmpty ? '작업자 없음' : job.workerName;
  final role = DashboardFormatters.workerKindLabel(job.workerKind);
  final title = job.jobKey.isEmpty ? '작업' : job.jobKey;
  return '$title · $worker · $role · ${DashboardFormatters.dateTime(job.startedAt)} · ${job.passCount}패스';
}
