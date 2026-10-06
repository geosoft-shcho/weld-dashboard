import '../entities/quality_result_report.dart';

abstract class QualityResultRepository {
  Future<List<QualityResultReport>> listForJob(String jobId);
}
