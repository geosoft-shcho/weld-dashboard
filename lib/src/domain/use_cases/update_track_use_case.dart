import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';

class UpdateTrackUseCase {
  UpdateTrackUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) {
    if (trackId.isEmpty) {
      throw const JobTimelineException(
        '트랙을 찾지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    final trimmed = name?.trim();
    final nextName = trimmed == null || trimmed.isEmpty ? null : trimmed;
    if (nextName == null && order == null && isVisible == null) {
      return Future.value();
    }
    return _repository.updateTrack(
      trackId: trackId,
      name: nextName,
      order: order,
      isVisible: isVisible,
    );
  }
}
