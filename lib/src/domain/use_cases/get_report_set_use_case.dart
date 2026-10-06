import '../entities/report_set.dart';
import '../repositories/report_set_repository.dart';

class GetReportSetUseCase {
  GetReportSetUseCase(this._repository);

  final ReportSetRepository _repository;

  Future<ReportSetDetail> execute({required String reportSetId}) {
    return _repository.getSet(reportSetId);
  }
}
