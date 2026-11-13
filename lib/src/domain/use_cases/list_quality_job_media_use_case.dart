import '../entities/quality_job_media.dart';
import '../repositories/quality_job_media_repository.dart';

class ListQualityJobMediaUseCase {
  ListQualityJobMediaUseCase(this._repository);

  final QualityJobMediaRepository _repository;

  Future<QualityJobMediaPage> execute({
    required String jobId,
    String passId = '',
    String pageToken = '',
  }) {
    if (jobId.isEmpty) {
      return Future.value(const QualityJobMediaPage(items: []));
    }
    return _repository.listJobMedia(
      jobId: jobId,
      passId: passId,
      pageToken: pageToken,
    );
  }
}
