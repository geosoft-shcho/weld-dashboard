import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';
import '../../../../domain/entities/ask_answer.dart';
import '../../../../domain/entities/job_timeline.dart';
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
      VideoMultimodalSide.assets => 360.0,
      VideoMultimodalSide.properties => 360.0,
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
        children: [const _SectionLabel('ASSETS'), _assetTable(visible)],
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

class ClipDetailRow {
  const ClipDetailRow({required this.label, required this.value});

  final String label;
  final String value;
}

class ClipDetailSection {
  const ClipDetailSection({required this.title, required this.rows});

  final String title;
  final List<ClipDetailRow> rows;
}

const _SECTION_TITLES = [
  '클립',
  '파일 구간',
  '클립 파일',
  '만든 실행',
  '관계',
  '대상 클립',
  '대상 파일',
];

const _CLIP_KEYS = {
  'clipId',
  'trackId',
  'kind',
  'timelineStartNs',
  'timelineEndNs',
  'labelValueId',
  'description',
  'embeddedAt',
  'createdAt',
  'updatedAt',
};

const _FIELD_LABELS = {
  'clipId': '클립 번호',
  'trackId': '트랙 번호',
  'kind': '종류',
  'timelineStartNs': '타임라인 시작',
  'timelineEndNs': '타임라인 끝',
  'labelValueId': '라벨',
  'description': '설명',
  'embeddedAt': '임베딩 시각',
  'createdAt': '만든 시각',
  'updatedAt': '고친 시각',
  'source.assetId': '파일 번호',
  'source.startNs': '파일 시작',
  'source.endNs': '파일 끝',
  'source.locator': '위치',
  'asset': '상태',
  'asset.assetId': '파일 번호',
  'asset.kind': '종류',
  'asset.fileName': '파일 이름',
  'asset.sha256': 'SHA-256',
  'asset.mimeType': 'MIME',
  'asset.sizeBytes': '크기',
  'asset.properties': '속성',
  'asset.equipmentId': '장비 번호',
  'asset.collectedAt': '수집 시각',
  'asset.recordedAt': '기록 시각',
  'asset.durationNs': '길이',
  'asset.provenance.operation': '작업',
  'asset.provenance.runId': '실행 번호',
  'asset.provenance.toolId': '도구 번호',
  'asset.provenance.toolVersion': '도구 버전',
  'asset.provenance.parameters': '매개변수',
  'asset.provenance.parentAssetId': '부모 파일 번호',
  'asset.contentUrl': '내용 주소',
  'asset.childCount': '자식 수',
  'provenance.confidence': '확신도',
  'provenance.reviewed': '검토',
  'provenance.runId': '실행 번호',
  'provenance.toolId': '도구 번호',
  'provenance.toolVersion': '도구 버전',
  'provenance.targetKind': '대상 종류',
  'provenance.targetId': '대상',
  'relation.fromClipId': '시작 클립',
  'relation.toClipId': '끝 클립',
  'targetClip': '상태',
  'targetClip.clipId': '클립 번호',
  'targetClip.kind': '종류',
  'targetClip.timelineStartNs': '타임라인 시작',
  'targetClip.timelineEndNs': '타임라인 끝',
  'targetAsset': '상태',
  'targetAsset.assetId': '파일 번호',
  'targetAsset.kind': '종류',
  'targetAsset.fileName': '파일 이름',
  'targetAsset.contentUrl': '내용 주소',
};

List<ClipDetailSection> groupClipDetailFields(List<ClipField> fields) {
  final buckets = <String, List<ClipDetailRow>>{
    for (final title in _SECTION_TITLES) title: <ClipDetailRow>[],
  };
  final clipExtras = <ClipDetailRow>[];
  for (final field in fields) {
    final title = _sectionTitle(field.label);
    final row = ClipDetailRow(
      label: _fieldLabel(field.label),
      value: field.value,
    );
    if (title == '클립' && !_CLIP_KEYS.contains(field.label)) {
      clipExtras.add(row);
      continue;
    }
    buckets[title]!.add(row);
  }
  buckets['클립']!.addAll(clipExtras);

  final sections = <ClipDetailSection>[];
  for (final title in _SECTION_TITLES) {
    final rows = buckets[title]!;
    if (rows.isEmpty) {
      continue;
    }
    if (title == '관계' && rows.every((row) => row.value == '—')) {
      continue;
    }
    sections.add(ClipDetailSection(title: title, rows: rows));
  }
  return sections;
}

String _sectionTitle(String key) {
  if (key == 'asset' || key.startsWith('asset.')) {
    return '클립 파일';
  }
  if (key.startsWith('source.')) {
    return '파일 구간';
  }
  if (key.startsWith('provenance.')) {
    return '만든 실행';
  }
  if (key.startsWith('relation.')) {
    return '관계';
  }
  if (key == 'targetClip' || key.startsWith('targetClip.')) {
    return '대상 클립';
  }
  if (key == 'targetAsset' || key.startsWith('targetAsset.')) {
    return '대상 파일';
  }
  return '클립';
}

String _fieldLabel(String key) {
  final known = _FIELD_LABELS[key];
  if (known != null) {
    return known;
  }
  const assetProvenance = 'asset.provenance.';
  if (!key.startsWith(assetProvenance)) {
    return key;
  }
  final provenanceKey = 'provenance.${key.substring(assetProvenance.length)}';
  return _FIELD_LABELS[provenanceKey] ?? key;
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
          else if (clip == null)
            ColoredBox(
              color: MultimodalStudioPalette.PANEL_PAPER,
              child: Column(
                children: [
                  const _DataRow([
                    _DataCell('항목', isHeader: true, flex: 1),
                    _DataCell('값', isHeader: true, flex: 1),
                  ], isHeader: true),
                  _DataRow([
                    const _DataCell('이름', flex: 2),
                    _DataCell(bar!.fileName, flex: 3),
                  ]),
                  _DataRow([
                    const _DataCell('유형', flex: 2),
                    _DataCell(bar.fileTypeLabel, flex: 3),
                  ]),
                  _DataRow([
                    const _DataCell('구간', flex: 2),
                    _DataCell(viewModel.playheadLabel, flex: 3),
                  ]),
                  if (bar.note.isNotEmpty)
                    _DataRow([
                      const _DataCell('메모', flex: 2),
                      _DataCell(bar.note, flex: 3),
                    ]),
                ],
              ),
            )
          else if (viewModel.isClipDetailLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: fluent.ProgressBar(strokeWidth: 2),
              ),
            )
          else
            ..._clipDetailChildren(),
        ],
      ),
      foot: const _FootNote('타임라인에서 고른 클립과 같은 시각의 수집값입니다.'),
    );
  }

  List<Widget> _clipDetailChildren() {
    final message = viewModel.clipDetailMessage;
    final sections = groupClipDetailFields(viewModel.clipDetailFields);
    if (message.isNotEmpty && sections.isEmpty) {
      return [_detailMessage(message)];
    }
    return [
      if (message.isNotEmpty) _detailMessage(message),
      for (final section in sections) ...[
        _SectionLabel(section.title),
        _PropertyTable(rows: section.rows),
      ],
    ];
  }
}

class _PropertyTable extends StatelessWidget {
  const _PropertyTable({required this.rows});

  final List<ClipDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MultimodalStudioPalette.PANEL_PAPER,
      child: Column(
        children: [
          const _DataRow([
            _DataCell('항목', isHeader: true, flex: 1),
            _DataCell('값', isHeader: true, flex: 1),
          ], isHeader: true),
          for (final row in rows)
            _DataRow([
              _DataCell(row.label, flex: 1),
              _DataCell(row.value, flex: 1),
            ]),
        ],
      ),
    );
  }
}

Widget _detailMessage(String message) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Text(
      message,
      style: const TextStyle(
        color: MultimodalStudioPalette.PANEL_MUTED,
        fontSize: 11,
      ),
    ),
  );
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
    final viewModel = widget.viewModel;
    final turns = viewModel.askTurns;
    final playheadSeconds = viewModel.playheadSeconds;
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
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                for (final turn in turns)
                  _AskMessage(
                    turn: turn,
                    playheadSeconds: playheadSeconds,
                    viewModel: viewModel,
                  ),
                if (viewModel.isAsking) const _AskPending(),
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: _fieldTextStyle,
                    cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
                    decoration: _fieldDecoration('영상 내용에 대해 질문하세요'),
                    onSubmitted: widget.viewModel.isAsking
                        ? null
                        : (_) => _send(),
                  ),
                ),
                const SizedBox(width: 4),
                _AccentButton(
                  label: '전송',
                  onPressed: widget.viewModel.isAsking ? null : _send,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AskMessage extends StatelessWidget {
  const _AskMessage({
    required this.turn,
    required this.playheadSeconds,
    required this.viewModel,
  });

  final AskTurn turn;
  final double playheadSeconds;
  final VideoMultimodalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      constraints: turn.isUser ? const BoxConstraints(maxWidth: 240) : null,
      decoration: BoxDecoration(
        color: turn.isUser
            ? MultimodalStudioPalette.PANEL_ACCENT_FILL
            : MultimodalStudioPalette.PANEL_PAPER,
        border: Border.all(color: MultimodalStudioPalette.PANEL_LINE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            turn.text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: MultimodalStudioPalette.PANEL_INK,
            ),
          ),
          for (var index = 0; index < turn.citations.length; index++)
            _AskCitationCard(
              index: index,
              citation: turn.citations[index],
              isSelected: _isCitationAtPlayhead(
                playheadSeconds,
                turn.citations[index],
              ),
              viewModel: viewModel,
            ),
        ],
      ),
    );
    if (turn.isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }
    return SizedBox(width: double.infinity, child: bubble);
  }
}

class _AskCitationCard extends StatefulWidget {
  const _AskCitationCard({
    required this.index,
    required this.citation,
    required this.isSelected,
    required this.viewModel,
  });

  final int index;
  final AskCitation citation;
  final bool isSelected;
  final VideoMultimodalViewModel viewModel;

  @override
  State<_AskCitationCard> createState() => _AskCitationCardState();
}

class _AskCitationCardState extends State<_AskCitationCard> {
  final TextEditingController _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _registerComment(AskCitation citation) async {
    final saved = await widget.viewModel.didCommentCitation(
      citation,
      _comment.text,
    );
    if (saved && mounted) {
      _comment.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final citation = widget.citation;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AskCitationButton(
            index: widget.index,
            citation: citation,
            isSelected: widget.isSelected,
            onPressed: () => widget.viewModel.didTapCitation(citation),
          ),
          Row(
            children: [
              IconButton(
                tooltip: '좋아요',
                visualDensity: VisualDensity.compact,
                onPressed: () => widget.viewModel.didLikeCitation(citation),
                icon: const Icon(
                  fluent.FluentIcons.like,
                  size: 16,
                  color: MultimodalStudioPalette.PANEL_INK,
                ),
              ),
              IconButton(
                tooltip: '싫어요',
                visualDensity: VisualDensity.compact,
                onPressed: () => widget.viewModel.didDislikeCitation(citation),
                icon: const Icon(
                  fluent.FluentIcons.dislike,
                  size: 16,
                  color: MultimodalStudioPalette.PANEL_INK,
                ),
              ),
              Expanded(
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _comment,
                          style: _fieldTextStyle,
                          cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
                          decoration: _fieldDecoration('코멘트를 입력하세요'),
                          onSubmitted: (_) => _registerComment(citation),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _AccentButton(
                        label: '등록',
                        onPressed: () => _registerComment(citation),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AskCitationButton extends StatelessWidget {
  const _AskCitationButton({
    required this.index,
    required this.citation,
    required this.isSelected,
    required this.onPressed,
  });

  final int index;
  final AskCitation citation;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final range =
        '${_citationClock(citation.startSeconds)}–${_citationClock(citation.endSeconds)}';
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: MultimodalStudioPalette.PANEL_INK,
        backgroundColor: isSelected
            ? MultimodalStudioPalette.PANEL_ACCENT_FILL
            : MultimodalStudioPalette.PANEL_PAGE,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: const Size.fromHeight(36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: BorderSide(
          color: isSelected
              ? MultimodalStudioPalette.PANEL_ACCENT
              : MultimodalStudioPalette.PANEL_LINE,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${_citationTitle(citation.text)}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            range,
            style: const TextStyle(
              fontSize: 11,
              color: MultimodalStudioPalette.PANEL_MUTED,
            ),
          ),
        ],
      ),
    );
  }
}

class _AskPending extends StatelessWidget {
  const _AskPending();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        '답변을 찾는 중입니다.',
        style: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: MultimodalStudioPalette.PANEL_MUTED,
        ),
      ),
    );
  }
}

bool _isCitationAtPlayhead(double playheadSeconds, AskCitation citation) {
  return (playheadSeconds - citation.startSeconds).abs() < 0.05;
}

String _citationTitle(String text) {
  final parts = [
    for (final part in text.split('|'))
      if (part.trim().isNotEmpty) part.trim(),
  ];
  if (parts.isEmpty) {
    return '근거 영상';
  }
  final title = parts.length >= 4 ? parts[3] : parts.last;
  for (final part in parts) {
    if (part.startsWith('job=')) {
      return '$title · 작업 ${part.substring(4)}';
    }
  }
  return title;
}

String _citationClock(double seconds) {
  final whole = seconds.floor().clamp(0, 86400);
  final hours = whole ~/ 3600;
  final minutes = (whole % 3600) ~/ 60;
  final remain = whole % 60;
  final minuteText = minutes.toString().padLeft(2, '0');
  final secondText = remain.toString().padLeft(2, '0');
  if (hours > 0) {
    return '$hours:$minuteText:$secondText';
  }
  return '$minuteText:$secondText';
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            _AccentButton(
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
