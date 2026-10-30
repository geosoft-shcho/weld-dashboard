import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../../domain/entities/work_attachment.dart';
import '../../../../domain/entities/work_attachment_type.dart';
import '../../../../domain/timeline_time.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'side_panel_chrome.dart';

const Map<WorkAttachmentType, Color> _DOT_COLOR = {
  WorkAttachmentType.video: Color(0xFF44AA44),
  WorkAttachmentType.audio: Color(0xFFAA8844),
  WorkAttachmentType.image: Color(0xFF4488AA),
  WorkAttachmentType.pdf: Color(0xFF888888),
  WorkAttachmentType.text: Color(0xFF888888),
};

class AssetsSideBody extends StatelessWidget {
  const AssetsSideBody({
    super.key,
    required this.viewModel,
    required this.onClose,
  });

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
    return SidePanelFrame(
      head: _head(),
      body: ListView(children: [_assetTable(visible)]),
    );
  }

  Widget _head() {
    return SidePanelHead(
      onClose: onClose,
      leading: TextField(
        style: sidePanelFieldTextStyle,
        cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
        decoration: sidePanelFieldDecoration('검색…').copyWith(
          prefixIcon: const Icon(
            fluent.FluentIcons.search,
            size: 14,
            color: MultimodalStudioPalette.PANEL_MUTED,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 28,
          ),
        ),
        onChanged: viewModel.didChangeAssetsSearch,
      ),
      actions: [
        // SidePanelAccentButton(
        //   label: 'Import',
        //   onPressed: () => viewModel.didShowNotice('Import는 다음 단계에서 연결됩니다.'),
        // ),
      ],
    );
  }

  Widget _assetTable(List<WorkAttachment> visible) {
    return ColoredBox(
      color: MultimodalStudioPalette.PANEL_PAPER,
      child: Column(
        children: [
          const SidePanelDataRow([
            SidePanelDataCell('', flex: 1, isHeader: true),
            SidePanelDataCell('이름', isHeader: true, flex: 4),
            SidePanelDataCell('유형', isHeader: true, flex: 4),
            SidePanelDataCell('길이', isHeader: true, flex: 2),
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
    final row = SidePanelDataRow(
      [
        SidePanelDataCell.dot(_DOT_COLOR[attachment.fileType]!),
        SidePanelDataCell(attachment.fileName, flex: 4),
        SidePanelDataCell(
          WorkAttachmentType.extensionOf(attachment.fileName),
          flex: 4,
          badge: isLocked ? '편집 금지' : '',
        ),
        SidePanelDataCell(_durationLabel(attachment), flex: 2),
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
          child: Text(attachment.fileName, style: sidePanelFieldTextStyle),
        ),
      ),
      child: row,
    );
  }

  String _durationLabel(WorkAttachment attachment) {
    final seconds = secondsFromNanoseconds(attachment.durationNs);
    if (seconds <= 0) {
      return '—';
    }
    final whole = seconds.floor();
    final minutes = whole ~/ 60;
    final remain = (whole % 60).toString().padLeft(2, '0');
    return '$minutes:$remain';
  }
}
