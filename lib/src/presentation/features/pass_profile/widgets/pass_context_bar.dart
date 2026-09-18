import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pass_joint_context.dart';
import '../../../core/themes/app_theme.dart';

class PassContextBar extends StatelessWidget {
  const PassContextBar({super.key, required this.contextData});

  final PassJointContext? contextData;

  @override
  Widget build(BuildContext context) {
    final data = contextData;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 8,
        children: [
          _item('공통키', data?.commonKey ?? '—'),
          _item(
            '작업지시',
            '${data?.workOrderNo ?? '—'} ${data?.title ?? ''}'.trim(),
          ),
          _item(
            '조인트',
            '${data?.jointNo ?? '—'} ${data?.jointName ?? ''}'.trim(),
          ),
          _item('작업자', data?.workerName ?? '—'),
          _item('장비', data?.equipmentName ?? '—'),
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Text(value.isEmpty ? '—' : value),
      ],
    );
  }
}
