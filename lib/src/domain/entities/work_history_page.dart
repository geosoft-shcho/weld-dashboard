import 'work_history_item.dart';

/// ListWorkHistory 한 페이지 결과.
class WorkHistoryPage {
  const WorkHistoryPage({
    required this.items,
    required this.totalCount,
  });

  final List<WorkHistoryItem> items;
  /// 필터 전체 매치 건수(페이지 크기와 무관).
  final int totalCount;
}
