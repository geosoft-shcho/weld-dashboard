import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';
import '../../../../domain/entities/label_vocab.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_dialogs.dart';
import 'multimodal_studio_palette.dart';
import 'side_panel_chrome.dart';

class LabelsSideBody extends StatefulWidget {
  const LabelsSideBody({super.key, required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  State<LabelsSideBody> createState() => _LabelsSideBodyState();
}

class _LabelsSideBodyState extends State<LabelsSideBody> {
  static const double _INDENT_STEP = 16;

  final TextEditingController _controller = TextEditingController();
  final Set<String> _collapsedIds = {};
  String? _addingParentId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectLabel(String valueId) {
    widget.viewModel.didSelectLabelValue(valueId);
    if (_addingParentId != null && _addingParentId != valueId) {
      setState(() => _addingParentId = null);
    }
  }

  void _openAdd(String parentValueId) {
    setState(() {
      _controller.clear();
      _addingParentId = parentValueId;
    });
  }

  Future<void> _addLabel(String parentValueId) async {
    final added = await widget.viewModel.didAddLabelValue(
      name: _controller.text,
      parentValueId: parentValueId,
    );
    if (!mounted || !added) {
      return;
    }
    _controller.clear();
    setState(() => _addingParentId = null);
  }

  Future<void> _renameLabel(LabelNode node) async {
    final next = await showMultimodalRenameLabelDialog(context, node.name);
    if (!mounted || next == null || next.isEmpty) {
      return;
    }
    await widget.viewModel.didRenameLabelValue(
      valueId: node.valueId,
      name: next,
    );
  }

  Future<void> _deprecateLabel(LabelNode node) async {
    final isConfirmed = await showMultimodalLabelDeleteDialog(
      context,
      node.name,
    );
    if (!mounted || !isConfirmed) {
      return;
    }
    await widget.viewModel.didDeprecateLabelValue(valueId: node.valueId);
  }

  List<Widget> _labelBranch(LabelNode node, {required int depth}) {
    final isSelected = widget.viewModel.selectedLabelValueId == node.valueId;
    final isCollapsed = _collapsedIds.contains(node.valueId);
    return [
      _LabelTreeRow(
        key: ValueKey(node.valueId),
        name: node.name,
        depth: depth,
        isRoot: depth == 0,
        isSelected: isSelected,
        hasChildren: node.children.isNotEmpty,
        isCollapsed: isCollapsed,
        onToggle: () => setState(() {
          if (isCollapsed) {
            _collapsedIds.remove(node.valueId);
          } else {
            _collapsedIds.add(node.valueId);
          }
        }),
        onSelect: () => _selectLabel(node.valueId),
        onRename: isSelected ? () => _renameLabel(node) : null,
        onDelete: isSelected ? () => _deprecateLabel(node) : null,
        onAddChild: isSelected ? () => _openAdd(node.valueId) : null,
      ),
      if (isSelected && _addingParentId == node.valueId)
        _addField(node.valueId, depth + 1),
      if (!isCollapsed)
        for (final child in node.children)
          ..._labelBranch(child, depth: depth + 1),
    ];
  }

  Widget _addField(String parentValueId, int depth) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8 + depth * _INDENT_STEP, 4, 8, 4),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: sidePanelFieldTextStyle,
                cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
                decoration: sidePanelFieldDecoration('새 라벨 이름'),
              ),
            ),
            const SizedBox(width: 4),
            SidePanelAccentButton(
              label: '추가',
              onPressed: () => _addLabel(parentValueId),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SidePanelFrame(
      head: SidePanelHead(title: 'Labels', onClose: widget.onClose),
      body: ListView(
        children: [
          if (widget.viewModel.labelMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Text(
                widget.viewModel.labelMessage,
                style: const TextStyle(
                  color: MultimodalStudioPalette.PANEL_INK,
                  fontSize: 11,
                ),
              ),
            ),
          if (widget.viewModel.isLoadingLabels &&
              widget.viewModel.labelRoots.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          if (!widget.viewModel.isLoadingLabels &&
              widget.viewModel.labelRoots.isEmpty &&
              widget.viewModel.labelMessage.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('사용할 수 있는 라벨이 없습니다.', style: TextStyle(fontSize: 12)),
            ),
          if (_addingParentId == '') _addField('', 0),
          for (final root in widget.viewModel.labelRoots)
            ..._labelBranch(root, depth: 0),
        ],
      ),
      foot: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LabelsToolbar(
            isAddingRoot: _addingParentId == '',
            canAddRoot: !widget.viewModel.isLoadingLabels,
            onAddRoot: () => _openAdd(''),
            canAttach: widget.viewModel.canAttachLabelToSelection,
            onAttach: widget.viewModel.didAttachLabelToSelectedClip,
            canDetach: widget.viewModel.canDetachLabelFromSelection,
            onDetach: widget.viewModel.didDetachLabelFromSelectedClip,
          ),
          const SidePanelFootNote('붙이기를 누르면 고른 라벨이 선택 클립에 연결됩니다.'),
        ],
      ),
    );
  }
}

class _LabelsToolbar extends StatelessWidget {
  const _LabelsToolbar({
    required this.isAddingRoot,
    required this.canAddRoot,
    required this.onAddRoot,
    required this.canAttach,
    required this.onAttach,
    required this.canDetach,
    required this.onDetach,
  });

  static const double _BAR_HEIGHT = 48;

  final bool isAddingRoot;
  final bool canAddRoot;
  final VoidCallback onAddRoot;
  final bool canAttach;
  final VoidCallback onAttach;
  final bool canDetach;
  final VoidCallback onDetach;

  @override
  Widget build(BuildContext context) {
    final stroke = fluent.FluentTheme.of(
      context,
    ).resources.cardStrokeColorDefault;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        border: Border(top: BorderSide(color: stroke)),
      ),
      child: SizedBox(
        height: _BAR_HEIGHT,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _group(stroke, [
                _LabelsToolbarButton(
                  icon: fluent.FluentIcons.add,
                  label: '맨 위 라벨 추가',
                  enabled: canAddRoot,
                  selected: isAddingRoot,
                  onPressed: onAddRoot,
                ),
              ]),
              _group(stroke, [
                _LabelsToolbarButton(
                  icon: fluent.FluentIcons.tag,
                  label: '클립에 붙이기',
                  enabled: canAttach,
                  accent: true,
                  onPressed: onAttach,
                ),
                if (canDetach)
                  _LabelsToolbarButton(
                    icon: fluent.FluentIcons.remove,
                    label: '라벨 떼기',
                    enabled: true,
                    onPressed: onDetach,
                  ),
              ], isLast: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _group(Color stroke, List<Widget> children, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: isLast ? null : Border(right: BorderSide(color: stroke)),
        ),
        child: Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 6),
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}

class _LabelsToolbarButton extends StatelessWidget {
  const _LabelsToolbarButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.selected = false,
    this.accent = false,
  });

  final fluent.IconData icon;
  final String label;
  final bool enabled;
  final bool selected;
  final bool accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    final foreground = selected
        ? fluent.Colors.white
        : accent
        ? AppTheme.ACCENT_STEEL
        : theme.resources.textFillColorPrimary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: fluent.Button(
        onPressed: enabled ? onPressed : null,
        style: fluent.ButtonStyle(
          padding: const fluent.WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          backgroundColor: fluent.WidgetStatePropertyAll(
            selected ? AppTheme.ACCENT_STEEL : fluent.Colors.transparent,
          ),
          foregroundColor: fluent.WidgetStatePropertyAll(foreground),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            fluent.Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: foreground)),
          ],
        ),
      ),
    );
  }
}

class _LabelTreeRow extends StatelessWidget {
  const _LabelTreeRow({
    super.key,
    required this.name,
    required this.depth,
    required this.isRoot,
    required this.isSelected,
    required this.hasChildren,
    required this.isCollapsed,
    required this.onToggle,
    required this.onSelect,
    required this.onRename,
    required this.onDelete,
    required this.onAddChild,
  });

  static const double _INDENT_STEP = 16;
  static const double _TOGGLE_SLOT = 28;

  final String name;
  final int depth;
  final bool isRoot;
  final bool isSelected;
  final bool hasChildren;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final VoidCallback onSelect;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;
  final VoidCallback? onAddChild;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? MultimodalStudioPalette.PANEL_ACCENT
        : MultimodalStudioPalette.PANEL_INK;
    return ColoredBox(
      color: isSelected
          ? MultimodalStudioPalette.PANEL_ACCENT_FILL
          : const Color(0x00000000),
      child: Padding(
        padding: EdgeInsets.only(left: 4 + depth * _INDENT_STEP),
        child: Row(
          children: [
            if (hasChildren)
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: _TOGGLE_SLOT,
                  height: _TOGGLE_SLOT,
                ),
                onPressed: onToggle,
                icon: Icon(
                  isCollapsed ? Icons.chevron_right : Icons.expand_more,
                  size: 16,
                  color: MultimodalStudioPalette.PANEL_MUTED,
                ),
              )
            else
              const SizedBox(width: _TOGGLE_SLOT),
            Expanded(
              child: InkWell(
                onTap: onSelect,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: isRoot ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            if (onRename != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onRename,
                icon: Icon(Icons.edit_outlined, size: 14, color: color),
              ),
            if (onDelete != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
                icon: Icon(Icons.close, size: 14, color: color),
              ),
            if (onAddChild != null)
              SidePanelQuietButton(label: '아래에 추가', onPressed: onAddChild!),
          ],
        ),
      ),
    );
  }
}
