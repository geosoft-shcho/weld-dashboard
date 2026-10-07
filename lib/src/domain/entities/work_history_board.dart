import 'equipment.dart';
import 'work_history_item.dart';
import 'work_history_project_filter.dart';
import 'work_history_query.dart';
import 'worker.dart';

class WorkHistoryBoard {
  const WorkHistoryBoard({
    required this.query,
    required this.visibleRows,
    required this.totalCount,
    required this.nextPageToken,
    required this.projects,
    required this.workers,
    required this.equipments,
  });

  final WorkHistoryQuery query;
  final List<WorkHistoryItem> visibleRows;
  final int totalCount;
  final String nextPageToken;
  final List<WorkHistoryProjectFilter> projects;
  final List<Worker> workers;
  final List<Equipment> equipments;

  bool get doesHaveMore => nextPageToken.isNotEmpty;

  WorkHistoryItem? get selectedItem {
    for (final item in visibleRows) {
      if (item.jobId == query.selectedJobId) {
        return item;
      }
    }
    return null;
  }
}
