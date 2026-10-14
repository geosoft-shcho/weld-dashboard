import '../clip_file_position.dart';
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
    String fromClipId = '',
    String toClipId = '',
    String sourceStartNs = '',
    String sourceEndNs = '',
    String sourceLimitNs = '',
  }) {
    if (trackId.isEmpty || !isOpenNanosecondInterval(startNs, endNs)) {
      throw const JobTimelineException(
        '클립 구간이 올바르지 않습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (kind == TimelineClipKind.unspecified) {
      throw const JobTimelineException(
        '클립 구간이 올바르지 않습니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (kind == TimelineClipKind.tag && labelValueId.isEmpty) {
      throw const JobTimelineException(
        '태그 클립에는 라벨이 필요합니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    if (kind == TimelineClipKind.relation &&
        (fromClipId.isEmpty || toClipId.isEmpty || fromClipId == toClipId)) {
      throw const JobTimelineException(
        '관계 클립에는 서로 다른 두 클립이 필요합니다.',
        failure: JobTimelineFailure.invalidArgument,
      );
    }
    final hasSourceStart = sourceStartNs.isNotEmpty;
    final hasSourceEnd = sourceEndNs.isNotEmpty;
    if (hasSourceStart != hasSourceEnd ||
        (hasSourceStart &&
            !sourceIntervalFitsAsset(
              sourceStartNs: sourceStartNs,
              sourceEndNs: sourceEndNs,
              assetDurationNs: sourceLimitNs,
            ))) {
      throw const JobTimelineException(
        '소스 구간이 올바르지 않습니다.',
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
      fromClipId: fromClipId,
      toClipId: toClipId,
      sourceStartNs: sourceStartNs,
      sourceEndNs: sourceEndNs,
    );
  }
}
