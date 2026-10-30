import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;
import 'package:provider/provider.dart';

import '../../../domain/entities/project_item_draft.dart';
import '../../../domain/entities/work_history_project_filter.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../core/widgets/waveform_material_scope.dart';
import '../../navigation/app_coordinator.dart';
import 'project_lookup_detail_view_model.dart';

class ProjectLookupDetailScreen extends StatelessWidget {
  const ProjectLookupDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<ProjectLookupDetailViewModel>(param1: projectId)..load(),
      child: const _ProjectLookupDetailBody(),
    );
  }
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

String _normCode(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), '').toUpperCase();

String _normUnit(String value) {
  final trimmed = value.trim();
  return RegExp(r'^\d$').hasMatch(trimmed) ? '0$trimmed' : trimmed;
}

class _ProjectLookupDetailBody extends StatefulWidget {
  const _ProjectLookupDetailBody();

  @override
  State<_ProjectLookupDetailBody> createState() =>
      _ProjectLookupDetailBodyState();
}

class _ProjectLookupDetailBodyState extends State<_ProjectLookupDetailBody> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _site = TextEditingController();
  final TextEditingController _customer = TextEditingController();
  final List<_ItemRow> _rows = [];

  bool _isEditing = false;
  bool _isBusy = false;
  String _editError = '';
  String _itemsError = '';
  String? _addingUnitNo;

  @override
  void dispose() {
    _name.dispose();
    _site.dispose();
    _customer.dispose();
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  ProjectLookupDetailViewModel get _viewModel =>
      context.read<ProjectLookupDetailViewModel>();

  void _startEdit(WorkHistoryProjectFilter project) {
    _name.text = project.projectName;
    _site.text = project.siteName;
    _customer.text = project.customer;
    setState(() {
      _isEditing = true;
      _editError = '';
    });
  }

  Future<void> _saveEdit() async {
    setState(() {
      _isBusy = true;
      _editError = '';
    });
    try {
      await _viewModel.updateBasicInfo(
        projectName: _name.text.trim(),
        siteName: _site.text.trim(),
        customer: _customer.text.trim(),
      );
      if (mounted) {
        setState(() => _isEditing = false);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _editError = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  void _startAdd(String unitNo) {
    setState(() {
      _addingUnitNo = unitNo;
      _itemsError = '';
      _rows.add(_ItemRow());
    });
  }

  void _cancelAdd() {
    for (final row in _rows) {
      row.dispose();
    }
    setState(() {
      _rows.clear();
      _addingUnitNo = null;
      _itemsError = '';
    });
  }

  Future<void> _saveAdd(String fixedUnitNo) async {
    final project = _viewModel.project;
    if (project == null) {
      return;
    }
    final drafts = <ProjectItemDraft>[];
    final keys = <String>{
      for (final unit in project.units)
        for (final item in unit.items) '${unit.unitNo}|${item.itemCode}',
    };
    for (final row in _rows) {
      final draft = ProjectItemDraft(
        unitNo: fixedUnitNo.isNotEmpty
            ? fixedUnitNo
            : _normUnit(row.unit.text),
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
      _isBusy = true;
      _itemsError = '';
    });
    try {
      await _viewModel.addItems(drafts);
      if (mounted) {
        _cancelAdd();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _itemsError = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final project = viewModel.project;
    return LookupDetailScaffold(
      title: project?.projectNo.isNotEmpty == true
          ? project!.projectNo
          : '공사 상세',
      subtitle: project == null ? '' : 'id ${project.projectId}',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [
        if (project != null && !_isEditing) ...[
          Button(
            onPressed: _isBusy ? null : () => _startEdit(project),
            child: const Text('기본 정보 수정'),
          ),
          const SizedBox(width: 8),
          Button(
            onPressed: _isBusy
                ? null
                : () => _didTapDeleteProject(context, project),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                const Color(0xFFE85D5D),
              ),
            ),
            child: const Text('지우기'),
          ),
        ],
      ],
      body: _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, ProjectLookupDetailViewModel viewModel) {
    if (viewModel.isLoading && viewModel.project == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return QueryFailurePane(
        title: '조회 실패',
        message: viewModel.errorMessage,
        onRetry: viewModel.load,
      );
    }
    final project = viewModel.project;
    if (project == null) {
      return const InfoBar(
        title: Text('공사 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    final coordinator = context.read<AppCoordinator>();
    return ListView(
      children: [
        if (_isEditing)
          _editForm(project)
        else ...[
          PassContextBar.entries(
            entries: [
              ('공사 번호', project.projectNo),
              ('공사 이름', project.projectName),
              ('현장', project.siteName),
              ('발주처', project.customer),
              ('작업', '${project.jobCount}건'),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              onPressed: () => coordinator.didTapOpenWorkHistory(
                equipmentId: '',
                projectNo: project.projectNo,
              ),
              child: const Text('작업 탭에서 보기 →'),
            ),
          ),
        ],
        const LookupDetailSectionTitle('호기 · 품목 배정'),
        Text(
          '공사 번호는 만든 뒤 고칠 수 없습니다. 호기만 따로 만들 수 없고, 품목 이름을 바꾸면 그 배정을 쓰는 작업 이름이 함께 바뀝니다.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 8),
        if (project.units.isEmpty && _addingUnitNo == null)
          const Text('배정된 품목이 없습니다. 첫 품목을 넣으면 호기도 생깁니다.')
        else
          for (final unit in project.units) _unitBlock(context, unit),
        if (_addingUnitNo == '') _pendingBlock(context, fixedUnitNo: ''),
        if (_addingUnitNo == null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              onPressed: _isBusy ? null : () => _startAdd(''),
              child: const Text('+ 호기 추가 (첫 품목과 함께)'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _editForm(WorkHistoryProjectFilter project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PassContextBar.entries(
          entries: [
            ('공사 번호', project.projectNo),
            ('작업', '${project.jobCount}건'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoLabel(
                label: '공사 이름',
                child: _TextInput(controller: _name, enabled: !_isBusy),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoLabel(
                label: '현장',
                child: _TextInput(controller: _site, enabled: !_isBusy),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoLabel(
                label: '발주처',
                child: _TextInput(controller: _customer, enabled: !_isBusy),
              ),
            ),
          ],
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
              onPressed: _isBusy ? null : _saveEdit,
              child: const Text('저장'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _unitBlock(BuildContext context, WorkHistoryUnitFilter unit) {
    final title = unit.unitNo == '00'
        ? '호기 구분 없음 (00)'
        : '${DashboardFormatters.unitNo(unit.unitNo)} (${unit.unitNo})';
    final coordinator = context.read<AppCoordinator>();
    final project = _viewModel.project;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Expander(
        header: Text('$title · ${unit.items.length}품목'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in unit.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Text(
                        unit.unitNo,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 88,
                      child: Text(
                        item.itemCode,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.itemName.isEmpty ? '—' : item.itemName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Button(
                      onPressed: project == null
                          ? null
                          : () => coordinator.didTapOpenWorkHistory(
                              equipmentId: '',
                              projectNo: project.projectNo,
                              unitNo: unit.unitNo,
                              itemCode: item.itemCode,
                            ),
                      child: const Text('작업 →'),
                    ),
                    const SizedBox(width: 4),
                    Button(
                      onPressed: item.projectItemId.isEmpty || _isBusy
                          ? null
                          : () => _didTapRenameItem(context, item),
                      child: const Text('이름 수정'),
                    ),
                    const SizedBox(width: 4),
                    Button(
                      onPressed: item.projectItemId.isEmpty || _isBusy
                          ? null
                          : () => _didTapDeleteItem(context, item),
                      child: const Text('지우기'),
                    ),
                  ],
                ),
              ),
            if (_addingUnitNo == unit.unitNo)
              _pendingBlock(context, fixedUnitNo: unit.unitNo)
            else
              Align(
                alignment: Alignment.centerLeft,
                child: Button(
                  onPressed: _isBusy || _addingUnitNo != null
                      ? null
                      : () => _startAdd(unit.unitNo),
                  child: Text('+ ${unit.unitNo}에 품목 추가'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _pendingBlock(
    BuildContext context, {
    required String fixedUnitNo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final row in _rows) ...[
            Row(
              children: [
                if (fixedUnitNo.isNotEmpty)
                  SizedBox(
                    width: 70,
                    child: Text(fixedUnitNo),
                  )
                else
                  SizedBox(
                    width: 70,
                    child: _TextInput(
                      controller: row.unit,
                      hintText: '05',
                      enabled: !_isBusy,
                    ),
                  ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: _TextInput(
                    controller: row.code,
                    hintText: 'LD-A',
                    enabled: !_isBusy,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TextInput(
                    controller: row.name,
                    hintText: '품목 이름',
                    enabled: !_isBusy,
                  ),
                ),
                const SizedBox(width: 8),
                Button(
                  onPressed: _isBusy
                      ? null
                      : () => setState(() {
                          _rows.remove(row);
                          row.dispose();
                        }),
                  child: const Text('✕'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Button(
                onPressed: _isBusy
                    ? null
                    : () => setState(() => _rows.add(_ItemRow())),
                child: const Text('+ 줄 추가'),
              ),
              const Spacer(),
              Button(
                onPressed: _isBusy ? null : _cancelAdd,
                child: const Text('취소'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _isBusy ? null : () => _saveAdd(fixedUnitNo),
                child: Text('배정 저장 (${_rows.length}줄)'),
              ),
            ],
          ),
          if (_itemsError.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_itemsError, style: TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }

  Future<void> _didTapRenameItem(
    BuildContext context,
    WorkHistoryItemFilter item,
  ) async {
    final controller = TextEditingController(text: item.itemName);
    var error = '';
    var busy = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return ContentDialog(
              title: const Text('품목 이름 수정'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${item.itemCode} · 그 배정을 쓰는 모든 작업의 품목 이름이 바뀝니다.'),
                    const SizedBox(height: 12),
                    _TextInput(controller: controller, enabled: !busy),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(error, style: TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
              actions: [
                Button(
                  onPressed: busy
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () async {
                          final name = controller.text.trim();
                          if (name.isEmpty) {
                            setDialogState(() => error = '이름을 넣으세요.');
                            return;
                          }
                          setDialogState(() {
                            busy = true;
                            error = '';
                          });
                          try {
                            await _viewModel.renameItem(
                              projectItemId: item.projectItemId,
                              itemName: name,
                            );
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          } catch (e) {
                            setDialogState(() {
                              busy = false;
                              error = e.toString();
                            });
                          }
                        },
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
  }

  Future<void> _didTapDeleteItem(
    BuildContext context,
    WorkHistoryItemFilter item,
  ) async {
    var error = '';
    var busy = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return ContentDialog(
              title: const Text('품목 지우기'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${item.itemCode} ${item.itemName} 배정을 지웁니다. 되돌릴 수 없습니다.'),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(error, style: TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
              actions: [
                Button(
                  onPressed: busy
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
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
                            await _viewModel.deleteItem(
                              projectItemId: item.projectItemId,
                            );
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          } catch (e) {
                            setDialogState(() {
                              busy = false;
                              error = e.toString();
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
  }

  Future<void> _didTapDeleteProject(
    BuildContext context,
    WorkHistoryProjectFilter project,
  ) async {
    final coordinator = context.read<AppCoordinator>();
    if (project.jobCount > 0) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => ContentDialog(
          title: const Text('공사를 지울 수 없습니다'),
          content: Text(
            '작업 ${project.jobCount}건이 있어 지울 수 없습니다. 배정도 함께 지워지므로 작업 없는 공사만 지울 수 있습니다.',
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
    final controller = TextEditingController();
    var error = '';
    var busy = false;
    var matches = false;
    final deleted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return ContentDialog(
              title: const Text('공사 지우기'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '배정도 함께 지워집니다. 되돌릴 수 없습니다. 확인하려면 공사 번호 ${project.projectNo}를 입력하세요.',
                    ),
                    const SizedBox(height: 12),
                    _TextInput(
                      controller: controller,
                      hintText: project.projectNo,
                      enabled: !busy,
                      onChanged: (value) => setDialogState(
                        () => matches = value.trim() == project.projectNo,
                      ),
                    ),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(error, style: TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
              actions: [
                Button(
                  onPressed: busy
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: !matches || busy
                      ? null
                      : () async {
                          setDialogState(() {
                            busy = true;
                            error = '';
                          });
                          try {
                            await _viewModel.deleteProject();
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop(true);
                            }
                          } catch (e) {
                            setDialogState(() {
                              busy = false;
                              error = e.toString();
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
    controller.dispose();
    if (deleted == true && context.mounted) {
      coordinator.didTapBackFromLookupDetail();
    }
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.controller,
    this.hintText = '',
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
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
