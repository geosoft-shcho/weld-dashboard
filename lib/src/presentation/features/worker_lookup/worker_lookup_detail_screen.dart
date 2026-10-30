import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/worker.dart';
import '../../../domain/entities/worker_kind.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../navigation/app_coordinator.dart';
import 'worker_lookup_detail_view_model.dart';

class WorkerLookupDetailScreen extends StatelessWidget {
  const WorkerLookupDetailScreen({super.key, required this.workerId});

  final String workerId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<WorkerLookupDetailViewModel>(param1: workerId)..load(),
      child: const _WorkerLookupDetailBody(),
    );
  }
}

class _WorkerLookupDetailBody extends StatefulWidget {
  const _WorkerLookupDetailBody();

  @override
  State<_WorkerLookupDetailBody> createState() =>
      _WorkerLookupDetailBodyState();
}

class _WorkerLookupDetailBodyState extends State<_WorkerLookupDetailBody> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _employeeNo = TextEditingController();
  final TextEditingController _description = TextEditingController();

  WorkerKind _kind = WorkerKind.general;
  bool _isInactive = false;
  bool _isEditing = false;
  bool _isBusy = false;
  String _editError = '';

  @override
  void dispose() {
    _name.dispose();
    _employeeNo.dispose();
    _description.dispose();
    super.dispose();
  }

  void _startEdit(Worker worker) {
    _name.text = worker.workerName;
    _employeeNo.text = worker.employeeNo;
    _description.text = worker.description;
    setState(() {
      _kind = worker.workerKind;
      _isInactive = worker.isInactive;
      _isEditing = true;
      _editError = '';
    });
  }

  Future<void> _didTapSave(WorkerLookupDetailViewModel viewModel) async {
    final workerName = _name.text.trim();
    if (workerName.isEmpty) {
      setState(() => _editError = '이름을 넣으세요.');
      return;
    }
    setState(() {
      _isBusy = true;
      _editError = '';
    });
    try {
      await viewModel.updateWorker(
        workerName: workerName,
        workerKind: _kind,
        employeeNo: _employeeNo.text.trim(),
        description: _description.text.trim(),
        isInactive: _isInactive,
      );
      if (mounted) {
        setState(() => _isEditing = false);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _editError = '$error');
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _didTapDelete(
    BuildContext context,
    Worker worker,
    WorkerLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) async {
    if (worker.jobCount > 0) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => ContentDialog(
          title: const Text('작업자를 지울 수 없습니다'),
          content: Text(
            '맡은 작업 ${worker.jobCount}건이 있어 지울 수 없습니다. 그만둔 사람은 지우지 말고 숨기세요.',
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }
    var error = '';
    var busy = false;
    final deleted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return ContentDialog(
              title: const Text('작업자 지우기'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${worker.workerName}을 지웁니다. 되돌릴 수 없습니다.'),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(error, style: TextStyle(color: Colors.red)),
                  ],
                ],
              ),
              actions: [
                Button(
                  onPressed: busy
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () async {
                          setDialogState(() {
                            busy = true;
                            error = '';
                          });
                          try {
                            await viewModel.deleteWorker();
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop(true);
                            }
                          } catch (e) {
                            setDialogState(() {
                              busy = false;
                              error = '$e';
                            });
                          }
                        },
                  child: const Text('지우기'),
                ),
              ],
            );
          },
        );
      },
    );
    if (deleted == true && context.mounted) {
      coordinator.didTapBackFromLookupDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkerLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final worker = viewModel.worker;
    return LookupDetailScaffold(
      title: worker?.workerName.isNotEmpty == true
          ? worker!.workerName
          : '작업자 상세',
      subtitle: worker == null ? '' : 'id ${worker.workerId}',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [
        if (worker != null && !_isEditing) ...[
          Button(
            onPressed: _isBusy ? null : () => _startEdit(worker),
            child: const Text('고치기'),
          ),
          const SizedBox(width: 8),
          Button(
            onPressed: _isBusy
                ? null
                : () => _didTapDelete(context, worker, viewModel, coordinator),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                const Color(0xFFE85D5D),
              ),
            ),
            child: const Text('지우기'),
          ),
        ],
      ],
      body: _body(context, viewModel, coordinator),
    );
  }

  Widget _body(
    BuildContext context,
    WorkerLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading && viewModel.worker == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return QueryFailurePane(
        title: '조회 실패',
        message: viewModel.errorMessage,
        onRetry: viewModel.load,
      );
    }
    final worker = viewModel.worker;
    if (worker == null) {
      return const InfoBar(
        title: Text('작업자 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    if (_isEditing) {
      return _editForm(viewModel);
    }
    final kindHint = worker.workerKind == WorkerKind.master
        ? '파형 비교의 명장 목록에 들어갑니다.'
        : '파형 비교의 명장 목록에는 안 들어갑니다.';
    return ListView(
      children: [
        PassContextBar.entries(
          entries: [
            ('종류', worker.workerKind.label),
            ('사번', worker.employeeNo),
            ('맡은 작업', '${worker.jobCount}건'),
            ('숨김', worker.isInactive ? '숨김 — 고르는 목록에서 빠짐' : '아니오'),
          ],
        ),
        const SizedBox(height: 12),
        if (worker.description.isNotEmpty) ...[
          const LookupDetailSectionTitle('비고'),
          Text(worker.description),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            kindHint,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ),
        const LookupDetailSectionTitle('맡은 작업'),
        LookupDetailPlainTable(
          headers: const ['공통키', '이음부', '작업일시'],
          emptyText: worker.jobCount == 0
              ? '맡은 작업이 없습니다'
              : '조건에 맞는 작업 목록이 없습니다',
          rows: [
            for (final job in viewModel.jobs)
              [
                job.commonKey,
                job.jointNo,
                DashboardFormatters.dateTime(job.workedAt),
              ],
          ],
          onRowTap: (index) {
            final job = viewModel.jobs[index];
            coordinator.didTapOpenWorkDetail(context, jobId: job.jobId);
          },
        ),
      ],
    );
  }

  Widget _editForm(WorkerLookupDetailViewModel viewModel) {
    return ListView(
      children: [
        InfoLabel(
          label: '이름 *',
          child: LookupSearchField(
            controller: _name,
            value: _name.text,
            hintText: '',
            enabled: !_isBusy,
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
            onChanged: _isBusy
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
            enabled: !_isBusy,
            textInputAction: TextInputAction.next,
            onChanged: (_) {},
          ),
        ),
        const SizedBox(height: 12),
        Checkbox(
          checked: _isInactive,
          content: const Text('숨김 — 고르는 목록에서 뺌(그만둔 사람)'),
          onChanged: _isBusy
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
            enabled: !_isBusy,
            maxLines: 2,
            textInputAction: TextInputAction.newline,
            onChanged: (_) {},
          ),
        ),
        if (_editError.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_editError, style: TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Button(
              onPressed: _isBusy
                  ? null
                  : () => setState(() => _isEditing = false),
              child: const Text('취소'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _isBusy ? null : () => _didTapSave(viewModel),
              child: const Text('저장'),
            ),
          ],
        ),
      ],
    );
  }
}
