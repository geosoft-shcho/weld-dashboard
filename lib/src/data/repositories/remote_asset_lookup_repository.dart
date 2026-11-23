import 'dart:convert';

import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';

import '../../domain/entities/asset_lookup_row.dart';
import '../../domain/repositories/asset_lookup_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/generated/mediatag/run/v1/run.pbenum.dart' as run_pb;
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemoteAssetLookupRepository implements AssetLookupRepository {
  RemoteAssetLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<AssetLookupPage> listAssets({
    required String kindCode,
    required String query,
    required String equipmentId,
    required bool unattachedOnly,
    String jobId = '',
    String projectId = '',
    String projectItemId = '',
    String workerId = '',
    String unitNo = '',
    String itemCode = '',
    String jointNo = '',
    int passNo = 0,
    bool sharedOnly = false,
    DateTime? startedFrom,
    DateTime? startedTo,
    String postprocessStatusCode = '',
    required int pageSize,
    required String pageToken,
  }) async {
    final request = asset_pb.ListAssetsRequest(
      pageSize: pageSize,
      pageToken: pageToken,
    );
    final kind = _kindOf(kindCode);
    if (kind != asset_pb.AssetKind.ASSET_KIND_UNSPECIFIED) {
      request.kind = kind;
    }
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty) {
      request.query = trimmedQuery;
    }
    final equipment = protoIdOrNull(equipmentId);
    if (equipment != null) {
      request.equipmentId = equipment;
    }
    final job = _jobFilter(
      jobId: jobId,
      projectId: projectId,
      projectItemId: projectItemId,
      workerId: workerId,
      unitNo: unitNo,
      itemCode: itemCode,
      jointNo: jointNo,
      passNo: passNo,
      sharedOnly: sharedOnly,
      startedFrom: startedFrom,
      startedTo: startedTo,
    );
    if (job != null) {
      request.job = job;
    } else if (unattachedOnly) {
      request.unattachedOnly = true;
    }
    final postprocessStatus = _postprocessStatusOf(postprocessStatusCode);
    if (postprocessStatus != run_pb.RunStatus.RUN_STATUS_UNSPECIFIED) {
      request.postprocessStatus = postprocessStatus;
    }
    final response = await _mediaTag.assetService.listAssets(request);
    final hasJob = jobId.isNotEmpty;
    return AssetLookupPage(
      rows: [
        for (final asset in response.assets)
          _rowFrom(
            asset,
            isAttached: hasJob,
            isUnattached: !hasJob && unattachedOnly,
            attachmentPassId: !hasJob
                ? ''
                : (response.passIds.containsKey(asset.assetId)
                      ? idText(response.passIds[asset.assetId]!)
                      : jobCommonPassToken),
          ),
      ],
      nextPageToken: response.nextPageToken,
      totalCount: response.totalCount,
    );
  }

  asset_pb.AssetJobFilter? _jobFilter({
    required String jobId,
    required String projectId,
    required String projectItemId,
    required String workerId,
    required String unitNo,
    required String itemCode,
    required String jointNo,
    required int passNo,
    required bool sharedOnly,
    required DateTime? startedFrom,
    required DateTime? startedTo,
  }) {
    final hasJob =
        jobId.isNotEmpty ||
        projectId.isNotEmpty ||
        projectItemId.isNotEmpty ||
        workerId.isNotEmpty ||
        unitNo.isNotEmpty ||
        itemCode.isNotEmpty ||
        jointNo.isNotEmpty ||
        passNo != 0 ||
        sharedOnly ||
        startedFrom != null ||
        startedTo != null;
    if (!hasJob) {
      return null;
    }
    final job = asset_pb.AssetJobFilter();
    final jobIdValue = protoIdOrNull(jobId);
    if (jobIdValue != null) {
      job.jobId = jobIdValue;
    }
    final projectIdValue = protoIdOrNull(projectId);
    if (projectIdValue != null) {
      job.projectId = projectIdValue;
    }
    final projectItemIdValue = protoIdOrNull(projectItemId);
    if (projectItemIdValue != null) {
      job.projectItemId = projectItemIdValue;
    }
    final workerIdValue = protoIdOrNull(workerId);
    if (workerIdValue != null) {
      job.workerId = workerIdValue;
    }
    if (unitNo.isNotEmpty) {
      job.unitNo = unitNo;
    }
    if (itemCode.isNotEmpty) {
      job.itemCode = itemCode;
    }
    if (jointNo.isNotEmpty) {
      job.jointNo = jointNo;
    }
    if (sharedOnly) {
      job.sharedOnly = true;
    } else if (passNo != 0) {
      job.passNo = passNo;
    }
    if (startedFrom != null) {
      job.startedFrom = Timestamp.fromDateTime(startedFrom);
    }
    if (startedTo != null) {
      job.startedTo = Timestamp.fromDateTime(startedTo);
    }
    return job;
  }

  @override
  Future<List<JobPassOption>> listJobPasses({required String jobId}) async {
    final response = await _mediaTag.workService.getJob(
      work_pb.GetJobRequest(jobId: protoId(jobId)),
    );
    return [
      for (final pass in response.passes)
        if (idText(pass.passId).isNotEmpty)
          JobPassOption(
            passId: idText(pass.passId),
            passNo: pass.passNo,
            startedAt: pass.hasStartedAt()
                ? pass.startedAt.toDateTime().toLocal()
                : null,
            endedAt: pass.hasEndedAt()
                ? pass.endedAt.toDateTime().toLocal()
                : null,
          ),
    ];
  }

  @override
  Future<AssetLookupRow?> getAsset({required String assetId}) async {
    final id = protoIdOrNull(assetId);
    if (id == null) {
      return null;
    }
    final response = await _mediaTag.assetService.getAsset(
      asset_pb.GetAssetRequest(assetId: id),
    );
    if (!response.hasAsset()) {
      return null;
    }
    return _rowFrom(response.asset, isAttached: false, includeDetail: true);
  }

  @override
  Future<String> updateAsset({
    required String assetId,
    required String subject,
    required String situation,
    DateTime? recordedAt,
    required List<String> changedFields,
  }) async {
    final id = protoIdOrNull(assetId);
    if (id == null) {
      throw ArgumentError('파일 번호가 없습니다.');
    }
    if (changedFields.isEmpty) {
      throw ArgumentError('바뀐 칸이 없습니다.');
    }
    final asset = asset_pb.Asset(
      assetId: id,
      subject: subject,
      situation: situation,
    );
    if (recordedAt != null) {
      asset.recordedAt = Timestamp.fromDateTime(recordedAt.toUtc());
    }
    final response = await _mediaTag.assetService.updateAsset(
      asset_pb.UpdateAssetRequest(
        asset: asset,
        updateMask: FieldMask(paths: changedFields),
      ),
    );
    return idText(response.replaceRunId);
  }

  @override
  Future<void> deleteAsset({required String assetId}) async {
    final id = protoIdOrNull(assetId);
    if (id == null) {
      throw ArgumentError('파일 번호가 없습니다.');
    }
    try {
      await _mediaTag.assetService.deleteAsset(
        asset_pb.DeleteAssetRequest(assetId: id),
      );
    } on ConnectException catch (error) {
      throw _assetWriteFailure(error);
    }
  }

  AssetLookupRow _rowFrom(
    asset_pb.Asset asset, {
    required bool isAttached,
    bool isUnattached = false,
    String attachmentPassId = '',
    bool includeDetail = false,
  }) {
    final parentId = asset.hasProvenance()
        ? asset.provenance.parentAssetId
        : Int64.ZERO;
    final parentText = parentId == Int64.ZERO ? '' : idText(parentId);
    var provenanceSummary = '';
    if (includeDetail && asset.hasProvenance()) {
      final provenance = asset.provenance;
      final parts = <String>[
        if (provenance.operation.isNotEmpty) provenance.operation,
        if (provenance.runId != Int64.ZERO) '실행 ${idText(provenance.runId)}',
        if (provenance.toolId != Int64.ZERO) '도구 ${idText(provenance.toolId)}',
        if (provenance.toolVersion.isNotEmpty) provenance.toolVersion,
      ];
      provenanceSummary = parts.join(' · ');
    }
    return AssetLookupRow(
      assetId: idText(asset.assetId),
      kindCode: _kindCodeOf(asset.kind),
      fileName: asset.fileName,
      equipmentId: idText(asset.equipmentId),
      sizeBytes: asset.sizeBytes.toInt(),
      durationNs: asset.hasDurationNs() ? asset.durationNs.toInt() : null,
      isDerived: parentId != Int64.ZERO,
      isAttached: isAttached,
      isUnattached: isUnattached,
      childCount: asset.childCount,
      attachmentPassId: attachmentPassId,
      parentAssetId: parentText,
      provenanceSummary: provenanceSummary,
      displayFields: includeDetail
          ? [
              for (final field in asset.display)
                if (field.label.isNotEmpty)
                  AssetDisplayField(label: field.label, value: field.value),
            ]
          : const [],
      propertiesJson: includeDetail &&
              asset.hasProperties() &&
              asset.properties.fields.isNotEmpty
          ? jsonEncode(asset.properties.toProto3Json())
          : '',
      subject: asset.subject,
      situation: asset.situation,
      contentUrl: _contentUrlOf(asset),
      mimeType: asset.mimeType,
      collectedAt: asset.hasCollectedAt()
          ? asset.collectedAt.toDateTime().toLocal()
          : null,
      recordedAt: asset.hasRecordedAt()
          ? asset.recordedAt.toDateTime().toLocal()
          : null,
      postprocess: asset.hasPostprocess()
          ? AssetPostprocessSummary(
              runId: asset.postprocess.runId == Int64.ZERO
                  ? ''
                  : idText(asset.postprocess.runId),
              statusCode: _postprocessStatusCodeOf(asset.postprocess.status),
              errorMessage: asset.postprocess.errorMessage,
            )
          : const AssetPostprocessSummary(),
      createdByDisplayName:
          asset.hasCreatedBy() ? asset.createdBy.displayName : '',
      updatedByDisplayName:
          asset.hasUpdatedBy() ? asset.updatedBy.displayName : '',
    );
  }

  String _contentUrlOf(asset_pb.Asset asset) {
    if (asset.contentUrl.isNotEmpty) {
      return _mediaTag.resolveContentUrl(asset.contentUrl);
    }
    if (asset.assetId == Int64.ZERO) {
      return '';
    }
    return _mediaTag.resolveContentUrl('/assets/${idText(asset.assetId)}/content');
  }

  run_pb.RunStatus _postprocessStatusOf(String code) {
    switch (code) {
      case 'queued':
        return run_pb.RunStatus.RUN_STATUS_QUEUED;
      case 'running':
        return run_pb.RunStatus.RUN_STATUS_RUNNING;
      case 'succeeded':
        return run_pb.RunStatus.RUN_STATUS_SUCCEEDED;
      case 'failed':
        return run_pb.RunStatus.RUN_STATUS_FAILED;
      case 'canceled':
        return run_pb.RunStatus.RUN_STATUS_CANCELED;
      default:
        return run_pb.RunStatus.RUN_STATUS_UNSPECIFIED;
    }
  }

  String _postprocessStatusCodeOf(run_pb.RunStatus status) {
    switch (status) {
      case run_pb.RunStatus.RUN_STATUS_QUEUED:
        return 'queued';
      case run_pb.RunStatus.RUN_STATUS_RUNNING:
        return 'running';
      case run_pb.RunStatus.RUN_STATUS_SUCCEEDED:
        return 'succeeded';
      case run_pb.RunStatus.RUN_STATUS_FAILED:
        return 'failed';
      case run_pb.RunStatus.RUN_STATUS_CANCELED:
        return 'canceled';
      case run_pb.RunStatus.RUN_STATUS_UNSPECIFIED:
      default:
        return '';
    }
  }

  @override
  Future<String> readContent({required String url}) {
    if (url.isEmpty) {
      return Future.value('');
    }
    return _mediaTag.readContent(url);
  }

  asset_pb.AssetKind _kindOf(String code) {
    switch (code) {
      case 'video':
        return asset_pb.AssetKind.ASSET_KIND_VIDEO;
      case 'audio':
        return asset_pb.AssetKind.ASSET_KIND_AUDIO;
      case 'image':
        return asset_pb.AssetKind.ASSET_KIND_IMAGE;
      case 'document':
        return asset_pb.AssetKind.ASSET_KIND_DOCUMENT;
      case 'pose':
        return asset_pb.AssetKind.ASSET_KIND_POSE;
      case 'subtitle':
        return asset_pb.AssetKind.ASSET_KIND_SUBTITLE;
      case 'timeseries':
        return asset_pb.AssetKind.ASSET_KIND_TIMESERIES;
      case 'pointCloud':
        return asset_pb.AssetKind.ASSET_KIND_POINTCLOUD;
      case 'ocrJson':
        return asset_pb.AssetKind.ASSET_KIND_OCR_JSON;
      case 'region':
        return asset_pb.AssetKind.ASSET_KIND_REGION;
      default:
        return asset_pb.AssetKind.ASSET_KIND_UNSPECIFIED;
    }
  }

  Exception _assetWriteFailure(ConnectException error) {
    switch (error.code) {
      case Code.failedPrecondition:
        final message = error.message.trim();
        return _WriteFailure(
          message.isEmpty
              ? '작업에 붙어 있거나 파생의 부모이거나 성적서 원본이면 지울 수 없습니다.'
              : message,
        );
      default:
        return error;
    }
  }

  String _kindCodeOf(asset_pb.AssetKind kind) {
    switch (kind) {
      case asset_pb.AssetKind.ASSET_KIND_VIDEO:
        return 'video';
      case asset_pb.AssetKind.ASSET_KIND_AUDIO:
        return 'audio';
      case asset_pb.AssetKind.ASSET_KIND_IMAGE:
        return 'image';
      case asset_pb.AssetKind.ASSET_KIND_DOCUMENT:
        return 'document';
      case asset_pb.AssetKind.ASSET_KIND_POSE:
        return 'pose';
      case asset_pb.AssetKind.ASSET_KIND_SUBTITLE:
        return 'subtitle';
      case asset_pb.AssetKind.ASSET_KIND_TIMESERIES:
        return 'timeseries';
      case asset_pb.AssetKind.ASSET_KIND_POINTCLOUD:
        return 'pointCloud';
      case asset_pb.AssetKind.ASSET_KIND_OCR_JSON:
        return 'ocrJson';
      case asset_pb.AssetKind.ASSET_KIND_REGION:
        return 'region';
      case asset_pb.AssetKind.ASSET_KIND_UNSPECIFIED:
        return '';
    }
    return '';
  }
}

class _WriteFailure implements Exception {
  _WriteFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
