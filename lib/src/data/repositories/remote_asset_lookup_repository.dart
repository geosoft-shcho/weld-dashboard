import 'package:fixnum/fixnum.dart';

import '../../domain/entities/asset_lookup_row.dart';
import '../../domain/repositories/asset_lookup_repository.dart';
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
    required String fileName,
    required String equipmentId,
    required bool unattachedOnly,
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
    final trimmedName = fileName.trim();
    if (trimmedName.isNotEmpty) {
      request.fileName = trimmedName;
    }
    final equipment = protoIdOrNull(equipmentId);
    if (equipment != null) {
      request.equipmentId = equipment;
    }
    if (unattachedOnly) {
      request.unattachedOnly = true;
    }
    final response = await _mediaTag.assetService.listAssets(request);
    return AssetLookupPage(
      rows: [
        for (final asset in response.assets)
          _rowFrom(
            asset,
            isAttached: false,
            isUnattached: unattachedOnly,
          ),
      ],
      nextPageToken: response.nextPageToken,
    );
  }

  @override
  Future<List<AssetLookupRow>> listJobAssets({
    required String jobId,
    required String passId,
  }) async {
    final request = asset_pb.ListJobAssetsRequest(jobId: protoId(jobId));
    if (passId == jobCommonPassToken) {
      request.passId = Int64.ZERO;
    } else {
      final selectedPassId = protoIdOrNull(passId);
      if (selectedPassId != null) {
        request.passId = selectedPassId;
      }
    }
    final response = await _mediaTag.assetService.listJobAssets(request);
    return [
      for (final item in response.assets)
        _rowFrom(
          item.asset,
          isAttached: true,
          attachmentPassId: item.passId == Int64.ZERO
              ? jobCommonPassToken
              : idText(item.passId),
        ),
    ];
  }

  @override
  Future<List<JobPassOption>> listJobPasses({required String jobId}) async {
    final response = await _mediaTag.workService.getJob(
      work_pb.GetJobRequest(jobId: protoId(jobId)),
    );
    return [
      for (final pass in response.passes)
        if (idText(pass.passId).isNotEmpty)
          JobPassOption(passId: idText(pass.passId), passNo: pass.passNo),
    ];
  }

  AssetLookupRow _rowFrom(
    asset_pb.Asset asset, {
    required bool isAttached,
    bool isUnattached = false,
    String attachmentPassId = '',
  }) {
    final parentId = asset.hasProvenance()
        ? asset.provenance.parentAssetId
        : Int64.ZERO;
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
