import '../../domain/entities/catalog_snapshot.dart';
import '../../domain/repositories/catalog_repository.dart';

class RemoteCatalogRepository implements CatalogRepository {
  @override
  Future<CatalogSnapshot> loadCatalog({required bool pdfrxReady}) async {
    return CatalogSnapshot(
      rowCountsByAsset: const {},
      snapshotAt: DateTime.now(),
      pdfrxReady: pdfrxReady,
    );
  }
}
