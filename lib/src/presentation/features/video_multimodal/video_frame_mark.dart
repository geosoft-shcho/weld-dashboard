/// 재생 중인 영상 프레임 위의 박스 또는 스켈레톤.
/// 좌표는 프레임 기준 0~1이고, 시각은 그 파일의 로컬 시각이다.
sealed class VideoFrameMark {
  const VideoFrameMark({
    required this.name,
    required this.start,
    required this.end,
  });

  final String name;
  final Duration start;
  final Duration end;

  bool contains(Duration position) => position >= start && position < end;
}

class VideoBoxMark extends VideoFrameMark {
  const VideoBoxMark({
    required super.name,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required super.start,
    required super.end,
  });

  final double left;
  final double top;
  final double width;
  final double height;
}

class VideoFramePoint {
  const VideoFramePoint({required this.x, required this.y});

  final double x;
  final double y;
}

class VideoSkeletonBone {
  const VideoSkeletonBone({required this.startIndex, required this.endIndex});

  final int startIndex;
  final int endIndex;
}

class VideoSkeletonMark extends VideoFrameMark {
  const VideoSkeletonMark({
    required super.name,
    required this.points,
    required this.bones,
    required super.start,
    required super.end,
  });

  final List<VideoFramePoint> points;
  final List<VideoSkeletonBone> bones;
}

List<VideoFrameMark> selectMarksAt(
  List<VideoFrameMark> marks,
  Duration position,
) {
  return [
    for (final mark in marks)
      if (mark.contains(position)) mark,
  ];
}

sealed class VideoMarkSelection {
  const VideoMarkSelection();
}

class VideoBoxSelection extends VideoMarkSelection {
  const VideoBoxSelection(this.markIndex);

  final int markIndex;

  @override
  bool operator ==(Object other) {
    return other is VideoBoxSelection && other.markIndex == markIndex;
  }

  @override
  int get hashCode => Object.hash(VideoBoxSelection, markIndex);
}

class VideoPointSelection extends VideoMarkSelection {
  const VideoPointSelection(this.markIndex, this.pointIndex);

  final int markIndex;
  final int pointIndex;

  @override
  bool operator ==(Object other) {
    return other is VideoPointSelection &&
        other.markIndex == markIndex &&
        other.pointIndex == pointIndex;
  }

  @override
  int get hashCode => Object.hash(VideoPointSelection, markIndex, pointIndex);
}

class VideoBoneSelection extends VideoMarkSelection {
  const VideoBoneSelection(this.markIndex, this.boneIndex);

  final int markIndex;
  final int boneIndex;

  @override
  bool operator ==(Object other) {
    return other is VideoBoneSelection &&
        other.markIndex == markIndex &&
        other.boneIndex == boneIndex;
  }

  @override
  int get hashCode => Object.hash(VideoBoneSelection, markIndex, boneIndex);
}

VideoFramePoint clampVideoFramePoint(double x, double y) {
  final clampedX = x < 0 ? 0.0 : (x > 1 ? 1.0 : x);
  final clampedY = y < 0 ? 0.0 : (y > 1 ? 1.0 : y);
  return VideoFramePoint(x: clampedX, y: clampedY);
}

List<VideoFramePoint> moveSkeletonPoint({
  required List<VideoFramePoint> points,
  required int pointIndex,
  required double dx,
  required double dy,
}) {
  return [
    for (var index = 0; index < points.length; index++)
      if (index == pointIndex)
        clampVideoFramePoint(points[index].x + dx, points[index].y + dy)
      else
        points[index],
  ];
}

List<VideoFramePoint> moveSkeletonBone({
  required List<VideoFramePoint> points,
  required int startIndex,
  required int endIndex,
  required double dx,
  required double dy,
}) {
  if (startIndex < 0 ||
      endIndex < 0 ||
      startIndex >= points.length ||
      endIndex >= points.length) {
    return points;
  }
  final limitedDx = _deltaInsideUnit(
    points[startIndex].x,
    points[endIndex].x,
    dx,
  );
  final limitedDy = _deltaInsideUnit(
    points[startIndex].y,
    points[endIndex].y,
    dy,
  );
  return [
    for (var index = 0; index < points.length; index++)
      if (index == startIndex || index == endIndex)
        VideoFramePoint(
          x: points[index].x + limitedDx,
          y: points[index].y + limitedDy,
        )
      else
        points[index],
  ];
}

double _deltaInsideUnit(double start, double end, double delta) {
  double fit(double origin, double value) {
    final next = origin + value;
    if (next < 0) {
      return -origin;
    }
    if (next > 1) {
      return 1 - origin;
    }
    return value;
  }

  return fit(end, fit(start, delta));
}
