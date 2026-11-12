import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';

/// 비교 지표 표. 평균 차이·유사도는 서버 연동 전 플레이스홀더.
class PassCompareSummary extends StatelessWidget {
  const PassCompareSummary({super.key});

  static final Color _BORDER = AppTheme.STATUS_OFF.withValues(alpha: 0.35);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '비교 지표',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          const Text(
            '서버 미구현',
            style: TextStyle(fontSize: 11, color: AppTheme.STATUS_OFF),
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: _BORDER, width: 1),
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(3),
              2: IntrinsicColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: AppTheme.SURFACE.withValues(alpha: 0.55),
                ),
                children: const [
                  _HeadCell('항목'),
                  _HeadCell('설명'),
                  _HeadCell('값'),
                ],
              ),
              const TableRow(
                children: [
                  _BodyCell('평균 차이', isLabel: true),
                  _BodyCell(
                    '아크 켜진 전체 구간의 명장 평균 대비 상대 평균이 얼마나 다른지 (예: 전류 +5.8A)',
                  ),
                  _BodyCell('—'),
                ],
              ),
              const TableRow(
                children: [
                  _BodyCell('유사도', isLabel: true),
                  _BodyCell('두 파형 모양이 얼마나 닮았는지 (값이 높을수록 비슷)'),
                  _BodyCell('—'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeadCell extends StatelessWidget {
  const _HeadCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.STATUS_OFF,
        ),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell(this.label, {this.isLabel = false});

  final String label;
  final bool isLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isLabel ? FontWeight.w600 : FontWeight.w400,
          height: 1.35,
          color: isLabel ? null : AppTheme.STATUS_OFF,
        ),
      ),
    );
  }
}
