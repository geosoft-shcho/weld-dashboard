import '../entities/report_set.dart';

abstract class ReportSetRepository {
  Future<List<ReportSetSummary>> listForJob(String jobId);

  Future<ReportSetDetail> getSet(String reportSetId);
}
