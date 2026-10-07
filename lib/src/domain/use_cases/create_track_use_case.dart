import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class CreateTrackUseCase {
  CreateTrackUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) {
    final trimmed = name.trim();
    if (jobId.isEmpty || trimmed.isEmpty) {
      throw const JobTimelineException(
        '트랙을 만들 정보가 없습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    return _repository.createTrack(
      jobId: jobId,
      name: trimmed,
      order: order,
      isVisible: isVisible,
    );
  }
}
