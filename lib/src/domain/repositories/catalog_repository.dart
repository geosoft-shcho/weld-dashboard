import '../entities/catalog_snapshot.dart';

abstract class CatalogRepository {
  Future<CatalogSnapshot> loadCatalog({required bool pdfrxReady});
}
