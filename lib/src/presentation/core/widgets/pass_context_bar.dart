import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/pass_joint_context.dart';
import '../formatters/dashboard_formatters.dart';
import '../themes/app_theme.dart';
import 'section_empty_placeholder.dart';

/// 공통 컨텍스트 카드: 공통키·공사·호기·품목·이음부·작업자·구분·장비를
/// 패스 프로파일·품질 이슈·작업 상세 화면이 같이 쓴다.
/// 조회 상세에서는 entries로 각 상세의 요약 항목을 같은 카드에 표시한다.
class PassContextBar extends StatelessWidget {
  const PassContextBar({super.key, required this.contextData}) : entries = null;

  const PassContextBar.entries({super.key, required this.entries})
    : contextData = null;

  final PassJointContext? contextData;
  final List<(String, String)>? entries;

  static const Color _BORDER = Color(0xFF3E424A);

  @override
  Widget build(BuildContext context) {
    final entries = this.entries;
    if (entries != null) {
      return _card(entries);
    }
    final data = contextData;
    if (data == null) {
      return const SectionEmptyPlaceholder(
        title: '컨텍스트 없음',
        message: '이 작업에 표시할 공사·작업자·장비 정보가 없습니다.',
      );
    }
    return _card([
      ('공통키', data.commonKey),
      ('공사', data.projectNo),
      ('호기', DashboardFormatters.unitNo(data.unitNo)),
      ('품목', data.itemName.isEmpty ? data.itemCode : data.itemName),
      ('이음부', data.jointNo),
      ('작업자', data.workerName),
      ('구분', DashboardFormatters.workerKindLabel(data.workerKind)),
      ('장비', data.equipmentName),
    ]);
  }

  Widget _card(List<(String, String)> entries) {
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
        children: [for (final entry in entries) _pair(entry.$1, entry.$2)],
      ),
    );
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
