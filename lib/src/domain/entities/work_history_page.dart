import 'work_history_item.dart';

/// ListJobs 한 페이지. [nextPageToken] 은 서버가 준 그대로다.
class WorkHistoryPage {
  const WorkHistoryPage({
    required this.items,
    required this.totalCount,
    required this.nextPageToken,
  });

  final List<WorkHistoryItem> items;
  final int totalCount;
  final String nextPageToken;
}
