import 'equipment.dart';
import 'joint.dart';
import 'work_history_item.dart';
import 'work_order.dart';
import 'worker.dart';

class WorkHistoryCatalog {
  const WorkHistoryCatalog({
    required this.items,
    required this.workOrders,
    required this.joints,
    required this.workers,
    required this.equipments,
  });

  final List<WorkHistoryItem> items;
  final List<WorkOrder> workOrders;
  final List<Joint> joints;
  final List<Worker> workers;
  final List<Equipment> equipments;
}
