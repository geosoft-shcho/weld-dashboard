import 'package:flutter/material.dart';

import '../../../core/widgets/author_display.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_helpers.dart';

/// 타임라인 좌측 트랙 라벨 열. 트랙 추가·이름 수정·삭제도 여기서 한다.
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
  // 좌우 패딩 + 아이콘 + AI 배지 + trackId + 수정/삭제 여유
  static const double _labelSide = 180;

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
              child: Row(
                children: [
                  Text(
                    '트랙 (${viewModel.timelineTracks.length})',
                    style: const TextStyle(
                      color: MultimodalStudioPalette.SAND_600,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Tooltip(
                    message: '트랙 추가',
                    verticalOffset: 12,
                    child: GestureDetector(
                      onTap: () => _showCreateTrackDialog(context),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: MultimodalStudioPalette.SAND_700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: const Key('timeline-track-labels'),
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final row in rows) _trackLabelRow(context, row)],
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

  Widget _trackLabelRow(BuildContext context, TimelineBoardRow row) {
    // 행·mute·모니터가 트랙 단위이므로 보조 식별자는 trackId. 클립 목록은 Tooltip.
    final identity = row.trackId;
    if (row.clips.isEmpty) {
      return _trackLabel(context, row, identity: identity);
    }
    return _trackLabel(
      context,
      row,
      isSelected: row.clips.any(_isClipSelected),
      identity: identity,
      onSelect: () => onSelectClip(_rowSelection(row)),
    );
  }

  String _trackIdentityTooltip(TimelineBoardRow row) {
    final trackLine = '트랙 ID: ${row.trackId}';
    final authorLine =
        '작성자: ${authorDisplayLabel(row.createdByDisplayName)} · '
        '수정자: ${authorDisplayLabel(row.updatedByDisplayName)}';
    if (row.clips.isEmpty) {
      return '$trackLine\n$authorLine\n클립: 없음';
    }
    if (row.clips.length == 1) {
      return '$trackLine\n$authorLine\n클립 ID: ${row.clips.first.clipId}';
    }
    final lines = [
      trackLine,
      authorLine,
      '클립 ID (${row.clips.length}):',
      for (final clip in row.clips) '· ${clip.clipId}',
    ];
    return lines.join('\n');
  }

  bool _isSelectedEditableTrack(TimelineBoardRow row) {
    final selected = viewModel.selectedServerTrack;
    return selected != null &&
        selected.trackId == row.trackId &&
        viewModel.isServerTimelineTrack(row.trackId);
  }

  Widget _trackLabel(
    BuildContext context,
    TimelineBoardRow row, {
    bool isSelected = false,
    String identity = '',
    VoidCallback? onSelect,
  }) {
    final canEditTrack = _isSelectedEditableTrack(row);
    final body = Row(
      children: [
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
    );
    // 체크·CRUD 밖. 활성+클립 있을 때만 본문 탭으로 선택.
    final Widget bodyArea;
    if (!row.isEnabled) {
      bodyArea = IgnorePointer(
        child: Opacity(opacity: 0.4, child: body),
      );
    } else if (onSelect != null) {
      bodyArea = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelect,
        child: body,
      );
    } else {
      bodyArea = body;
    }
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
              message: row.isEnabled ? '트랙 끄기' : '트랙 켜기',
              child: GestureDetector(
                onTap: () => viewModel.didTapToggleTrackVisibility(row.trackId),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    row.isEnabled
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 14,
                    color: MultimodalStudioPalette.SAND_700,
                  ),
                ),
              ),
            ),
            Expanded(child: bodyArea),
            if (canEditTrack) ...[
              _circleButton(
                tooltip: '트랙 이름 수정',
                icon: Icons.edit_outlined,
                iconColor: MultimodalStudioPalette.SAND_700,
                onTap: () => _showRenameTrackDialog(context, row.label),
              ),
              _circleButton(
                tooltip: '트랙 삭제',
                icon: Icons.delete_outline,
                iconColor: MultimodalStudioPalette.CANTELOUPE_400,
                onTap: () => _confirmDeleteTrack(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 모니터·차트·소리·트랙 CRUD. 원 배경으로 버튼임을 드러낸다.
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

  Future<void> _showCreateTrackDialog(BuildContext context) async {
    final name = await _showTrackNameDialog(
      context,
      title: '트랙 추가',
      confirmLabel: '추가',
      fieldKey: const Key('new-timeline-track-name'),
    );
    if (name == null) {
      return;
    }
    await viewModel.didSubmitNewTimelineTrack(name);
  }

  Future<void> _showRenameTrackDialog(
    BuildContext context,
    String currentName,
  ) async {
    final name = await _showTrackNameDialog(
      context,
      title: '트랙 이름 수정',
      confirmLabel: '수정',
      initialName: currentName,
      fieldKey: const Key('selected-timeline-track-name'),
    );
    if (name == null) {
      return;
    }
    await viewModel.didSubmitTimelineTrackName(name);
  }

  Future<String?> _showTrackNameDialog(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    String initialName = '',
    Key? fieldKey,
  }) async {
    final controller = TextEditingController(text: initialName);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return WorkDetailMaterialScope(
          child: AlertDialog(
            title: Text(title),
            content: TextField(
              key: fieldKey,
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '트랙 이름',
                isDense: true,
              ),
              onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, controller.text.trim()),
                child: Text(confirmLabel),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    return name;
  }

  Future<void> _confirmDeleteTrack(BuildContext context) async {
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return WorkDetailMaterialScope(
          child: AlertDialog(
            content: const Text('이 트랙의 클립도 함께 지워집니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('지우기'),
              ),
            ],
          ),
        );
      },
    );
    if (didConfirm != true) {
      return;
    }
    await viewModel.didTapDeleteSelectedTimelineTrack();
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
