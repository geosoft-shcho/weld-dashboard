import '../../domain/entities/collection_assignment.dart';
import '../../domain/entities/collection_catalog.dart';
import '../../domain/entities/collection_board_query.dart';
import '../../domain/entities/collection_event.dart';
import '../../domain/entities/collection_status.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/time_sync_status.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/collection_catalog_repository.dart';
import '../datasources/generated/dashboard_service.pb.dart' as pb;
import '../datasources/remote/dashboard_service_data_source.dart';

class RemoteCollectionCatalogRepository implements CollectionCatalogRepository {
  RemoteCollectionCatalogRepository(this._source);

  final DashboardServiceDataSource _source;

  @override
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query}) async {
    final date = query == null ? '' : _date(query.selectedDate);
    final assignment = query == null
        ? pb.AssignmentFilter()
        : pb.AssignmentFilter(
            projectIds: query.projectIds,
            workerIds: query.workerIds,
            unassigned: query.isUnassignedOnly,
          );
    final equipmentResponse = await _source.client.listEquipment(
      pb.ListEquipmentRequest(),
    );
    final projectResponse = await _source.client.listProjects(
      pb.ListProjectsRequest(),
    );
    final workerResponse = await _source.client.listWorkers(
      pb.ListWorkersRequest(),
    );
    final assignmentResponse = await _source.client.listCollectionAssignments(
      pb.ListCollectionAssignmentsRequest(),
    );
    final statusResponse = await _source.client.listEquipmentStatus(
      pb.ListEquipmentStatusRequest(
        date: date,
        equipmentIds: query?.equipmentIds ?? const [],
        lines: query?.lineNames ?? const [],
        connectionStatuses:
            query?.connectionStatuses.map((item) => item.name) ?? const [],
        assignment: assignment,
      ),
    );
    final eventResponse = await _source.client.listCollectionEvents(
      pb.ListCollectionEventsRequest(
        date: date,
        equipmentIds: query?.equipmentIds ?? const [],
        lines: query?.lineNames ?? const [],
        connectionStatuses:
            query?.connectionStatuses.map((item) => item.name) ?? const [],
        assignment: assignment,
        from: query == null ? '' : _time(query.startMinutes),
        to: query == null ? '' : _time(query.endMinutes),
      ),
    );

    final statuses = [
      for (final item in statusResponse.items)
        CollectionStatus(
          equipmentId: item.equipmentId,
          snapshotAt: DateTime.tryParse(item.snapshotAt) ?? DateTime.now(),
          connectionStatus: ConnectionStatus.parse(item.connectionStatus),
          receivedCount: item.receivedCount,
          windowLabel: item.windowLabel,
          lossRatePercent: item.hasLossRatePct() ? item.lossRatePct : null,
          timeSyncStatus: TimeSyncStatus.parse(item.timeSyncStatus),
          clockOffsetMs: item.hasClockOffsetMs() ? item.clockOffsetMs : null,
          lastReceivedAt: DateTime.tryParse(item.lastReceivedAt),
        ),
    ];
    final snapshotAt =
        statusResponse.items
            .map((item) => DateTime.tryParse(item.snapshotAt))
            .whereType<DateTime>()
            .firstOrNull ??
        DateTime.now();

    return CollectionCatalog(
      equipments: [
        for (final item in equipmentResponse.items)
          Equipment(
            equipmentId: item.equipmentId,
            equipmentName: item.equipmentName,
            lineName: item.lineName,
          ),
      ],
      projects: [
        for (final item in projectResponse.items)
          Project(projectId: item.projectId, projectName: item.projectName),
      ],
      workers: [
        for (final item in workerResponse.items)
          Worker(workerId: item.workerId, workerName: item.workerName),
      ],
      assignments: [
        for (final item in assignmentResponse.items)
          CollectionAssignment(
            assignmentId: item.assignmentId,
            equipmentId: item.equipmentId,
            projectId: item.projectId,
            workerId: item.workerId,
            assignedFrom: DateTime.parse(item.assignedFrom),
            assignedTo: DateTime.parse(item.assignedTo),
          ),
      ],
      statuses: statuses,
      events: [
        for (final item in eventResponse.items)
          CollectionEvent(
            eventId: item.eventId,
            equipmentId: item.equipmentId,
            equipmentName: item.equipmentName,
            lineName: item.lineName,
            eventAt: DateTime.parse(item.eventAt),
            durationSec: item.durationSec,
            connectionStatus: ConnectionStatus.parse(item.connectionStatus),
            receivedCount: item.receivedCount,
            windowLabel: item.windowLabel,
            lossRatePercent: item.hasLossRatePct() ? item.lossRatePct : null,
            timeSyncStatus: TimeSyncStatus.parse(item.timeSyncStatus),
            clockOffsetMs: item.hasClockOffsetMs() ? item.clockOffsetMs : null,
          ),
      ],
      snapshotAt: snapshotAt,
      isServerFiltered: true,
    );
  }

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  String _time(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
}
