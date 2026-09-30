import 'package:flutter/material.dart';

import '../video_frame_mark.dart';
import 'multimodal_studio_palette.dart';

enum VideoBoxEdge {
  left,
  right,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class VideoBoxEditor extends StatefulWidget {
  const VideoBoxEditor({
    super.key,
    required this.mark,
    required this.frame,
    required this.isSelected,
    required this.onPointerDown,
    required this.onCommit,
  });

  final VideoBoxMark mark;
  final Rect frame;
  final bool isSelected;
  final VoidCallback onPointerDown;
  final void Function(double left, double top, double width, double height)
  onCommit;

  @override
  State<VideoBoxEditor> createState() => _VideoBoxEditorState();
}

class _VideoBoxEditorState extends State<VideoBoxEditor> {
  static const double _MIN_FRACTION = 0.02;
  static const double _HANDLE_SIZE = 8;
  static const double _STROKE_WIDTH = 2;

  late double _left;
  late double _top;
  late double _width;
  late double _height;
  _BoxDrag? _drag;

  @override
  void initState() {
    super.initState();
    _syncFromMark();
  }

  @override
  void didUpdateWidget(covariant VideoBoxEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_drag == null) {
      _syncFromMark();
    }
  }

  void _syncFromMark() {
    final frame = widget.frame;
    final mark = widget.mark;
    _left = frame.left + mark.left * frame.width;
    _top = frame.top + mark.top * frame.height;
    _width = mark.width * frame.width;
    _height = mark.height * frame.height;
  }

  void _startDrag(VideoBoxEdge? edge, Offset position) {
    if (!widget.isSelected || _drag != null) {
      return;
    }
    _drag = _BoxDrag(
      edge: edge,
      originLeft: _left,
      originTop: _top,
      originWidth: _width,
      originHeight: _height,
      start: position,
    );
  }

  void _updateDrag(Offset position) {
    final drag = _drag;
    if (drag == null) {
      return;
    }
    final next = _resized(drag, position - drag.start);
    setState(() {
      _left = next.left;
      _top = next.top;
      _width = next.width;
      _height = next.height;
    });
  }

  void _endDrag() {
    final drag = _drag;
    if (drag == null) {
      return;
    }
    _drag = null;
    final frame = widget.frame;
    if (frame.width <= 0 || frame.height <= 0) {
      return;
    }
    widget.onCommit(
      (_left - frame.left) / frame.width,
      (_top - frame.top) / frame.height,
      _width / frame.width,
      _height / frame.height,
    );
  }

  Rect _resized(_BoxDrag drag, Offset delta) {
    var left = drag.originLeft;
    var top = drag.originTop;
    var right = drag.originLeft + drag.originWidth;
    var bottom = drag.originTop + drag.originHeight;
    final edge = drag.edge;
    if (edge == null) {
      left += delta.dx;
      right += delta.dx;
      top += delta.dy;
      bottom += delta.dy;
    } else {
      if (edge == VideoBoxEdge.left ||
          edge == VideoBoxEdge.topLeft ||
          edge == VideoBoxEdge.bottomLeft) {
        left += delta.dx;
      }
      if (edge == VideoBoxEdge.right ||
          edge == VideoBoxEdge.topRight ||
          edge == VideoBoxEdge.bottomRight) {
        right += delta.dx;
      }
      if (edge == VideoBoxEdge.top ||
          edge == VideoBoxEdge.topLeft ||
          edge == VideoBoxEdge.topRight) {
        top += delta.dy;
      }
      if (edge == VideoBoxEdge.bottom ||
          edge == VideoBoxEdge.bottomLeft ||
          edge == VideoBoxEdge.bottomRight) {
        bottom += delta.dy;
      }
    }

    final frame = widget.frame;
    final minWidth = frame.width * _MIN_FRACTION;
    final minHeight = frame.height * _MIN_FRACTION;
    if (right - left < minWidth) {
      if (edge == VideoBoxEdge.left ||
          edge == VideoBoxEdge.topLeft ||
          edge == VideoBoxEdge.bottomLeft) {
        left = right - minWidth;
      } else {
        right = left + minWidth;
      }
    }
    if (bottom - top < minHeight) {
      if (edge == VideoBoxEdge.top ||
          edge == VideoBoxEdge.topLeft ||
          edge == VideoBoxEdge.topRight) {
        top = bottom - minHeight;
      } else {
        bottom = top + minHeight;
      }
    }

    if (edge == null) {
      if (left < frame.left) {
        right += frame.left - left;
        left = frame.left;
      }
      if (top < frame.top) {
        bottom += frame.top - top;
        top = frame.top;
      }
      if (right > frame.right) {
        left -= right - frame.right;
        right = frame.right;
      }
      if (bottom > frame.bottom) {
        top -= bottom - frame.bottom;
        bottom = frame.bottom;
      }
    } else {
      left = left.clamp(frame.left, frame.right - minWidth);
      right = right.clamp(left + minWidth, frame.right);
      top = top.clamp(frame.top, frame.bottom - minHeight);
      bottom = bottom.clamp(top + minHeight, frame.bottom);
    }
    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      width: _width,
      height: _height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: MultimodalStudioPalette.GRAPE_500,
                  width: _STROKE_WIDTH,
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          _label(),
          if (widget.isSelected)
            Positioned.fill(
              child: _BoxTarget(
                edge: null,
                isSelected: true,
                cursor: SystemMouseCursors.move,
                onSelect: widget.onPointerDown,
                onDragStart: _startDrag,
                onDragUpdate: _updateDrag,
                onDragEnd: _endDrag,
              ),
            ),
          _edge(
            VideoBoxEdge.top,
            left: 0,
            right: 0,
            top: -_HANDLE_SIZE / 2,
            height: _HANDLE_SIZE,
          ),
          _edge(
            VideoBoxEdge.bottom,
            left: 0,
            right: 0,
            bottom: -_HANDLE_SIZE / 2,
            height: _HANDLE_SIZE,
          ),
          _edge(
            VideoBoxEdge.left,
            top: 0,
            bottom: 0,
            left: -_HANDLE_SIZE / 2,
            width: _HANDLE_SIZE,
          ),
          _edge(
            VideoBoxEdge.right,
            top: 0,
            bottom: 0,
            right: -_HANDLE_SIZE / 2,
            width: _HANDLE_SIZE,
          ),
          if (widget.isSelected) ...[
            _corner(
              VideoBoxEdge.topLeft,
              left: -_HANDLE_SIZE / 2,
              top: -_HANDLE_SIZE / 2,
            ),
            _corner(
              VideoBoxEdge.topRight,
              right: -_HANDLE_SIZE / 2,
              top: -_HANDLE_SIZE / 2,
            ),
            _corner(
              VideoBoxEdge.bottomLeft,
              left: -_HANDLE_SIZE / 2,
              bottom: -_HANDLE_SIZE / 2,
            ),
            _corner(
              VideoBoxEdge.bottomRight,
              right: -_HANDLE_SIZE / 2,
              bottom: -_HANDLE_SIZE / 2,
            ),
          ],
        ],
      ),
    );
  }

  Widget _label() {
    final above = _top - widget.frame.top >= 16;
    return Positioned(
      left: 0,
      top: above ? -16 : 2,
      child: IgnorePointer(
        child: Text(
          widget.mark.name,
          style: const TextStyle(
            color: MultimodalStudioPalette.SAND_900,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: MultimodalStudioPalette.SAND_0,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _edge(
    VideoBoxEdge edge, {
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: VideoBoxResizeHandle(
        edge: edge,
        isSelected: widget.isSelected,
        onSelect: widget.onPointerDown,
        onDragStart: _startDrag,
        onDragUpdate: _updateDrag,
        onDragEnd: _endDrag,
      ),
    );
  }

  Widget _corner(
    VideoBoxEdge edge, {
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: _HANDLE_SIZE,
      height: _HANDLE_SIZE,
      child: VideoBoxResizeHandle(
        edge: edge,
        isSelected: true,
        onSelect: widget.onPointerDown,
        onDragStart: _startDrag,
        onDragUpdate: _updateDrag,
        onDragEnd: _endDrag,
      ),
    );
  }
}

class VideoBoxResizeHandle extends StatelessWidget {
  const VideoBoxResizeHandle({
    super.key,
    required this.edge,
    required this.isSelected,
    required this.onSelect,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final VideoBoxEdge edge;
  final bool isSelected;
  final VoidCallback onSelect;
  final void Function(VideoBoxEdge edge, Offset position) onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return _BoxTarget(
      edge: edge,
      isSelected: isSelected,
      cursor: _cursor(edge),
      onSelect: onSelect,
      onDragStart: (edge, position) => onDragStart(edge ?? this.edge, position),
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: MultimodalStudioPalette.GRAPE_500,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : const SizedBox.expand(),
    );
  }

  MouseCursor _cursor(VideoBoxEdge edge) {
    return switch (edge) {
      VideoBoxEdge.left ||
      VideoBoxEdge.right => SystemMouseCursors.resizeLeftRight,
      VideoBoxEdge.top ||
      VideoBoxEdge.bottom => SystemMouseCursors.resizeUpDown,
      VideoBoxEdge.topLeft ||
      VideoBoxEdge.bottomRight => SystemMouseCursors.resizeUpLeftDownRight,
      VideoBoxEdge.topRight ||
      VideoBoxEdge.bottomLeft => SystemMouseCursors.resizeUpRightDownLeft,
    };
  }
}

class _BoxTarget extends StatelessWidget {
  const _BoxTarget({
    required this.edge,
    required this.isSelected,
    required this.cursor,
    required this.onSelect,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.child,
  });

  final VideoBoxEdge? edge;
  final bool isSelected;
  final MouseCursor cursor;
  final VoidCallback onSelect;
  final void Function(VideoBoxEdge? edge, Offset position) onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) {
        onSelect();
        if (!isSelected) {
          return;
        }
        onDragStart(edge, details.globalPosition);
      },
      onPanUpdate: (details) => onDragUpdate(details.globalPosition),
      onPanEnd: (_) => onDragEnd(),
      onPanCancel: onDragEnd,
      child: MouseRegion(
        cursor: isSelected ? cursor : SystemMouseCursors.click,
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _BoxDrag {
  const _BoxDrag({
    required this.edge,
    required this.originLeft,
    required this.originTop,
    required this.originWidth,
    required this.originHeight,
    required this.start,
  });

  final VideoBoxEdge? edge;
  final double originLeft;
  final double originTop;
  final double originWidth;
  final double originHeight;
  final Offset start;
}
