import '../entities/quality_job_media.dart';

abstract class QualityJobMediaRepository {
  /// [passId]가 비면 job의 PDF/video를 페이지 단위로 반환한다. 각 항목의 passId는 유지한다.
  Future<QualityJobMediaPage> listJobMedia({
    required String jobId,
    String passId = '',
    String pageToken = '',
  });
}
