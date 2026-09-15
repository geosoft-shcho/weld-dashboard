import '../entities/work_history_catalog.dart';
import '../repositories/work_history_repository.dart';

class LoadWorkHistoryCatalogUseCase {
  LoadWorkHistoryCatalogUseCase(this._repository);

  final WorkHistoryRepository _repository;

  Future<WorkHistoryCatalog> execute() {
    return _repository.loadCatalog();
  }
}
