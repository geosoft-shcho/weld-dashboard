import 'work_attachment.dart';
import 'work_attachment_type.dart';
import 'work_history_item.dart';

class WorkDetail {
  const WorkDetail({required this.job, required this.attachments});

  final WorkHistoryItem? job;
  final List<WorkAttachment> attachments;

  bool get doesHaveJob => job != null;

  int countByType(WorkAttachmentType type) {
    var count = 0;
    for (final attachment in attachments) {
      if (attachment.fileType == type) {
        count += 1;
      }
    }
    return count;
  }

  List<WorkAttachment> attachmentsOf(WorkAttachmentType type) {
    return [
      for (final attachment in attachments)
        if (attachment.fileType == type) attachment,
    ];
  }
}
