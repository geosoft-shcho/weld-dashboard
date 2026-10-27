import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/asset_lookup_kind.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/section_empty_placeholder.dart';
import '../../../core/widgets/command_bar_widget_item.dart';
import '../../../core/widgets/screen_command_bar.dart';
import '../../asset_lookup/asset_upload_dialog.dart';
import '../../../../domain/entities/asset_lookup_row.dart';
import '../job_lookup_detail_view_model.dart';
import 'job_detail_action_bar.dart';
import 'job_detail_text_input.dart';

class JobAttachmentTab extends StatefulWidget {
  const JobAttachmentTab({super.key, required this.viewModel});

  final JobLookupDetailViewModel viewModel;

  @override
  State<JobAttachmentTab> createState() => _JobAttachmentTabState();
}

class _JobAttachmentTabState extends State<JobAttachmentTab> {
  String _error = '';
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

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _isWorking = true;
      _error = '';
    });
    try {
      await action();
    } catch (error) {
      if (mounted) _error = error.toString();
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
          title: const Text('올리기 완료'),
          content: Text(notes.join('\n')),
          severity: InfoBarSeverity.warning,
          onClose: close,
        );
      },
    );
  }

  Future<void> _didTapAttach() async {
    final assetId = TextEditingController();
    var passId = '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => ContentDialog(
          title: const Text('에셋 붙이기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '문서 PDF를 붙이면 첨부만 됩니다. 성적서 세트에는 이어지지 않습니다.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '에셋 번호 *',
                child: JobDetailTextInput(
                  controller: assetId,
                  hintText: '1234',
                ),
              ),
              const SizedBox(height: 12),
              InfoLabel(
                label: '패스',
                child: _passCombo(
                  value: passId,
                  onChanged: (value) =>
                      setDialogState(() => passId = value ?? ''),
                ),
              ),
            ],
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('붙이기'),
            ),
          ],
        ),
      ),
    );
    final id = assetId.text.trim();
    if (confirmed != true) return;
    if (id.isEmpty || int.tryParse(id) == null) {
      setState(() => _error = '에셋 번호를 숫자로 넣으세요.');
      return;
    }
    await _run(() => _viewModel.attachAsset(assetId: id, passId: passId));
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
    return ListView(
      children: [
        JobDetailActionBar(
          items: [
            CommandBarWidgetItem(
              child: FilledButton(
                onPressed: _isWorking ? null : _didTapUploadToJob,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.upload, size: 14),
                    SizedBox(width: 6),
                    Text('에셋 올리기'),
                  ],
                ),
              ),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.attach),
              label: const CommandBarLabel('에셋 붙이기(첨부만)'),
              onPressed: _isWorking ? null : _didTapAttach,
            ),
          ],
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_error, style: TextStyle(color: Colors.red)),
        ],
        if (_isWorking) ...[
          const SizedBox(height: 12),
          const Center(child: ProgressRing()),
        ],
        const SizedBox(height: 12),
        if (_viewModel.attachments.isEmpty)
          const SectionEmptyPlaceholder(
            title: '첨부가 없습니다',
            message: '이 작업에 올리거나 이미 있는 에셋을 붙일 수 있습니다.',
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
                          SizedBox(width: 70, child: Text(row.assetId)),
                          SizedBox(
                            width: 90,
                            child: Text(
                              AssetLookupKindOption.labelOf(row.kindCode),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row.fileName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 130,
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
                          const SizedBox(width: 4),
                          Tooltip(
                            message: '떼기',
                            child: IconButton(
                              icon: const Icon(
                                FluentIcons.remove_link,
                                size: 14,
                              ),
                              onPressed: _isWorking
                                  ? null
                                  : () => _run(
                                      () => _viewModel.detachAsset(row.assetId),
                                    ),
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
            SizedBox(width: 70, child: Text('번호', style: headerStyle)),
            SizedBox(width: 90, child: Text('종류', style: headerStyle)),
            Expanded(child: Text('파일', style: headerStyle)),
            SizedBox(width: 130, child: Text('패스', style: headerStyle)),
            SizedBox(width: 4),
            SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
