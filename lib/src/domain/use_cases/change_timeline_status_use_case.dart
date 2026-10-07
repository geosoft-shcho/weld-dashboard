import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class ChangeTimelineStatusUseCase {
  ChangeTimelineStatusUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) {
    if (jobId.isEmpty) {
      throw const JobTimelineException(
        '작업을 찾지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (fromStatus == toStatus) {
      return Future.value();
    }
    return _repository.changeTimelineStatus(
      jobId: jobId,
      fromStatus: fromStatus,
      toStatus: toStatus,
    );
  }
}
