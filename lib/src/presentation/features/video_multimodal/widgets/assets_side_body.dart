import 'package:connectrpc/connect.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../../domain/entities/work_attachment.dart';
import '../../../../domain/entities/work_attachment_type.dart';
import '../../../../domain/timeline_time.dart';
import '../../asset_lookup/asset_attach_dialog.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
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
  bool _isDetaching = false;
  bool _isAttaching = false;

  VideoMultimodalViewModel get viewModel => widget.viewModel;
  VoidCallback get onClose => widget.onClose;

  bool get _isBusy =>
      _isDetaching || _isAttaching || viewModel.isLoadingAssetsPage;

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

  String _userFacingError(Object error) {
    if (error is ConnectException) {
      final message = error.message.trim();
      if (message.isNotEmpty) return message;
    }
    return error.toString();
  }

  Future<void> _showMessageDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return WorkDetailMaterialScope(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('닫기'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDetachFailureDialog({
    required String assetId,
    required Object error,
  }) async {
    if (!mounted) return;
    if (error is! ConnectException) {
      await _showMessageDialog('첨부를 해제할 수 없습니다', _userFacingError(error));
      return;
    }
    if (error.code == Code.failedPrecondition &&
        error.message.contains('clip_job_id_source_asset_id_fkey')) {
      await _showMessageDialog(
        '첨부를 해제할 수 없습니다',
        '자료 $assetId를 쓰는 타임라인 클립을 먼저 지우세요.\n'
            '클립 삭제는 되돌릴 수 없습니다.',
      );
      return;
    }
    if (error.code == Code.failedPrecondition &&
        (error.message.contains('코멘트') ||
            error.message.contains('DeleteComment'))) {
      await _showMessageDialog(
        '첨부를 해제할 수 없습니다',
        '코멘트가 이 녹화를 쓰고 있습니다. 코멘트를 먼저 지운 뒤 다시 첨부 해제를 누르세요.',
      );
      return;
    }
    if (error.code == Code.failedPrecondition) {
      final detail = error.message.trim();
      final body = detail.isEmpty
          ? '이 자료를 쓰는 클립이나 성적서 매칭이 남아 있을 수 있습니다. '
                '참조를 끊은 뒤 다시 첨부 해제를 누르세요.'
          : '이 자료를 쓰는 클립이나 성적서 매칭이 남아 있을 수 있습니다. '
                '참조를 끊은 뒤 다시 첨부 해제를 누르세요.\n$detail';
      await _showMessageDialog('첨부를 해제할 수 없습니다', body);
      return;
    }
    await _showMessageDialog('첨부를 해제할 수 없습니다', _userFacingError(error));
  }

  Future<void> _didTapAttach() async {
    if (_isBusy) return;
    await viewModel.ensureJobPasses();
    if (!mounted) return;
    final result = await showAssetAttachDialog(
      context: context,
      loadPage: viewModel.listAttachCandidates,
      passes: [
        for (final pass in viewModel.passes)
          AssetAttachPassOption(passId: pass.passId, passNo: pass.passNo),
      ],
      excludedAssetIds: {
        for (final row in viewModel.assetsPageRows) row.attachmentId,
      },
    );
    if (result == null || result.assetIds.isEmpty || !mounted) return;
    setState(() => _isAttaching = true);
    try {
      await viewModel.didTapAttachAssets(
        assetIds: result.assetIds,
        passId: result.passId,
      );
    } catch (error) {
      await _showMessageDialog('파일을 첨부할 수 없습니다', _userFacingError(error));
    } finally {
      if (mounted) setState(() => _isAttaching = false);
    }
  }

  Future<void> _didTapDetach(String assetId) async {
    if (_isBusy || assetId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return WorkDetailMaterialScope(
          child: AlertDialog(
            title: const Text('첨부를 해제할까요?'),
            content: const Text('이 작업에서만 떼어냅니다. 파일 자체는 남습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('해제'),
              ),
            ],
          ),
        );
      },
    );
    if (confirmed != true || !mounted) return;
    setState(() => _isDetaching = true);
    try {
      await viewModel.didTapDetachAsset(assetId);
    } catch (error) {
      await _showDetachFailureDialog(assetId: assetId, error: error);
    } finally {
      if (mounted) setState(() => _isDetaching = false);
    }
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
              SidePanelDataCell('번호', isHeader: true, flex: 3),
              SidePanelDataCell('이름', isHeader: true, flex: 4),
              SidePanelDataCell('유형', isHeader: true, flex: 3),
              SidePanelDataCell('길이', isHeader: true, flex: 2),
              SidePanelDataCell('첨부해제', isHeader: true, flex: 2),
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
        decoration: sidePanelFieldDecoration('번호·이름 검색…').copyWith(
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
        SidePanelQuietButton(
          icon: fluent.FluentIcons.attach,
          label: '파일 첨부',
          onPressed: _isBusy ? null : _didTapAttach,
        ),
        SidePanelAccentButton(
          icon: fluent.FluentIcons.refresh,
          label: '초기화',
          onPressed: _isBusy ? null : _resetAssets,
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
          '파일이 없습니다.',
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
        onPressed: isSelected || viewModel.isLoadingAssetsPage || _isDetaching
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
        SidePanelDataCell(attachment.attachmentId, flex: 3),
        SidePanelDataCell(attachment.fileName, flex: 4),
        SidePanelDataCell(
          WorkAttachmentType.extensionOf(attachment.fileName),
          flex: 3,
          badge: isLocked ? '편집 금지' : '',
        ),
        SidePanelDataCell(_durationLabel(attachment), flex: 2),
        SidePanelDataCell.child(
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: '첨부 해제',
            onPressed: _isBusy || attachment.attachmentId.isEmpty
                ? null
                : () => _didTapDetach(attachment.attachmentId),
              icon: const Icon(
                Icons.link_off,
                size: 16,
                color: MultimodalStudioPalette.PANEL_DANGER,
              ),
            ),
          ),
          flex: 2,
        ),
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
