enum JobTimelineStatus { unspecified, draft, suggested, confirmed, rejected }

enum TimelineClipKind {
  unspecified,
  video,
  audio,
  image,
  pdf,
  subtitle,
  pose,
  timeseries,
  pointCloud,
  file,
  tag,
  region,
}

class TimelineClip {
  const TimelineClip({
    required this.clipId,
    required this.trackId,
    required this.kind,
    required this.startNs,
    required this.endNs,
    required this.assetId,
    required this.fileName,
    required this.playbackUrl,
    required this.description,
    required this.showsToolBadge,
    this.labelValueId = '',
  });

  final String clipId;
  final String trackId;
  final TimelineClipKind kind;
  final String startNs;
  final String endNs;
  final String assetId;
  final String fileName;
  final String playbackUrl;
  final String description;
  final bool showsToolBadge;
  final String labelValueId;

  String get startNanoseconds => startNs;
  String get endNanoseconds => endNs;
  String get contentUrl => playbackUrl;
  bool get showsToolMark => showsToolBadge;
}

class TimelineTrack {
  const TimelineTrack({
    required this.trackId,
    required this.name,
    required this.order,
    this.isVisible = true,
    required this.clips,
  });

  final String trackId;
  final String name;
  final int order;
  final bool isVisible;
  final List<TimelineClip> clips;
}

class JobTimeline {
  const JobTimeline({
    required this.jobId,
    required this.name,
    required this.tracks,
    this.status = JobTimelineStatus.unspecified,
  });

  static const empty = JobTimeline(jobId: '', name: '', tracks: []);

  final String jobId;
  final String name;
  final JobTimelineStatus status;
  final List<TimelineTrack> tracks;

  List<TimelineClip> get clips => [for (final track in tracks) ...track.clips];
}

enum JobTimelineFailure {
  unknown,
  invalidArgument,
  notFound,
  failedPrecondition,
  aborted,
}

class JobTimelineException implements Exception {
  const JobTimelineException(
    this.message, {
    this.failure = JobTimelineFailure.unknown,
  });

  final String message;
  final JobTimelineFailure failure;

  @override
  String toString() => message;
}
