import 'package:fixnum/fixnum.dart';

import '../../domain/entities/collected_node.dart';
import '../../domain/entities/collection_assignment.dart';
import '../../domain/entities/collection_catalog.dart';
import '../../domain/entities/collection_board_query.dart';
import '../../domain/entities/collection_event.dart';
import '../../domain/entities/collection_status.dart';
import '../../domain/entities/collection_summary.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/time_sync_status.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/collection_catalog_repository.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart' as ts;
import '../datasources/generated/mediatag/asset/v1/asset.pbenum.dart'
    as asset_pb;
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

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
    final nodes = await listCollectedNodes(CollectedNodePath.root());
    final selectedDay = query?.selectedDate ?? DateTime.now();
    final dayStart = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));
    final equipments = [
      for (final item in equipmentResponse.equipment)
        Equipment(
          equipmentId: idText(item.equipmentId),
          equipmentName: item.equipmentName,
          equipmentCode: item.equipmentCode,
        ),
    ];
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
          Worker(workerId: idText(item.workerId), workerName: item.workerName),
      ],
      assignments: _assignmentsFrom(nodes, dayStart, dayEnd),
      statuses: [for (final node in nodes) _statusFrom(node, snapshotAt)],
      events: [
        for (final node in nodes)
          ..._eventsFrom(node, equipmentById, dayStart, dayEnd),
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
      final projectNo = node.path.projectNo;
      if (projectNo.isEmpty) {
        continue;
      }
      final key = '${node.nodeKey}/$projectNo';
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
          equipmentId: node.nodeKey,
          projectId: projectNo,
          workerId: '',
          assignedFrom: assignedFrom,
          assignedTo: assignedTo,
        ),
      );
    }
    return assignments;
  }

  CollectionStatus _statusFrom(CollectedNode node, DateTime snapshotAt) {
    final assetCount = node.assetCount ?? 0;
    final isConnected = assetCount > 0 || node.isAssetNode;
    return CollectionStatus(
      equipmentId: node.nodeKey,
      snapshotAt: snapshotAt,
      connectionStatus: isConnected
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

  List<CollectionEvent> _eventsFrom(
    CollectedNode node,
    Map<String, Equipment> equipmentById,
    DateTime dayStart,
    DateTime dayEnd,
  ) {
    final ranges = node.segments.isNotEmpty
        ? node.segments
        : [
            CollectedTimeRange(
              startedAt: node.startedAt,
              endedAt: node.endedAt,
            ),
          ];
    final events = <CollectionEvent>[];
    final assetCount = node.assetCount ?? 0;
    final isConnected = assetCount > 0 || node.isAssetNode;
    final connectionStatus = isConnected
        ? ConnectionStatus.connected
        : ConnectionStatus.disconnected;
    for (var index = 0; index < ranges.length; index++) {
      final startedAt = ranges[index].startedAt;
      final endedAt = ranges[index].endedAt;
      if (startedAt == null || endedAt == null) {
        continue;
      }
      final isPoint = !endedAt.isAfter(startedAt);
      if (isPoint) {
        if (startedAt.isBefore(dayStart) || !startedAt.isBefore(dayEnd)) {
          continue;
        }
        events.add(
          CollectionEvent(
            eventId: '${node.nodeKey}/${startedAt.toIso8601String()}/$index',
            equipmentId: node.nodeKey,
            equipmentName: node.label.isNotEmpty ? node.label : node.nodeKey,
            lineName: '',
            eventAt: startedAt,
            durationSec: 0,
            connectionStatus: connectionStatus,
            receivedCount: assetCount,
            windowLabel: _segmentWindowLabel(
              startedAt: startedAt,
              endedAt: endedAt,
              isPoint: true,
            ),
            lossRatePercent: null,
            timeSyncStatus: TimeSyncStatus.synced,
            clockOffsetMs: null,
          ),
        );
        continue;
      }
      final visibleStart = startedAt.isBefore(dayStart) ? dayStart : startedAt;
      final visibleEnd = endedAt.isAfter(dayEnd) ? dayEnd : endedAt;
      if (!visibleStart.isBefore(visibleEnd)) {
        continue;
      }
      events.add(
        CollectionEvent(
          eventId: '${node.nodeKey}/${visibleStart.toIso8601String()}/$index',
          equipmentId: node.nodeKey,
          equipmentName: node.label.isNotEmpty ? node.label : node.nodeKey,
          lineName: '',
          eventAt: visibleStart,
          durationSec: visibleEnd.difference(visibleStart).inSeconds,
          connectionStatus: connectionStatus,
          receivedCount: assetCount,
          windowLabel: _segmentWindowLabel(
            startedAt: startedAt,
            endedAt: endedAt,
            isPoint: false,
          ),
          lossRatePercent: null,
          timeSyncStatus: TimeSyncStatus.synced,
          clockOffsetMs: null,
        ),
      );
    }
    return events;
  }

  String _windowLabel(CollectedNode node) {
    final startedAt = node.firstRecordedAt ?? node.startedAt;
    final endedAt = node.lastRecordedAt ?? node.endedAt;
    if (startedAt == null || endedAt == null) {
      return node.label;
    }
    return _segmentWindowLabel(
      startedAt: startedAt,
      endedAt: endedAt,
      isPoint: !endedAt.isAfter(startedAt),
    );
  }

  String _segmentWindowLabel({
    required DateTime startedAt,
    required DateTime endedAt,
    required bool isPoint,
  }) {
    if (isPoint) {
      return _dateClock(startedAt);
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
    CollectedSegmentUnit segmentUnit = CollectedSegmentUnit.job,
    String workerId = '',
  }) async {
    final doesHaveJob = parent.jobId.isNotEmpty;
    final worker = protoIdOrNull(workerId);
    final response = await _source.workService.listCollectionNodes(
      pb.ListCollectionNodesRequest(
        parent: _pathToProto(parent),
        segmentUnit: switch (segmentUnit) {
          CollectedSegmentUnit.job => pb.SegmentUnit.SEGMENT_UNIT_JOB,
          CollectedSegmentUnit.pass => pb.SegmentUnit.SEGMENT_UNIT_PASS,
        },
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
        workerId: worker,
      ),
    );
    return [for (final node in response.nodes) _nodeFromProto(node)];
  }

  @override
  Future<CollectionSummaryLoad> getCollectionSummary({
    CollectedNodePath? parent,
    String workerId = '',
  }) async {
    final worker = protoIdOrNull(workerId);
    final request = pb.GetCollectionSummaryRequest(workerId: worker);
    if (parent != null) {
      request.parent = _pathToProto(parent);
    }
    final response = await _source.workService.getCollectionSummary(request);
    return CollectionSummaryLoad(
      summary: _summaryFromProto(response.summary),
      runningTraceCount: response.traceRunningCount.toInt(),
      failedTraceCount: response.traceFailedCount.toInt(),
    );
  }

  @override
  Future<List<AssetCountRow>> listAssetCounts({
    CollectedNodePath? parent,
    String workerId = '',
    AssetCountTimeBasis basis = AssetCountTimeBasis.collected,
    DateTime? from,
    DateTime? to,
  }) async {
    final worker = protoIdOrNull(workerId);
    final request = pb.ListAssetCountsRequest(
      basis: switch (basis) {
        AssetCountTimeBasis.collected =>
          pb.AssetTimeBasis.ASSET_TIME_BASIS_COLLECTED,
        AssetCountTimeBasis.recorded =>
          pb.AssetTimeBasis.ASSET_TIME_BASIS_RECORDED,
      },
      workerId: worker,
    );
    if (parent != null) {
      request.parent = _pathToProto(parent);
    }
    if (from != null) {
      request.from = ts.Timestamp.fromDateTime(from.toUtc());
    }
    if (to != null) {
      request.to = ts.Timestamp.fromDateTime(to.toUtc());
    }
    final response = await _source.workService.listAssetCounts(request);
    return [
      for (final row in response.counts)
        AssetCountRow(
          date: row.date,
          kind: _assetKindFromProto(row.kind),
          assetCount: row.assetCount.toInt(),
          totalSizeBytes: row.totalSizeBytes.toInt(),
        ),
    ];
  }

  pb.CollectionPath _pathToProto(CollectedNodePath path) {
    final message = pb.CollectionPath(
      view: pb.CollectionView.COLLECTION_VIEW_PROJECT,
      level: switch (path.level) {
        CollectedNodeLevel.unspecified =>
          pb.CollectionLevel.COLLECTION_LEVEL_UNSPECIFIED,
        CollectedNodeLevel.project =>
          pb.CollectionLevel.COLLECTION_LEVEL_PROJECT,
        CollectedNodeLevel.item => pb.CollectionLevel.COLLECTION_LEVEL_ITEM,
        CollectedNodeLevel.job => pb.CollectionLevel.COLLECTION_LEVEL_JOB,
      },
      projectNo: path.projectNo,
      commonKey: path.commonKey,
    );
    final jobId = protoIdOrNull(path.jobId);
    if (jobId != null) {
      message.jobId = jobId;
    }
    return message;
  }

  CollectedNode _nodeFromProto(pb.CollectionNode node) {
    final path = node.path;
    return CollectedNode(
      path: CollectedNodePath(
        view: CollectedNodeView.project,
        level: switch (path.level) {
          pb.CollectionLevel.COLLECTION_LEVEL_PROJECT =>
            CollectedNodeLevel.project,
          pb.CollectionLevel.COLLECTION_LEVEL_ITEM => CollectedNodeLevel.item,
          pb.CollectionLevel.COLLECTION_LEVEL_JOB => CollectedNodeLevel.job,
          _ => CollectedNodeLevel.unspecified,
        },
        projectNo: path.projectNo,
        commonKey: path.commonKey,
        jobId: idText(path.jobId),
        passId: idText(path.passId),
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
      assetId: node.hasAsset() ? idText(node.asset.assetId) : '',
      segments: [
        for (final segment in node.segments)
          CollectedTimeRange(
            startedAt: segment.hasStartedAt()
                ? segment.startedAt.toDateTime().toLocal()
                : null,
            endedAt: segment.hasEndedAt()
                ? segment.endedAt.toDateTime().toLocal()
                : null,
          ),
      ],
    );
  }

  CollectionSummary _summaryFromProto(pb.CollectionSummary summary) {
    return CollectionSummary(
      assetCount: summary.assetCount.toInt(),
      totalSizeBytes: summary.totalSizeBytes.toInt(),
      firstRecordedAt: summary.hasFirstRecordedAt()
          ? summary.firstRecordedAt.toDateTime().toLocal()
          : null,
      lastRecordedAt: summary.hasLastRecordedAt()
          ? summary.lastRecordedAt.toDateTime().toLocal()
          : null,
      lastCollectedAt: summary.hasLastCollectedAt()
          ? summary.lastCollectedAt.toDateTime().toLocal()
          : null,
      jobCount: summary.jobCount.toInt(),
      workDurationSeconds: summary.workDurationSeconds.toInt(),
      jobWithoutAssetCount: summary.jobWithoutAssetCount.toInt(),
      clipCount: summary.clipCount.toInt(),
      embeddedClipCount: summary.embeddedClipCount.toInt(),
      timeUnverifiedAssetCount: summary.timeUnverifiedAssetCount.toInt(),
      coverage: [
        for (final item in summary.coverage)
          KindCoverage(
            kind: _assetKindFromProto(item.kind),
            coveredSeconds: item.coveredSeconds.toInt(),
          ),
      ],
      weldDurationSeconds: summary.weldDurationSeconds.toInt(),
      attachedAssetCount: summary.attachedAssetCount.toInt(),
      embeddedAttachedAssetCount: summary.embeddedAttachedAssetCount.toInt(),
      commentCount: summary.commentCount.toInt(),
      embeddedCommentCount: summary.embeddedCommentCount.toInt(),
    );
  }

  CollectionAssetKind _assetKindFromProto(asset_pb.AssetKind kind) {
    return switch (kind) {
      asset_pb.AssetKind.ASSET_KIND_VIDEO => CollectionAssetKind.video,
      asset_pb.AssetKind.ASSET_KIND_AUDIO => CollectionAssetKind.audio,
      asset_pb.AssetKind.ASSET_KIND_IMAGE => CollectionAssetKind.image,
      asset_pb.AssetKind.ASSET_KIND_DOCUMENT => CollectionAssetKind.document,
      asset_pb.AssetKind.ASSET_KIND_POSE => CollectionAssetKind.pose,
      asset_pb.AssetKind.ASSET_KIND_SUBTITLE => CollectionAssetKind.subtitle,
      asset_pb.AssetKind.ASSET_KIND_TIMESERIES =>
        CollectionAssetKind.timeseries,
      asset_pb.AssetKind.ASSET_KIND_POINTCLOUD =>
        CollectionAssetKind.pointcloud,
      asset_pb.AssetKind.ASSET_KIND_OCR_JSON => CollectionAssetKind.ocrJson,
      asset_pb.AssetKind.ASSET_KIND_REGION => CollectionAssetKind.region,
      _ => CollectionAssetKind.unspecified,
    };
  }
}
