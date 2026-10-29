import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/worker_kind.dart';
import '../../core/widgets/lookup_search_field.dart';
import 'worker_lookup_view_model.dart';

Future<String?> showWorkerCreateDialog(
  BuildContext context,
  WorkerLookupViewModel viewModel,
) {
  return showDialog<String>(
    context: context,
    builder: (_) => _WorkerCreateDialog(viewModel: viewModel),
  );
}

class _WorkerCreateDialog extends StatefulWidget {
  const _WorkerCreateDialog({required this.viewModel});

  final WorkerLookupViewModel viewModel;

  @override
  State<_WorkerCreateDialog> createState() => _WorkerCreateDialogState();
}

class _WorkerCreateDialogState extends State<_WorkerCreateDialog> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _employeeNo = TextEditingController();
  final TextEditingController _description = TextEditingController();

  WorkerKind _kind = WorkerKind.general;
  bool _isInactive = false;
  bool _isCreating = false;
  String _error = '';

  @override
  void dispose() {
    _name.dispose();
    _employeeNo.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _didTapCreate() async {
    final workerName = _name.text.trim();
    final employeeNo = _employeeNo.text.trim();
    if (workerName.isEmpty) {
      setState(() => _error = '이름을 넣으세요.');
      return;
    }
    if (employeeNo.isNotEmpty &&
        widget.viewModel.workers.any(
          (worker) => worker.employeeNo == employeeNo,
        )) {
      setState(() => _error = '같은 사번이 이미 있습니다.');
      return;
    }
    final hasSameName = widget.viewModel.workers.any(
      (worker) => worker.workerName.trim() == workerName,
    );
    if (hasSameName) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => ContentDialog(
          title: const Text('같은 이름'),
          content: Text('$workerName 작업자가 이미 있습니다. 그대로 만들까요?'),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('만들기'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) {
        return;
      }
    }
    setState(() {
      _isCreating = true;
      _error = '';
    });
    try {
      final workerId = await widget.viewModel.createWorker(
        workerName: workerName,
        workerKind: _kind,
        employeeNo: employeeNo,
        description: _description.text.trim(),
        isInactive: _isInactive,
      );
      if (mounted) {
        Navigator.of(context).pop(workerId);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isCreating = false;
          _error = '$error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('새 작업자'),
      constraints: const BoxConstraints(maxWidth: 480),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoLabel(
              label: '이름 *',
              child: LookupSearchField(
                controller: _name,
                value: _name.text,
                hintText: '',
                enabled: !_isCreating,
                textInputAction: TextInputAction.next,
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 12),
            InfoLabel(
              label: '종류',
              child: ComboBox<WorkerKind>(
                value: _kind,
                isExpanded: true,
                items: const [
                  ComboBoxItem(value: WorkerKind.master, child: Text('명장')),
                  ComboBoxItem(value: WorkerKind.general, child: Text('일반')),
                  ComboBoxItem(value: WorkerKind.robot, child: Text('로봇')),
                  ComboBoxItem(value: WorkerKind.unknown, child: Text('모름')),
                ],
                onChanged: _isCreating
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _kind = value);
                        }
                      },
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '명장은 파형 비교의 “명장만”에 쓰입니다. 모름으로 두면 비교 대상에서 빠집니다.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            InfoLabel(
              label: '사번',
              child: LookupSearchField(
                controller: _employeeNo,
                value: _employeeNo.text,
                hintText: '비워도 됨 · 있으면 겹칠 수 없음',
                enabled: !_isCreating,
                textInputAction: TextInputAction.next,
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 12),
            Checkbox(
              checked: _isInactive,
              content: const Text('숨김 — 고르는 목록에서 뺌(그만둔 사람)'),
              onChanged: _isCreating
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _isInactive = value);
                      }
                    },
            ),
            const SizedBox(height: 12),
            InfoLabel(
              label: '비고',
              child: LookupSearchField(
                controller: _description,
                value: _description.text,
                hintText: '경력 · 자격 · 주 공정 등',
                enabled: !_isCreating,
                maxLines: 2,
                textInputAction: TextInputAction.newline,
                onChanged: (_) {},
              ),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_error, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: [
        Button(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isCreating ? null : _didTapCreate,
          child: const Text('만들기'),
        ),
      ],
    );
  }
}
