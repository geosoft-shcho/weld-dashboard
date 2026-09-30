import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../video_frame_mark.dart';
import 'multimodal_studio_palette.dart';
import 'video_box_editor.dart';
import 'video_skeleton_editor.dart';

Rect fittedVideoFrame(Size video, Size view) {
  if (video.width <= 0 ||
      video.height <= 0 ||
      view.width <= 0 ||
      view.height <= 0) {
    return Rect.zero;
  }
  final fitted = applyBoxFit(BoxFit.contain, video, view);
  final width = fitted.destination.width;
  final height = fitted.destination.height;
  return Rect.fromLTWH(
    (view.width - width) / 2,
    (view.height - height) / 2,
    width,
    height,
  );
}

class VideoFrameMarkLayer extends StatefulWidget {
  const VideoFrameMarkLayer({
    super.key,
    required this.controller,
    required this.marks,
    required this.selection,
    required this.onSelect,
    required this.onCommitBox,
    required this.onCommitSkeleton,
  });

  final VideoPlayerController controller;
  final List<VideoFrameMark> marks;
  final VideoMarkSelection? selection;
  final ValueChanged<VideoMarkSelection> onSelect;
  final void Function(
    int markIndex,
    double left,
    double top,
    double width,
    double height,
  )
  onCommitBox;
  final void Function(int markIndex, List<VideoFramePoint> points)
  onCommitSkeleton;

  @override
  State<VideoFrameMarkLayer> createState() => _VideoFrameMarkLayerState();
}

class _SkeletonGesture {
  const _SkeletonGesture({
    required this.markIndex,
    required this.pointIndex,
    required this.boneStartIndex,
    required this.boneEndIndex,
    required this.origin,
    required this.start,
  });

  final int markIndex;
  final int? pointIndex;
  final int? boneStartIndex;
  final int? boneEndIndex;
  final List<VideoFramePoint> origin;
  final Offset start;
}

class _VideoFrameMarkLayerState extends State<VideoFrameMarkLayer> {
  _SkeletonGesture? _gesture;
  List<VideoFramePoint>? _preview;
  Rect _frame = Rect.zero;

  List<VideoFramePoint> _pointsFor(int index, VideoSkeletonMark mark) {
    if (_gesture?.markIndex == index && _preview != null) {
      return _preview!;
    }
    return mark.points;
  }

  void _beginPointDrag(
    int markIndex,
    int pointIndex,
    Offset start,
    List<VideoFramePoint> origin,
  ) {
    if (!_isPointSelected(markIndex, pointIndex) || _gesture != null) {
      return;
    }
    _gesture = _SkeletonGesture(
      markIndex: markIndex,
      pointIndex: pointIndex,
      boneStartIndex: null,
      boneEndIndex: null,
      origin: origin,
      start: start,
    );
  }

  void _beginBoneDrag(
    int markIndex,
    int boneIndex,
    int startIndex,
    int endIndex,
    Offset start,
    List<VideoFramePoint> origin,
  ) {
    if (!_isBoneSelected(markIndex, boneIndex) || _gesture != null) {
      return;
    }
    _gesture = _SkeletonGesture(
      markIndex: markIndex,
      pointIndex: null,
      boneStartIndex: startIndex,
      boneEndIndex: endIndex,
      origin: origin,
      start: start,
    );
  }

  void _updateDrag(Offset position) {
    final gesture = _gesture;
    if (gesture == null || _frame.width <= 0 || _frame.height <= 0) {
      return;
    }
    final dx = (position.dx - gesture.start.dx) / _frame.width;
    final dy = (position.dy - gesture.start.dy) / _frame.height;
    final points = gesture.pointIndex != null
        ? moveSkeletonPoint(
            points: gesture.origin,
            pointIndex: gesture.pointIndex!,
            dx: dx,
            dy: dy,
          )
        : moveSkeletonBone(
            points: gesture.origin,
            startIndex: gesture.boneStartIndex!,
            endIndex: gesture.boneEndIndex!,
            dx: dx,
            dy: dy,
          );
    setState(() => _preview = points);
  }

  void _endDrag() {
    final gesture = _gesture;
    final preview = _preview;
    if (gesture == null) {
      return;
    }
    _gesture = null;
    _preview = null;
    if (preview == null) {
      return;
    }
    widget.onCommitSkeleton(gesture.markIndex, preview);
  }

  bool _isPointSelected(int markIndex, int pointIndex) {
    final selection = widget.selection;
    return selection is VideoPointSelection &&
        selection.markIndex == markIndex &&
        selection.pointIndex == pointIndex;
  }

  bool _isBoneSelected(int markIndex, int boneIndex) {
    final selection = widget.selection;
    return selection is VideoBoneSelection &&
        selection.markIndex == markIndex &&
        selection.boneIndex == boneIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final value = widget.controller.value;
        final videoSize = value.isInitialized ? value.size : Size.zero;
        return LayoutBuilder(
          builder: (context, constraints) {
            final frame = fittedVideoFrame(videoSize, constraints.biggest);
            _frame = frame;
            final visible = selectMarksAt(widget.marks, value.position);
            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                IgnorePointer(
                  child: CustomPaint(
                    painter: _VideoFrameMarkPainter(
                      marks: widget.marks,
                      position: value.position,
                      videoSize: videoSize,
                      previewMarkIndex: _gesture?.markIndex,
                      previewPoints: _preview,
                      selection: widget.selection,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                if (!frame.isEmpty)
                  for (var index = 0; index < widget.marks.length; index++)
                    if (widget.marks[index] is VideoSkeletonMark &&
                        visible.contains(widget.marks[index]))
                      ..._boneTargets(
                        index,
                        widget.marks[index] as VideoSkeletonMark,
                        frame,
                      ),
                if (!frame.isEmpty)
                  for (var index = 0; index < widget.marks.length; index++)
                    if (widget.marks[index] is VideoBoxMark &&
                        visible.contains(widget.marks[index]))
                      VideoBoxEditor(
                        key: ValueKey('box-$index'),
                        mark: widget.marks[index] as VideoBoxMark,
                        frame: frame,
                        isSelected:
                            widget.selection is VideoBoxSelection &&
                            (widget.selection as VideoBoxSelection).markIndex ==
                                index,
                        onPointerDown: () =>
                            widget.onSelect(VideoBoxSelection(index)),
                        onCommit: (left, top, width, height) {
                          widget.onCommitBox(index, left, top, width, height);
                        },
                      ),
                if (!frame.isEmpty)
                  for (var index = 0; index < widget.marks.length; index++)
                    if (widget.marks[index] is VideoSkeletonMark &&
                        visible.contains(widget.marks[index]))
                      ..._joints(
                        index,
                        widget.marks[index] as VideoSkeletonMark,
                        frame,
                      ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _boneTargets(int markIndex, VideoSkeletonMark mark, Rect frame) {
    final points = _pointsFor(markIndex, mark);
    return [
      for (var boneIndex = 0; boneIndex < mark.bones.length; boneIndex++)
        if (_offsetAt(points, mark.bones[boneIndex].startIndex, frame)
            case final start?)
          if (_offsetAt(points, mark.bones[boneIndex].endIndex, frame)
              case final end?)
            Positioned.fill(
              child: VideoBoneTarget(
                key: ValueKey('bone-$markIndex-$boneIndex'),
                start: start,
                end: end,
                isSelected: _isBoneSelected(markIndex, boneIndex),
                onSelect: () =>
                    widget.onSelect(VideoBoneSelection(markIndex, boneIndex)),
                onDragStart: (position) => _beginBoneDrag(
                  markIndex,
                  boneIndex,
                  mark.bones[boneIndex].startIndex,
                  mark.bones[boneIndex].endIndex,
                  position,
                  points,
                ),
                onDragUpdate: _updateDrag,
                onDragEnd: _endDrag,
              ),
            ),
    ];
  }

  List<Widget> _joints(int markIndex, VideoSkeletonMark mark, Rect frame) {
    final points = _pointsFor(markIndex, mark);
    return [
      for (var pointIndex = 0; pointIndex < points.length; pointIndex++)
        Positioned(
          left:
              frame.left +
              points[pointIndex].x * frame.width -
              VideoJointHandle.RADIUS,
          top:
              frame.top +
              points[pointIndex].y * frame.height -
              VideoJointHandle.RADIUS,
          width: VideoJointHandle.RADIUS * 2,
          height: VideoJointHandle.RADIUS * 2,
          child: VideoJointHandle(
            key: ValueKey('joint-$markIndex-$pointIndex'),
            isSelected: _isPointSelected(markIndex, pointIndex),
            onSelect: () =>
                widget.onSelect(VideoPointSelection(markIndex, pointIndex)),
            onDragStart: (position) =>
                _beginPointDrag(markIndex, pointIndex, position, points),
            onDragUpdate: _updateDrag,
            onDragEnd: _endDrag,
          ),
        ),
    ];
  }

  Offset? _offsetAt(List<VideoFramePoint> points, int index, Rect frame) {
    if (index < 0 || index >= points.length) {
      return null;
    }
    final point = points[index];
    return Offset(
      frame.left + point.x * frame.width,
      frame.top + point.y * frame.height,
    );
  }
}

class _VideoFrameMarkPainter extends CustomPainter {
  const _VideoFrameMarkPainter({
    required this.marks,
    required this.position,
    required this.videoSize,
    required this.previewMarkIndex,
    required this.previewPoints,
    required this.selection,
  });

  static const double _STROKE_WIDTH = 2;
  static const double _SELECTED_STROKE_WIDTH = 4;
  static const double _LABEL_SIZE = 12;

  final List<VideoFrameMark> marks;
  final Duration position;
  final Size videoSize;
  final int? previewMarkIndex;
  final List<VideoFramePoint>? previewPoints;
  final VideoMarkSelection? selection;

  @override
  void paint(Canvas canvas, Size size) {
    final frame = fittedVideoFrame(videoSize, size);
    if (frame.isEmpty) {
      return;
    }
    canvas.save();
    canvas.clipRect(frame);
    for (var index = 0; index < marks.length; index++) {
      final mark = marks[index];
      if (mark is! VideoSkeletonMark || !mark.contains(position)) {
        continue;
      }
      final points = index == previewMarkIndex && previewPoints != null
          ? previewPoints!
          : mark.points;
      _paintBones(canvas, frame, mark, points, index);
      _paintName(canvas, frame, mark, points);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _VideoFrameMarkPainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.videoSize != videoSize ||
        oldDelegate.marks != marks ||
        oldDelegate.previewMarkIndex != previewMarkIndex ||
        oldDelegate.previewPoints != previewPoints ||
        oldDelegate.selection != selection;
  }

  Offset _point(Rect frame, double x, double y) {
    return Offset(frame.left + x * frame.width, frame.top + y * frame.height);
  }

  void _paintBones(
    Canvas canvas,
    Rect frame,
    VideoSkeletonMark mark,
    List<VideoFramePoint> points,
    int markIndex,
  ) {
    final paint = Paint()
      ..color = MultimodalStudioPalette.KALE_300
      ..strokeCap = StrokeCap.round;
    for (var boneIndex = 0; boneIndex < mark.bones.length; boneIndex++) {
      final bone = mark.bones[boneIndex];
      final start = _pointAt(points, bone.startIndex);
      final end = _pointAt(points, bone.endIndex);
      if (start == null || end == null) {
        continue;
      }
      final current = selection;
      final selected =
          current is VideoBoneSelection &&
          current.markIndex == markIndex &&
          current.boneIndex == boneIndex;
      paint.strokeWidth = selected ? _SELECTED_STROKE_WIDTH : _STROKE_WIDTH;
      canvas.drawLine(
        _point(frame, start.x, start.y),
        _point(frame, end.x, end.y),
        paint,
      );
    }
  }

  void _paintName(
    Canvas canvas,
    Rect frame,
    VideoSkeletonMark mark,
    List<VideoFramePoint> points,
  ) {
    final anchor = points.isEmpty
        ? frame.topLeft
        : _point(frame, points.first.x, points.first.y);
    final origin = _labelOrigin(anchor, frame, mark.name);
    _paintLabel(
      canvas,
      mark.name,
      origin + const Offset(1, 1),
      MultimodalStudioPalette.SAND_0,
    );
    _paintLabel(canvas, mark.name, origin, MultimodalStudioPalette.SAND_900);
  }

  Offset _labelOrigin(Offset anchor, Rect frame, String name) {
    final label = _labelPainter(name, MultimodalStudioPalette.SAND_900);
    var dx = anchor.dx;
    var dy = anchor.dy - label.height - 4;
    if (dy < frame.top) {
      dy = frame.top;
    }
    if (dx + label.width > frame.right) {
      dx = frame.right - label.width;
    }
    if (dx < frame.left) {
      dx = frame.left;
    }
    return Offset(dx, dy);
  }

  void _paintLabel(Canvas canvas, String name, Offset origin, Color color) {
    _labelPainter(name, color).paint(canvas, origin);
  }

  TextPainter _labelPainter(String name, Color color) {
    return TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
          color: color,
          fontSize: _LABEL_SIZE,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  VideoFramePoint? _pointAt(List<VideoFramePoint> points, int index) {
    if (index < 0 || index >= points.length) {
      return null;
    }
    return points[index];
  }
}
