import '../entities/collection_catalog.dart';
import '../repositories/collection_catalog_repository.dart';

class LoadCollectionCatalogUseCase {
  LoadCollectionCatalogUseCase(this._repository);

  final CollectionCatalogRepository _repository;

  Future<CollectionCatalog> execute() {
    return _repository.loadCatalog();
  }
}
