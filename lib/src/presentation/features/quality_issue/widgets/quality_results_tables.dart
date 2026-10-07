import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_result_report.dart';
import '../../../core/themes/app_theme.dart';

class QualityResultsTables extends StatelessWidget {
  const QualityResultsTables({
    super.key,
    required this.reports,
    required this.onSelectInspection,
  });

  final List<QualityResultReport> reports;
  final void Function(String reportSetId, int? pageStart) onSelectInspection;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const InfoBar(
        title: Text('성적서가 없습니다'),
        severity: InfoBarSeverity.info,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final report in reports) ...[
          const Text('검사', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _InspectionTable(
            inspections: report.inspections,
            onSelect: (pageStart) =>
                onSelectInspection(report.reportSetId, pageStart),
          ),
          const SizedBox(height: 16),
          const Text('이음부', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _JointTable(joints: report.joints),
        ],
      ],
    );
  }
}

class _InspectionTable extends StatelessWidget {
  const _InspectionTable({required this.inspections, required this.onSelect});

  final List<QualityInspectionRow> inspections;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.4),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.6),
        4: FlexColumnWidth(1.2),
      },
      children: [
        const TableRow(
          children: [
            _Head('검사'),
            _Head('보고서 번호'),
            _Head('검사일'),
            _Head('판정'),
            _Head('기관'),
          ],
        ),
        for (final inspection in inspections)
          TableRow(
            children: [
              _Body(
                inspection.kindLabel,
                onTap: () => onSelect(inspection.pageStart),
              ),
              _Body(
                inspection.reportNo,
                onTap: () => onSelect(inspection.pageStart),
              ),
              _Body(
                inspection.reportDate,
                onTap: () => onSelect(inspection.pageStart),
              ),
              _Body(
                inspection.result,
                onTap: () => onSelect(inspection.pageStart),
              ),
              _Body(
                inspection.agency,
                onTap: () => onSelect(inspection.pageStart),
              ),
            ],
          ),
      ],
    );
  }
}

class _JointTable extends StatelessWidget {
  const _JointTable({required this.joints});

  final List<QualityJointRow> joints;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.6),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(1),
      },
      children: [
        const TableRow(
          children: [
            _Head('이음부'),
            _Head('작업'),
            _Head('UT 지시'),
            _Head('UT 판정'),
            _Head('MT 지시'),
            _Head('MT 판정'),
          ],
        ),
        for (final joint in joints)
          TableRow(
            children: [
              _Body(joint.jointNo),
              _Body(joint.jobLabel),
              _Body(joint.utIndication),
              _Body(joint.utResult),
              _Body(joint.mtIndication),
              _Body(joint.mtResult),
            ],
          ),
      ],
    );
  }
}

class _Head extends StatelessWidget {
  const _Head(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text, {this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(8), child: Text(text)),
    );
  }
}
