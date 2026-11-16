import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';

const double TIMELINE_BOARD_EDIT_TOOL_HEIGHT = 28;

/// 타임라인 상단 도구·트랙 편집 줄·관계 배너.
class TimelineBoardToolbar extends StatelessWidget {
  const TimelineBoardToolbar({
    super.key,
    required this.viewModel,
    required this.newTrackNameController,
    required this.trackNameController,
    required this.onConfirmDeleteSelection,
    required this.onSubmitNewTrack,
    required this.onConfirmDeleteTrack,
  });

  final VideoMultimodalViewModel viewModel;
  final TextEditingController newTrackNameController;
  final TextEditingController trackNameController;
  final VoidCallback onConfirmDeleteSelection;
  final VoidCallback onSubmitNewTrack;
  final VoidCallback onConfirmDeleteTrack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toolbar(),
        _editTools(),
        if (viewModel.isRelationMode) _relationBanner(),
      ],
    );
  }

  Widget _toolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_0,
        border: Border(
          bottom: BorderSide(color: MultimodalStudioPalette.SAND_300),
        ),
      ),
      child: Row(
        children: [
          TimelineBoardToolGroup([
            TimelineBoardToolButton(
              '클립 선택',
              selected: !viewModel.isRelationMode,
              onPressed: viewModel.didTapSelectTool,
            ),
            TimelineBoardToolButton(
              '클립 관계',
              selected: viewModel.isRelationMode,
              onPressed: viewModel.didTapToggleRelationMode,
            ),
            TimelineBoardToolButton(
              '클립 삭제',
              onPressed: viewModel.canDeleteSelection
                  ? onConfirmDeleteSelection
                  : null,
            ),
          ]),
          const Spacer(),
          TimelineBoardToolGroup([
            TimelineBoardToolButton(
              'Tracks',
              selected: viewModel.isTrackMenuOpen,
              onPressed: viewModel.didTapToggleTrackMenu,
            ),
            TimelineBoardToolButton(
              'Marker',
              onPressed: viewModel.didTapAddMarker,
            ),
            TimelineBoardToolButton(
              'Labels',
              onPressed: viewModel.didTapToggleLabels,
            ),
          ], isLast: true),
        ],
      ),
    );
  }

  Widget _editTools() {
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

  Widget _relationBanner() {
    return Container(
      color: MultimodalStudioPalette.GRAPE_0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              viewModel.relationPrompt,
              style: const TextStyle(
                color: MultimodalStudioPalette.GRAPE_400,
                fontSize: 11,
              ),
            ),
          ),
          TextButton(
            onPressed: viewModel.didTapCancelRelationMode,
            child: const Text('취소', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class TimelineBoardToolGroup extends StatelessWidget {
  const TimelineBoardToolGroup(this.children, {super.key, this.isLast = false});

  final List<Widget> children;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                right: BorderSide(color: MultimodalStudioPalette.SAND_300),
              ),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: isLast ? 0 : 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(width: 2),
              children[index],
            ],
          ],
        ),
      ),
    );
  }
}

class TimelineBoardToolButton extends StatelessWidget {
  const TimelineBoardToolButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.selected = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TIMELINE_BOARD_EDIT_TOOL_HEIGHT,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: selected
              ? MultimodalStudioPalette.GRAPE_500
              : MultimodalStudioPalette.SAND_900,
          backgroundColor: selected
              ? MultimodalStudioPalette.GRAPE_100
              : Colors.transparent,
          disabledForegroundColor: MultimodalStudioPalette.SAND_600,
          side: BorderSide(
            color: selected
                ? MultimodalStudioPalette.GRAPE_500
                : MultimodalStudioPalette.SAND_300,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(0, TIMELINE_BOARD_EDIT_TOOL_HEIGHT),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: const TextStyle(fontSize: 11, height: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Tracks 메뉴 오버레이.
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
    var menuWidth = 96.0;
    final scaler = MediaQuery.textScalerOf(context);
    for (final track in tracks) {
      final width = rowChrome + _labelTextWidth(track.label, scaler);
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
