import 'clip_file_position.dart';
import 'timeline_time.dart';

/// 타임라인 `T` → 파일 seek(ms). [clip]이 없으면 [fallbackLocalSeconds] 사용.
int fileSeekMillisecondsAt({
  required ClipPlaybackInput? clip,
  required double playheadSeconds,
  required double fallbackLocalSeconds,
}) {
  final position = clip == null
      ? null
      : clipFilePositionAt(clip: clip, playheadSeconds: playheadSeconds);
  final seconds = position?.fileSeconds ?? fallbackLocalSeconds;
  final milliseconds = (seconds * 1000).round();
  return milliseconds < 0 ? 0 : milliseconds;
}

/// `playbackRate = 타임라인 배속 × 클립 배속`.
double playbackRateAt({
  required ClipPlaybackInput? clip,
  required double playheadSeconds,
  required double timelinePlaybackRate,
}) {
  if (clip == null) {
    return timelinePlaybackRate;
  }
  final position = clipFilePositionAt(
    clip: clip,
    playheadSeconds: playheadSeconds,
  );
  final clipRate = position?.rate ?? 1.0;
  return timelinePlaybackRate * clipRate;
}

/// 클립 내용 끝(파일 축 ms). `video.duration` 대신 Asset 축 기준.
int? clipFileContentEndMilliseconds({required ClipPlaybackInput clip}) {
  final endPlayhead = secondsFromNanoseconds(clip.timelineEndNs);
  final position = clipFilePositionAt(
    clip: clip,
    playheadSeconds: endPlayhead > 0 ? endPlayhead - 1e-6 : endPlayhead,
  );
  if (position == null) {
    return null;
  }
  final ms = (position.fileSeconds * 1000).round();
  return ms < 0 ? 0 : ms;
}

bool doesFileDriftBeyond({
  required double fileSeconds,
  required double expectedFileSeconds,
  double thresholdSeconds = 0.1,
}) {
  return (fileSeconds - expectedFileSeconds).abs() > thresholdSeconds;
}
