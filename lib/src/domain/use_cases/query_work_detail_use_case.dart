import '../entities/work_detail.dart';
import '../entities/work_detail_catalog.dart';
import '../entities/work_history_item.dart';

class QueryWorkDetailUseCase {
  WorkDetail execute({
    required WorkDetailCatalog catalog,
    required String historyId,
  }) {
    final job = _jobFor(catalog.items, historyId);
    if (job == null) {
      return const WorkDetail(job: null, attachments: []);
    }
    return WorkDetail(
      job: job,
      attachments: [
        for (final attachment in catalog.attachments)
          if (attachment.historyId == job.historyId) attachment,
      ],
    );
  }

  WorkHistoryItem? _jobFor(List<WorkHistoryItem> items, String historyId) {
    if (historyId.isNotEmpty) {
      for (final item in items) {
        if (item.historyId == historyId) {
          return item;
        }
      }
      return null;
    }
    WorkHistoryItem? latest;
    for (final item in items) {
      if (latest == null) {
        latest = item;
        continue;
      }
      final byTime = item.workedAt.compareTo(latest.workedAt);
      if (byTime > 0 ||
          (byTime == 0 && item.historyId.compareTo(latest.historyId) < 0)) {
        latest = item;
      }
    }
    return latest;
  }
}
