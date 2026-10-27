import '../entities/report_set.dart';
import '../repositories/report_set_repository.dart';

class ListReportSetsUseCase {
  ListReportSetsUseCase(this._repository);

  final ReportSetRepository _repository;

  Future<List<ReportSetSummary>> execute({required String jobId}) {
    return _repository.listForJob(jobId);
  }

  Future<List<ReportSetSummary>> byCommonKey({required String commonKey}) {
    if (commonKey.isEmpty) {
      return Future.value(const []);
    }
    return _repository.listByCommonKey(commonKey);
  }
}
