import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/equipment.dart';
import '../../core/widgets/lookup_search_field.dart';
import 'equipment_lookup_view_model.dart';

Future<String?> showEquipmentCreateDialog(
  BuildContext context,
  EquipmentLookupViewModel viewModel,
) {
  return showDialog<String>(
    context: context,
    builder: (_) => _EquipmentCreateDialog(viewModel: viewModel),
  );
}

class _EquipmentCreateDialog extends StatefulWidget {
  const _EquipmentCreateDialog({required this.viewModel});

  final EquipmentLookupViewModel viewModel;

  @override
  State<_EquipmentCreateDialog> createState() => _EquipmentCreateDialogState();
}

class _EquipmentCreateDialogState extends State<_EquipmentCreateDialog> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _description = TextEditingController();

  bool _isInactive = false;
  bool _isCreating = false;
  String _error = '';

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _didTapCreate() async {
    final equipmentName = _name.text.trim();
    final equipmentCode = normalizedEquipmentCode(_code.text);
    if (equipmentName.isEmpty) {
      setState(() => _error = '이름을 넣으세요.');
      return;
    }
    if (equipmentCode.isNotEmpty &&
        widget.viewModel.equipmentItems.any(
          (item) => item.equipmentCode == equipmentCode,
        )) {
      setState(() => _error = '같은 장비 코드가 이미 있습니다.');
      return;
    }
    setState(() {
      _isCreating = true;
      _error = '';
    });
    try {
      final equipmentId = await widget.viewModel.createEquipment(
        equipmentName: equipmentName,
        equipmentCode: equipmentCode,
        description: _description.text.trim(),
        isInactive: _isInactive,
      );
      if (mounted) {
        Navigator.of(context).pop(equipmentId);
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
      title: const Text('새 장비'),
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
              label: '장비 코드',
              child: LookupSearchField(
                controller: _code,
                value: _code.text,
                hintText: 'DEMO-PANEL',
                enabled: !_isCreating,
                textInputAction: TextInputAction.next,
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '코드는 적재기가 장비를 찾는 값입니다. 비우면 손으로만 고를 수 있습니다. 공백 없이 대문자로 보냅니다.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Checkbox(
              checked: _isInactive,
              content: const Text('숨김 — 고르는 목록에서 뺌(안 쓰는 장비)'),
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
                hintText: '설치 위치 · 설정 등',
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
