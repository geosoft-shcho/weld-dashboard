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

class AssetsSideBody extends StatefulWidget {
  const AssetsSideBody({
    super.key,
    required this.viewModel,
    required this.onClose,
  });

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  State<AssetsSideBody> createState() => _AssetsSideBodyState();
}

class _AssetsSideBodyState extends State<AssetsSideBody> {
  late final TextEditingController _searchController;

  VideoMultimodalViewModel get viewModel => widget.viewModel;
  VoidCallback get onClose => widget.onClose;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: viewModel.assetsSearchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _resetAssets() async {
    _searchController.clear();
    await viewModel.didTapResetAssets();
  }

  @override
  Widget build(BuildContext context) {
    return SidePanelFrame(
      head: _head(),
      body: ColoredBox(
        color: MultimodalStudioPalette.PANEL_PAPER,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SidePanelDataRow([
              SidePanelDataCell('', flex: 1, isHeader: true),
              SidePanelDataCell('이름', isHeader: true, flex: 4),
              SidePanelDataCell('유형', isHeader: true, flex: 4),
              SidePanelDataCell('길이', isHeader: true, flex: 2),
            ], isHeader: true),
            Expanded(child: _tableBody()),
          ],
        ),
      ),
      foot: _pager(),
    );
  }

  Widget _head() {
    return SidePanelHead(
      onClose: onClose,
      leading: TextField(
        controller: _searchController,
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
        SidePanelAccentButton(
          label: '초기화',
          onPressed: viewModel.isLoadingAssetsPage ? null : _resetAssets,
        ),
      ],
    );
  }

  Widget _tableBody() {
    final rows = viewModel.assetsPageRows;
    if (viewModel.isLoadingAssetsPage && rows.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          '에셋이 없습니다.',
          style: TextStyle(
            color: MultimodalStudioPalette.PANEL_MUTED,
            fontSize: 11,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) => _assetRow(rows[index]),
    );
  }

  Widget _pager() {
    final pageCount = viewModel.assetsPageCount;
    final current = viewModel.assetsPageIndex;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.PANEL_PAPER,
        border: Border(
          top: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
        ),
      ),
      child: Row(
        children: [
          Text(
            viewModel.isLoadingAssetsPage
                ? '불러오는 중…'
                : '${viewModel.assetsTotalCount}개',
            style: const TextStyle(
              color: MultimodalStudioPalette.PANEL_MUTED,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          for (var page = 1; page <= pageCount; page++) ...[
            if (page > 1) const SizedBox(width: 4),
            _pageButton(page: page, isSelected: page == current),
          ],
        ],
      ),
    );
  }

  Widget _pageButton({required int page, required bool isSelected}) {
    return SizedBox(
      height: 24,
      child: TextButton(
        onPressed: isSelected || viewModel.isLoadingAssetsPage
            ? null
            : () => viewModel.didSelectAssetsPage(page),
        style: TextButton.styleFrom(
          minimumSize: const Size(28, 24),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          foregroundColor: isSelected
              ? MultimodalStudioPalette.PANEL_ACCENT
              : MultimodalStudioPalette.PANEL_INK,
          textStyle: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        child: Text('$page'),
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
        SidePanelDataCell.dot(
          _DOT_COLOR[attachment.fileType] ?? const Color(0xFF888888),
        ),
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
