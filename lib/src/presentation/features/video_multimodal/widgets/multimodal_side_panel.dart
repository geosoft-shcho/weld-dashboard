import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';
import '../../../../domain/entities/label_vocab.dart';
import '../../../../domain/entities/work_attachment.dart';
import '../../../../domain/entities/work_attachment_type.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_dialogs.dart';
import 'multimodal_studio_palette.dart';

const Map<WorkAttachmentType, Color> _DOT_COLOR = {
  WorkAttachmentType.video: Color(0xFF44AA44),
  WorkAttachmentType.audio: Color(0xFFAA8844),
  WorkAttachmentType.image: Color(0xFF4488AA),
  WorkAttachmentType.pdf: Color(0xFF888888),
  WorkAttachmentType.text: Color(0xFF888888),
};

class MultimodalSidePanel extends StatelessWidget {
  const MultimodalSidePanel({
    super.key,
    required this.viewModel,
    required this.onClose,
  });

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final width = switch (viewModel.side) {
      VideoMultimodalSide.ask => 360.0,
      VideoMultimodalSide.assets => 300.0,
      VideoMultimodalSide.properties => 300.0,
      _ => 320.0,
    };
    return WorkDetailMaterialScope(
      child: Material(
        color: MultimodalStudioPalette.PANEL_PAGE,
        child: SizedBox(
          width: width,
          child: switch (viewModel.side) {
            VideoMultimodalSide.assets => _AssetsBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.properties => _PropertiesBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.ask => _AskBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.labels => _LabelsBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.none => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

class _PanelFrame extends StatelessWidget {
  const _PanelFrame({required this.head, required this.body, this.foot});

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

class _PanelHead extends StatelessWidget {
  const _PanelHead({
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

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

class _FootNote extends StatelessWidget {
  const _FootNote(this.text);

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

class _AccentButton extends StatelessWidget {
  const _AccentButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: MultimodalStudioPalette.PANEL_ACCENT,
        foregroundColor: MultimodalStudioPalette.PANEL_PAGE,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

class _QuietButton extends StatelessWidget {
  const _QuietButton({required this.label, required this.onPressed});

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

InputDecoration _fieldDecoration(String hintText) {
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

const TextStyle _fieldTextStyle = TextStyle(
  fontSize: 11,
  color: MultimodalStudioPalette.PANEL_INK,
);

class _DataRow extends StatelessWidget {
  const _DataRow(
    this.cells, {
    this.isHeader = false,
    this.isMuted = false,
    this.isSelected = false,
    this.onTap,
  });

  final List<_DataCell> cells;
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

class _DataCell {
  const _DataCell(
    this.text, {
    this.flex = 1,
    this.isHeader = false,
    this.badge = '',
  }) : dot = null;

  const _DataCell.dot(this.dot)
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
              overflow: TextOverflow.ellipsis,
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

class _AssetsBody extends StatelessWidget {
  const _AssetsBody({required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final query = viewModel.assetsSearchQuery.trim().toLowerCase();
    final visible = [
      for (final attachment in viewModel.attachments)
        if (query.isEmpty || attachment.fileName.toLowerCase().contains(query))
          attachment,
    ];
    return _PanelFrame(
      head: _head(),
      body: ListView(
        children: [
          const _SectionLabel('ASSETS'),
          _assetTable(visible),
          const _SectionLabel('LAYERS · 시퀀스'),
          _layerTable(),
        ],
      ),
      foot: const _FootNote('VIDEO/AUDIO 편집 금지 · 서버 트랙에 놓으면 클립이 생깁니다.'),
    );
  }

  Widget _head() {
    return _PanelHead(
      onClose: onClose,
      leading: TextField(
        style: _fieldTextStyle,
        cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
        decoration: _fieldDecoration('검색…'),
        onChanged: viewModel.didChangeAssetsSearch,
      ),
      actions: [
        _AccentButton(
          label: 'Import',
          onPressed: () => viewModel.didShowNotice('Import는 다음 단계에서 연결됩니다.'),
        ),
      ],
    );
  }

  Widget _assetTable(List<WorkAttachment> visible) {
    return ColoredBox(
      color: MultimodalStudioPalette.PANEL_PAPER,
      child: Column(
        children: [
          const _DataRow([
            _DataCell('', flex: 1, isHeader: true),
            _DataCell('이름', isHeader: true, flex: 4),
            _DataCell('유형', isHeader: true, flex: 4),
            _DataCell('길이', isHeader: true, flex: 2),
          ], isHeader: true),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '에셋이 없습니다.',
                style: TextStyle(
                  color: MultimodalStudioPalette.PANEL_MUTED,
                  fontSize: 11,
                ),
              ),
            )
          else
            for (final attachment in visible) _assetRow(attachment),
        ],
      ),
    );
  }

  Widget _assetRow(WorkAttachment attachment) {
    final isLocked =
        attachment.fileType == WorkAttachmentType.video ||
        attachment.fileType == WorkAttachmentType.audio;
    final isSelected =
        viewModel.selectedAttachment?.attachmentId == attachment.attachmentId;
    final row = _DataRow(
      [
        _DataCell.dot(_DOT_COLOR[attachment.fileType]!),
        _DataCell(attachment.fileName, flex: 4),
        _DataCell(
          WorkAttachmentType.extensionOf(attachment.fileName),
          flex: 4,
          badge: isLocked ? '편집 금지' : '',
        ),
        _DataCell(_durationLabel(attachment), flex: 2),
      ],
      isMuted: isLocked,
      isSelected: isSelected,
      onTap: () => viewModel.didTapBar(attachment.attachmentId),
    );
    return Draggable<String>(
      data:
          '${VideoMultimodalViewModel.ASSET_DRAG_PREFIX}${attachment.attachmentId}',
      feedback: Material(
        color: MultimodalStudioPalette.PANEL_PAPER,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(attachment.fileName, style: _fieldTextStyle),
        ),
      ),
      child: row,
    );
  }

  Widget _layerTable() {
    final layers = viewModel.sampleLayers;
    return ColoredBox(
      color: MultimodalStudioPalette.PANEL_PAPER,
      child: Column(
        children: [
          const _DataRow([
            _DataCell('이름', isHeader: true, flex: 4),
            _DataCell('유형', isHeader: true, flex: 3),
            _DataCell('', isHeader: true, flex: 3),
          ], isHeader: true),
          if (layers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '레이어가 없습니다.',
                style: TextStyle(
                  color: MultimodalStudioPalette.PANEL_MUTED,
                  fontSize: 11,
                ),
              ),
            )
          else
            for (final layer in layers)
              _DataRow([
                _DataCell(layer.displayName, flex: 4),
                _DataCell(layer.kind, flex: 3),
                const _DataCell('', flex: 3),
              ]),
        ],
      ),
    );
  }

  String _durationLabel(WorkAttachment attachment) {
    for (final bar in viewModel.visibleBars) {
      if (bar.attachmentId != attachment.attachmentId) {
        continue;
      }
      final whole = (bar.endSeconds - bar.startSeconds).floor();
      final minutes = whole ~/ 60;
      final seconds = (whole % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
    return '—';
  }
}

class _PropertiesBody extends StatelessWidget {
  const _PropertiesBody({required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final clip = viewModel.selectedClip;
    final bar = viewModel.selectedBar;
    return _PanelFrame(
      head: _PanelHead(title: 'Properties', onClose: onClose),
      body: ListView(
        children: [
          const _SectionLabel('선택'),
          if (clip == null && bar == null)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '타임라인 클립을 선택하면 속성이 표시됩니다.',
                style: TextStyle(
                  color: MultimodalStudioPalette.PANEL_MUTED,
                  fontSize: 11,
                ),
              ),
            )
          else
            ColoredBox(
              color: MultimodalStudioPalette.PANEL_PAPER,
              child: Column(
                children: [
                  const _DataRow([
                    _DataCell('항목', isHeader: true, flex: 2),
                    _DataCell('값', isHeader: true, flex: 3),
                  ], isHeader: true),
                  _DataRow([
                    _DataCell(
                      clip != null && clip.hasLabel ? '라벨' : '이름',
                      flex: 2,
                    ),
                    _DataCell(clip?.text ?? bar!.fileName, flex: 3),
                  ]),
                  _DataRow([
                    _DataCell(clip == null ? '유형' : '레인', flex: 2),
                    _DataCell(
                      clip == null ? bar!.fileTypeLabel : clip.laneLabel,
                      flex: 3,
                    ),
                  ]),
                  _DataRow([
                    const _DataCell('구간', flex: 2),
                    _DataCell(
                      clip == null
                          ? viewModel.playheadLabel
                          : '${clip.startSeconds.toStringAsFixed(1)}–${clip.endSeconds.toStringAsFixed(1)}초',
                      flex: 3,
                    ),
                  ]),
                  if (bar != null && bar.note.isNotEmpty)
                    _DataRow([
                      const _DataCell('메모', flex: 2),
                      _DataCell(bar.note, flex: 3),
                    ]),
                ],
              ),
            ),
        ],
      ),
      foot: const _FootNote('타임라인에서 고른 클립과 같은 시각의 수집값입니다.'),
    );
  }
}

class _AskBody extends StatefulWidget {
  const _AskBody({required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  State<_AskBody> createState() => _AskBodyState();
}

class _AskBodyState extends State<_AskBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    widget.viewModel.didSendAsk(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final turns = widget.viewModel.askTurns;
    return _PanelFrame(
      head: _PanelHead(title: '영상 질의', onClose: widget.onClose),
      body: turns.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'STT 전사를 바탕으로 영상 구간을 질문해 보세요.\n예: 용접 장면',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MultimodalStudioPalette.PANEL_MUTED,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                for (final turn in turns)
                  Align(
                    alignment: turn.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: turn.isUser
                            ? MultimodalStudioPalette.PANEL_ACCENT_FILL
                            : MultimodalStudioPalette.PANEL_PAPER,
                        border: Border.all(
                          color: MultimodalStudioPalette.PANEL_LINE,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(turn.text, style: _fieldTextStyle),
                          if (turn.citationStartSeconds != null)
                            _QuietButton(
                              label:
                                  '${turn.citationStartSeconds!.toStringAsFixed(1)}–${turn.citationEndSeconds!.toStringAsFixed(1)}',
                              onPressed: () => widget.viewModel.didTapCitation(
                                turn.citationStartSeconds!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      foot: DecoratedBox(
        decoration: const BoxDecoration(
          color: MultimodalStudioPalette.PANEL_PAPER,
          border: Border(
            top: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: _fieldTextStyle,
                  cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
                  decoration: _fieldDecoration('영상 내용에 대해 질문하세요'),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 4),
              _AccentButton(label: '전송', onPressed: _send),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelsBody extends StatefulWidget {
  const _LabelsBody({required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  State<_LabelsBody> createState() => _LabelsBodyState();
}

class _LabelsBodyState extends State<_LabelsBody> {
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: _fieldTextStyle,
              cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
              decoration: _fieldDecoration('새 라벨 이름'),
            ),
          ),
          const SizedBox(width: 4),
          _AccentButton(label: '추가', onPressed: () => _addLabel(parentValueId)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PanelFrame(
      head: _PanelHead(title: 'Labels', onClose: widget.onClose),
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
          const _FootNote('붙이기를 누르면 고른 라벨이 선택 클립에 연결됩니다.'),
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
              _QuietButton(label: '아래에 추가', onPressed: onAddChild!),
          ],
        ),
      ),
    );
  }
}
