import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_toolbar.dart';

/// 트랙 추가·이름 수정·삭제 줄.
class TimelineBoardEditTools extends StatelessWidget {
  const TimelineBoardEditTools({
    super.key,
    required this.viewModel,
    required this.newTrackNameController,
    required this.trackNameController,
    required this.onSubmitNewTrack,
    required this.onConfirmDeleteTrack,
  });

  final VideoMultimodalViewModel viewModel;
  final TextEditingController newTrackNameController;
  final TextEditingController trackNameController;
  final VoidCallback onSubmitNewTrack;
  final VoidCallback onConfirmDeleteTrack;

  @override
  Widget build(BuildContext context) {
    final canEditTrack = viewModel.canEditSelectedServerTrack;
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _trackNameField(
              key: const Key('new-timeline-track-name'),
              controller: newTrackNameController,
              hint: '트랙 이름',
            ),
            TimelineBoardToolButton('트랙 추가', onPressed: onSubmitNewTrack),
            _trackNameField(
              key: const Key('selected-timeline-track-name'),
              controller: trackNameController,
              hint: '선택한 트랙',
              enabled: canEditTrack,
            ),
            TimelineBoardToolButton(
              '트랙 수정',
              onPressed: canEditTrack
                  ? () => viewModel.didSubmitTimelineTrackName(
                      trackNameController.text,
                    )
                  : null,
            ),
            Tooltip(
              message: '이 트랙의 클립도 함께 지워집니다.',
              child: TimelineBoardToolButton(
                '트랙 삭제',
                onPressed: canEditTrack ? onConfirmDeleteTrack : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trackNameField({
    required Key key,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return Container(
      width: 180,
      height: TIMELINE_BOARD_EDIT_TOOL_HEIGHT,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: MultimodalStudioPalette.SAND_300),
        borderRadius: BorderRadius.circular(3),
      ),
      child: TextField(
        key: key,
        controller: controller,
        enabled: enabled,
        cursorHeight: 14,
        style: const TextStyle(fontSize: 11, height: 1.2),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 11,
            height: 1.2,
            color: MultimodalStudioPalette.SAND_600,
          ),
        ),
      ),
    );
  }
}

/// 트랙 목록 메뉴 오버레이 (전체/개별 체크).
class TimelineBoardTrackMenu extends StatelessWidget {
  const TimelineBoardTrackMenu({
    super.key,
    required this.viewModel,
    required this.boardHeight,
  });

  final VideoMultimodalViewModel viewModel;
  final double boardHeight;

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    const menuTop = 36.0;
    const menuBottomPad = 8.0;
    const rowChrome = 38.0;
    final maxHeight = (boardHeight - menuTop - menuBottomPad).clamp(
      120.0,
      double.infinity,
    );
    final tracks = <({String key, String label})>[
      for (final track in viewModel.timelineTracks)
        (
          key: track.trackId,
          label: track.name.trim().isEmpty ? '트랙' : track.name.trim(),
        ),
    ];
    var menuWidth = 196.0;
    final scaler = MediaQuery.textScalerOf(context);
    for (final label in ['전체', ...tracks.map((track) => track.label)]) {
      final width = rowChrome + _labelTextWidth(label, scaler);
      if (width > menuWidth) {
        menuWidth = width;
      }
    }
    return Positioned(
      right: 12,
      top: menuTop,
      child: Material(
        elevation: 6,
        color: MultimodalStudioPalette.SAND_0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: menuWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                InkWell(
                  onTap: viewModel.didTapToggleAllTracks,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          viewModel.areAllTracksEnabled
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color: MultimodalStudioPalette.SAND_700,
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            '전체',
                            style: TextStyle(
                              color: MultimodalStudioPalette.SAND_900,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: MultimodalStudioPalette.SAND_300,
                  ),
                ),
                for (final track in tracks)
                  InkWell(
                    onTap: () =>
                        viewModel.didTapToggleTrackVisibility(track.key),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            viewModel.isTrackVisible(track.key)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 16,
                            color: MultimodalStudioPalette.SAND_700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              track.label,
                              style: const TextStyle(
                                color: MultimodalStudioPalette.SAND_900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _labelTextWidth(String text, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _labelStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}
