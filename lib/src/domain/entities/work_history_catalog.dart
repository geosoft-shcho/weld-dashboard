import 'equipment.dart';
import 'work_history_item.dart';
import 'work_history_project_filter.dart';
import 'worker.dart';

class WorkHistoryCatalog {
  const WorkHistoryCatalog({
    required this.items,
    required this.projects,
    required this.workers,
    required this.equipments,
  });

  final List<WorkHistoryItem> items;
  final List<WorkHistoryProjectFilter> projects;
  final List<Worker> workers;
  final List<Equipment> equipments;
}
