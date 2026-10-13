import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../video_overlay_frame.dart';
import 'multimodal_studio_palette.dart';

bool _posePaintLoggedEmpty = false;
bool _posePaintLoggedMiss = false;
Duration? _posePaintDrawnStart;
String _posePaintFramesToken = '';

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

class VideoFrameMarkLayer extends StatelessWidget {
  const VideoFrameMarkLayer({
    super.key,
    required this.controller,
    required this.frames,
  });

  final VideoPlayerController controller;
  final List<VideoOverlayFrame> frames;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final value = controller.value;
        return IgnorePointer(
          child: CustomPaint(
            painter: _VideoOverlayPainter(
              frames: frames,
              position: value.position,
              videoSize: value.isInitialized ? value.size : Size.zero,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _VideoOverlayPainter extends CustomPainter {
  const _VideoOverlayPainter({
    required this.frames,
    required this.position,
    required this.videoSize,
  });

  static const double _STROKE_WIDTH = 2;
  static const double _POINT_RADIUS = 3;

  final List<VideoOverlayFrame> frames;
  final Duration position;
  final Size videoSize;

  @override
  void paint(Canvas canvas, Size size) {
    final frame = fittedVideoFrame(videoSize, size);
    if (frame.isEmpty) {
      _logPosePaint(drawn: null, view: Size.zero);
      return;
    }
    canvas.save();
    canvas.clipRect(frame);
    VideoOverlayFrame? drawn;
    for (final overlay in frames) {
      if (!overlay.contains(position)) {
        continue;
      }
      drawn = overlay;
      _paintBoxes(canvas, frame, overlay.boxes);
      _paintBones(canvas, frame, overlay);
      _paintPoints(canvas, frame, overlay.points);
    }
    canvas.restore();
    _logPosePaint(drawn: drawn, view: frame.size);
  }

  void _logPosePaint({
    required VideoOverlayFrame? drawn,
    required Size view,
  }) {
    if (!kDebugMode || frames.isEmpty) {
      return;
    }
    final token =
        '${frames.length}:${frames.first.start.inMilliseconds}:'
        '${frames.last.end.inMilliseconds}';
    if (token != _posePaintFramesToken) {
      _posePaintFramesToken = token;
      _posePaintLoggedEmpty = false;
      _posePaintLoggedMiss = false;
      _posePaintDrawnStart = null;
    }
    if (view == Size.zero) {
      if (_posePaintLoggedEmpty) {
        return;
      }
      _posePaintLoggedEmpty = true;
      debugPrint(
        '[POSE] paint skipped: video frame is empty '
        'video=${videoSize.width}x${videoSize.height} '
        'frames=${frames.length}',
      );
      return;
    }
    if (drawn == null) {
      if (_posePaintLoggedMiss) {
        return;
      }
      _posePaintLoggedMiss = true;
      final first = frames.first;
      debugPrint(
        '[POSE] paint missed: position=${position.inMilliseconds}ms '
        'frames=${frames.length} '
        'first=${first.start.inMilliseconds}-${first.end.inMilliseconds}ms '
        'view=${view.width.round()}x${view.height.round()}',
      );
      return;
    }
    if (_posePaintDrawnStart == drawn.start) {
      return;
    }
    _posePaintLoggedMiss = false;
    _posePaintDrawnStart = drawn.start;
    final linked = _linkedBones(drawn);
    debugPrint(
      '[POSE] paint: position=${position.inMilliseconds}ms '
      'window=${drawn.start.inMilliseconds}-${drawn.end.inMilliseconds}ms '
      'boxes=${drawn.boxes.length} points=${drawn.points.length} '
      'bones=${linked.drawn}/${drawn.bones.length} skipped=${linked.skipped} '
      'view=${view.width.round()}x${view.height.round()}',
    );
  }

  ({int drawn, int skipped}) _linkedBones(VideoOverlayFrame overlay) {
    var drawn = 0;
    var skipped = 0;
    for (final bone in overlay.bones) {
      final start = _pointAt(overlay.points, bone.startIndex);
      final end = _pointAt(overlay.points, bone.endIndex);
      if (start == null || end == null) {
        skipped += 1;
      } else {
        drawn += 1;
      }
    }
    return (drawn: drawn, skipped: skipped);
  }

  @override
  bool shouldRepaint(covariant _VideoOverlayPainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.videoSize != videoSize ||
        oldDelegate.frames != frames;
  }

  void _paintBoxes(Canvas canvas, Rect frame, List<VideoOverlayBox> boxes) {
    final paint = Paint()
      ..color = MultimodalStudioPalette.GRAPE_500
      ..style = PaintingStyle.stroke
      ..strokeWidth = _STROKE_WIDTH;
    for (final box in boxes) {
      canvas.drawRect(
        Rect.fromLTWH(
          frame.left + box.left * frame.width,
          frame.top + box.top * frame.height,
          box.width * frame.width,
          box.height * frame.height,
        ),
        paint,
      );
    }
  }

  void _paintBones(Canvas canvas, Rect frame, VideoOverlayFrame overlay) {
    final paint = Paint()
      ..color = MultimodalStudioPalette.KALE_300
      ..strokeWidth = _STROKE_WIDTH
      ..strokeCap = StrokeCap.round;
    for (final bone in overlay.bones) {
      final start = _pointAt(overlay.points, bone.startIndex);
      final end = _pointAt(overlay.points, bone.endIndex);
      if (start == null || end == null) {
        continue;
      }
      canvas.drawLine(_offset(frame, start), _offset(frame, end), paint);
    }
  }

  void _paintPoints(Canvas canvas, Rect frame, List<VideoOverlayPoint> points) {
    final paint = Paint()..color = MultimodalStudioPalette.KALE_300;
    for (final point in points) {
      canvas.drawCircle(_offset(frame, point), _POINT_RADIUS, paint);
    }
  }

  Offset _offset(Rect frame, VideoOverlayPoint point) {
    return Offset(
      frame.left + point.x * frame.width,
      frame.top + point.y * frame.height,
    );
  }

  VideoOverlayPoint? _pointAt(List<VideoOverlayPoint> points, int index) {
    if (index < 0 || index >= points.length) {
      return null;
    }
    return points[index];
  }
}
