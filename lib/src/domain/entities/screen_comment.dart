enum ScreenCommentSttKind {
  missing,
  queued,
  running,
  succeeded,
  failed,
  canceled,
}

class ScreenComment {
  const ScreenComment({
    required this.commentId,
    required this.body,
    required this.sttLabel,
    this.sttMessage = '',
    this.playClipId = '',
    this.playheadNs,
    this.videoAssetId = '',
  });

  final String commentId;
  final String body;
  final String sttLabel;
  final String sttMessage;
  final String playClipId;
  final int? playheadNs;
  final String videoAssetId;

  bool get canPlay => playClipId.isNotEmpty || videoAssetId.isNotEmpty;
}

String screenCommentSttLabel(ScreenCommentSttKind kind) {
  switch (kind) {
    case ScreenCommentSttKind.missing:
      return '맡기지 못함';
    case ScreenCommentSttKind.queued:
    case ScreenCommentSttKind.running:
      return '처리 중';
    case ScreenCommentSttKind.succeeded:
      return '완료';
    case ScreenCommentSttKind.failed:
      return '실패';
    case ScreenCommentSttKind.canceled:
      return '취소';
  }
}

/// context에서 재생할 클립과 작업 시간축 시각을 고른다.
/// 클립이 있는 첫 줄을 쓰고, 없으면 클립 번호는 비운다.
({String clipId, int? playheadNs}) screenCommentPlayback(List<Object?> rows) {
  for (final row in rows) {
    if (row is! Map) {
      continue;
    }
    final clipId = _clipId(row['selected']);
    if (clipId.isEmpty) {
      continue;
    }
    return (clipId: clipId, playheadNs: _startNs(row['range']));
  }
  return (clipId: '', playheadNs: null);
}

String _clipId(Object? selected) {
  if (selected is! List) {
    return '';
  }
  for (final item in selected) {
    if (item is! Map) {
      continue;
    }
    final id = _whole(item['clip_id']);
    if (id != null && id != 0) {
      return '$id';
    }
  }
  return '';
}

int? _startNs(Object? range) {
  if (range is! Map) {
    return null;
  }
  final start = _whole(range['start_ns']);
  final end = _whole(range['end_ns']);
  if (start == null || end == null || start > end) {
    return null;
  }
  return start;
}

int? _whole(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.round();
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}
