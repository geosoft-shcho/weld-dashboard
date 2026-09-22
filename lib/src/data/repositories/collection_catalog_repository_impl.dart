import '../../domain/entities/collection_catalog.dart';
import '../../domain/entities/collection_board_query.dart';
import '../../domain/entities/collection_event.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/repositories/collection_catalog_repository.dart';
import '../datasources/local/csv_asset_data_source.dart';
import '../models/collection_assignment_dto.dart';
import '../models/collection_event_dto.dart';
import '../models/collection_status_dto.dart';
import '../models/equipment_dto.dart';
import '../models/project_dto.dart';
import '../models/worker_dto.dart';

class CollectionCatalogRepositoryImpl implements CollectionCatalogRepository {
  CollectionCatalogRepositoryImpl(this._csvAssetDataSource);

  static final DateTime FALLBACK_SNAPSHOT_AT = DateTime(2026, 9, 7, 9, 50);

  final CsvAssetDataSource _csvAssetDataSource;

  @override
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query}) async {
    final equipmentRows = await _csvAssetDataSource.loadEquipmentRows();
    final projectRows = await _csvAssetDataSource.loadProjectRows();
    final workerRows = await _csvAssetDataSource.loadWorkerRows();
    final assignmentRows = await _csvAssetDataSource.loadAssignmentRows();
    final eventRows = await _csvAssetDataSource.loadEventRows();
    final statusRows = await _csvAssetDataSource.loadStatusRows();
    final equipments = [
      for (final row in equipmentRows) EquipmentDto.fromRow(row).toDomain(),
    ];
    final equipmentById = {
      for (final equipment in equipments) equipment.equipmentId: equipment,
    };
    final statuses = [
      for (final row in statusRows) CollectionStatusDto.fromRow(row).toDomain(),
    ];
    return CollectionCatalog(
      equipments: equipments,
      projects: [
        for (final row in projectRows) ProjectDto.fromRow(row).toDomain(),
      ],
      workers: [
        for (final row in workerRows) WorkerDto.fromRow(row).toDomain(),
      ],
      assignments: [
        for (final row in assignmentRows)
          CollectionAssignmentDto.fromRow(row).toDomain(),
      ],
      statuses: statuses,
      events: [for (final row in eventRows) _eventFrom(row, equipmentById)],
      snapshotAt: statuses.isEmpty
          ? FALLBACK_SNAPSHOT_AT
          : statuses.first.snapshotAt,
    );
  }

  static CollectionEvent _eventFrom(
    Map<String, String> row,
    Map<String, Equipment> equipmentById,
  ) {
    final dto = CollectionEventDto.fromRow(row);
    final equipment = equipmentById[dto.equipmentId];
    return dto.toDomain(
      equipmentName: equipment?.equipmentName ?? dto.equipmentId,
      lineName: equipment?.lineName ?? '',
    );
  }
}
