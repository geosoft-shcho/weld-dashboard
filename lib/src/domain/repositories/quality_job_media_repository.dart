import '../entities/quality_job_media.dart';

abstract class QualityJobMediaRepository {
  Future<List<QualityJobMedia>> listJobMedia({
    required String jobId,
    required String passId,
  });
}
