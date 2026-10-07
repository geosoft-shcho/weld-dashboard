import '../entities/comparison_job_candidate.dart';
import '../repositories/pass_waveform_repository.dart';

class ListComparisonJobsUseCase {
  ListComparisonJobsUseCase(this._repository);

  final PassWaveformRepository _repository;

  Future<ComparisonJobPage> execute({
    required String projectNo,
    required String itemCode,
    required String unitNo,
    required String excludeJobId,
    String pageToken = '',
  }) {
    return _repository.listComparisonJobs(
      projectNo: projectNo,
      itemCode: itemCode,
      unitNo: unitNo,
      excludeJobId: excludeJobId,
      pageToken: pageToken,
    );
  }
}
