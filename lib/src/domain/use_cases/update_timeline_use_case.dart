import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class UpdateTimelineUseCase {
  UpdateTimelineUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({
    required String jobId,
    String? name,
    String? description,
  }) {
    if (jobId.isEmpty) {
      throw const JobTimelineException(
        '작업을 열지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (name == null && description == null) {
      return Future.value();
    }
    return _repository.updateTimeline(
      jobId: jobId,
      name: name,
      description: description,
    );
  }
}
