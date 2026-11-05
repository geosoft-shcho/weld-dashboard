import '../entities/asset_upload.dart';
import '../repositories/asset_upload_repository.dart';

class DeleteScreenCommentUseCase {
  const DeleteScreenCommentUseCase(this._repository);

  final AssetUploadRepository _repository;

  Future<void> execute({required String commentId}) {
    if (commentId.isEmpty) {
      throw const AssetUploadException('코멘트를 찾지 못했습니다.');
    }
    return _repository.deleteScreenComment(commentId: commentId);
  }
}
