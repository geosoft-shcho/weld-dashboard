import 'package:flutter/material.dart';

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
  });

  final String clipId;
  final String attachmentId;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final Color background;
  final Color foreground;
  final Color border;
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
  final videos = [
    for (final bar in viewModel.visibleBars)
      if (bar.isVideo) bar,
  ];
  final audios = [
    for (final bar in viewModel.visibleBars)
      if (!bar.isVideo) bar,
  ];
  if (videos.isNotEmpty && viewModel.isLaneVisible('video')) {
    rows.add(
      TimelineBoardRow(
        laneKey: 'video',
        label: '영상',
        labelColor: MultimodalStudioPalette.SAND_700,
        showsAiBadge: false,
        clips: [
          for (final bar in videos)
            TimelineBoardClip(
              clipId: '',
              attachmentId: bar.attachmentId,
              text: bar.fileName,
              startSeconds: bar.startSeconds,
              endSeconds: bar.endSeconds,
              background: MultimodalStudioPalette.GRAPE_100,
              foreground: MultimodalStudioPalette.GRAPE_400,
              border: Colors.transparent,
            ),
        ],
      ),
    );
  }
  if (audios.isNotEmpty && viewModel.isLaneVisible('audio')) {
    rows.add(
      TimelineBoardRow(
        laneKey: 'audio',
        label: '오디오',
        labelColor: MultimodalStudioPalette.PLUM_500,
        showsAiBadge: false,
        clips: [
          for (final bar in audios)
            TimelineBoardClip(
              clipId: '',
              attachmentId: bar.attachmentId,
              text: bar.fileName,
              startSeconds: bar.startSeconds,
              endSeconds: bar.endSeconds,
              background: MultimodalStudioPalette.KALE_0,
              foreground: MultimodalStudioPalette.KALE_300,
              border: Colors.transparent,
            ),
        ],
      ),
    );
  }
  const order = [
    VideoMultimodalViewModel.TEXT_LANE_KEY,
    'audio_manual',
    'object',
    'pose_object',
    'saved_attachment',
    'relation',
  ];
  for (final laneKey in order) {
    final clips = [
      for (final clip in viewModel.sampleClips)
        if (clip.laneKey == laneKey) clip,
    ];
    final isDefaultLane =
        laneKey == 'saved_attachment' || laneKey == 'relation';
    if (!viewModel.isLaneVisible(laneKey)) {
      continue;
    }
    if (clips.isEmpty && !isDefaultLane) {
      continue;
    }
    final first = clips.isEmpty ? null : clips.first;
    rows.add(
      TimelineBoardRow(
        laneKey: laneKey,
        label: first?.laneLabel ?? _defaultLaneLabel(laneKey),
        labelColor: _labelColor(laneKey),
        showsAiBadge: first?.showsAiBadge ?? false,
        clips: [
          for (final clip in clips)
            TimelineBoardClip(
              clipId: clip.clipId,
              attachmentId: '',
              text: clip.text,
              startSeconds: clip.startSeconds,
              endSeconds: clip.endSeconds,

              /// 레인 색
              background: timelineLaneBackground(laneKey),

              /// 레인 색
              foreground: timelineLaneForeground(laneKey),

              border: clip.isDashed
                  ? timelineLaneForeground(laneKey)
                  : Colors.transparent,
            ),
        ],
      ),
    );
  }
  return rows;
}

String _defaultLaneLabel(String laneKey) {
  switch (laneKey) {
    case 'saved_attachment':
      return '첨부 파일';
    case 'relation':
      return '관계 설정';
    default:
      return laneKey;
  }
}

Color _labelColor(String laneKey) {
  switch (laneKey) {
    case 'object':
    case 'audio_manual':
      return MultimodalStudioPalette.PLUM_500;
    case 'pose_object':
    case VideoMultimodalViewModel.TEXT_LANE_KEY:
      return MultimodalStudioPalette.GRAPE_700;
    default:
      return MultimodalStudioPalette.SAND_700;
  }
}

Color timelineLaneBackground(String laneKey) {
  switch (laneKey) {
    case VideoMultimodalViewModel.TEXT_LANE_KEY:
      return MultimodalStudioPalette.KALE_0;
    case 'audio_manual':
      return MultimodalStudioPalette.GRAPE_0;
    case 'object':
      return MultimodalStudioPalette.PLUM_100;
    case 'pose_object':
      return MultimodalStudioPalette.GRAPE_0;
    case 'saved_attachment':
      return MultimodalStudioPalette.PERSIMMON_0;
    case 'relation':
      return const Color(0xFF3A2438);
    default:
      return MultimodalStudioPalette.SAND_200;
  }
}

Color timelineLaneForeground(String laneKey) {
  switch (laneKey) {
    case VideoMultimodalViewModel.TEXT_LANE_KEY:
      return MultimodalStudioPalette.KALE_300;
    case 'audio_manual':
    case 'pose_object':
      return MultimodalStudioPalette.GRAPE_700;
    case 'object':
      return MultimodalStudioPalette.PLUM_400;
    case 'saved_attachment':
      return MultimodalStudioPalette.PERSIMMON_300;
    case 'relation':
      return MultimodalStudioPalette.PLUM_400;
    default:
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
