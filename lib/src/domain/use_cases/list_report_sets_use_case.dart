import '../entities/report_set.dart';
import '../repositories/report_set_repository.dart';

class ListReportSetsUseCase {
  ListReportSetsUseCase(this._repository);

  final ReportSetRepository _repository;

  Future<List<ReportSetSummary>> execute({required String jobId}) {
    return _repository.listForJob(jobId);
  }
}
