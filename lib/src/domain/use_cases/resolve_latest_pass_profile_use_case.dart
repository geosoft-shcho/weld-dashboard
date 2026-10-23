import '../entities/latest_pass_profile_target.dart';
import '../entities/work_history_item.dart';

class ResolveLatestPassProfileUseCase {
  LatestPassProfileTarget? execute({
    required List<WorkHistoryItem> jobs,
  }) {
    for (final job in jobs) {
      if (job.passCount <= 0 && job.passes.isEmpty) {
        continue;
      }
      if (job.jobId.isEmpty || job.commonKey.isEmpty) {
        continue;
      }
      final passId = job.passes.isEmpty ? '' : job.passes.first.passId;
      return LatestPassProfileTarget(
        commonKey: job.commonKey,
        jobId: job.jobId,
        passId: passId,
      );
    }
    return null;
  }
}
