import '../entities/report_set.dart';
import '../repositories/report_set_repository.dart';

class UpdateReportFieldUseCase {
  const UpdateReportFieldUseCase(this._repository);

  final ReportSetRepository _repository;

  Future<ReportReviewRow> execute({
    required String table,
    required String rowId,
    required String column,
    required String value,
    String reviewId = '',
  }) {
    if (table.isEmpty || rowId.isEmpty || column.isEmpty) {
      throw ArgumentError('표·행·칸이 필요합니다.');
    }
    return _repository.updateField(
      table: table,
      rowId: rowId,
      column: column,
      value: value,
      reviewId: reviewId,
    );
  }
}
