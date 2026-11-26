import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';

const double TIMELINE_BOARD_EDIT_TOOL_HEIGHT = 28;

/// 타임라인 상단 클립 도구·관계 배너.
class TimelineBoardToolbar extends StatelessWidget {
  const TimelineBoardToolbar({
    super.key,
    required this.viewModel,
    required this.onConfirmDeleteSelection,
  });

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onConfirmDeleteSelection;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toolbar(),
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
              icon: Icons.near_me,
              selected: !viewModel.isRelationMode,
              onPressed: viewModel.didTapSelectTool,
            ),
            TimelineBoardToolButton(
              '클립 관계',
              icon: Icons.link,
              selected: viewModel.isRelationMode,
              onPressed: viewModel.didTapToggleRelationMode,
            ),
            TimelineBoardToolButton(
              '클립 삭제',
              icon: Icons.delete_outline,
              onPressed: viewModel.canDeleteSelection
                  ? onConfirmDeleteSelection
                  : null,
            ),
          ]),
          const Spacer(),
          TimelineBoardToolGroup([
            TimelineBoardToolButton(
              '트랙 목록',
              icon: Icons.view_list,
              selected: viewModel.isTrackMenuOpen,
              onPressed: viewModel.didTapToggleTrackMenu,
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
    this.icon,
    this.selected = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(label);
    final child = icon == null
        ? labelText
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14),
              const SizedBox(width: 4),
              labelText,
            ],
          );
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
        child: child,
      ),
    );
  }
}
