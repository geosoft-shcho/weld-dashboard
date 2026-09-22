import '../entities/work_history_catalog.dart';
import '../entities/work_history_query.dart';

abstract class WorkHistoryRepository {
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query});
}
