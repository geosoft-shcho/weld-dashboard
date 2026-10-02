import 'package:fixnum/fixnum.dart';

import '../../domain/entities/collected_node.dart';
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
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as pb;
import '../datasources/remote/media_tag_data_source.dart';

class RemoteCollectionCatalogRepository implements CollectionCatalogRepository {
  RemoteCollectionCatalogRepository(this._source);

  final MediaTagDataSource _source;

  @override
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query}) async {
    final equipmentResponse = await _source.workService.listEquipment(
      pb.ListEquipmentRequest(),
    );
    final projectResponse = await _source.workService.listProjects(
      pb.ListProjectsRequest(),
    );
    final workerResponse = await _source.workService.listWorkers(
      pb.ListWorkersRequest(),
    );
    final nodes = await listCollectedNodes(
      CollectedNodePath.root(CollectedNodeView.equipment),
    );
    final selectedDay = query?.selectedDate ?? DateTime.now();
    final dayStart = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final equipments = [
      for (final item in equipmentResponse.equipment)
        Equipment(
          equipmentId: item.equipmentId,
          equipmentName: item.equipmentName,
          lineName: item.lineName,
        ),
    ];
    for (final node in nodes) {
      final equipmentId = _equipmentIdOf(node);
      final name = node.label.isEmpty ? '미지정' : node.label;
      final index = equipments.indexWhere(
        (item) => item.equipmentId == equipmentId,
      );
      if (index < 0) {
        equipments.add(
          Equipment(
            equipmentId: equipmentId,
            equipmentName: name,
            lineName: '',
          ),
        );
        continue;
      }
      if (node.label.isEmpty) {
        continue;
      }
      final current = equipments[index];
      equipments[index] = Equipment(
        equipmentId: current.equipmentId,
        equipmentName: node.label,
        lineName: current.lineName,
      );
    }
    final equipmentById = {
      for (final equipment in equipments) equipment.equipmentId: equipment,
    };
    final snapshotAt = DateTime.now();
    return CollectionCatalog(
      equipments: equipments,
      projects: [
        for (final item in projectResponse.projects)
          Project(projectId: item.projectNo, projectName: item.projectName),
      ],
      workers: [
        for (final item in workerResponse.workers)
          Worker(workerId: item.workerId, workerName: item.workerName),
      ],
      assignments: _assignmentsFrom(nodes, dayStart, dayEnd),
      statuses: [for (final node in nodes) _statusFrom(node, snapshotAt)],
      events: [
        for (final node in nodes)
          ?_eventFrom(node, equipmentById, dayStart, dayEnd),
      ],
      snapshotAt: snapshotAt,
      isServerFiltered: false,
    );
  }

  List<CollectionAssignment> _assignmentsFrom(
    List<CollectedNode> nodes,
    DateTime dayStart,
    DateTime dayEnd,
  ) {
    final assignments = <CollectionAssignment>[];
    final seen = <String>{};
    for (final node in nodes) {
      final equipmentId = _equipmentIdOf(node);
      final projectNo = node.path.projectNo;
      final workerId = node.path.workerId;
      if (equipmentId.isEmpty || equipmentId == 'unspecified') {
        continue;
      }
      if (projectNo.isEmpty && workerId.isEmpty) {
        continue;
      }
      final key = '$equipmentId/$projectNo/$workerId';
      if (!seen.add(key)) {
        continue;
      }
      final assignedFrom = node.startedAt ?? dayStart;
      var assignedTo = node.endedAt ?? dayEnd;
      if (!assignedTo.isAfter(assignedFrom)) {
        assignedTo = assignedFrom.add(const Duration(seconds: 1));
      }
      assignments.add(
        CollectionAssignment(
          assignmentId: key,
          equipmentId: equipmentId,
          projectId: projectNo,
          workerId: workerId,
          assignedFrom: assignedFrom,
          assignedTo: assignedTo,
        ),
      );
    }
    return assignments;
  }

  CollectionStatus _statusFrom(CollectedNode node, DateTime snapshotAt) {
    final equipmentId = _equipmentIdOf(node);
    final assetCount = node.assetCount ?? 0;
    return CollectionStatus(
      equipmentId: equipmentId,
      snapshotAt: snapshotAt,
      connectionStatus: assetCount > 0
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected,
      receivedCount: assetCount,
      windowLabel: _windowLabel(node),
      lossRatePercent: null,
      timeSyncStatus: node.startedAt != null && node.endedAt != null
          ? TimeSyncStatus.synced
          : TimeSyncStatus.unsynced,
      clockOffsetMs: null,
      lastReceivedAt: node.lastCollectedAt ?? node.lastRecordedAt,
    );
  }

  CollectionEvent? _eventFrom(
    CollectedNode node,
    Map<String, Equipment> equipmentById,
    DateTime dayStart,
    DateTime dayEnd,
  ) {
    final startedAt = node.startedAt;
    final endedAt = node.endedAt;
    if (startedAt == null || endedAt == null || !endedAt.isAfter(startedAt)) {
      return null;
    }
    final visibleStart = startedAt.isBefore(dayStart) ? dayStart : startedAt;
    final visibleEnd = endedAt.isAfter(dayEnd) ? dayEnd : endedAt;
    if (!visibleStart.isBefore(visibleEnd)) {
      return null;
    }
    final equipmentId = _equipmentIdOf(node);
    final equipment = equipmentById[equipmentId];
    return CollectionEvent(
      eventId: '$equipmentId/${visibleStart.toIso8601String()}',
      equipmentId: equipmentId,
      equipmentName: node.label.isNotEmpty
          ? node.label
          : (equipment?.equipmentName ?? equipmentId),
      lineName: equipment?.lineName ?? '',
      eventAt: visibleStart,
      durationSec: visibleEnd.difference(visibleStart).inSeconds,
      connectionStatus: (node.assetCount ?? 0) > 0
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected,
      receivedCount: node.assetCount ?? 0,
      windowLabel: _windowLabel(node),
      lossRatePercent: null,
      timeSyncStatus: TimeSyncStatus.synced,
      clockOffsetMs: null,
    );
  }

  String _equipmentIdOf(CollectedNode node) {
    return node.path.equipmentId.isEmpty ? 'unspecified' : node.path.equipmentId;
  }

  String _windowLabel(CollectedNode node) {
    final startedAt = node.firstRecordedAt ?? node.startedAt;
    final endedAt = node.lastRecordedAt ?? node.endedAt;
    if (startedAt == null || endedAt == null) {
      return node.label;
    }
    final doesSpanDays =
        startedAt.year != endedAt.year ||
        startedAt.month != endedAt.month ||
        startedAt.day != endedAt.day;
    if (!doesSpanDays) {
      return '${_clock(startedAt)}–${_clock(endedAt)}';
    }
    return '${_dateClock(startedAt)}–${_dateClock(endedAt)}';
  }

  String _dateClock(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$month/$day ${_clock(value)}';
  }

  String _clock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Future<List<CollectedNode>> listCollectedNodes(
    CollectedNodePath parent, {
    int? startOffsetNs,
    int? endOffsetNs,
    CollectedTimeBasis basis = CollectedTimeBasis.work,
  }) async {
    final doesHaveJob = parent.jobId.isNotEmpty;
    final response = await _source.workService.listCollectionNodes(
      pb.ListCollectionNodesRequest(
        parent: _pathToProto(parent),
        basis: switch (basis) {
          CollectedTimeBasis.work => pb.TimeBasis.TIME_BASIS_WORK,
          CollectedTimeBasis.collection => pb.TimeBasis.TIME_BASIS_COLLECTION,
        },
        startOffsetNs: doesHaveJob && startOffsetNs != null
            ? Int64(startOffsetNs)
            : null,
        endOffsetNs: doesHaveJob && endOffsetNs != null
            ? Int64(endOffsetNs)
            : null,
      ),
    );
    return [for (final node in response.nodes) _nodeFromProto(node)];
  }

  pb.CollectionPath _pathToProto(CollectedNodePath path) {
    return pb.CollectionPath(
      view: switch (path.view) {
        CollectedNodeView.equipment => pb.CollectionView.COLLECTION_VIEW_EQUIPMENT,
        CollectedNodeView.worker => pb.CollectionView.COLLECTION_VIEW_WORKER,
      },
      level: switch (path.level) {
        CollectedNodeLevel.unspecified =>
          pb.CollectionLevel.COLLECTION_LEVEL_UNSPECIFIED,
        CollectedNodeLevel.equipment =>
          pb.CollectionLevel.COLLECTION_LEVEL_EQUIPMENT,
        CollectedNodeLevel.worker => pb.CollectionLevel.COLLECTION_LEVEL_WORKER,
        CollectedNodeLevel.project =>
          pb.CollectionLevel.COLLECTION_LEVEL_PROJECT,
        CollectedNodeLevel.job => pb.CollectionLevel.COLLECTION_LEVEL_JOB,
        CollectedNodeLevel.pass => pb.CollectionLevel.COLLECTION_LEVEL_PASS,
      },
      equipmentId: path.equipmentId,
      workerId: path.workerId,
      projectNo: path.projectNo,
      jobId: path.jobId,
      passId: path.passId,
    );
  }

  CollectedNode _nodeFromProto(pb.CollectionNode node) {
    final path = node.path;
    return CollectedNode(
      path: CollectedNodePath(
        view: switch (path.view) {
          pb.CollectionView.COLLECTION_VIEW_WORKER => CollectedNodeView.worker,
          _ => CollectedNodeView.equipment,
        },
        level: switch (path.level) {
          pb.CollectionLevel.COLLECTION_LEVEL_EQUIPMENT =>
            CollectedNodeLevel.equipment,
          pb.CollectionLevel.COLLECTION_LEVEL_WORKER =>
            CollectedNodeLevel.worker,
          pb.CollectionLevel.COLLECTION_LEVEL_PROJECT =>
            CollectedNodeLevel.project,
          pb.CollectionLevel.COLLECTION_LEVEL_JOB => CollectedNodeLevel.job,
          pb.CollectionLevel.COLLECTION_LEVEL_PASS => CollectedNodeLevel.pass,
          _ => CollectedNodeLevel.unspecified,
        },
        equipmentId: path.equipmentId,
        workerId: path.workerId,
        projectNo: path.projectNo,
        jobId: path.jobId,
        passId: path.passId,
      ),
      label: node.label,
      hasChildren: node.hasChildren,
      assetCount: node.hasSummary() && node.summary.hasAssetCount()
          ? node.summary.assetCount.toInt()
          : null,
      totalSizeBytes: node.hasSummary() && node.summary.hasTotalSizeBytes()
          ? node.summary.totalSizeBytes.toInt()
          : null,
      firstRecordedAt: node.hasSummary() && node.summary.hasFirstRecordedAt()
          ? node.summary.firstRecordedAt.toDateTime().toLocal()
          : null,
      lastRecordedAt: node.hasSummary() && node.summary.hasLastRecordedAt()
          ? node.summary.lastRecordedAt.toDateTime().toLocal()
          : null,
      lastCollectedAt: node.hasSummary() && node.summary.hasLastCollectedAt()
          ? node.summary.lastCollectedAt.toDateTime().toLocal()
          : null,
      jobCount: node.hasSummary() && node.summary.hasJobCount()
          ? node.summary.jobCount.toInt()
          : null,
      workDurationSeconds:
          node.hasSummary() && node.summary.hasWorkDurationSeconds()
          ? node.summary.workDurationSeconds.toInt()
          : null,
      startedAt: node.hasStartedAt()
          ? node.startedAt.toDateTime().toLocal()
          : null,
      endedAt: node.hasEndedAt() ? node.endedAt.toDateTime().toLocal() : null,
      contentUrl: node.hasAsset() ? node.asset.contentUrl : '',
    );
  }
}
