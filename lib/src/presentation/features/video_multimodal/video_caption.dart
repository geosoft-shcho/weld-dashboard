/// 텍스트 레이어 한 구간. 시각은 공유 타임라인 기준이다.
class TextLayerSegment {
  const TextLayerSegment({
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
  });

  final String text;
  final double startSeconds;
  final double endSeconds;
}

/// 재생 중인 영상 파일 안의 자막. 시각은 그 파일의 로컬 시각이다.
class VideoCaption {
  const VideoCaption({
    required this.text,
    required this.start,
    required this.end,
  });

  final String text;
  final Duration start;
  final Duration end;

  @override
  bool operator ==(Object other) {
    return other is VideoCaption &&
        other.text == text &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(text, start, end);
}
