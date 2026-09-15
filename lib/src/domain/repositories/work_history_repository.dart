import '../entities/work_history_catalog.dart';

abstract class WorkHistoryRepository {
  Future<WorkHistoryCatalog> loadCatalog();
}
