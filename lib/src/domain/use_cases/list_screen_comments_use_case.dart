import '../entities/screen_comment.dart';
import '../repositories/asset_upload_repository.dart';

class ListScreenCommentsUseCase {
  const ListScreenCommentsUseCase(this._repository);

  final AssetUploadRepository _repository;

  Future<List<ScreenComment>> execute({required String jobId}) {
    if (jobId.isEmpty) {
      return Future.value(const []);
    }
    return _repository.listScreenComments(jobId: jobId);
  }
}
