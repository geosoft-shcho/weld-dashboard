import '../entities/asset_upload.dart';
import '../entities/screen_comment.dart';
import '../repositories/asset_upload_repository.dart';

class CreateScreenCommentUseCase {
  const CreateScreenCommentUseCase(this._repository);

  final AssetUploadRepository _repository;

  Future<ScreenComment> execute({
    required String jobId,
    String passId = '',
    required String audioAssetId,
    String videoAssetId = '',
    String body = '',
    required DateTime startedAt,
    required List<Map<String, Object?>> context,
  }) {
    if (jobId.isEmpty) {
      throw const AssetUploadException('작업을 열지 못했습니다.');
    }
    if (audioAssetId.isEmpty) {
      throw const AssetUploadException('코멘트 음성이 없습니다.');
    }
    if (context.isEmpty) {
      throw const AssetUploadException('화면 상태가 없습니다.');
    }
    return _repository.createScreenComment(
      jobId: jobId,
      passId: passId,
      audioAssetId: audioAssetId,
      videoAssetId: videoAssetId,
      body: body,
      startedAt: startedAt,
      context: context,
    );
  }
}
