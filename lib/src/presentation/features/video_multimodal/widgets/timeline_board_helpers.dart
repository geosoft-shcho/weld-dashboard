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

/// 시간 눈금
class TimelineRulerPainter extends CustomPainter {
  const TimelineRulerPainter({
    required this.spanSeconds,
    required this.pixelsPerSecond,
    required this.stepSeconds,
  });

  final double spanSeconds;
  final double pixelsPerSecond;
  final double stepSeconds;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = MultimodalStudioPalette.SAND_0,
    );
    final line = Paint()
      ..color = MultimodalStudioPalette.SAND_200
      ..strokeWidth = 1;
    final steps = stepSeconds <= 0 ? 0 : (spanSeconds / stepSeconds).floor();
    for (var index = 0; index <= steps; index++) {
      final second = index * stepSeconds;
      final x = second * pixelsPerSecond;
      canvas.drawLine(Offset(x, 12), Offset(x, size.height), line);
      final total = second.round();
      final label = '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}';
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
        oldDelegate.pixelsPerSecond != pixelsPerSecond ||
        oldDelegate.stepSeconds != stepSeconds;
  }
}
