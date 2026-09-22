import '../../domain/entities/catalog_snapshot.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/generated/dashboard_service.pb.dart' as pb;
import '../datasources/remote/dashboard_service_data_source.dart';

class RemoteCatalogRepository implements CatalogRepository {
  RemoteCatalogRepository(this._source);

  final DashboardServiceDataSource _source;

  @override
  Future<CatalogSnapshot> loadCatalog({required bool pdfrxReady}) async {
    final statuses = await _source.client.listEquipmentStatus(
      pb.ListEquipmentStatusRequest(),
    );
    final snapshotAt =
        statuses.items
            .map((item) => DateTime.tryParse(item.snapshotAt))
            .whereType<DateTime>()
            .firstOrNull ??
        DateTime.now();
    return CatalogSnapshot(
      rowCountsByAsset: {'equipment_status': statuses.items.length},
      snapshotAt: snapshotAt,
      pdfrxReady: pdfrxReady,
    );
  }
}
