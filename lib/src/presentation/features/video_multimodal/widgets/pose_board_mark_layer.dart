import 'package:flutter/material.dart';

import 'multimodal_studio_palette.dart';
import 'timeline_board_helpers.dart';

/// 포즈 클립 위 실데이터 막대. Stack children에 spread한다.
List<Widget> buildPoseBoardMarkWidgets({
  required TimelineBoardClip clip,
  required double pixelsPerSecond,
  required void Function(double seconds) seekHandler,
}) {
  final top = 8.0 + clip.laneIndex * TIMELINE_TRACK_LANE_HEIGHT;
  final marks = <Widget>[];
  for (final mark in clip.poseMarks) {
    final left = mark.startSeconds * pixelsPerSecond;
    final durationSeconds = mark.endSeconds - mark.startSeconds;
    var width = durationSeconds * pixelsPerSecond;
    if (width < 2) {
      width = 2;
    }
    final seekSeconds = mark.startSeconds + durationSeconds / 2;
    marks.add(
      Positioned(
        left: left,
        top: top,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => seekHandler(seekSeconds),
          child: SizedBox(
            width: width,
            height: 12,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: MultimodalStudioPalette.GRAPE_400,
              ),
            ),
          ),
        ),
      ),
    );
  }
  return marks;
}
