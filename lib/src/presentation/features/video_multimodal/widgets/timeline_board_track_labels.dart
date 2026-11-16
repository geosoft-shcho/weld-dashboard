import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_helpers.dart';

/// 타임라인 좌측 트랙 라벨 열.
class TimelineBoardTrackLabels extends StatelessWidget {
  const TimelineBoardTrackLabels({
    super.key,
    required this.viewModel,
    required this.rows,
    required this.scrollController,
    required this.onSelectClip,
  });

  final VideoMultimodalViewModel viewModel;
  final List<TimelineBoardRow> rows;
  final ScrollController scrollController;
  final ValueChanged<TimelineBoardClip> onSelectClip;

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle _identityStyle = TextStyle(
    color: MultimodalStudioPalette.SAND_600,
    fontSize: 9,
  );
  // 좌우 패딩 + 아이콘 + AI 배지 + trackId 여유
  static const double _labelSide = 140;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _labelsWidth(context),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_200,
        border: Border(
          right: BorderSide(color: MultimodalStudioPalette.SAND_300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 22,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '트랙 (${viewModel.timelineTracks.length})',
                  style: const TextStyle(
                    color: MultimodalStudioPalette.SAND_600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: const Key('timeline-track-labels'),
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final row in rows) _trackLabelRow(row)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _labelTextWidth(BuildContext context, String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _labelStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  double _labelsWidth(BuildContext context) {
    var widest = _labelTextWidth(
      context,
      '트랙 (${viewModel.timelineTracks.length})',
    );
    for (final row in rows) {
      final width = _labelTextWidth(context, row.label);
      if (width > widest) {
        widest = width;
      }
    }
    return widest + _labelSide;
  }

  Widget _trackLabelRow(TimelineBoardRow row) {
    // 행·mute·모니터가 트랙 단위이므로 보조 식별자는 trackId. 클립 목록은 Tooltip.
    final identity = row.trackId;
    if (row.clips.isEmpty) {
      return _trackLabel(row, identity: identity);
    }
    final clip = _rowSelection(row);
    final isSelected = row.clips.any(_isClipSelected);
    return GestureDetector(
      onTap: () => onSelectClip(clip),
      child: _trackLabel(row, isSelected: isSelected, identity: identity),
    );
  }

  String _trackIdentityTooltip(TimelineBoardRow row) {
    final trackLine = '트랙 ID: ${row.trackId}';
    if (row.clips.isEmpty) {
      return '$trackLine\n클립: 없음';
    }
    if (row.clips.length == 1) {
      return '$trackLine\n클립 ID: ${row.clips.first.clipId}';
    }
    final lines = [
      trackLine,
      '클립 ID (${row.clips.length}):',
      for (final clip in row.clips) '· ${clip.clipId}',
    ];
    return lines.join('\n');
  }

  Widget _trackLabel(
    TimelineBoardRow row, {
    bool isSelected = false,
    String identity = '',
  }) {
    return Tooltip(
      message: _trackIdentityTooltip(row),
      verticalOffset: 12,
      child: Container(
        height: row.height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: isSelected ? MultimodalStudioPalette.GRAPE_100 : null,
        child: Row(
          children: [
            Tooltip(
              message: '트랙 가리기',
              child: GestureDetector(
                onTap: () => viewModel.didTapToggleTrackVisibility(row.trackId),
                child: const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.check_box,
                    size: 14,
                    color: MultimodalStudioPalette.SAND_700,
                  ),
                ),
              ),
            ),
            if (row.showsAiBadge)
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: MultimodalStudioPalette.GRAPE_0,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: MultimodalStudioPalette.GRAPE_700,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Text(
              row.label,
              maxLines: 1,
              softWrap: false,
              style: _labelStyle.copyWith(color: row.labelColor),
            ),
            if (identity.isNotEmpty) ...[
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  identity,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: _identityStyle,
                ),
              ),
            ],
            const SizedBox(width: 4),
            if (viewModel.isServerTimelineTrack(row.trackId) &&
                viewModel.trackHasVideo(row.trackId))
              _circleButton(
                tooltip: viewModel.isTrackMonitored(row.trackId)
                    ? '모니터 끄기'
                    : '모니터 켜기',
                icon: viewModel.isTrackMonitored(row.trackId)
                    ? Icons.videocam
                    : Icons.videocam_outlined,
                iconColor: viewModel.isTrackMonitored(row.trackId)
                    ? MultimodalStudioPalette.GRAPE_700
                    : MultimodalStudioPalette.SAND_600,
                onTap: () => viewModel.didTapMonitorTrack(row.trackId),
              ),
            if (viewModel.isServerTimelineTrack(row.trackId) &&
                viewModel.trackHasTimeseries(row.trackId))
              _circleButton(
                tooltip: row.isChartExpanded ? '차트 접기' : '시계열 차트',
                icon: Icons.show_chart,
                iconColor: row.isChartExpanded
                    ? MultimodalStudioPalette.GRAPE_700
                    : MultimodalStudioPalette.SAND_600,
                onTap: () => viewModel.didTapToggleTimeseriesChart(row.trackId),
              ),
            if (viewModel.isServerTimelineTrack(row.trackId) &&
                viewModel.trackHasAudio(row.trackId))
              _circleButton(
                tooltip: row.isChartExpanded ? '차트 접기' : '음성 차트',
                icon: Icons.show_chart,
                iconColor: row.isChartExpanded
                    ? MultimodalStudioPalette.GRAPE_700
                    : MultimodalStudioPalette.SAND_600,
                onTap: () => viewModel.didTapToggleAudioChart(row.trackId),
              ),
            if (viewModel.trackShowsAudioMuteToggle(row.trackId))
              _circleButton(
                tooltip: viewModel.isTrackAudioMuted(row.trackId)
                    ? '소리 켜기'
                    : '소리 끄기',
                icon: viewModel.isTrackAudioMuted(row.trackId)
                    ? Icons.volume_off
                    : Icons.volume_up,
                iconColor: viewModel.isTrackAudioMuted(row.trackId)
                    ? MultimodalStudioPalette.CANTELOUPE_400
                    : MultimodalStudioPalette.SAND_600,
                onTap: () => viewModel.didTapToggleTrackAudioMute(row.trackId),
              ),
          ],
        ),
      ),
    );
  }

  /// 모니터·차트·소리 토글. 원 배경으로 버튼임을 드러낸다.
  Widget _circleButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      verticalOffset: 12,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: MultimodalStudioPalette.SAND_300,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 22,
              height: 22,
              child: Center(child: Icon(icon, size: 12, color: iconColor)),
            ),
          ),
        ),
      ),
    );
  }

  TimelineBoardClip _rowSelection(TimelineBoardRow row) {
    for (final clip in row.clips) {
      if (_isClipSelected(clip)) {
        return clip;
      }
    }
    return row.clips.first;
  }

  bool _isClipSelected(TimelineBoardClip clip) {
    if (clip.clipId.isNotEmpty) {
      return clip.clipId == viewModel.selectedClipId;
    }
    return clip.attachmentId.isNotEmpty &&
        clip.attachmentId == (viewModel.selectedBar?.attachmentId ?? '');
  }
}
