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
        child: _LayerDeleteDialog(viewModel: viewModel),
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
  BuildContext context, {
  required bool succeeded,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final title = succeeded ? '레이어 반영 완료' : '레이어 반영 실패';
      final body = succeeded
          ? '"자막" (TEXT) — 수정\n"포즈" (POSE) — segment 1건 추가'
          : '레이어 저장에 실패했습니다.';
      return WorkDetailMaterialScope(
        child: AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('닫기'),
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

class _LayerDeleteDialog extends StatefulWidget {
  const _LayerDeleteDialog({required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<_LayerDeleteDialog> createState() => _LayerDeleteDialogState();
}

class _LayerDeleteDialogState extends State<_LayerDeleteDialog> {
  String _selectedLayerId = '';

  @override
  void initState() {
    super.initState();
    final layers = widget.viewModel.sampleLayers;
    if (layers.isNotEmpty) {
      _selectedLayerId = layers.first.layerId;
    }
  }

  SampleLayerSummary? get _selected {
    for (final layer in widget.viewModel.sampleLayers) {
      if (layer.layerId == _selectedLayerId) {
        return layer;
      }
    }
    return null;
  }

  Future<void> _confirm() async {
    final layer = _selected;
    if (layer == null) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return WorkDetailMaterialScope(
          child: AlertDialog(
            title: const Text('레이어 삭제'),
            content: Text('「${layer.displayName}」 레이어를 삭제하시겠습니까?'),
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
    if (confirmed == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final layers = widget.viewModel.sampleLayers;
    if (layers.isEmpty) {
      return AlertDialog(
        title: const Text('레이어 삭제'),
        content: const Text('삭제할 수 있는 레이어(TEXT·TAG·POSE)가 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      );
    }
    final selected = _selected;
    return AlertDialog(
      title: const Text('레이어 삭제'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '삭제할 annotation 레이어를 선택하세요. 상세 정보는 프로젝트 조회(GetProject) 요약과 로드된 레이어 문서(GetLayer)를 기준으로 표시합니다.',
            ),
            const SizedBox(height: 8),
            for (final layer in layers)
              ListTile(
                selected: layer.layerId == _selectedLayerId,
                title: Text(layer.displayName),
                subtitle: Text(layer.kind),
                onTap: () => setState(() => _selectedLayerId = layer.layerId),
              ),
            if (selected != null) ...[
              const Divider(),
              _field('표시 이름', selected.displayName),
              _field('종류', selected.kind),
              _field('순서', '${selected.order}'),
              _field('숨김', selected.isHidden ? '예' : '아니오'),
              _field('메인 레이어', selected.isMainLayer ? '예' : '아니오'),
              _field('revision', selected.revision),
              _field('콘텐츠 상태', selected.contentStatus),
              _field('tagType', selected.tagType),
              _field('segment 수', '${selected.segmentCount}'),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(onPressed: _confirm, child: const Text('삭제')),
      ],
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
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

  void _start(InferenceTool tool) {
    final toolName = tool.name.isEmpty ? tool.toolId : tool.name;
    widget.viewModel.didStartInference(toolId: tool.toolId, toolName: toolName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('추론 모델 선택'),
      content: SizedBox(
        width: 420,
        child: _isLoading
            ? const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_message.isNotEmpty) Text(_message),
                  for (final tool in _tools)
                    ListTile(
                      title: Text(tool.name.isEmpty ? tool.toolId : tool.name),
                      onTap: () => _start(tool),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _tools.isEmpty ? null : () => _start(_tools.first),
          child: const Text('실행'),
        ),
      ],
    );
  }
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
