import '../entities/catalog_snapshot.dart';
import '../repositories/catalog_repository.dart';

class LoadCatalogUseCase {
  LoadCatalogUseCase(this._repository);

  final CatalogRepository _repository;

  Future<CatalogSnapshot> execute({required bool pdfrxReady}) {
    return _repository.loadCatalog(pdfrxReady: pdfrxReady);
  }
}
