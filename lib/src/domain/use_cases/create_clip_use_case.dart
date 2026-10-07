import '../entities/job_timeline.dart';
import '../repositories/job_timeline_repository.dart';
import '../timeline_time.dart';

class CreateClipUseCase {
  CreateClipUseCase(this._repository);

  final JobTimelineRepository _repository;

  Future<void> execute({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    bool omitsKind = false,
    List<String> inputClipIds = const [],
  }) {
    if (trackId.isEmpty || !isOpenNanosecondInterval(startNs, endNs)) {
      throw const JobTimelineException(
        '클립 구간이 올바르지 않습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (!omitsKind && kind == TimelineClipKind.unspecified) {
      throw const JobTimelineException(
        '클립 구간이 올바르지 않습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (!omitsKind && kind == TimelineClipKind.tag && labelValueId.isEmpty) {
      throw const JobTimelineException(
        '태그 클립에는 라벨이 필요합니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    return _repository.createClip(
      trackId: trackId,
      kind: kind,
      startNs: startNs,
      endNs: endNs,
      assetId: assetId,
      labelValueId: labelValueId,
      description: description,
      omitsKind: omitsKind,
      inputClipIds: inputClipIds,
    );
  }
}
