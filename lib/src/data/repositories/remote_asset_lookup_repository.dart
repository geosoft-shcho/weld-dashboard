import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/asset_lookup_row.dart';
import '../../domain/repositories/asset_lookup_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
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
    if (kDebugMode) {
      debugPrint('[AssetLookup] request ${request.toProto3Json()}');
    }
    final response = await _mediaTag.assetService.listAssets(request);
    if (kDebugMode) {
      final names = [
        for (final asset in response.assets.take(5)) asset.fileName,
      ];
      debugPrint(
        '[AssetLookup] response count=${response.assets.length} '
        'total=${response.totalCount} next=${response.nextPageToken} '
        'passIds=${response.passIds.length} first=$names',
      );
    }
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
  Future<void> updateAsset({
    required String assetId,
    required String subject,
    required String situation,
    required List<String> changedFields,
  }) async {
    final id = protoIdOrNull(assetId);
    if (id == null) {
      throw ArgumentError('에셋 번호가 없습니다.');
    }
    if (changedFields.isEmpty) {
      throw ArgumentError('바뀐 칸이 없습니다.');
    }
    await _mediaTag.assetService.updateAsset(
      asset_pb.UpdateAssetRequest(
        asset: asset_pb.Asset(
          assetId: id,
          subject: subject,
          situation: situation,
        ),
        updateMask: FieldMask(paths: changedFields),
      ),
    );
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
    );
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
