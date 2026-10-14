import 'package:flutter/material.dart';

import '../../../../domain/entities/job_timeline.dart';
import '../../../../domain/timeline_time.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';

class TimelineBoardRow {
  const TimelineBoardRow({
    required this.laneKey,
    required this.label,
    required this.labelColor,
    required this.showsAiBadge,
    required this.clips,
  });

  final String laneKey;
  final String label;
  final Color labelColor;
  final bool showsAiBadge;
  final List<TimelineBoardClip> clips;
}

class TimelineBoardClip {
  const TimelineBoardClip({
    required this.clipId,
    required this.attachmentId,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.background,
    required this.foreground,
    required this.border,
    this.showsPoseDots = false,
    this.hasLabel = false,
  });

  final String clipId;
  final String attachmentId;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final Color background;
  final Color foreground;
  final Color border;
  final bool showsPoseDots;
  final bool hasLabel;
}

/// 클립 또는 막대 식별자
String rangeIdOf(TimelineBoardClip clip) {
  if (clip.clipId.isNotEmpty) {
    return clip.clipId;
  }
  return clip.attachmentId;
}

/// 행이 목록 화면 밖에 있으면 그 행의 위쪽이 보이도록 옮길 스크롤 위치.
double? revealOffsetForObjectRow({
  required int rowIndex,
  required double rowExtent,
  required double pixels,
  required double viewport,
  required double maxScrollExtent,
}) {
  if (rowIndex < 0 || rowExtent <= 0 || viewport <= 0) {
    return null;
  }
  final top = rowIndex * rowExtent;
  final bottom = top + rowExtent;
  if (top >= pixels && bottom <= pixels + viewport) {
    return null;
  }
  return top.clamp(0.0, maxScrollExtent);
}

/// 레인 생성
List<TimelineBoardRow> buildTimelineBoardRows(
  VideoMultimodalViewModel viewModel,
) {
  final rows = <TimelineBoardRow>[];
  for (final track in viewModel.timelineTracks) {
    if (!viewModel.isLaneVisible(track.trackId)) {
      continue;
    }
    final clips = track.clips;
    rows.add(
      TimelineBoardRow(
        laneKey: track.trackId,
        label: track.name.trim().isEmpty ? '트랙' : track.name.trim(),
        labelColor: MultimodalStudioPalette.SAND_700,
        showsAiBadge: clips.any((clip) => clip.showsToolMark),
        clips: [
          for (final clip in clips)
            TimelineBoardClip(
              clipId: clip.clipId,
              attachmentId: '',
              text: viewModel.clipCaption(clip),
              startSeconds: secondsFromNanoseconds(clip.startNanoseconds),
              endSeconds: secondsFromNanoseconds(clip.endNanoseconds),
              background: clip.labelValueId.isEmpty
                  ? timelineKindBackground(clip.kind)
                  : MultimodalStudioPalette.PLUM_100,
              foreground: clip.labelValueId.isEmpty
                  ? timelineKindForeground(clip.kind)
                  : MultimodalStudioPalette.PLUM_400,
              border: clip.labelValueId.isEmpty
                  ? Colors.transparent
                  : MultimodalStudioPalette.PLUM_500,
              showsPoseDots: clip.kind == TimelineClipKind.pose,
              hasLabel: clip.labelValueId.isNotEmpty,
            ),
        ],
      ),
    );
  }
  return rows;
}

Color timelineKindBackground(TimelineClipKind kind) {
  switch (kind) {
    case TimelineClipKind.video:
      return MultimodalStudioPalette.GRAPE_100;
    case TimelineClipKind.audio:
    case TimelineClipKind.subtitle:
      return MultimodalStudioPalette.KALE_0;
    case TimelineClipKind.pose:
      return MultimodalStudioPalette.GRAPE_0;
    case TimelineClipKind.tag:
    case TimelineClipKind.region:
    case TimelineClipKind.relation:
      return MultimodalStudioPalette.PLUM_100;
    case TimelineClipKind.image:
    case TimelineClipKind.pdf:
    case TimelineClipKind.file:
      return MultimodalStudioPalette.PERSIMMON_0;
    case TimelineClipKind.timeseries:
    case TimelineClipKind.pointCloud:
    case TimelineClipKind.unspecified:
      return MultimodalStudioPalette.SAND_200;
  }
}

Color timelineKindForeground(TimelineClipKind kind) {
  switch (kind) {
    case TimelineClipKind.video:
    case TimelineClipKind.pose:
      return MultimodalStudioPalette.GRAPE_400;
    case TimelineClipKind.audio:
    case TimelineClipKind.subtitle:
      return MultimodalStudioPalette.KALE_300;
    case TimelineClipKind.tag:
    case TimelineClipKind.region:
    case TimelineClipKind.relation:
      return MultimodalStudioPalette.PLUM_400;
    case TimelineClipKind.image:
    case TimelineClipKind.pdf:
    case TimelineClipKind.file:
      return MultimodalStudioPalette.PERSIMMON_300;
    case TimelineClipKind.timeseries:
    case TimelineClipKind.pointCloud:
    case TimelineClipKind.unspecified:
      return MultimodalStudioPalette.SAND_900;
  }
}

/// 이동과 리사이즈 계산
class TimelineClipEdit {
  const TimelineClipEdit({
    required this.clipId,
    required this.isBar,
    required this.startSeconds,
    required this.endSeconds,
  });

  final String clipId;
  final bool isBar;
  final double startSeconds;
  final double endSeconds;

  double get length => endSeconds - startSeconds;

  TimelineClipEdit move(double deltaSeconds, double span) {
    final duration = length;
    var start = startSeconds + deltaSeconds;
    if (start < 0) {
      start = 0;
    }
    if (start + duration > span) {
      start = (span - duration).clamp(0.0, span).toDouble();
    }
    return TimelineClipEdit(
      clipId: clipId,
      isBar: isBar,
      startSeconds: start,
      endSeconds: start + duration,
    );
  }

  TimelineClipEdit resizeLeading(double deltaSeconds) {
    final next = (startSeconds + deltaSeconds).clamp(
      0.0,
      endSeconds - VideoMultimodalViewModel.MIN_REGION_SECONDS,
    );
    return TimelineClipEdit(
      clipId: clipId,
      isBar: isBar,
      startSeconds: next.toDouble(),
      endSeconds: endSeconds,
    );
  }

  TimelineClipEdit resizeTrailing(double deltaSeconds, double span) {
    final next = (endSeconds + deltaSeconds).clamp(
      startSeconds + VideoMultimodalViewModel.MIN_REGION_SECONDS,
      span,
    );
    return TimelineClipEdit(
      clipId: clipId,
      isBar: isBar,
      startSeconds: startSeconds,
      endSeconds: next.toDouble(),
    );
  }
}

/// 30fps 기준 시:분:초:프레임. 반올림된 프레임의 올림도 반영한다.
String formatTimelineTimecode(double seconds) {
  final totalFrames = (seconds * 30).round();
  final totalSeconds = totalFrames ~/ 30;
  return [
    totalSeconds ~/ 3600,
    (totalSeconds ~/ 60) % 60,
    totalSeconds % 60,
    totalFrames % 30,
  ].map((part) => part.toString().padLeft(2, '0')).join(':');
}

/// 시간 눈금
class TimelineRulerPainter extends CustomPainter {
  const TimelineRulerPainter({
    required this.spanSeconds,
    required this.pixelsPerSecond,
  });

  final double spanSeconds;
  final double pixelsPerSecond;
  static const int TICK_SECONDS = 60;
  static const int LABEL_SECONDS = 300;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = MultimodalStudioPalette.SAND_0,
    );
    final line = Paint()
      ..color = MultimodalStudioPalette.SAND_200
      ..strokeWidth = 1;
    final steps = (spanSeconds / TICK_SECONDS).floor();
    for (var index = 0; index <= steps; index++) {
      final second = index * TICK_SECONDS;
      final x = second * pixelsPerSecond;
      canvas.drawLine(Offset(x, 12), Offset(x, size.height), line);
      if (second % LABEL_SECONDS != 0) {
        continue;
      }
      final label = formatTimelineTimecode(second.toDouble());
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: MultimodalStudioPalette.SAND_600,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x + 3, 0));
      painter.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant TimelineRulerPainter oldDelegate) {
    return oldDelegate.spanSeconds != spanSeconds ||
        oldDelegate.pixelsPerSecond != pixelsPerSecond;
  }
}
