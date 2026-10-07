const _NS_PER_MS = 1000000;

class PassVideoSpan {
  const PassVideoSpan({
    required this.assetId,
    required this.recordedAt,
    required this.durationNs,
  });

  final String assetId;
  final DateTime recordedAt;
  final int durationNs;
}

class PassVideoSeek {
  const PassVideoSeek({required this.assetId, required this.seekMs});

  final String assetId;
  final int seekMs;
}

/// 패스 시작 기준 시각이 들어가는 영상을 고르고, 그 파일 안의 밀리초를 돌려준다.
///
/// 구간은 [recordedAt, recordedAt + duration) 이다. 보고 있는 영상이 그 시각을
/// 포함하면 그 영상을 유지하고, 아니면 구간 시작이 가장 이른 영상을 고른다.
PassVideoSeek? resolvePassVideoSeek({
  required int passOffsetNs,
  required DateTime passStartedAt,
  required String focusedAssetId,
  required List<PassVideoSpan> videos,
}) {
  final tapMs = passOffsetNs < 0 ? 0 : passOffsetNs ~/ _NS_PER_MS;
  PassVideoSpan? focused;
  PassVideoSpan? earliest;
  var earliestStartMs = 0;
  for (final video in videos) {
    if (video.assetId.isEmpty || video.durationNs <= 0) {
      continue;
    }
    final startMs = video.recordedAt.difference(passStartedAt).inMilliseconds;
    final endMs = startMs + video.durationNs ~/ _NS_PER_MS;
    final isInside = tapMs >= startMs && tapMs < endMs;
    if (!isInside) {
      continue;
    }
    if (video.assetId == focusedAssetId) {
      focused = video;
    }
    if (earliest == null || startMs < earliestStartMs) {
      earliest = video;
      earliestStartMs = startMs;
    }
  }
  final chosen = focused ?? earliest;
  if (chosen == null) {
    return null;
  }
  final startMs = chosen.recordedAt.difference(passStartedAt).inMilliseconds;
  final seekMs = tapMs - startMs;
  return PassVideoSeek(
    assetId: chosen.assetId,
    seekMs: seekMs < 0 ? 0 : seekMs,
  );
}
