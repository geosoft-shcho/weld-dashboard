import '../../domain/entities/catalog_snapshot.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/local/csv_asset_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._csvAssetDataSource);

  static final DateTime SNAPSHOT_AT = DateTime(2026, 9, 7, 9, 50);

  final CsvAssetDataSource _csvAssetDataSource;

  @override
  Future<CatalogSnapshot> loadCatalog({required bool pdfrxReady}) async {
    final rowCountsByAsset = await _csvAssetDataSource.loadRowCounts();
    return CatalogSnapshot(
      rowCountsByAsset: rowCountsByAsset,
      snapshotAt: SNAPSHOT_AT,
      pdfrxReady: pdfrxReady,
    );
  }
}
