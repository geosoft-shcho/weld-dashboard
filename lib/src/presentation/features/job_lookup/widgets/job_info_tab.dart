import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/job_detail.dart';
import '../../../../domain/entities/job_draft.dart';
import '../../../../domain/entities/worker_kind.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/screen_command_bar.dart';
import '../job_lookup_detail_view_model.dart';
import 'job_detail_action_bar.dart';
import 'job_detail_text_input.dart';

class JobInfoTab extends StatefulWidget {
  const JobInfoTab({
    super.key,
    required this.viewModel,
    required this.onDeleted,
  });

  final JobLookupDetailViewModel viewModel;
  final VoidCallback onDeleted;

  @override
  State<JobInfoTab> createState() => _JobInfoTabState();
}

class _JobInfoTabState extends State<JobInfoTab> {
  final TextEditingController _unit = TextEditingController();
  final TextEditingController _itemCode = TextEditingController();
  final TextEditingController _joint = TextEditingController();
  final TextEditingController _jobName = TextEditingController();
  final TextEditingController _itemNo = TextEditingController();
  final TextEditingController _operationNo = TextEditingController();
  final TextEditingController _material = TextEditingController();
  final TextEditingController _outerDiameter = TextEditingController();
  final TextEditingController _thickness = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();

  String _projectNo = '';
  String _projectId = '';
  String _workerId = '';
  String _error = '';
  String _message = '';
  bool _isSaving = false;
  String _loadedJobId = '';

  JobLookupDetailViewModel get _viewModel => widget.viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final detail = _viewModel.detail;
    if (detail != null && detail.jobId != _loadedJobId) {
      _loadedJobId = detail.jobId;
      _fill(detail);
    }
  }

  void _fill(JobDetail detail) {
    _projectNo = detail.projectNo;
    _projectId = detail.projectId;
    _workerId = detail.workerId;
    _unit.text = detail.unitNo;
    _itemCode.text = detail.itemCode;
    _joint.text = detail.jointNo;
    _jobName.text = detail.jobName;
    _itemNo.text = detail.itemNo;
    _operationNo.text = detail.operationNo;
    _material.text = detail.material;
    _outerDiameter.text = detail.outerDiameterMm?.toString() ?? '';
    _thickness.text = detail.thicknessMm?.toString() ?? '';
    _start.text = jobDateTimeText(detail.startedAt);
    _end.text = jobDateTimeText(detail.endedAt);
  }

  @override
  void dispose() {
    for (final c in [
      _unit,
      _itemCode,
      _joint,
      _jobName,
      _itemNo,
      _operationNo,
      _material,
      _outerDiameter,
      _thickness,
      _start,
      _end,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _number(TextEditingController c) =>
      c.text.trim().isEmpty ? null : double.tryParse(c.text.trim());

  bool _hasBadNumber(TextEditingController c) =>
      c.text.trim().isNotEmpty && _number(c) == null;

  Future<void> _didTapSave() async {
    final detail = _viewModel.detail;
    if (detail == null) return;
    if (isBadJobDateTime(_start.text) || isBadJobDateTime(_end.text)) {
      setState(() => _error = '시각 형식이 틀립니다. 예: 2026-10-30 08:16:00.000');
      return;
    }
    if (_hasBadNumber(_outerDiameter) || _hasBadNumber(_thickness)) {
      setState(() => _error = '외경 · 두께는 숫자로 넣으세요.');
      return;
    }
    final draft = JobEditDraft(
      projectId: _projectId,
      projectNo: _projectNo,
      unitNo: normalizeUnitNo(_unit.text),
      itemCode: normalizeCode(_itemCode.text),
      jointNo: normalizeCode(_joint.text),
      jobName: _jobName.text.trim(),
      itemNo: _itemNo.text.trim(),
      operationNo: _operationNo.text.trim(),
      material: _material.text.trim(),
      outerDiameterMm: _number(_outerDiameter),
      thicknessMm: _number(_thickness),
      workerId: _workerId,
      startedAt: parseJobDateTime(_start.text),
      endedAt: parseJobDateTime(_end.text),
    );
    final error = draft.validate(detail);
    if (error.isNotEmpty) {
      setState(() => _error = error);
      return;
    }
    if (draft.changedFields(detail).isEmpty) {
      setState(() => _message = '바뀐 칸이 없습니다.');
      return;
    }
    final doesChangeKey = draft.doesChangeKeyFields(detail);
    setState(() {
      _isSaving = true;
      _error = '';
      _message = '';
    });
    try {
      final updated = await _viewModel.updateJob(draft);
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _fill(updated);
        _message = doesChangeKey
            ? '저장했습니다. 공통키와 작업 키가 다시 만들어졌습니다: ${updated.jobKey}'
            : '저장했습니다.';
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _error = error.toString();
        });
      }
    }
  }

  Future<void> _didTapDelete() async {
    final detail = _viewModel.detail;
    if (detail == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('작업을 지울까요?'),
        content: Text(
          '되돌릴 수 없습니다. 패스 ${detail.passes.length}개도 함께 지워집니다. '
          '첨부 · 타임라인 · 성적서가 있으면 서버가 막습니다.',
        ),
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
    if (confirmed != true) return;
    setState(() {
      _isSaving = true;
      _error = '';
    });
    try {
      await _viewModel.deleteJob();
      if (mounted) widget.onDeleted();
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
    final detail = _viewModel.detail;
    final job = _viewModel.job;
    if (detail == null || job == null) {
      return const InfoBar(
        title: Text('상세 없음'),
        content: Text('작업 상세를 불러오지 못했습니다. 다시 조회하세요.'),
        severity: InfoBarSeverity.warning,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JobDetailActionBar(
          items: [
            CommandBarButton(
              icon: const Icon(FluentIcons.save),
              label: const CommandBarLabel('저장'),
              onPressed: _isSaving ? null : _didTapSave,
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.delete),
              label: const CommandBarLabel('작업 지우기'),
              onPressed: _isSaving ? null : _didTapDelete,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.SURFACE_RAISED,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF3E424A)),
            ),
            child: ListView(
              children: [
                if (detail.jobKey.isNotEmpty)
                  Text(detail.jobKey, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '품목 이름: ${detail.itemName.isEmpty ? '—' : detail.itemName} '
                  '(품목 이름은 공사에서 고칩니다)',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InfoLabel(
                        label: '공사',
                        child: ComboBox<String>(
                          isExpanded: true,
                          value: _projectNo.isEmpty ? null : _projectNo,
                          items: [
                            if (_projectNo.isNotEmpty &&
                                !_viewModel.projects.any(
                                  (project) => project.projectNo == _projectNo,
                                ))
                              ComboBoxItem(
                                value: _projectNo,
                                child: Text(_projectNo),
                              ),
                            for (final project in _viewModel.projects)
                              ComboBoxItem(
                                value: project.projectNo,
                                child: Text(
                                  project.projectName.isEmpty
                                      ? project.projectNo
                                      : '${project.projectNo} ${project.projectName}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: _isSaving
                              ? null
                              : (value) {
                                  if (value == null) return;
                                  for (final project in _viewModel.projects) {
                                    if (project.projectNo == value) {
                                      _projectId = project.projectId;
                                    }
                                  }
                                  setState(() => _projectNo = value);
                                },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _field('호기', _unit, hintText: '05')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field('품목 코드', _itemCode, hintText: 'TFPB'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field('이음부', _joint, hintText: 'DGT-ELA-01'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoLabel(
                        label: '작업자',
                        child: ComboBox<String>(
                          isExpanded: true,
                          value: _workerId,
                          items: [
                            const ComboBoxItem(value: '', child: Text('미지정')),
                            for (final worker in _viewModel.workers)
                              if (!worker.isInactive ||
                                  worker.workerId == detail.workerId)
                                ComboBoxItem(
                                  value: worker.workerId,
                                  child: Text(
                                    '${worker.workerName} · ${worker.workerKind.label}',
                                  ),
                                ),
                          ],
                          onChanged: _isSaving
                              ? null
                              : (value) {
                                  if (value != null)
                                    setState(() => _workerId = value);
                                },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _field('작업 이름', _jobName)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        '시작 *',
                        _start,
                        hintText: '2026-10-30 08:16:00.000',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        '종료',
                        _end,
                        hintText: '2026-10-30 09:04:14.100',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _field('품목 번호', _itemNo)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('공정 번호', _operationNo)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('재질', _material)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('외경 (mm)', _outerDiameter)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('두께 (mm)', _thickness)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '공사 · 호기 · 품목 · 이음부 · 시작을 바꾸면 공통키와 작업 키가 다시 만들어집니다.',
                  style: TextStyle(fontSize: 12),
                ),
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_error, style: TextStyle(color: Colors.red)),
                ],
                if (_message.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_message, style: const TextStyle(fontSize: 12)),
                ],
                if (_isSaving) ...[
                  const SizedBox(height: 12),
                  const Center(child: ProgressRing()),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String hintText = '',
  }) {
    return InfoLabel(
      label: label,
      child: JobDetailTextInput(
        controller: controller,
        hintText: hintText,
        enabled: !_isSaving,
      ),
    );
  }
}
