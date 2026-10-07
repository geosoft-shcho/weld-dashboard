import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class DeleteClipUseCase {
  DeleteClipUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({required String clipId}) {
    if (clipId.isEmpty) {
      throw const JobTimelineException(
        '클립을 찾지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    return _repository.deleteClip(clipId: clipId);
  }
}
