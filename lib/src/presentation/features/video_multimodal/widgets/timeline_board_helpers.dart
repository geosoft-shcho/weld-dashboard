import 'package:flutter/material.dart';

import '../../../../domain/clip_file_position.dart';
import '../../../../domain/entities/job_timeline.dart';
import '../../../../domain/timeline_time.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';

const double TIMELINE_TRACK_LANE_HEIGHT = 28;
const double TIMELINE_TIMESERIES_CHART_HEIGHT = 240;

class TimelineBoardRow {
  const TimelineBoardRow({
    required this.laneKey,
    required this.label,
    required this.labelColor,
    required this.showsAiBadge,
    required this.clips,
    required this.laneCount,
    this.isChartExpanded = false,
  });

  final String laneKey;
  final String label;
  final Color labelColor;
  final bool showsAiBadge;
  final List<TimelineBoardClip> clips;
  final int laneCount;
  final bool isChartExpanded;

  double get height => isChartExpanded
      ? TIMELINE_TIMESERIES_CHART_HEIGHT
      : TIMELINE_TRACK_LANE_HEIGHT * laneCount;
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
    this.kind = TimelineClipKind.unspecified,
    this.showsPoseDots = false,
    this.hasLabel = false,
    this.laneIndex = 0,
    this.rateLabel = '',
    this.isChartExpanded = false,
  });

  final String clipId;
  final String attachmentId;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final Color background;
  final Color foreground;
  final Color border;
  final TimelineClipKind kind;
  final bool showsPoseDots;
  final bool hasLabel;
  final int laneIndex;
  final String rateLabel;
  final bool isChartExpanded;
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

double? revealOffsetForPlacedRow({
  required double rowTop,
  required double rowExtent,
  required double pixels,
  required double viewport,
  required double maxScrollExtent,
}) {
  if (rowTop < 0 || rowExtent <= 0 || viewport <= 0) {
    return null;
  }
  final bottom = rowTop + rowExtent;
  if (rowTop >= pixels && bottom <= pixels + viewport) {
    return null;
  }
  return rowTop.clamp(0.0, maxScrollExtent);
}

/// 같은 트랙에서 겹친 클립의 줄. 맞닿는 `[start, end)`는 겹침이 아니다.
Map<String, int> assignClipLanes(List<TimelineClip> clips) {
  final ordered = [...clips]..sort(_compareClipOrder);
  final laneEndNs = <BigInt>[];
  final lanes = <String, int>{};
  for (final clip in ordered) {
    final start = BigInt.tryParse(clip.startNs) ?? BigInt.zero;
    final end = BigInt.tryParse(clip.endNs) ?? start;
    var lane = -1;
    for (var index = 0; index < laneEndNs.length; index++) {
      if (laneEndNs[index] <= start) {
        lane = index;
        break;
      }
    }
    if (lane < 0) {
      lane = laneEndNs.length;
      laneEndNs.add(end);
    } else {
      laneEndNs[lane] = end;
    }
    lanes[clip.clipId] = lane;
  }
  return lanes;
}

int _compareClipOrder(TimelineClip left, TimelineClip right) {
  final start = (BigInt.tryParse(left.startNs) ?? BigInt.zero).compareTo(
    BigInt.tryParse(right.startNs) ?? BigInt.zero,
  );
  if (start != 0) {
    return start;
  }
  final leftId = BigInt.tryParse(left.clipId);
  final rightId = BigInt.tryParse(right.clipId);
  if (leftId != null && rightId != null && leftId != rightId) {
    return leftId.compareTo(rightId);
  }
  return left.clipId.compareTo(right.clipId);
}

int _laneCount(Map<String, int> lanes) {
  var count = 1;
  for (final lane in lanes.values) {
    if (lane + 1 > count) {
      count = lane + 1;
    }
  }
  return count;
}

String _rateLabel(TimelineClip clip) {
  final position = clipFilePositionAt(
    clip: ClipPlaybackInput(
      timelineStartNs: clip.startNs,
      timelineEndNs: clip.endNs,
      sourceStartNs: clip.sourceStartNs,
      sourceEndNs: clip.sourceEndNs,
      assetDurationNs: clip.assetDurationNs,
      assetStartTimeNs: clip.assetStartTimeNs,
    ),
    playheadSeconds: secondsFromNanoseconds(clip.startNs),
  );
  return position?.rateLabel ?? '';
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
    final lanes = assignClipLanes(clips);
    final expandedClipId = viewModel.chartExpandedClipId;
    rows.add(
      TimelineBoardRow(
        laneKey: track.trackId,
        label: track.name.trim().isEmpty ? '트랙' : track.name.trim(),
        labelColor: MultimodalStudioPalette.SAND_700,
        showsAiBadge: clips.any((clip) => clip.showsToolMark),
        laneCount: _laneCount(lanes),
        isChartExpanded: clips.any((clip) => clip.clipId == expandedClipId),
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
              kind: clip.kind,
              showsPoseDots: clip.kind == TimelineClipKind.pose,
              hasLabel: clip.labelValueId.isNotEmpty,
              laneIndex: lanes[clip.clipId] ?? 0,
              rateLabel: _rateLabel(clip),
              isChartExpanded: clip.clipId == expandedClipId,
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

/// 시간 눈금. 1초마다 작은 눈금, 1분마다 큰 눈금과 시각 숫자.
class TimelineRulerPainter extends CustomPainter {
  const TimelineRulerPainter({
    required this.spanSeconds,
    required this.pixelsPerSecond,
  });

  final double spanSeconds;
  final double pixelsPerSecond;

  static const int MINUTE_SECONDS = 60;
  static const double MINOR_TICK_TOP = 16;
  static const double MAJOR_TICK_TOP = 8;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = MultimodalStudioPalette.SAND_0,
    );
    final minor = Paint()
      ..color = MultimodalStudioPalette.SAND_300
      ..strokeWidth = 1;
    final major = Paint()
      ..color = MultimodalStudioPalette.SAND_600
      ..strokeWidth = 1;

    for (var second = 0; second <= spanSeconds.floor(); second++) {
      final x = second * pixelsPerSecond;
      final isMinute = second % MINUTE_SECONDS == 0;
      canvas.drawLine(
        Offset(x, isMinute ? MAJOR_TICK_TOP : MINOR_TICK_TOP),
        Offset(x, size.height),
        isMinute ? major : minor,
      );
      if (isMinute) {
        _paintLabel(canvas, x, second.toDouble());
      }
    }
  }

  void _paintLabel(Canvas canvas, double x, double second) {
    final painter = TextPainter(
      text: TextSpan(
        text: formatTimelineTimecode(second),
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

  @override
  bool shouldRepaint(covariant TimelineRulerPainter oldDelegate) {
    return oldDelegate.spanSeconds != spanSeconds ||
        oldDelegate.pixelsPerSecond != pixelsPerSecond;
  }
}
