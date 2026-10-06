import '../../domain/entities/quality_job_media.dart';
import '../../domain/repositories/quality_job_media_repository.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/remote/media_tag_data_source.dart';

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
    final response = await _mediaTag.assetService.listJobAssets(
      asset_pb.ListJobAssetsRequest(jobId: jobId, passId: passId),
    );
    final pdfs = <QualityJobMedia>[];
    final videos = <QualityJobMedia>[];
    for (final item in response.assets) {
      final asset = item.asset;
      if (asset.assetId.isEmpty) {
        continue;
      }
      final isVideo = asset.kind == asset_pb.AssetKind.ASSET_KIND_VIDEO;
      if (!isVideo && !_isPdf(asset)) {
        continue;
      }
      final media = QualityJobMedia(
        assetId: asset.assetId,
        fileName: asset.fileName,
        url: _mediaTag.resolveContentUrl(asset.contentUrl),
        passId: item.passId,
        isVideo: isVideo,
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
