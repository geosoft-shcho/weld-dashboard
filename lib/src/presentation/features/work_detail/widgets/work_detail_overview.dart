import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/work_attachment.dart';
import '../../../../domain/entities/work_attachment_type.dart';
import '../work_detail_view_model.dart';
import 'work_detail_image_viewer.dart';

class WorkDetailOverview extends StatelessWidget {
  const WorkDetailOverview({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final attachments = viewModel.detail?.attachments ?? const [];

    if (attachments.isEmpty) {
      return const InfoBar(
        title: Text('첨부 파일이 없습니다.'),
        content: Text('이 작업에는 등록된 첨부파일이 없습니다.'),
        severity: InfoBarSeverity.warning,
      );
    }

    return ListView(children: [_buildAttachmentTable(context, attachments)]);
  }

  Widget _buildAttachmentTable(
    BuildContext context,
    List<WorkAttachment> attachments,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: '첨부파일 목록',
          subtitle: '파일을 선택하면 해당 뷰어 탭으로 이동합니다.',
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(100),
              1: FlexColumnWidth(2.5),
              2: FlexColumnWidth(2),
              3: FixedColumnWidth(90),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableHeader(),

              for (var index = 0; index < attachments.length; index++)
                _buildTableRow(attachments[index], index),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.02)),
      children: [
        _tableCell('유형', isHeader: true),
        _tableCell('파일명', isHeader: true),
        _tableCell('설명', isHeader: true),
        _tableCell('동작', isHeader: true),
      ],
    );
  }

  TableRow _buildTableRow(WorkAttachment attachment, int index) {
    return TableRow(
      decoration: index.isEven
          ? BoxDecoration(color: Colors.white.withValues(alpha: 0.08))
          : null,
      children: [
        _tableCell(attachment.fileType.label),
        _tableCell(attachment.fileName),
        _tableCell(attachment.note.isEmpty ? '-' : attachment.note),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Button(
            onPressed: () => viewModel.didTapJumpToAttachment(attachment),
            child: const Text('열기'),
          ),
        ),
      ],
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isHeader ? 12 : 13,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 4),

        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[100])),
      ],
    );
  }
}
