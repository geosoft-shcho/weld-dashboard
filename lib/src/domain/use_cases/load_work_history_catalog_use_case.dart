import '../entities/work_history_catalog.dart';
import '../entities/work_history_query.dart';
import '../repositories/work_history_repository.dart';

class LoadWorkHistoryCatalogUseCase {
  LoadWorkHistoryCatalogUseCase(this._repository);

  final WorkHistoryRepository _repository;

  Future<WorkHistoryCatalog> execute({WorkHistoryQuery? query}) {
    return _repository.loadCatalog(query: query);
  }
}
