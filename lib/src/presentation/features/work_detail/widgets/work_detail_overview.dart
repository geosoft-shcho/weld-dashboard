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
        title: Text('첨부 파일이 없습니다. 이미지·비디오·PDF·오디오·텍스트 탭은 빈 상태입니다.'),
        severity: InfoBarSeverity.warning,
      );
    }
    return ListView(
      children: [
        Text(
          '첨부 ${attachments.length}건. 칩을 누르면 해당 뷰어 탭으로 이동합니다. 각 탭은 Flutter 패키지 1개에 대응합니다.',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final attachment in attachments)
              Button(
                onPressed: () => viewModel.didTapJumpToAttachment(attachment),
                child: Text(
                  '${attachment.fileType.label} · ${attachment.fileName}',
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final attachment in attachments)
              if (attachment.fileType == WorkAttachmentType.image)
                _preview(attachment),
          ],
        ),
      ],
    );
  }

  Widget _preview(WorkAttachment attachment) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: GestureDetector(
              onTap: () => viewModel.didTapJumpToAttachment(attachment),
              child: WorkDetailImageFrame(attachment: attachment),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            attachment.note.isEmpty
                ? attachment.fileName
                : '${attachment.fileName} · ${attachment.note}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
