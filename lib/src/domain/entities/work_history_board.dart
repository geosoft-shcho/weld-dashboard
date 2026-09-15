import 'equipment.dart';
import 'joint.dart';
import 'work_history_item.dart';
import 'work_history_query.dart';
import 'work_order.dart';
import 'worker.dart';

class WorkHistoryBoard {
  const WorkHistoryBoard({
    required this.query,
    required this.visibleRows,
    required this.totalCount,
    required this.workOrders,
    required this.joints,
    required this.workers,
    required this.equipments,
  });

  final WorkHistoryQuery query;
  final List<WorkHistoryItem> visibleRows;
  final int totalCount;
  final List<WorkOrder> workOrders;
  final List<Joint> joints;
  final List<Worker> workers;
  final List<Equipment> equipments;

  bool get doesHaveMore => visibleRows.length < totalCount;

  WorkHistoryItem? get selectedItem {
    for (final item in visibleRows) {
      if (item.historyId == query.selectedHistoryId) {
        return item;
      }
    }
    return null;
  }
}
