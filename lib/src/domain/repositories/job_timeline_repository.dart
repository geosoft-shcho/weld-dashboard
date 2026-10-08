import '../entities/job_timeline.dart';

abstract class JobTimelineRepository {
  Future<JobTimeline> getTimeline({required String jobId});

  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  });

  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  });

  Future<void> deleteTrack({required String trackId});

  Future<void> createClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId,
    String labelValueId,
    String description,
    bool omitsKind,
    List<String> inputClipIds,
  });

  Future<void> updateClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  });

  Future<void> deleteClip({required String clipId});

  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  });

  Future<String> readContent({required String url});
}
