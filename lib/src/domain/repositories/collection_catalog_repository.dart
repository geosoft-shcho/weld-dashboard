import '../entities/collection_catalog.dart';
import '../entities/collection_board_query.dart';

abstract class CollectionCatalogRepository {
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query});
}
