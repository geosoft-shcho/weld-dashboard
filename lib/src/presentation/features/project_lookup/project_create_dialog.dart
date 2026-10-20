import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;

import '../../../domain/entities/project_item_draft.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/waveform_material_scope.dart';
import 'project_lookup_view_model.dart';

Future<String?> showProjectCreateDialog(
  BuildContext context,
  ProjectLookupViewModel viewModel,
) {
  return showDialog<String>(
    context: context,
    builder: (_) => _ProjectCreateDialog(viewModel: viewModel),
  );
}

String _normCode(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), '').toUpperCase();

String _normUnit(String value) {
  final trimmed = value.trim();
  return RegExp(r'^\d$').hasMatch(trimmed) ? '0$trimmed' : trimmed;
}

class _ItemRow {
  final TextEditingController unit = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController name = TextEditingController();

  void dispose() {
    unit.dispose();
    code.dispose();
    name.dispose();
  }
}

class _ProjectCreateDialog extends StatefulWidget {
  const _ProjectCreateDialog({required this.viewModel});

  final ProjectLookupViewModel viewModel;

  @override
  State<_ProjectCreateDialog> createState() => _ProjectCreateDialogState();
}

class _ProjectCreateDialogState extends State<_ProjectCreateDialog> {
  final TextEditingController _projectNo = TextEditingController();
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _siteName = TextEditingController();
  final TextEditingController _customer = TextEditingController();
  final List<_ItemRow> _rows = [];

  String _projectError = '';
  String _itemsError = '';
  String? _createdProjectId;
  bool _isCreating = false;

  ProjectLookupViewModel get _viewModel => widget.viewModel;

  @override
  void dispose() {
    _projectNo.dispose();
    _projectName.dispose();
    _siteName.dispose();
    _customer.dispose();
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _didTapAddRow() {
    final row = _ItemRow();
    if (_rows.isNotEmpty) {
      row.unit.text = _rows.last.unit.text;
    }
    setState(() => _rows.add(row));
  }

  void _didTapRemoveRow(_ItemRow row) {
    setState(() {
      _rows.remove(row);
      row.dispose();
    });
  }

  Future<void> _didTapCreate() async {
    final projectNo = _normCode(_projectNo.text);
    if (_createdProjectId == null) {
      if (projectNo.isEmpty) {
        setState(() => _projectError = '공사 번호를 넣으세요.');
        return;
      }
      if (_viewModel.projectNos.contains(projectNo)) {
        setState(() => _projectError = '$projectNo는 이미 있는 공사 번호입니다.');
        return;
      }
    }
    final drafts = <ProjectItemDraft>[];
    final keys = <String>{};
    for (final row in _rows) {
      final draft = ProjectItemDraft(
        unitNo: _normUnit(row.unit.text),
        itemCode: _normCode(row.code.text),
        itemName: row.name.text.trim(),
      );
      if (draft.unitNo.isEmpty ||
          draft.itemCode.isEmpty ||
          draft.itemName.isEmpty) {
        setState(() => _itemsError = '호기 · 품목 코드 · 이름을 모두 넣어야 합니다.');
        return;
      }
      if (!keys.add('${draft.unitNo}|${draft.itemCode}')) {
        setState(() => _itemsError = '같은 호기 · 품목 코드가 두 줄 있습니다.');
        return;
      }
      drafts.add(draft);
    }
    setState(() {
      _isCreating = true;
      _projectError = '';
      _itemsError = '';
    });
    try {
      var projectId = _createdProjectId;
      if (projectId == null) {
        projectId = await _viewModel.createProject(
          projectNo: projectNo,
          projectName: _projectName.text.trim(),
          siteName: _siteName.text.trim(),
          customer: _customer.text.trim(),
        );
        _createdProjectId = projectId;
      }
      if (drafts.isNotEmpty) {
        await _viewModel.createProjectItems(
          projectId: projectId,
          items: drafts,
        );
      }
      if (mounted) {
        Navigator.of(context).pop(projectId);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isCreating = false;
          if (_createdProjectId == null) {
            _projectError = error.toString();
          } else {
            _itemsError = error.toString();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('새 공사'),
      constraints: const BoxConstraints(maxWidth: 640, maxHeight: 640),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoLabel(
                label: '공사 번호 *',
                child: _TextInput(
                  controller: _projectNo,
                  hintText: 'TP130',
                  enabled: !_isCreating,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '만든 뒤에는 고칠 수 없습니다. PDF DB·CARO의 공사 번호와 같게 넣으세요.',
                style: TextStyle(fontSize: 12),
              ),
              if (_projectError.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(_projectError, style: TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: '공사 이름',
                      child: _TextInput(
                        controller: _projectName,
                        enabled: !_isCreating,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoLabel(
                      label: '현장',
                      child: _TextInput(
                        controller: _siteName,
                        enabled: !_isCreating,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoLabel(
                      label: '발주처',
                      child: _TextInput(
                        controller: _customer,
                        enabled: !_isCreating,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text(
                    '호기 · 품목 배정',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '선택. 나중에 넣어도 됩니다.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final row in _rows) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: _TextInput(
                        controller: row.unit,
                        hintText: '05',
                        enabled: !_isCreating,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: _TextInput(
                        controller: row.code,
                        hintText: 'LD-A',
                        enabled: !_isCreating,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TextInput(
                        controller: row.name,
                        hintText: '품목 이름',
                        enabled: !_isCreating,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Button(
                      onPressed: _isCreating
                          ? null
                          : () => _didTapRemoveRow(row),
                      child: const Text('✕'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: Button(
                  onPressed: _isCreating ? null : _didTapAddRow,
                  child: const Text('+ 줄 추가'),
                ),
              ),
              if (_itemsError.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_itemsError, style: TextStyle(color: Colors.red)),
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
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: controller,
        enabled: enabled,
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
