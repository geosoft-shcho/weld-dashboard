import '../entities/work_detail_catalog.dart';
import '../repositories/work_detail_repository.dart';

class LoadWorkDetailCatalogUseCase {
  LoadWorkDetailCatalogUseCase(this._repository);

  final WorkDetailRepository _repository;

  Future<WorkDetailCatalog> execute({String historyId = ''}) {
    return _repository.loadCatalog(historyId: historyId);
  }
}
