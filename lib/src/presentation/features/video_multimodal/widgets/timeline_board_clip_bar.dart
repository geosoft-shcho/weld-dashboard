import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'audio_clip_chart.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_helpers.dart';
import 'timeseries_clip_chart.dart';

/// 타임라인 한 클립(바) UI. 드래그·리사이즈·차트 표시.
class TimelineBoardClipBar extends StatelessWidget {
  const TimelineBoardClipBar({
    super.key,
    required this.viewModel,
    required this.clip,
    required this.row,
    required this.edit,
    required this.isSelected,
    required this.onTap,
    required this.onBeginEdit,
    required this.onMove,
    required this.onResize,
    required this.onCommit,
    required this.onClear,
  });

  final VideoMultimodalViewModel viewModel;
  final TimelineBoardClip clip;
  final TimelineBoardRow row;
  final TimelineClipEdit? edit;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<TimelineBoardClip> onBeginEdit;
  final void Function(String clipId, double deltaSeconds) onMove;
  final void Function(String clipId, double deltaSeconds, {required bool isLeading})
      onResize;
  final VoidCallback onCommit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final range = _shownRange();
    final left = range.startSeconds * viewModel.pixelsPerSecond;
    var width =
        (range.endSeconds - range.startSeconds) * viewModel.pixelsPerSecond;
    final minimum = VideoMultimodalViewModel.MIN_CLIP_WIDTH;
    if (width < minimum) {
      width = minimum;
    }
    final canEdit = rangeIdOf(clip).isNotEmpty && !clip.isChartExpanded;
    if (canEdit && isSelected && width < 12) {
      width = 12;
    }
    if (clip.isChartExpanded) {
      final rawDurationMs = ((range.endSeconds - range.startSeconds) * 1000)
          .round();
      final durationMs = rawDurationMs < 1 ? 1 : rawDurationMs;
      final chartKind = clipChartKindOf(clip.kind);
      final Widget chart;
      switch (chartKind) {
        case ClipChartKind.audio:
          chart = AudioClipChart(
            amplitudes: viewModel.audioAmplitudes,
            isLoading: viewModel.isAudioChartLoading,
            errorMessage: viewModel.audioChartError,
            durationMs: durationMs,
            selectedTimeMs: viewModel.timeseriesSelectedTimeMs,
            onTimeTapMs: viewModel.didTapAudioChartTime,
          );
        case ClipChartKind.timeseries:
          chart = TimeseriesClipChart(
            key: ValueKey<String>('timeseries-chart-${clip.clipId}'),
            series: viewModel.timeseriesSeries,
            isLoading: viewModel.isTimeseriesChartLoading,
            errorMessage: viewModel.timeseriesChartError,
            durationMs: durationMs,
            selectedTimeMs: viewModel.timeseriesSelectedTimeMs,
            selectedTimeLabel: viewModel.playheadLabel,
            onTimeTapMs: viewModel.didTapTimeseriesChartTime,
          );
        case null:
          chart = const SizedBox.shrink();
      }
      return Positioned(
        left: left,
        top: 0,
        width: width < 160 ? 160 : width,
        height: row.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: MultimodalStudioPalette.GRAPE_400,
              width: 1,
            ),
          ),
          child: chart,
        ),
      );
    }
    return Positioned(
      left: left,
      top: 4 + clip.laneIndex * TIMELINE_TRACK_LANE_HEIGHT,
      width: width,
      height: 20,
      child: GestureDetector(
        onTap: onTap,
        onHorizontalDragStart: canEdit ? (_) => onBeginEdit(clip) : null,
        onHorizontalDragUpdate: canEdit
            ? (details) => onMove(
                rangeIdOf(clip),
                details.delta.dx / viewModel.pixelsPerSecond,
              )
            : null,
        onHorizontalDragEnd: canEdit ? (_) => onCommit() : null,
        onHorizontalDragCancel: canEdit ? () => onClear() : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: clip.background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected
                  ? MultimodalStudioPalette.GRAPE_500
                  : clip.border,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  clip.rateLabel.isEmpty
                      ? clip.text
                      : '${clip.text} ${clip.rateLabel}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: clip.foreground,
                    fontSize: 11,
                    height: 1.6,
                    fontWeight: clip.hasLabel
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
              if (canEdit && isSelected) ...[
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: _resizeHandle(isLeading: true),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: _resizeHandle(isLeading: false),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _resizeHandle({required bool isLeading}) {
    return GestureDetector(
      onHorizontalDragStart: (_) => onBeginEdit(clip),
      onHorizontalDragUpdate: (details) => onResize(
        rangeIdOf(clip),
        details.delta.dx / viewModel.pixelsPerSecond,
        isLeading: isLeading,
      ),
      onHorizontalDragEnd: (_) => onCommit(),
      onHorizontalDragCancel: onClear,
      child: const MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: ColoredBox(color: Color(0x66FFFFFF)),
      ),
    );
  }

  TimelineClipEdit _shownRange() {
    final active = edit;
    final rangeId = rangeIdOf(clip);
    if (active != null && active.clipId == rangeId) {
      return active;
    }
    return TimelineClipEdit(
      clipId: rangeId,
      isBar: clip.clipId.isEmpty,
      startSeconds: clip.startSeconds,
      endSeconds: clip.endSeconds,
    );
  }
}
