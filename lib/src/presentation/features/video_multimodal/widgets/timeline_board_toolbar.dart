import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_track_tools.dart';

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
        TimelineBoardEditTools(
          viewModel: viewModel,
          newTrackNameController: newTrackNameController,
          trackNameController: trackNameController,
          onSubmitNewTrack: onSubmitNewTrack,
          onConfirmDeleteTrack: onConfirmDeleteTrack,
        ),
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
              '트랙 목록',
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
