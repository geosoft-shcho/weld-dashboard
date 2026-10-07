import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class GetJobTimelineUseCase {
  GetJobTimelineUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<JobTimeline> execute({required String jobId}) {
    if (jobId.isEmpty) {
      return Future.value(JobTimeline.empty);
    }
    return _repository.getTimeline(jobId: jobId);
  }
}
