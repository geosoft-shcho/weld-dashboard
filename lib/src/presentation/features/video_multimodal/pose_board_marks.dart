import 'video_overlay_frame.dart';

const int POSE_BOARD_MARK_MAX_COUNT = 100;
const double POSE_BOARD_MARK_MERGE_GAP_SECONDS = 0.05;

/// 포즈 JSON 프레임을 보드 클립 위에 그릴 타임라인 구간.
class PoseBoardMark {
  const PoseBoardMark({
    required this.startSeconds,
    required this.endSeconds,
  });

  final double startSeconds;
  final double endSeconds;
}

/// 파일 로컬 프레임 → 클립 타임라인 초. 인접 구간 병합 후 개수 상한.
List<PoseBoardMark> poseBoardMarksFromFrames({
  required List<VideoOverlayFrame> frames,
  required double clipStartSeconds,
  required double clipEndSeconds,
  int maxMarkCount = POSE_BOARD_MARK_MAX_COUNT,
  double mergeGapSeconds = POSE_BOARD_MARK_MERGE_GAP_SECONDS,
}) {
  if (frames.isEmpty || clipEndSeconds <= clipStartSeconds) {
    return const [];
  }
  final mapped = <({double start, double end})>[];
  for (final frame in frames) {
    final localStart = frame.start.inMicroseconds / 1e6;
    final localEnd = frame.end.inMicroseconds / 1e6;
    final start = (clipStartSeconds + localStart).clamp(
      clipStartSeconds,
      clipEndSeconds,
    );
    final end = (clipStartSeconds + localEnd).clamp(
      clipStartSeconds,
      clipEndSeconds,
    );
    if (end <= start) {
      continue;
    }
    mapped.add((start: start, end: end));
  }
  if (mapped.isEmpty) {
    return const [];
  }
  mapped.sort((left, right) => left.start.compareTo(right.start));
  final merged = <({double start, double end})>[];
  var current = mapped.first;
  for (var index = 1; index < mapped.length; index++) {
    final next = mapped[index];
    if (next.start <= current.end + mergeGapSeconds) {
      current = (
        start: current.start,
        end: next.end > current.end ? next.end : current.end,
      );
      continue;
    }
    merged.add(current);
    current = next;
  }
  merged.add(current);
  if (merged.length <= maxMarkCount) {
    return [
      for (final mark in merged)
        PoseBoardMark(startSeconds: mark.start, endSeconds: mark.end),
    ];
  }
  final step = merged.length / maxMarkCount;
  final sampled = <PoseBoardMark>[];
  for (var index = 0; index < maxMarkCount; index++) {
    final mark = merged[(index * step).floor().clamp(0, merged.length - 1)];
    sampled.add(PoseBoardMark(startSeconds: mark.start, endSeconds: mark.end));
  }
  return sampled;
}
