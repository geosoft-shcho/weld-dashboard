import 'package:connectrpc/connect.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/asset_lookup_kind.dart';
import '../../../../domain/entities/asset_lookup_row.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/screen_command_bar.dart';
import '../../../core/widgets/section_empty_placeholder.dart';
import '../../../navigation/app_coordinator.dart';
import '../../asset_lookup/asset_attach_dialog.dart';
import '../../asset_lookup/asset_upload_dialog.dart';
import '../../auth/auth_session_view_model.dart';
import '../job_lookup_detail_view_model.dart';
import 'job_detail_action_bar.dart';

const double _kAttachmentColId = 70;
const double _kAttachmentColKind = 90;
const double _kAttachmentColPostprocess = 120;
const double _kAttachmentColPass = 130;
const double _kAttachmentColActionsGap = 4;
const double _kAttachmentColActions = 220;

class JobAttachmentTab extends StatefulWidget {
  const JobAttachmentTab({super.key, required this.viewModel});

  final JobLookupDetailViewModel viewModel;

  @override
  State<JobAttachmentTab> createState() => _JobAttachmentTabState();
}

class _JobAttachmentTabState extends State<JobAttachmentTab> {
  bool _isWorking = false;

  JobLookupDetailViewModel get _viewModel => widget.viewModel;

  String _passIdOf(AssetLookupRow row) {
    if (row.attachmentPassId.isEmpty ||
        row.attachmentPassId == jobCommonPassToken) {
      return '';
    }
    for (final pass in _viewModel.passes) {
      if (pass.passId == row.attachmentPassId) return row.attachmentPassId;
    }
    return '';
  }

  String _userFacingError(Object error) {
    if (error is ConnectException) {
      final message = error.message.trim();
      if (message.isNotEmpty) return message;
    }
    return error.toString();
  }

  Future<void> _showErrorDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  bool _isClipDetachBlock(ConnectException error) {
    return error.code == Code.failedPrecondition &&
        error.message.contains('clip_job_id_source_asset_id_fkey');
  }

  bool _isCommentDetachBlock(ConnectException error) {
    if (error.code != Code.failedPrecondition) return false;
    final message = error.message;
    return message.contains('코멘트') || message.contains('DeleteComment');
  }

  Future<void> _showDetachFailureDialog({
    required String assetId,
    required Object error,
  }) async {
    if (!mounted) return;
    if (error is! ConnectException) {
      await _showErrorDialog('첨부를 해제할 수 없습니다', _userFacingError(error));
      return;
    }
    if (_isClipDetachBlock(error)) {
      final canOpenVideo = context.read<AuthSessionViewModel>()
          .canAccessVideoMultimodal;
      final openTimeline = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => ContentDialog(
          title: const Text('첨부를 해제할 수 없습니다'),
          content: Text(
            '자료 $assetId를 쓰는 타임라인 클립이 있어 첨부를 뗄 수 없습니다.\n'
            '타임라인에서 해당 자료 클립을 지운 뒤 다시 첨부 해제를 누르세요.\n'
            '클립 삭제는 되돌릴 수 없습니다.',
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('닫기'),
            ),
            FilledButton(
              onPressed: canOpenVideo
                  ? () => Navigator.of(dialogContext).pop(true)
                  : null,
              child: const Text('타임라인으로 이동'),
            ),
          ],
        ),
      );
      if (openTimeline == true && mounted) {
        context.read<AppCoordinator>().didTapOpenVideoMultimodal(
          context,
          jobId: _viewModel.jobId,
        );
      }
      return;
    }
    if (_isCommentDetachBlock(error)) {
      await _showErrorDialog(
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
      await _showErrorDialog('첨부를 해제할 수 없습니다', body);
      return;
    }
    await _showErrorDialog('첨부를 해제할 수 없습니다', _userFacingError(error));
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _isWorking = true);
    try {
      await action();
    } catch (error) {
      await _showErrorDialog('요청을 처리할 수 없습니다', _userFacingError(error));
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _didTapDetach(String assetId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('첨부를 해제할까요?'),
        content: const Text('이 작업에서만 떼어냅니다. 파일 자체는 남습니다.'),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('해제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _isWorking = true);
    try {
      await _viewModel.detachAsset(assetId);
    } catch (error) {
      await _showDetachFailureDialog(assetId: assetId, error: error);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _didTapUploadToJob() async {
    final result = await showAssetUploadDialog(
      context,
      jobs: _viewModel.uploadJobs,
      equipment: _viewModel.equipment,
      initialJobId: _viewModel.jobId,
      initialPassId: '',
      lockJob: true,
      loadFormats: _viewModel.loadUploadFormats,
      pickFiles: _viewModel.pickUploadFiles,
      uploadQueue: _viewModel.uploadAssetQueue,
      retryPostprocess: _viewModel.retryPostprocess,
    );
    if (result == null || !result.hasSuccess || !mounted) return;
    await _run(_viewModel.didFinishUpload);
    if (!mounted) return;
    final notes = [...result.warningNotes, ...result.failureNotes];
    if (notes.isEmpty) return;
    await displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: const Text('업로드 완료'),
          content: Text(notes.join('\n')),
          severity: InfoBarSeverity.warning,
          onClose: close,
        );
      },
    );
  }

  Future<void> _didTapAttach() async {
    final result = await showAssetAttachDialog(
      context: context,
      loadPage: _viewModel.listAttachCandidates,
      passes: [
        for (final pass in _viewModel.passes)
          AssetAttachPassOption(passId: pass.passId, passNo: pass.passNo),
      ],
      excludedAssetIds: {
        for (final row in _viewModel.attachments) row.assetId,
      },
    );
    if (result == null || result.assetIds.isEmpty) return;
    await _run(
      () => _viewModel.attachAssets(
        assetIds: result.assetIds,
        passId: result.passId,
      ),
    );
  }

  Widget _passCombo({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return ComboBox<String>(
      isExpanded: true,
      value: value,
      items: [
        const ComboBoxItem(value: '', child: Text('작업 공용')),
        for (final pass in _viewModel.passes)
          ComboBoxItem(value: pass.passId, child: Text('${pass.passNo}패스')),
      ],
      onChanged: _isWorking ? null : onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isWorking ||
            _viewModel.isLoadingAttachments ||
            _viewModel.isLoadingMoreAttachments)
          const ProgressBar(),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter < 240) {
                _viewModel.didScrollAttachmentsNearEnd();
              }
              return false;
            },
            child: ListView(
              children: [
                JobDetailActionBar(
                  leading: _viewModel.didLoadAttachments
                      ? Text('전체 첨부 ${_viewModel.attachmentTotalCount}건')
                      : null,
                  items: [
                    CommandBarButton(
                      icon: const Icon(FluentIcons.upload, size: 12),
                      label: const CommandBarLabel('파일 업로드'),
                      onPressed: _isWorking || _viewModel.isLoadingAttachments
                          ? null
                          : _didTapUploadToJob,
                    ),
                    CommandBarButton(
                      icon: const Icon(FluentIcons.attach, size: 12),
                      label: const CommandBarLabel('파일 첨부'),
                      onPressed: _isWorking || _viewModel.isLoadingAttachments
                          ? null
                          : _didTapAttach,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_viewModel.isLoadingAttachments &&
                    _viewModel.attachments.isEmpty)
                  const SizedBox.shrink()
                else if (_viewModel.attachments.isEmpty)
                  const SectionEmptyPlaceholder(
                    title: '첨부가 없습니다',
                    message: '이 작업에 업로드하거나 이미 있는 파일을 첨부할 수 있습니다.',
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.SURFACE_RAISED,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF3E424A)),
                    ),
                    child: Column(
                      children: [
                        const _JobAttachmentTableHeader(),
                        for (final row in _viewModel.attachments)
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFF3E424A)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: _kAttachmentColId,
                                    child: Text(row.assetId),
                                  ),
                                  SizedBox(
                                    width: _kAttachmentColKind,
                                    child: Text(
                                      AssetLookupKindOption.labelOf(
                                        row.kindCode,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      row.fileName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _kAttachmentColPostprocess,
                                    child: _JobAttachmentPostprocessCell(
                                      postprocess: row.postprocess,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _kAttachmentColPass,
                                    child: _passCombo(
                                      value: _passIdOf(row),
                                      onChanged: (value) {
                                        if (value == null) return;
                                        _run(
                                          () => _viewModel.changeAttachmentPass(
                                            assetId: row.assetId,
                                            passId: value,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: _kAttachmentColActionsGap,
                                  ),
                                  SizedBox(
                                    width: _kAttachmentColActions,
                                    child: Row(
                                      children: [
                                        Button(
                                          onPressed:
                                              _isWorking || row.assetId.isEmpty
                                              ? null
                                              : () => context
                                                    .read<AppCoordinator>()
                                                    .didTapOpenAssetDetail(
                                                      row.assetId,
                                                    ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                FluentIcons.red_eye,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                '자세히 보기',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Button(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                  AppTheme.STATUS_ERROR,
                                                ),
                                          ),
                                          onPressed: _isWorking
                                              ? null
                                              : () =>
                                                    _didTapDetach(row.assetId),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                FluentIcons.remove_link,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                '첨부 해제',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JobAttachmentTableHeader extends StatelessWidget {
  const _JobAttachmentTableHeader();

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600);
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF32363C),
        border: Border(bottom: BorderSide(color: Color(0xFF3E424A))),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: _kAttachmentColId,
              child: Text('번호', style: headerStyle),
            ),
            SizedBox(
              width: _kAttachmentColKind,
              child: Text('종류', style: headerStyle),
            ),
            Expanded(child: Text('파일', style: headerStyle)),
            SizedBox(
              width: _kAttachmentColPostprocess,
              child: Text('후처리', style: headerStyle),
            ),
            SizedBox(
              width: _kAttachmentColPass,
              child: Text('패스', style: headerStyle),
            ),
            SizedBox(width: _kAttachmentColActionsGap),
            SizedBox(
              width: _kAttachmentColActions,
              child: Text('기능', style: headerStyle),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobAttachmentPostprocessCell extends StatelessWidget {
  const _JobAttachmentPostprocessCell({required this.postprocess});

  final AssetPostprocessSummary postprocess;

  @override
  Widget build(BuildContext context) {
    if (postprocess.isEmpty) {
      return Text(
        '—',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withValues(alpha: 0.55),
        ),
      );
    }
    final label = AssetPostprocessStatusOption.labelOf(postprocess.statusCode);
    final isFailed = postprocess.isFailed;
    final isCanceled = postprocess.statusCode == 'canceled';
    final emphasize = isFailed || isCanceled;
    final color = isFailed
        ? Colors.red
        : isCanceled
        ? const Color(0xFFE8A838)
        : null;
    final content = Row(
      children: [
        if (emphasize) ...[
          Icon(
            isFailed ? FluentIcons.error_badge : FluentIcons.warning,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ),
      ],
    );
    final reason = postprocess.errorMessage.trim();
    if (!emphasize || reason.isEmpty) {
      return content;
    }
    return Tooltip(message: reason, child: content);
  }
}
