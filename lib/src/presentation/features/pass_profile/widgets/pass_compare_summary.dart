import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/waveform_channel_compare_summary.dart';
import '../../../core/themes/app_theme.dart';

/// 서버 GetPassWaveform.compare_summary 채널별 평균 차이·유사도 표.
class PassCompareSummary extends StatelessWidget {
  const PassCompareSummary({super.key, this.items = const []});

  final List<WaveformChannelCompareSummary> items;

  static final Color _BORDER = AppTheme.STATUS_OFF.withValues(alpha: 0.35);

  @override
  Widget build(BuildContext context) {
    final rows = items.isEmpty
        ? const [
            TableRow(
              children: [
                _BodyCell('-', isLabel: true),
                _BodyCell('-'),
                _BodyCell('-'),
              ],
            ),
          ]
        : [
            for (final item in items)
              TableRow(
                children: [
                  _BodyCell(item.channelName, isLabel: true),
                  _BodyCell(_meanDiffText(item)),
                  _BodyCell(_similarityText(item)),
                ],
              ),
          ];
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
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: _BORDER, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: AppTheme.SURFACE.withValues(alpha: 0.55),
                ),
                children: const [
                  _HeadCell('채널'),
                  _HeadCell('평균 차이'),
                  _HeadCell('유사도'),
                ],
              ),
              ...rows,
            ],
          ),
        ],
      ),
    );
  }

  static String _meanDiffText(WaveformChannelCompareSummary item) {
    final value = item.meanDiff;
    if (value == null || value.isNaN) {
      return '-';
    }
    final sign = value > 0 ? '+' : '';
    final number = value.toStringAsFixed(1);
    final unit = item.unit.trim();
    if (unit.isEmpty) {
      return '$sign$number';
    }
    return '$sign$number $unit';
  }

  static String _similarityText(WaveformChannelCompareSummary item) {
    final value = item.similarity;
    if (value == null || value.isNaN) {
      return '-';
    }
    return value.toStringAsFixed(2);
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
