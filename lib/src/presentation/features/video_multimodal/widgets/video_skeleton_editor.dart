import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'multimodal_studio_palette.dart';

class VideoJointHandle extends StatelessWidget {
  const VideoJointHandle({
    super.key,
    required this.isSelected,
    required this.onSelect,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  static const double RADIUS = 4;

  final bool isSelected;
  final VoidCallback onSelect;
  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) {
        onSelect();
        if (!isSelected) {
          return;
        }
        onDragStart(details.globalPosition);
      },
      onPanUpdate: (details) => onDragUpdate(details.globalPosition),
      onPanEnd: (_) => onDragEnd(),
      onPanCancel: onDragEnd,
      child: MouseRegion(
        cursor: isSelected ? SystemMouseCursors.grab : SystemMouseCursors.click,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: MultimodalStudioPalette.PERSIMMON_300,
            shape: BoxShape.circle,
            border: isSelected
                ? const Border.fromBorderSide(
                    BorderSide(
                      color: MultimodalStudioPalette.SAND_900,
                      width: 1.5,
                    ),
                  )
                : null,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class VideoBoneTarget extends StatelessWidget {
  const VideoBoneTarget({
    super.key,
    required this.start,
    required this.end,
    required this.isSelected,
    required this.onSelect,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  static const double HIT_SLOP = 6;

  final Offset start;
  final Offset end;
  final bool isSelected;
  final VoidCallback onSelect;
  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.deferToChild,
      cursor: isSelected ? SystemMouseCursors.move : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onPanDown: (details) {
          onSelect();
          if (!isSelected) {
            return;
          }
          onDragStart(details.globalPosition);
        },
        onPanUpdate: (details) => onDragUpdate(details.globalPosition),
        onPanEnd: (_) => onDragEnd(),
        onPanCancel: onDragEnd,
        child: _BoneHitArea(start: start, end: end),
      ),
    );
  }
}

class _BoneHitArea extends LeafRenderObjectWidget {
  const _BoneHitArea({required this.start, required this.end});

  final Offset start;
  final Offset end;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBoneHit(start: start, end: end);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderBoneHit renderObject) {
    renderObject
      ..start = start
      ..end = end;
  }
}

class _RenderBoneHit extends RenderBox {
  _RenderBoneHit({required this.start, required this.end});

  Offset start;
  Offset end;

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) {
      return false;
    }
    if (_distance(position) > VideoBoneTarget.HIT_SLOP) {
      return false;
    }
    result.add(BoxHitTestEntry(this, position));
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {}

  double _distance(Offset point) {
    final lengthSquared = (end - start).distanceSquared;
    if (lengthSquared == 0) {
      return (point - start).distance;
    }
    final t =
        (((point.dx - start.dx) * (end.dx - start.dx)) +
            ((point.dy - start.dy) * (end.dy - start.dy))) /
        lengthSquared;
    final clamped = t < 0 ? 0.0 : (t > 1 ? 1.0 : t);
    final projection = Offset(
      start.dx + (end.dx - start.dx) * clamped,
      start.dy + (end.dy - start.dy) * clamped,
    );
    return (point - projection).distance;
  }
}
