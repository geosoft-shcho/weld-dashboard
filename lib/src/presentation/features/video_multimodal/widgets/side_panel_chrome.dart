import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'multimodal_studio_palette.dart';

class SidePanelFrame extends StatelessWidget {
  const SidePanelFrame({super.key, required this.head, required this.body, this.foot});

  final Widget head;
  final Widget body;
  final Widget? foot;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MultimodalStudioPalette.PANEL_PAGE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          head,
          Expanded(child: body),
          ?foot,
        ],
      ),
    );
  }
}

class SidePanelHead extends StatelessWidget {
  const SidePanelHead({
    super.key,
    required this.onClose,
    this.title = '',
    this.leading,
    this.actions = const [],
  });

  final VoidCallback onClose;
  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.PANEL_PAPER,
        border: Border(
          bottom: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
        ),
      ),
      child: Row(
        children: [
          if (leading != null)
            Expanded(child: leading!)
          else
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: MultimodalStudioPalette.PANEL_INK,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          for (final action in actions) ...[const SizedBox(width: 4), action],
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
            icon: const Icon(
              Icons.close,
              size: 16,
              color: MultimodalStudioPalette.PANEL_MUTED,
            ),
          ),
        ],
      ),
    );
  }
}

class SidePanelSectionLabel extends StatelessWidget {
  const SidePanelSectionLabel(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: MultimodalStudioPalette.PANEL_MUTED,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class SidePanelFootNote extends StatelessWidget {
  const SidePanelFootNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.PANEL_PAPER,
        border: Border(
          top: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Text(
          text,
          style: const TextStyle(
            color: MultimodalStudioPalette.PANEL_MUTED,
            fontSize: 11,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class SidePanelAccentButton extends StatelessWidget {
  const SidePanelAccentButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: MultimodalStudioPalette.PANEL_ACCENT,
        foregroundColor: const fluent.Color.fromARGB(255, 18, 13, 13),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

class SidePanelQuietButton extends StatelessWidget {
  const SidePanelQuietButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: MultimodalStudioPalette.PANEL_ACCENT,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 11),
      ),
      child: Text(label),
    );
  }
}

InputDecoration sidePanelFieldDecoration(String hintText) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
  );
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: MultimodalStudioPalette.PANEL_PAGE,
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 11,
      color: MultimodalStudioPalette.PANEL_MUTED,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    border: border,
    enabledBorder: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: MultimodalStudioPalette.PANEL_ACCENT),
    ),
  );
}

const TextStyle sidePanelFieldTextStyle = TextStyle(
  fontSize: 11,
  color: MultimodalStudioPalette.PANEL_INK,
);

class SidePanelDataRow extends StatelessWidget {
  const SidePanelDataRow(
    this.cells, {
    super.key,
    this.isHeader = false,
    this.isMuted = false,
    this.isSelected = false,
    this.onTap,
  });

  final List<SidePanelDataCell> cells;
  final bool isHeader;
  final bool isMuted;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isHeader
        ? MultimodalStudioPalette.PANEL_PAGE
        : isSelected
        ? MultimodalStudioPalette.PANEL_ACCENT_FILL
        : isMuted
        ? MultimodalStudioPalette.PANEL_PAGE
        : MultimodalStudioPalette.PANEL_PAPER;
    final hoverColor = isSelected || isMuted
        ? Colors.transparent
        : MultimodalStudioPalette.PANEL_ACCENT_FILL;
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                for (final cell in cells)
                  Expanded(
                    flex: cell.flex,
                    child: cell.build(isHeader: isHeader),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SidePanelDataCell {
  const SidePanelDataCell(
    this.text, {
    this.flex = 1,
    this.isHeader = false,
    this.badge = '',
  }) : dot = null;

  const SidePanelDataCell.dot(this.dot)
    : text = '',
      flex = 1,
      isHeader = false,
      badge = '';

  final String text;
  final int flex;
  final bool isHeader;
  final String badge;
  final Color? dot;

  Widget build({required bool isHeader}) {
    final tone = isHeader || this.isHeader
        ? MultimodalStudioPalette.PANEL_MUTED
        : MultimodalStudioPalette.PANEL_INK;
    return Row(
      children: [
        if (dot != null)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          )
        else
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: tone,
                fontSize: isHeader || this.isHeader ? 10 : 11,
                fontWeight: isHeader || this.isHeader
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        if (badge.isNotEmpty) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: MultimodalStudioPalette.PANEL_DANGER_FILL,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: MultimodalStudioPalette.PANEL_DANGER,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
