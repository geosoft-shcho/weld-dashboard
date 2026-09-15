import '../entities/collection_catalog.dart';

abstract class CollectionCatalogRepository {
  Future<CollectionCatalog> loadCatalog();
}
