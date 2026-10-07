import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';
import '../timeline_time.dart';

class UpdateClipUseCase {
  UpdateClipUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) {
    if (clipId.isEmpty) {
      throw const JobTimelineException(
        '클립을 찾지 못했습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (startNs != null &&
        endNs != null &&
        !isOpenNanosecondInterval(startNs, endNs)) {
      throw const JobTimelineException(
        '구간이 너무 짧습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    final hasChange =
        trackId != null ||
        startNs != null ||
        endNs != null ||
        assetId != null ||
        labelValueId != null ||
        description != null ||
        isReviewed != null;
    if (!hasChange) {
      return Future.value();
    }
    return _repository.updateClip(
      clipId: clipId,
      trackId: trackId,
      startNs: startNs,
      endNs: endNs,
      assetId: assetId,
      labelValueId: labelValueId,
      description: description,
      isReviewed: isReviewed,
    );
  }
}
