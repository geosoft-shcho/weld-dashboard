import '../../../domain/clip_file_position.dart';
import '../../../domain/entities/job_timeline.dart';
import '../../../domain/timeline_time.dart';

bool doTimelineIntervalsOverlap(
  String firstStartNs,
  String firstEndNs,
  String secondStartNs,
  String secondEndNs,
) {
  final firstStart = secondsFromNanoseconds(firstStartNs);
  final firstEnd = secondsFromNanoseconds(firstEndNs);
  final secondStart = secondsFromNanoseconds(secondStartNs);
  final secondEnd = secondsFromNanoseconds(secondEndNs);
  return firstStart < secondEnd && secondStart < firstEnd;
}

bool doesClipCoverSeconds(TimelineClip clip, double seconds) {
  final start = secondsFromNanoseconds(clip.startNanoseconds);
  final end = secondsFromNanoseconds(clip.endNanoseconds);
  return seconds >= start && seconds < end;
}

int compareTimelineClipId(TimelineClip left, TimelineClip right) {
  final leftId = BigInt.tryParse(left.clipId);
  final rightId = BigInt.tryParse(right.clipId);
  if (leftId != null && rightId != null) {
    return leftId.compareTo(rightId);
  }
  return left.clipId.compareTo(right.clipId);
}

String overlaySeekStartNs(ClipDetail detail, TimelineClip video) {
  final overlaps = doTimelineIntervalsOverlap(
    detail.timelineStartNs,
    detail.timelineEndNs,
    video.startNs,
    video.endNs,
  );
  if (overlaps && detail.timelineStartNs.isNotEmpty) {
    return detail.timelineStartNs;
  }
  return video.startNs;
}

ClipPlaybackInput clipPlaybackInputFrom(TimelineClip clip) {
  return ClipPlaybackInput(
    timelineStartNs: clip.startNs,
    timelineEndNs: clip.endNs,
    sourceStartNs: clip.sourceStartNs,
    sourceEndNs: clip.sourceEndNs,
    assetDurationNs: clip.assetDurationNs,
    assetStartTimeNs: clip.assetStartTimeNs,
  );
}

String timelineClipKindLabel(TimelineClipKind kind) {
  switch (kind) {
    case TimelineClipKind.video:
      return '영상';
    case TimelineClipKind.audio:
      return '음성';
    case TimelineClipKind.image:
      return '이미지';
    case TimelineClipKind.pdf:
      return 'PDF';
    case TimelineClipKind.subtitle:
      return '자막';
    case TimelineClipKind.pose:
      return '포즈';
    case TimelineClipKind.timeseries:
      return '시계열';
    case TimelineClipKind.pointCloud:
      return '포인트클라우드';
    case TimelineClipKind.file:
      return '파일';
    case TimelineClipKind.tag:
      return '태그';
    case TimelineClipKind.region:
      return '영역';
    case TimelineClipKind.relation:
      return '관계';
    case TimelineClipKind.unspecified:
      return '클립';
  }
}

/// 클립 end 중 최대 초. 미디어(영상·음성·assetDur) span 밖에 떨어진 클립은 제외.
double timelineSpanSecondsFromClips(
  Iterable<TimelineClip> clips, {
  double emptySpanSeconds = 60,
}) {
  var mediaEnd = 0.0;
  for (final clip in clips) {
    final resolved = _resolvedClipEndSeconds(clip);
    if (!_isMediaSpanAnchor(clip) || resolved.endSeconds <= mediaEnd) {
      continue;
    }
    mediaEnd = resolved.endSeconds;
  }
  var end = mediaEnd;
  for (final clip in clips) {
    final resolved = _resolvedClipEndSeconds(clip);
    if (mediaEnd > 0 && resolved.startSeconds > mediaEnd + 60) {
      continue;
    }
    if (resolved.endSeconds > end) {
      end = resolved.endSeconds;
    }
  }
  if (end <= 0) {
    return emptySpanSeconds;
  }
  return end;
}

bool doesClipCountTowardTimelineSpan(
  TimelineClip clip, {
  required double mediaEndSeconds,
}) {
  if (mediaEndSeconds <= 0) {
    return true;
  }
  final start = secondsFromNanoseconds(clip.startNanoseconds);
  return start <= mediaEndSeconds + 60;
}

({double startSeconds, double endSeconds, bool repaired})
_resolvedClipEndSeconds(TimelineClip clip) {
  final startSeconds = secondsFromNanoseconds(clip.startNanoseconds);
  var endSeconds = secondsFromNanoseconds(clip.endNanoseconds);
  final assetDur = secondsFromNanoseconds(clip.assetDurationNs);
  var repaired = false;
  if (assetDur > 0 && endSeconds - startSeconds > assetDur * 2 + 60) {
    endSeconds = startSeconds + assetDur;
    repaired = true;
  }
  return (
    startSeconds: startSeconds,
    endSeconds: endSeconds,
    repaired: repaired,
  );
}

bool _isMediaSpanAnchor(TimelineClip clip) {
  if (secondsFromNanoseconds(clip.assetDurationNs) > 0) {
    return true;
  }
  return clip.kind == TimelineClipKind.video ||
      clip.kind == TimelineClipKind.audio;
}
