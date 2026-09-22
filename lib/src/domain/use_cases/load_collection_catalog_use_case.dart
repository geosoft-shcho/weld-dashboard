import '../entities/collection_catalog.dart';
import '../entities/collection_board_query.dart';
import '../repositories/collection_catalog_repository.dart';

class LoadCollectionCatalogUseCase {
  LoadCollectionCatalogUseCase(this._repository);

  final CollectionCatalogRepository _repository;

  Future<CollectionCatalog> execute({CollectionBoardQuery? query}) {
    return _repository.loadCatalog(query: query);
  }
}
