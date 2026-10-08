/// 영상 프레임 위에 그릴 포즈 한 장.
/// 좌표는 프레임 기준 0~1이고, 시각은 재생 중인 영상 파일의 로컬 시각이다.
class VideoOverlayFrame {
  const VideoOverlayFrame({
    required this.start,
    required this.end,
    required this.boxes,
    required this.points,
    required this.bones,
  });

  final Duration start;
  final Duration end;
  final List<VideoOverlayBox> boxes;
  final List<VideoOverlayPoint> points;
  final List<VideoOverlayBone> bones;

  bool contains(Duration position) => position >= start && position < end;
}

class VideoOverlayBox {
  const VideoOverlayBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;
}

class VideoOverlayPoint {
  const VideoOverlayPoint({required this.x, required this.y});

  final double x;
  final double y;
}

class VideoOverlayBone {
  const VideoOverlayBone({required this.startIndex, required this.endIndex});

  final int startIndex;
  final int endIndex;
}
