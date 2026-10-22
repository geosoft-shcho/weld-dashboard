import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;

import '../../../../domain/entities/job_draft.dart';
import '../../../../domain/entities/work_history_project_filter.dart';
import '../../../../domain/entities/worker_kind.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/waveform_material_scope.dart';
import '../work_history_view_model.dart';

Future<void> showWorkJobCreateDialog(
  BuildContext context,
  WorkHistoryViewModel viewModel,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => _WorkJobCreateDialog(viewModel: viewModel),
  );
}

class _PassRow {
  _PassRow(int passNo) : no = TextEditingController(text: '$passNo');

  final TextEditingController no;
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();

  void dispose() {
    no.dispose();
    start.dispose();
    end.dispose();
  }
}

class _WorkJobCreateDialog extends StatefulWidget {
  const _WorkJobCreateDialog({required this.viewModel});

  final WorkHistoryViewModel viewModel;

  @override
  State<_WorkJobCreateDialog> createState() => _WorkJobCreateDialogState();
}

class _WorkJobCreateDialogState extends State<_WorkJobCreateDialog> {
  final TextEditingController _joint = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();
  final TextEditingController _newUnit = TextEditingController();
  final TextEditingController _newCode = TextEditingController();
  final TextEditingController _newName = TextEditingController();
  final List<_PassRow> _passes = [_PassRow(1)];

  String _projectNo = '';
  String _itemKey = '';
  String _workerId = '';
  String _error = '';
  bool _isCreating = false;

  WorkHistoryViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    final board = _viewModel.board!;
    final query = _viewModel.query;
    for (final project in board.projects) {
      if (project.projectNo == query.projectNo) _projectNo = query.projectNo;
    }
    if (_projectNo.isEmpty && board.projects.isNotEmpty) {
      _projectNo = board.projects.first.projectNo;
    }
    _itemKey = _firstItemKey(_selectedProject);
    if (query.unitNo.isNotEmpty && query.itemCode.isNotEmpty) {
      final key = '${query.unitNo}|${query.itemCode}';
      if (_itemKeys.contains(key)) _itemKey = key;
    }
    for (final worker in board.workers) {
      if (worker.workerId == query.workerId && !worker.isInactive) {
        _workerId = query.workerId;
      }
    }
    _joint.text = query.jointNo;
  }

  @override
  void dispose() {
    _joint.dispose();
    _start.dispose();
    _end.dispose();
    _newUnit.dispose();
    _newCode.dispose();
    _newName.dispose();
    for (final row in _passes) {
      row.dispose();
    }
    super.dispose();
  }

  WorkHistoryProjectFilter? get _selectedProject {
    for (final project in _viewModel.board!.projects) {
      if (project.projectNo == _projectNo) return project;
    }
    return null;
  }

  List<String> get _itemKeys {
    final project = _selectedProject;
    if (project == null) return const [];
    return [
      for (final unit in project.units)
        for (final item in unit.items) '${unit.unitNo}|${item.itemCode}',
    ];
  }

  String _firstItemKey(WorkHistoryProjectFilter? project) {
    if (project == null) return 'new';
    for (final unit in project.units) {
      for (final item in unit.items) {
        return '${unit.unitNo}|${item.itemCode}';
      }
    }
    return 'new';
  }

  void _didTapAddPass() {
    final last = _passes.isEmpty ? null : _passes.last;
    final row = _PassRow((int.tryParse(last?.no.text ?? '') ?? 0) + 1);
    if (last != null) row.start.text = last.end.text;
    setState(() => _passes.add(row));
  }

  void _didTapRemovePass(_PassRow row) {
    setState(() {
      _passes.remove(row);
      row.dispose();
    });
  }

  DateTime? _dateTime(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

  bool _hasBadDateTime(TextEditingController controller) {
    return controller.text.trim().isNotEmpty && _dateTime(controller) == null;
  }

  Future<void> _didTapCreate() async {
    if (_hasBadDateTime(_start) ||
        _hasBadDateTime(_end) ||
        _passes.any(
          (row) => _hasBadDateTime(row.start) || _hasBadDateTime(row.end),
        )) {
      setState(() => _error = '시각 형식이 틀립니다. 예: 2026-10-30 08:16:00.000');
      return;
    }
    var unitNo = '';
    var itemCode = '';
    var itemName = '';
    if (_itemKey == 'new') {
      unitNo = normalizeUnitNo(_newUnit.text);
      itemCode = normalizeCode(_newCode.text);
      itemName = _newName.text.trim();
      if (unitNo.isEmpty || itemCode.isEmpty || itemName.isEmpty) {
        setState(() => _error = '새 배정이면 호기 · 품목 코드 · 이름이 필요합니다.');
        return;
      }
    } else if (_itemKey.contains('|')) {
      final parts = _itemKey.split('|');
      unitNo = parts[0];
      itemCode = parts[1];
    }
    final project = _selectedProject;
    final draft = JobDraft(
      projectId: project?.projectId ?? '',
      projectNo: _projectNo,
      unitNo: unitNo,
      itemCode: itemCode,
      itemName: itemName,
      jointNo: normalizeCode(_joint.text),
      workerId: _workerId,
      startedAt: _dateTime(_start),
      endedAt: _dateTime(_end),
      passes: [
        for (final row in _passes)
          JobPassDraft(
            passNo: int.tryParse(row.no.text.trim()) ?? 0,
            startedAt: _dateTime(row.start),
            endedAt: _dateTime(row.end),
          ),
      ],
    );
    final error = draft.validate();
    if (error.isNotEmpty) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _isCreating = true;
      _error = '';
    });
    try {
      final jobId = await _viewModel.createJob(draft);
      await _viewModel.didCreateJob(draft, jobId);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _isCreating = false;
          _error = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final board = _viewModel.board!;
    final project = _selectedProject;
    return ContentDialog(
      title: const Text('새 작업'),
      constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
      content: SizedBox(
        width: 680,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: '공사 *',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: _projectNo,
                        items: [
                          for (final item in board.projects)
                            ComboBoxItem(
                              value: item.projectNo,
                              child: Text(
                                item.projectName.isEmpty
                                    ? item.projectNo
                                    : '${item.projectNo} ${item.projectName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: _isCreating
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  _projectNo = value;
                                  _itemKey = _firstItemKey(_selectedProject);
                                });
                              },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoLabel(
                      label: '호기 · 품목 *',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: _itemKey,
                        items: [
                          if (project != null)
                            for (final unit in project.units)
                              for (final item in unit.items)
                                ComboBoxItem(
                                  value: '${unit.unitNo}|${item.itemCode}',
                                  child: Text(
                                    '${unit.unitNo} · ${item.itemCode} ${item.itemName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          const ComboBoxItem(
                            value: 'new',
                            child: Text('+ 새 배정'),
                          ),
                        ],
                        onChanged: _isCreating
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() => _itemKey = value);
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
              if (_itemKey == 'new') ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: InfoLabel(
                        label: '호기',
                        child: _TextInput(
                          controller: _newUnit,
                          hintText: '01',
                          enabled: !_isCreating,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 140,
                      child: InfoLabel(
                        label: '품목 코드',
                        child: _TextInput(
                          controller: _newCode,
                          hintText: 'LD-D',
                          enabled: !_isCreating,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoLabel(
                        label: '품목 이름 *',
                        child: _TextInput(
                          controller: _newName,
                          hintText: '새 배정이면 필수',
                          enabled: !_isCreating,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: '이음부 *',
                      child: _TextInput(
                        controller: _joint,
                        hintText: 'DGT-ELC-02',
                        enabled: !_isCreating,
                      ),
                    ),
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
                          for (final worker in board.workers)
                            if (!worker.isInactive)
                              ComboBoxItem(
                                value: worker.workerId,
                                child: Text(
                                  '${worker.workerName} · ${worker.workerKind.label}',
                                ),
                              ),
                        ],
                        onChanged: _isCreating
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() => _workerId = value);
                                }
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
                      label: '시작 *',
                      child: _TextInput(
                        controller: _start,
                        hintText: '2026-10-30 08:16:00.000',
                        enabled: !_isCreating,
                        onSubmitted: (value) {
                          if (_passes.isNotEmpty &&
                              _passes.first.start.text.isEmpty) {
                            setState(() => _passes.first.start.text = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoLabel(
                      label: '종료',
                      child: _TextInput(
                        controller: _end,
                        hintText: '2026-10-30 09:04:14.100',
                        enabled: !_isCreating,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('패스', style: TextStyle(fontWeight: FontWeight.w600)),
              const Text(
                '선택. 작업 구간 안, 서로 겹치지 않게. 시각을 비우면 번호만 만듭니다.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              if (_passes.isEmpty)
                const Text('패스 없이 만듭니다', style: TextStyle(fontSize: 12)),
              for (final row in _passes) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: _TextInput(
                        controller: row.no,
                        hintText: '1',
                        enabled: !_isCreating,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TextInput(
                        controller: row.start,
                        hintText: '시작',
                        enabled: !_isCreating,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TextInput(
                        controller: row.end,
                        hintText: '종료',
                        enabled: !_isCreating,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Button(
                      onPressed: _isCreating
                          ? null
                          : () => _didTapRemovePass(row),
                      child: const Text('✕'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: Button(
                  onPressed: _isCreating ? null : _didTapAddPass,
                  child: const Text('+ 패스 추가'),
                ),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(_error, style: TextStyle(color: Colors.red)),
              ],
              if (_isCreating) ...[
                const SizedBox(height: 12),
                const Center(child: ProgressRing()),
              ],
            ],
          ),
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

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.controller,
    this.hintText = '',
    this.enabled = true,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: controller,
        enabled: enabled,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: AppTheme.INK, fontSize: 13),
        cursorColor: AppTheme.ACCENT_STEEL,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppTheme.INK.withValues(alpha: 0.45),
            fontSize: 13,
          ),
          filled: true,
          fillColor: AppTheme.SURFACE,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF3E424A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF3E424A)),
          ),
        ),
      ),
    );
  }
}
