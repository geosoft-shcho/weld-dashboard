import '../../domain/entities/quality_job_media.dart';
import '../../domain/repositories/quality_job_media_repository.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemoteQualityJobMediaRepository implements QualityJobMediaRepository {
  RemoteQualityJobMediaRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<QualityJobMedia>> listJobMedia({
    required String jobId,
    required String passId,
  }) async {
    if (jobId.isEmpty || passId.isEmpty) {
      return const [];
    }
    final request = asset_pb.ListAssetsRequest(pageSize: 200);
    request.job = asset_pb.AssetJobFilter(jobId: protoId(jobId));
    final response = await _mediaTag.assetService.listAssets(request);
    final pdfs = <QualityJobMedia>[];
    final videos = <QualityJobMedia>[];
    for (final asset in response.assets) {
      final assetId = idText(asset.assetId);
      if (assetId.isEmpty) {
        continue;
      }
      final attachedPassId = response.passIds.containsKey(asset.assetId)
          ? idText(response.passIds[asset.assetId]!)
          : '';
      if (attachedPassId != passId) {
        continue;
      }
      final isVideo = asset.kind == asset_pb.AssetKind.ASSET_KIND_VIDEO;
      if (!isVideo && !_isPdf(asset)) {
        continue;
      }
      final media = QualityJobMedia(
        assetId: assetId,
        fileName: asset.fileName,
        url: _mediaTag.resolveContentUrl(asset.contentUrl),
        passId: attachedPassId,
        isVideo: isVideo,
        recordedAt: asset.hasRecordedAt()
            ? asset.recordedAt.toDateTime()
            : null,
        durationNs: asset.hasDurationNs() ? asset.durationNs.toInt() : null,
      );
      if (isVideo) {
        videos.add(media);
      } else {
        pdfs.add(media);
      }
    }
    return [...pdfs, ...videos];
  }

  bool _isPdf(asset_pb.Asset asset) {
    if (asset.kind != asset_pb.AssetKind.ASSET_KIND_DOCUMENT) {
      return false;
    }
    final name = asset.fileName.toLowerCase();
    final mime = asset.mimeType.toLowerCase();
    return name.endsWith('.pdf') || mime.contains('pdf');
  }
}
