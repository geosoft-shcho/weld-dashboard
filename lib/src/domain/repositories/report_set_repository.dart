import '../entities/report_set.dart';

abstract class ReportSetRepository {
  Future<List<ReportSetSummary>> listForJob(String jobId);

  Future<List<ReportSetSummary>> listByCommonKey(String commonKey);

  Future<ReportSetDetail> getSet(String reportSetId);

  /// 칸 하나 고치기. [reviewId]가 있으면 확인 목록 그 줄을 보정으로 표시.
  Future<ReportReviewRow> updateField({
    required String table,
    required String rowId,
    required String column,
    required String value,
    String reviewId = '',
  });
}
