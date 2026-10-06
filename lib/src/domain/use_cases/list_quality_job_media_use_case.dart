import '../entities/quality_job_media.dart';
import '../repositories/quality_job_media_repository.dart';

class ListQualityJobMediaUseCase {
  ListQualityJobMediaUseCase(this._repository);

  final QualityJobMediaRepository _repository;

  Future<List<QualityJobMedia>> execute({
    required String jobId,
    required String passId,
  }) {
    if (jobId.isEmpty || passId.isEmpty) {
      return Future.value(const []);
    }
    return _repository.listJobMedia(jobId: jobId, passId: passId);
  }
}
