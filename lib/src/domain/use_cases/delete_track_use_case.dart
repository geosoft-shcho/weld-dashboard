import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class DeleteTrackUseCase {
  DeleteTrackUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({required String trackId}) {
    if (trackId.isEmpty) {
      throw const JobTimelineException(
        '트랙을 찾지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    return _repository.deleteTrack(trackId: trackId);
  }
}
