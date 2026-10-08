import '../../../domain/entities/job_timeline.dart';
import '../../../domain/timeline_time.dart';
import 'video_caption.dart';
import 'video_overlay_frame.dart';

List<VideoCaption> captionsOnVideo({
  required double videoStartSeconds,
  required double videoEndSeconds,
  required List<TimelineOverlay> overlays,
  required Map<String, List<VideoCaption>> cuesByAssetId,
}) {
  final captions = <VideoCaption>[];
  for (final overlay in overlays) {
    if (overlay.kind != TimelineOverlayKind.subtitle) {
      continue;
    }
    if (!_overlapsVideo(overlay, videoStartSeconds, videoEndSeconds)) {
      continue;
    }
    final cues = cuesByAssetId[overlay.assetId] ?? const <VideoCaption>[];
    for (final cue in cues) {
      if (!_keepsFileTime(cue.start, overlay)) {
        continue;
      }
      final start = _shift(cue.start, overlay, videoStartSeconds);
      final end = _shift(cue.end, overlay, videoStartSeconds);
      if (end <= start) {
        continue;
      }
      captions.add(VideoCaption(text: cue.text, start: start, end: end));
    }
  }
  return captions;
}

List<VideoOverlayFrame> framesOnVideo({
  required double videoStartSeconds,
  required double videoEndSeconds,
  required List<TimelineOverlay> overlays,
  required Map<String, List<VideoOverlayFrame>> framesByAssetId,
}) {
  final frames = <VideoOverlayFrame>[];
  for (final overlay in overlays) {
    if (overlay.kind != TimelineOverlayKind.pose) {
      continue;
    }
    if (!_overlapsVideo(overlay, videoStartSeconds, videoEndSeconds)) {
      continue;
    }
    final sourceFrames =
        framesByAssetId[overlay.assetId] ?? const <VideoOverlayFrame>[];
    for (final frame in sourceFrames) {
      if (!_keepsFileTime(frame.start, overlay)) {
        continue;
      }
      final start = _shift(frame.start, overlay, videoStartSeconds);
      final end = _shift(frame.end, overlay, videoStartSeconds);
      if (end <= start) {
        continue;
      }
      frames.add(
        VideoOverlayFrame(
          start: start,
          end: end,
          boxes: frame.boxes,
          points: frame.points,
          bones: frame.bones,
        ),
      );
    }
  }
  return frames;
}

bool _overlapsVideo(
  TimelineOverlay overlay,
  double videoStartSeconds,
  double videoEndSeconds,
) {
  final start = secondsFromNanoseconds(overlay.timelineStartNs);
  final end = secondsFromNanoseconds(overlay.timelineEndNs);
  return start < videoEndSeconds && videoStartSeconds < end;
}

bool _keepsFileTime(Duration fileTime, TimelineOverlay overlay) {
  final seconds = fileTime.inMicroseconds / Duration.microsecondsPerSecond;
  if (overlay.sourceStartNs.isNotEmpty &&
      seconds < secondsFromNanoseconds(overlay.sourceStartNs)) {
    return false;
  }
  if (overlay.sourceEndNs.isNotEmpty &&
      seconds >= secondsFromNanoseconds(overlay.sourceEndNs)) {
    return false;
  }
  return true;
}

Duration _shift(
  Duration fileTime,
  TimelineOverlay overlay,
  double videoStartSeconds,
) {
  final fileSeconds = fileTime.inMicroseconds / Duration.microsecondsPerSecond;
  final sourceStart = overlay.sourceStartNs.isEmpty
      ? 0.0
      : secondsFromNanoseconds(overlay.sourceStartNs);
  final local =
      fileSeconds +
      secondsFromNanoseconds(overlay.timelineStartNs) -
      videoStartSeconds -
      sourceStart;
  return Duration(
    microseconds: (local * Duration.microsecondsPerSecond).round(),
  );
}
