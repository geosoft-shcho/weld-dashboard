import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pass_joint_context.dart';

class PassContextBar extends StatelessWidget {
  const PassContextBar({super.key, required this.contextData});

  final PassJointContext? contextData;

  @override
  Widget build(BuildContext context) {
    final data = contextData;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D32),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          _pair('공통키', data?.commonKey ?? '—'),
          _pair(
            '작업지시',
            _joined(data?.workOrderNo, data?.title, separator: ' · '),
          ),
          _pair(
            '조인트',
            _joined(data?.jointNo, data?.jointName, separator: ' '),
          ),
          _pair('작업자', data?.workerName ?? '—'),
          _pair('장비', data?.equipmentName ?? '—'),
        ],
      ),
    );
  }

  String _joined(String? left, String? right, {required String separator}) {
    final first = left?.trim() ?? '';
    final second = right?.trim() ?? '';
    if (first.isEmpty && second.isEmpty) {
      return '—';
    }
    if (first.isEmpty) {
      return second;
    }
    if (second.isEmpty) {
      return first;
    }
    return '$first$separator$second';
  }

  Widget _pair(String label, String value) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF8E949E)),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
