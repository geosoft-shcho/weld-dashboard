import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_link.dart';
import '../../../core/themes/app_theme.dart';

class QualityLinksTable extends StatelessWidget {
  const QualityLinksTable({
    super.key,
    required this.links,
    required this.selectedLinkId,
    required this.onSelectLink,
  });

  final List<QualityLink> links;
  final String selectedLinkId;
  final ValueChanged<String> onSelectLink;

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return const InfoBar(
        title: Text('연결된 품질 링크가 없습니다'),
        severity: InfoBarSeverity.info,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('품질 링크', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: AppTheme.STATUS_OFF.withValues(alpha: 0.35)),
          columnWidths: const {
            0: FlexColumnWidth(1.1),
            1: FlexColumnWidth(1.1),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(1.4),
            4: FlexColumnWidth(2),
          },
          children: [
            const TableRow(
              children: [
                _Head('link_id'),
                _Head('pass_id'),
                _Head('segment'),
                _Head('구간(ms)'),
                _Head('note'),
              ],
            ),
            for (final link in links)
              TableRow(
                children: [
                  _Cell(
                    link.linkId,
                    isSelected: link.linkId == selectedLinkId,
                    onTap: () => onSelectLink(link.linkId),
                  ),
                  _Cell(
                    link.passId,
                    isSelected: link.linkId == selectedLinkId,
                    onTap: () => onSelectLink(link.linkId),
                  ),
                  _Cell(
                    link.segmentId,
                    isSelected: link.linkId == selectedLinkId,
                    onTap: () => onSelectLink(link.linkId),
                  ),
                  _Cell(
                    '${link.startMs}–${link.endMs}',
                    isSelected: link.linkId == selectedLinkId,
                    onTap: () => onSelectLink(link.linkId),
                  ),
                  _Cell(
                    link.note,
                    isSelected: link.linkId == selectedLinkId,
                    onTap: () => onSelectLink(link.linkId),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _Head extends StatelessWidget {
  const _Head(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(
    this.label, {
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ColoredBox(
            color: isSelected
                ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.25)
                : const Color(0x00000000),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(label),
        ),
      ),
    );
  }
}
