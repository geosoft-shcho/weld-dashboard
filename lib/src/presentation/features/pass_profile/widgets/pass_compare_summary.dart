import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/channel_compare_stats.dart';
import '../../../core/themes/app_theme.dart';

/// Channel × compare-pair table for master vs beginner / master vs robot.
class PassCompareSummary extends StatelessWidget {
  const PassCompareSummary({super.key, required this.stats});

  final ChannelCompareStats stats;

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
            '비교 요약',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          const Text(
            '로드된 시계열에서 계산',
            style: TextStyle(fontSize: 11, color: AppTheme.STATUS_OFF),
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: _BORDER, width: 1),
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: AppTheme.SURFACE.withValues(alpha: 0.55),
                ),
                children: const [
                  _HeadCell(''),
                  _HeadCell('명장 vs 초보자'),
                  _HeadCell('명장 vs 로봇'),
                ],
              ),
              _dataRow(
                '전류',
                stats.currentBeginner,
                stats.currentRobot,
                1,
              ),
              _dataRow(
                '전압',
                stats.voltageBeginner,
                stats.voltageRobot,
                2,
              ),
              _dataRow(
                '속도',
                stats.speedBeginner,
                stats.speedRobot,
                2,
              ),
              _dataRow(
                '회전 속도',
                stats.rotationBeginner,
                stats.rotationRobot,
                3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _dataRow(
    String channel,
    DiffStat beginner,
    DiffStat robot,
    int digits,
  ) {
    return TableRow(
      children: [
        _BodyCell(channel, isLabel: true),
        _BodyCell(_fmt(beginner, digits)),
        _BodyCell(_fmt(robot, digits)),
      ],
    );
  }

  String _fmt(DiffStat stat, int digits) {
    if (!stat.isComparable) {
      return '비교 불가';
    }
    return '평균 ${stat.mean!.toStringAsFixed(digits)}\n최대 ${stat.max!.toStringAsFixed(digits)}';
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
        ),
      ),
    );
  }
}
