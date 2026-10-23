import '../entities/latest_quality_issue_target.dart';
import '../entities/work_history_item.dart';

class ResolveLatestQualityIssueUseCase {
  LatestQualityIssueTarget? execute({
    required List<WorkHistoryItem> jobs,
  }) {
    for (final job in jobs) {
      if (!job.hasReport) {
        continue;
      }
      if (job.jobId.isEmpty || job.commonKey.isEmpty) {
        continue;
      }
      final passId = job.passes.isEmpty ? '' : job.passes.first.passId;
      return LatestQualityIssueTarget(
        commonKey: job.commonKey,
        jobId: job.jobId,
        passId: passId,
        linkId: '',
      );
    }
    return null;
  }
}
