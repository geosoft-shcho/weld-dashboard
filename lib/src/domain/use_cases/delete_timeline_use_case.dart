import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class DeleteTimelineUseCase {
  DeleteTimelineUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({required String jobId}) {
    if (jobId.isEmpty) {
      throw const JobTimelineException(
        '작업을 열지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    return _repository.deleteTimeline(jobId: jobId);
  }
}
