import 'timeline_time.dart';

/// 타임라인 시각과 파일 시각을 오가는 계산. 길이는 `asset_duration_ns`이고
/// `video.duration`은 쓰지 않는다.
class ClipFilePosition {
  const ClipFilePosition({
    required this.fileSeconds,
    required this.rate,
    required this.showsRate,
  });

  final double fileSeconds;
  final double rate;
  final bool showsRate;

  String get rateLabel => showsRate ? formatClipRateLabel(rate) : '';
}

class ClipPlaybackInput {
  const ClipPlaybackInput({
    required this.timelineStartNs,
    required this.timelineEndNs,
    this.sourceStartNs = '',
    this.sourceEndNs = '',
    this.assetDurationNs = '',
    this.assetStartTimeNs = '',
  });

  final String timelineStartNs;
  final String timelineEndNs;
  final String sourceStartNs;
  final String sourceEndNs;
  final String assetDurationNs;
  final String assetStartTimeNs;
}

ClipFilePosition? clipFilePositionAt({
  required ClipPlaybackInput clip,
  required double playheadSeconds,
}) {
  final window = _sourceWindow(clip);
  if (window == null) {
    return null;
  }
  final assetAxis =
      window.sourceStartSeconds +
      (playheadSeconds - window.timelineStartSeconds) * window.rate;
  return ClipFilePosition(
    fileSeconds: window.fileStartSeconds + assetAxis,
    rate: window.rate,
    showsRate: window.showsRate,
  );
}

double? playheadSecondsFromFilePosition({
  required ClipPlaybackInput clip,
  required double fileSeconds,
}) {
  final window = _sourceWindow(clip);
  if (window == null) {
    return null;
  }
  if (window.rate == 0) {
    return window.timelineStartSeconds;
  }
  final assetAxis = fileSeconds - window.fileStartSeconds;
  return window.timelineStartSeconds +
      (assetAxis - window.sourceStartSeconds) / window.rate;
}

/// `0 ≤ start ≤ end ≤ Asset 길이`. 길이를 모르면 끝은 검사하지 않는다.
bool sourceIntervalFitsAsset({
  required String sourceStartNs,
  required String sourceEndNs,
  required String assetDurationNs,
}) {
  final start = BigInt.tryParse(sourceStartNs);
  final end = BigInt.tryParse(sourceEndNs);
  if (start == null || end == null || start.isNegative || end < start) {
    return false;
  }
  if (assetDurationNs.isEmpty) {
    return true;
  }
  final duration = BigInt.tryParse(assetDurationNs);
  if (duration == null) {
    return false;
  }
  return end <= duration;
}

String formatClipRateLabel(double rate) {
  if (rate.isNaN || rate.isInfinite || (rate - 1).abs() < 1e-6) {
    return '';
  }
  var text = rate.toStringAsFixed(3);
  text = text.replaceFirst(RegExp(r'0+$'), '');
  text = text.replaceFirst(RegExp(r'\.$'), '');
  return 'x$text';
}

class _SourceWindow {
  const _SourceWindow({
    required this.timelineStartSeconds,
    required this.sourceStartSeconds,
    required this.fileStartSeconds,
    required this.rate,
    required this.showsRate,
  });

  final double timelineStartSeconds;
  final double sourceStartSeconds;
  final double fileStartSeconds;
  final double rate;
  final bool showsRate;
}

_SourceWindow? _sourceWindow(ClipPlaybackInput clip) {
  final timelineStart = secondsFromNanoseconds(clip.timelineStartNs);
  final timelineEnd = secondsFromNanoseconds(clip.timelineEndNs);
  final clipLength = timelineEnd - timelineStart;
  if (clipLength <= 0) {
    return null;
  }
  final hasSource =
      clip.sourceStartNs.isNotEmpty && clip.sourceEndNs.isNotEmpty;
  final durationSeconds = clip.assetDurationNs.isEmpty
      ? null
      : secondsFromNanoseconds(clip.assetDurationNs);
  final double sourceStart;
  final double sourceEnd;
  final bool showsRate;
  if (hasSource) {
    sourceStart = secondsFromNanoseconds(clip.sourceStartNs);
    sourceEnd = secondsFromNanoseconds(clip.sourceEndNs);
    showsRate = true;
  } else if (durationSeconds != null && durationSeconds > 0) {
    sourceStart = 0;
    sourceEnd = durationSeconds;
    showsRate = true;
  } else {
    sourceStart = 0;
    sourceEnd = clipLength;
    showsRate = false;
  }
  final sourceLength = sourceEnd - sourceStart;
  final rate = sourceLength <= 0 ? 0.0 : sourceLength / clipLength;
  return _SourceWindow(
    timelineStartSeconds: timelineStart,
    sourceStartSeconds: sourceStart,
    fileStartSeconds: secondsFromNanoseconds(clip.assetStartTimeNs),
    rate: rate,
    showsRate: showsRate && formatClipRateLabel(rate).isNotEmpty,
  );
}
