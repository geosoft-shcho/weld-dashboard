import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class GetClipUseCase {
  GetClipUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<ClipDetail> execute({required String clipId}) {
    if (clipId.isEmpty) {
      return Future.value(ClipDetail.empty);
    }
    return _repository.getClip(clipId: clipId);
  }
}
