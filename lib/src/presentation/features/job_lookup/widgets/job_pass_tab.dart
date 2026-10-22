import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/job_detail.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../job_lookup_detail_view_model.dart';
import 'job_detail_text_input.dart';

class JobPassTab extends StatelessWidget {
  const JobPassTab({super.key, required this.viewModel});

  final JobLookupDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final detail = viewModel.detail;
    return ListView(
      children: [
        if (detail == null)
          const Text('패스 정보가 없습니다.')
        else ...[
          for (final pass in viewModel.passes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(
                      '${pass.passNo}패스${pass.passNo == 1 ? ' 초층' : ''} · ${pass.kind.label}',
                    ),
                  ),
                  Expanded(
                    child: Text(DashboardFormatters.dateTime(pass.startedAt)),
                  ),
                  Expanded(
                    child: Text(DashboardFormatters.dateTime(pass.endedAt)),
                  ),
                  Button(
                    onPressed: () => showJobPassDialog(
                      context,
                      viewModel: viewModel,
                      original: pass,
                    ),
                    child: const Text('수정'),
                  ),
                  const SizedBox(width: 8),
                  Button(
                    onPressed: () => _didTapDelete(context, pass),
                    child: const Text('지우기'),
                  ),
                ],
              ),
            ),
          if (viewModel.passes.isEmpty) const Text('패스가 없습니다'),
        ],
        const SizedBox(height: 8),
        const Text(
          '작업 구간 안이어야 하고 서로 겹칠 수 없습니다. 끝과 시작이 맞닿는 건 됩니다.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: detail == null
                ? null
                : () => showJobPassDialog(context, viewModel: viewModel),
            child: const Text('+ 패스 추가'),
          ),
        ),
      ],
    );
  }

  Future<void> _didTapDelete(BuildContext context, JobPassDetail pass) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: Text('${pass.passNo}패스를 지울까요?'),
        content: const Text('되돌릴 수 없습니다. 이 패스에 붙은 첨부는 작업 공용이 됩니다.'),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('지우기'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await viewModel.deletePass(pass.passId);
    } catch (error) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => ContentDialog(
            title: const Text('지울 수 없습니다'),
            content: Text(error.toString()),
            actions: [
              Button(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('닫기'),
              ),
            ],
          ),
        );
      }
    }
  }
}

Future<void> showJobPassDialog(
  BuildContext context, {
  required JobLookupDetailViewModel viewModel,
  JobPassDetail? original,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _JobPassDialog(viewModel: viewModel, original: original),
  );
}

class _JobPassDialog extends StatefulWidget {
  const _JobPassDialog({required this.viewModel, this.original});

  final JobLookupDetailViewModel viewModel;
  final JobPassDetail? original;

  @override
  State<_JobPassDialog> createState() => _JobPassDialogState();
}

class _JobPassDialogState extends State<_JobPassDialog> {
  late final TextEditingController _no;
  late final TextEditingController _start;
  late final TextEditingController _end;
  late PassKind _kind;
  String _error = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final original = widget.original;
    var nextNo = 1;
    for (final pass in widget.viewModel.passes) {
      if (pass.passNo >= nextNo) nextNo = pass.passNo + 1;
    }
    _no = TextEditingController(text: '${original?.passNo ?? nextNo}');
    _start = TextEditingController(text: jobDateTimeText(original?.startedAt));
    _end = TextEditingController(text: jobDateTimeText(original?.endedAt));
    _kind = original?.kind ?? PassKind.unknown;
  }

  @override
  void dispose() {
    _no.dispose();
    _start.dispose();
    _end.dispose();
    super.dispose();
  }

  Future<void> _didTapSave() async {
    final detail = widget.viewModel.detail;
    if (detail == null) return;
    if (isBadJobDateTime(_start.text) || isBadJobDateTime(_end.text)) {
      setState(() => _error = '시각 형식이 틀립니다. 예: 2026-10-30 08:16:00.000');
      return;
    }
    final draft = PassEditDraft(
      passNo: int.tryParse(_no.text.trim()) ?? 0,
      kind: _kind,
      startedAt: parseJobDateTime(_start.text),
      endedAt: parseJobDateTime(_end.text),
    );
    final error = validatePassRange(
      passNo: draft.passNo,
      startedAt: draft.startedAt,
      endedAt: draft.endedAt,
      jobStartedAt: detail.startedAt,
      jobEndedAt: detail.endedAt,
      passes: widget.viewModel.passes,
      skipPassId: widget.original?.passId ?? '',
    );
    if (error.isNotEmpty) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _isSaving = true;
      _error = '';
    });
    try {
      final original = widget.original;
      if (original == null) {
        await widget.viewModel.createPass(draft);
      } else {
        await widget.viewModel.updatePass(original, draft);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _error = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final original = widget.original;
    final detail = widget.viewModel.detail;
    return ContentDialog(
      title: Text(original == null ? '패스 추가' : '${original.passNo}패스 수정'),
      constraints: const BoxConstraints(maxWidth: 560),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: InfoLabel(
                  label: '패스 번호 *',
                  child: JobDetailTextInput(
                    controller: _no,
                    hintText: '1',
                    enabled: !_isSaving,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoLabel(
                  label: '종류',
                  child: ComboBox<PassKind>(
                    isExpanded: true,
                    value: _kind,
                    items: [
                      for (final kind in PassKind.values)
                        ComboBoxItem(value: kind, child: Text(kind.label)),
                    ],
                    onChanged: _isSaving
                        ? null
                        : (value) {
                            if (value != null) setState(() => _kind = value);
                          },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InfoLabel(
                  label: '시작',
                  child: JobDetailTextInput(
                    controller: _start,
                    hintText: '2026-10-30 08:16:00.000',
                    enabled: !_isSaving,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoLabel(
                  label: '종료',
                  child: JobDetailTextInput(
                    controller: _end,
                    hintText: '2026-10-30 08:29:16.300',
                    enabled: !_isSaving,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '작업 구간 ${jobDateTimeText(detail?.startedAt)} ~ ${jobDateTimeText(detail?.endedAt)}. '
            '시각은 비워 둘 수 있습니다.',
            style: const TextStyle(fontSize: 12),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_error, style: TextStyle(color: Colors.red)),
          ],
          if (_isSaving) ...[
            const SizedBox(height: 12),
            const Center(child: ProgressRing()),
          ],
        ],
      ),
      actions: [
        Button(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _didTapSave,
          child: Text(original == null ? '추가' : '저장'),
        ),
      ],
    );
  }
}
