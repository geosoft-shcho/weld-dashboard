import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_result_group.dart';
import '../../../core/themes/app_theme.dart';

class QualityPaperMeta extends StatelessWidget {
  const QualityPaperMeta({super.key, required this.group});

  final QualityResultGroup? group;

  @override
  Widget build(BuildContext context) {
    final data = group;
    if (data == null) {
      return const InfoBar(
        title: Text('이 패스에 페이퍼 품질 결과가 없습니다'),
        severity: InfoBarSeverity.warning,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.paperDocNo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _row('검사일', data.inspectedAt),
        _row('검사자', data.inspectorName),
        _row('공통키', data.commonKey),
        _row('패스/구간', '${data.passId} / ${data.segmentId}'),
        _row(
          '판정',
          data.judgement,
          isFail: data.judgement != '합격',
        ),
        _row('이슈 요약', data.issueSummary),
        const SizedBox(height: 12),
        const Text('검사 항목', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: AppTheme.STATUS_OFF.withValues(alpha: 0.35)),
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
          },
          children: [
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('항목', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('결과', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('비고', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            for (final item in data.items)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(item.itemName),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      item.itemResult,
                      style: TextStyle(
                        color: item.itemResult == '불합격'
                            ? AppTheme.STATUS_ERROR
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(item.itemNote),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _row(String label, String value, {bool isFail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(color: isFail ? AppTheme.STATUS_ERROR : null),
            ),
          ),
        ],
      ),
    );
  }
}
