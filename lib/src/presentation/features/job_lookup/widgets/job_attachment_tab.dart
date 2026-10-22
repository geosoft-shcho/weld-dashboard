import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/asset_lookup_kind.dart';
import '../../../../domain/entities/asset_lookup_row.dart';
import '../job_lookup_detail_view_model.dart';
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
        Row(
          children: [
            FilledButton(
              onPressed: _isWorking ? null : _didTapAttach,
              child: const Text('에셋 붙이기'),
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
          const Text('첨부가 없습니다')
        else
          for (final row in _viewModel.attachments)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 70, child: Text(row.assetId)),
                  SizedBox(
                    width: 90,
                    child: Text(AssetLookupKindOption.labelOf(row.kindCode)),
                  ),
                  Expanded(
                    child: Text(row.fileName, overflow: TextOverflow.ellipsis),
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
                  const SizedBox(width: 8),
                  Button(
                    onPressed: _isWorking
                        ? null
                        : () => _run(() => _viewModel.detachAsset(row.assetId)),
                    child: const Text('떼기'),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
