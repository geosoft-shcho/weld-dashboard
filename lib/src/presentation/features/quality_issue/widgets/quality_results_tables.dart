import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_result_report.dart';
import '../../../core/themes/app_theme.dart';

/// 짝수 데이터 행(2·4·6…) 배경. SURFACE(#1C1F24)와 확실히 구분.
const Color _kEvenRow = Color(0xFF343A42);
const Color _kHoverRow = Color(0xFF3E4550);

class QualityResultsTables extends StatelessWidget {
  const QualityResultsTables({
    super.key,
    required this.reports,
    required this.onSelectInspection,
    this.selectedReportSetId,
  });

  final List<QualityResultReport> reports;
  final void Function(String reportSetId, int? pageStart) onSelectInspection;
  final String? selectedReportSetId;

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
          const SizedBox(height: 2),
          Text(
            '행을 누르면 해당 성적서 PDF로 이동합니다',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.STATUS_OFF.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 6),
          _InspectionTable(
            inspections: report.inspections,
            selected: report.reportSetId == selectedReportSetId,
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

class _InspectionTable extends StatefulWidget {
  const _InspectionTable({
    required this.inspections,
    required this.selected,
    required this.onSelect,
  });

  final List<QualityInspectionRow> inspections;
  final bool selected;
  final ValueChanged<int?> onSelect;

  @override
  State<_InspectionTable> createState() => _InspectionTableState();
}

class _InspectionTableState extends State<_InspectionTable> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.4),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.6),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(0.5),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFF32363C)),
          children: [
            _Head('검사'),
            _Head('보고서 번호'),
            _Head('검사일'),
            _Head('판정'),
            _Head('기관'),
            _Head(''),
          ],
        ),
        for (var i = 0; i < widget.inspections.length; i++)
          _inspectionDataRow(
            inspection: widget.inspections[i],
            rowColor: _qualityTableRowColor(
              index: i,
              selected: widget.selected,
              hovered: _hoveredIndex == i,
            ),
            onHoverChanged: (hovered) => _setHovered(i, hovered),
            onSelect: widget.onSelect,
          ),
      ],
    );
  }

  void _setHovered(int index, bool hovered) {
    if (hovered) {
      if (_hoveredIndex == index) {
        return;
      }
      setState(() => _hoveredIndex = index);
      return;
    }
    if (_hoveredIndex != index) {
      return;
    }
    setState(() => _hoveredIndex = null);
  }
}

TableRow _inspectionDataRow({
  required QualityInspectionRow inspection,
  required Color? rowColor,
  required ValueChanged<bool> onHoverChanged,
  required ValueChanged<int?> onSelect,
}) {
  void onTap() => onSelect(inspection.pageStart);
  return TableRow(
    decoration: rowColor == null ? null : BoxDecoration(color: rowColor),
    children: [
      _SelectableBody(
        inspection.kindLabel,
        onTap: onTap,
        onHoverChanged: onHoverChanged,
      ),
      _SelectableBody(
        inspection.reportNo,
        onTap: onTap,
        onHoverChanged: onHoverChanged,
      ),
      _SelectableBody(
        inspection.reportDate,
        onTap: onTap,
        onHoverChanged: onHoverChanged,
      ),
      _SelectableBody(
        inspection.result,
        onTap: onTap,
        onHoverChanged: onHoverChanged,
      ),
      _SelectableBody(
        inspection.agency,
        onTap: onTap,
        onHoverChanged: onHoverChanged,
      ),
      _SelectHint(onTap: onTap, onHoverChanged: onHoverChanged),
    ],
  );
}

/// 호버 > 선택 틴트 > 짝수 스트라이프 > 없음.
Color? _qualityTableRowColor({
  required int index,
  bool selected = false,
  bool hovered = false,
}) {
  if (hovered) {
    return selected
        ? Color.alphaBlend(
            AppTheme.ACCENT_STEEL.withValues(alpha: 0.18),
            _kHoverRow,
          )
        : _kHoverRow;
  }
  if (!index.isOdd && !selected) {
    return null;
  }
  if (!index.isOdd && selected) {
    return AppTheme.ACCENT_STEEL.withValues(alpha: 0.18);
  }
  if (selected) {
    return Color.alphaBlend(
      AppTheme.ACCENT_STEEL.withValues(alpha: 0.18),
      _kEvenRow,
    );
  }
  return _kEvenRow;
}

class _JointTable extends StatefulWidget {
  const _JointTable({required this.joints});

  final List<QualityJointRow> joints;

  @override
  State<_JointTable> createState() => _JointTableState();
}

class _JointTableState extends State<_JointTable> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
          decoration: BoxDecoration(color: Color(0xFF32363C)),
          children: [
            _Head('이음부'),
            _Head('작업'),
            _Head('UT 지시'),
            _Head('UT 판정'),
            _Head('MT 지시'),
            _Head('MT 판정'),
          ],
        ),
        for (var i = 0; i < widget.joints.length; i++)
          _jointDataRow(
            joint: widget.joints[i],
            rowColor: _qualityTableRowColor(
              index: i,
              hovered: _hoveredIndex == i,
            ),
            onHoverChanged: (hovered) => _setHovered(i, hovered),
          ),
      ],
    );
  }

  void _setHovered(int index, bool hovered) {
    if (hovered) {
      if (_hoveredIndex == index) {
        return;
      }
      setState(() => _hoveredIndex = index);
      return;
    }
    if (_hoveredIndex != index) {
      return;
    }
    setState(() => _hoveredIndex = null);
  }
}

TableRow _jointDataRow({
  required QualityJointRow joint,
  required Color? rowColor,
  required ValueChanged<bool> onHoverChanged,
}) {
  return TableRow(
    decoration: rowColor == null ? null : BoxDecoration(color: rowColor),
    children: [
      _HoverBody(joint.jointNo, onHoverChanged: onHoverChanged),
      _HoverBody(joint.jobLabel, onHoverChanged: onHoverChanged),
      _HoverBody(joint.utIndication, onHoverChanged: onHoverChanged),
      _HoverBody(joint.utResult, onHoverChanged: onHoverChanged),
      _HoverBody(joint.mtIndication, onHoverChanged: onHoverChanged),
      _HoverBody(joint.mtResult, onHoverChanged: onHoverChanged),
    ],
  );
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

class _HoverBody extends StatelessWidget {
  const _HoverBody(this.text, {required this.onHoverChanged});

  final String text;
  final ValueChanged<bool> onHoverChanged;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Padding(padding: const EdgeInsets.all(8), child: Text(text)),
    );
  }
}

class _SelectableBody extends StatelessWidget {
  const _SelectableBody(
    this.text, {
    required this.onTap,
    required this.onHoverChanged,
  });

  final String text;
  final VoidCallback onTap;
  final ValueChanged<bool> onHoverChanged;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(8), child: Text(text)),
      ),
    );
  }
}

class _SelectHint extends StatelessWidget {
  const _SelectHint({required this.onTap, required this.onHoverChanged});

  final VoidCallback onTap;
  final ValueChanged<bool> onHoverChanged;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Icon(
            FluentIcons.chevron_right,
            size: 12,
            color: AppTheme.ACCENT_STEEL,
          ),
        ),
      ),
    );
  }
}
