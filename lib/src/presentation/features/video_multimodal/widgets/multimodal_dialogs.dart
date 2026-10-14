import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../../domain/entities/tool_run.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';

Future<void> showMultimodalLayerDeleteDialog(
  BuildContext context,
  VideoMultimodalViewModel viewModel,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return WorkDetailMaterialScope(
        child: _TimelineDeleteDialog(viewModel: viewModel),
      );
    },
  );
}

Future<void> showMultimodalInferencePicker(
  BuildContext context,
  VideoMultimodalViewModel viewModel,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return WorkDetailMaterialScope(
        child: _InferencePickerDialog(viewModel: viewModel),
      );
    },
  );
}

Future<void> showMultimodalPersistDialog(
  BuildContext context,
  VideoMultimodalViewModel viewModel,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return WorkDetailMaterialScope(
        child: _TimelineSaveDialog(viewModel: viewModel),
      );
    },
  );
}

Future<void> showMultimodalCreatedClipDialog(
  BuildContext context,
  CreatedClipNotice notice,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return WorkDetailMaterialScope(
        child: AlertDialog(
          title: const Text('클립 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${notice.kindLabel} 클립을 만들었습니다',
                style: const TextStyle(fontSize: 12),
              ),
              Text(notice.body, style: const TextStyle(fontSize: 12)),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    },
  );
}

Future<bool> showMultimodalLabelDeleteDialog(
  BuildContext context,
  String name,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return WorkDetailMaterialScope(
        child: AlertDialog(
          title: const Text('라벨 삭제'),
          content: Text('「$name」 라벨을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('삭제'),
            ),
          ],
        ),
      );
    },
  );
  return confirmed ?? false;
}

Future<String?> showMultimodalRenameLabelDialog(
  BuildContext context,
  String initialName,
) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return WorkDetailMaterialScope(
        child: _RenameLabelDialog(initialName: initialName),
      );
    },
  );
}

class _TimelineSaveDialog extends StatefulWidget {
  const _TimelineSaveDialog({required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<_TimelineSaveDialog> createState() => _TimelineSaveDialogState();
}

class _TimelineSaveDialogState extends State<_TimelineSaveDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String _message = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.viewModel.timelineName,
    );
    _descriptionController = TextEditingController(
      text: widget.viewModel.timelineDescription,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _message = '';
    });
    final message = await widget.viewModel.didSaveTimeline(
      name: _nameController.text,
      description: _descriptionController.text,
    );
    if (!mounted) {
      return;
    }
    if (message == null) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _isSaving = false;
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('타임라인 저장'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: '설명'),
          ),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_message),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class _TimelineDeleteDialog extends StatefulWidget {
  const _TimelineDeleteDialog({required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<_TimelineDeleteDialog> createState() => _TimelineDeleteDialogState();
}

class _TimelineDeleteDialogState extends State<_TimelineDeleteDialog> {
  String _message = '';
  bool _isDeleting = false;

  Future<void> _delete() async {
    setState(() {
      _isDeleting = true;
      _message = '';
    });
    final message = await widget.viewModel.didDeleteTimeline();
    if (!mounted) {
      return;
    }
    if (message == null) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _isDeleting = false;
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('타임라인 삭제'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('타임라인과 트랙·클립을 지웁니다. 작업과 첨부 파일은 남습니다.'),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_message),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isDeleting ? null : _delete,
          child: const Text('삭제'),
        ),
      ],
    );
  }
}

class _InferencePickerDialog extends StatefulWidget {
  const _InferencePickerDialog({required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<_InferencePickerDialog> createState() => _InferencePickerDialogState();
}

class _InferencePickerDialogState extends State<_InferencePickerDialog> {
  List<InferenceTool> _tools = const [];
  String _selectedToolId = '';
  bool _isLoading = true;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadTools();
  }

  Future<void> _loadTools() async {
    try {
      final tools = await widget.viewModel.loadInferenceTools();
      if (!mounted) {
        return;
      }
      setState(() {
        _tools = tools;
        _isLoading = false;
        _message = tools.isEmpty ? '사용할 수 있는 도구가 없습니다.' : '';
      });
    } on ToolRunException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _message = error.message;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _message = error.toString();
      });
    }
  }

  void _select(InferenceTool tool) {
    setState(() => _selectedToolId = tool.toolId);
  }

  void _startSelected() {
    InferenceTool? selected;
    for (final tool in _tools) {
      if (tool.toolId == _selectedToolId) {
        selected = tool;
        break;
      }
    }
    if (selected == null) {
      return;
    }
    final toolName = selected.name.isEmpty ? selected.toolId : selected.name;
    widget.viewModel.didStartInference(
      toolId: selected.toolId,
      toolName: toolName,
      isSpeechToText: selected.isSpeechToText,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return fluent.ContentDialog(
      title: const Text('추론 모델/작업 도구 선택'),
      constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
      content: SizedBox(
        width: 440,
        child: _isLoading
            ? const SizedBox(
                height: 80,
                child: Center(child: fluent.ProgressRing()),
              )
            : ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_message.isNotEmpty)
                        fluent.InfoBar(
                          title: Text(
                            _message == '사용할 수 있는 도구가 없습니다.' ? '안내' : '조회 실패',
                          ),
                          content: Text(_message),
                          severity: _message == '사용할 수 있는 도구가 없습니다.'
                              ? fluent.InfoBarSeverity.info
                              : fluent.InfoBarSeverity.error,
                        ),
                      for (final tool in _tools)
                        fluent.ListTile.selectable(
                          selected: tool.toolId == _selectedToolId,
                          selectionMode: fluent.ListTileSelectionMode.single,
                          title: Text(
                            tool.name.isEmpty ? tool.toolId : tool.name,
                          ),
                          subtitle: _toolDetail(context, tool),
                          onPressed: () => _select(tool),
                        ),
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        fluent.Button(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        fluent.FilledButton(
          onPressed: _selectedToolId.isEmpty ? null : _startSelected,
          child: const Text('실행'),
        ),
      ],
    );
  }

  Widget? _toolDetail(BuildContext context, InferenceTool tool) {
    final description = tool.description.trim();
    final facts = _toolFacts(tool.summary);
    if (description.isEmpty && facts.isEmpty) {
      return null;
    }
    final theme = fluent.FluentTheme.of(context);
    final body = (theme.typography.body ?? const TextStyle()).copyWith(
      fontSize: 11,
      height: 1.45,
    );
    final labelStyle = (theme.typography.caption ?? const TextStyle()).copyWith(
      color: theme.resources.textFillColorSecondary,
    );
    final valueStyle = theme.typography.caption ?? const TextStyle();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty) Text(description, style: body),
          if (description.isNotEmpty && facts.isNotEmpty)
            const SizedBox(height: 8),
          for (final fact in facts)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 72, child: Text(fact.$1, style: labelStyle)),
                  Expanded(child: Text(fact.$2, style: valueStyle)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

const _HIDDEN_TOOL_FACT_LABELS = {'id', 'model', 'pattern', 'unit', 'dispatch'};

List<(String, String)> _toolFacts(String summary) {
  final facts = <(String, String)>[];
  for (final line in summary.split('\n')) {
    for (final part in line.split('·')) {
      final text = part.trim();
      if (text.isEmpty) {
        continue;
      }
      final split = text.indexOf(' ');
      final label = split <= 0 ? text : text.substring(0, split);
      if (_HIDDEN_TOOL_FACT_LABELS.contains(label)) {
        continue;
      }
      final value = split <= 0 ? '' : text.substring(split + 1).trim();
      facts.add((label, value));
    }
  }
  return facts;
}

class _RenameLabelDialog extends StatefulWidget {
  const _RenameLabelDialog({required this.initialName});

  final String initialName;

  @override
  State<_RenameLabelDialog> createState() => _RenameLabelDialogState();
}

class _RenameLabelDialogState extends State<_RenameLabelDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('라벨 이름 변경'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(prefixText: '#'),
        onSubmitted: (_) => Navigator.pop(context, _controller.text.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('저장'),
        ),
      ],
    );
  }
}
