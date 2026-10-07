import '../entities/quality_result_report.dart';
import '../repositories/quality_result_repository.dart';

class ListQualityResultsUseCase {
  ListQualityResultsUseCase(this._repository);

  final QualityResultRepository _repository;

  Future<List<QualityResultReport>> execute({required String jobId}) {
    return _repository.listForJob(jobId);
  }
}
