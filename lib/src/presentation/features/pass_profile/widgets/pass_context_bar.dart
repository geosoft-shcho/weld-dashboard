import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pass_joint_context.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/section_empty_placeholder.dart';

class PassContextBar extends StatelessWidget {
  const PassContextBar({super.key, required this.contextData});

  final PassJointContext? contextData;

  static const Color _BORDER = Color(0xFF3E424A);

  @override
  Widget build(BuildContext context) {
    final data = contextData;
    if (data == null) {
      return const SectionEmptyPlaceholder(
        title: '컨텍스트 없음',
        message: '이 이음에 표시할 작업·조인트·작업자·장비 정보가 없습니다.',
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _BORDER),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          _pair('공통키', data.commonKey),
          _pair(
            '작업지시',
            _joined(data.workOrderNo, data.title, separator: ' · '),
          ),
          _pair(
            '조인트',
            _joined(data.jointNo, data.jointName, separator: ' '),
          ),
          _pair('작업자', data.workerName),
          _pair('장비', data.equipmentName),
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
    final trimmed = value.trim();
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppTheme.STATUS_OFF),
          ),
          const SizedBox(height: 2),
          Text(
            trimmed.isEmpty ? '—' : trimmed,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
