import '../entities/asset_upload.dart';
import '../entities/screen_comment.dart';
import '../repositories/asset_upload_repository.dart';

class UpdateScreenCommentUseCase {
  const UpdateScreenCommentUseCase(this._repository);

  final AssetUploadRepository _repository;

  Future<ScreenComment> execute({
    required String commentId,
    required String body,
  }) {
    if (commentId.isEmpty) {
      throw const AssetUploadException('코멘트를 찾지 못했습니다.');
    }
    return _repository.updateScreenComment(commentId: commentId, body: body);
  }
}
