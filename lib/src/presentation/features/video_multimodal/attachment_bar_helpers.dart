import '../../../domain/entities/work_attachment.dart';
import '../../../domain/entities/work_attachment_type.dart';
import 'video_multimodal_models.dart';

const double provisionalBarSeconds = 10;

bool isDepthVideoFileName(String fileName) {
  final parts = fileName.trim().toLowerCase().split('/');
  if (parts.isEmpty) {
    return false;
  }
  return parts.last.startsWith('depth_');
}

List<TemporaryAttachmentBar> chainAttachmentBars(
  List<WorkAttachment> attachments,
  WorkAttachmentType type,
) {
  final bars = <TemporaryAttachmentBar>[];
  var cursor = 0.0;
  for (final attachment in attachments) {
    if (attachment.fileType != type) {
      continue;
    }
    final mediaUrl = attachment.networkUrl ?? attachment.assetPath ?? '';
    if (mediaUrl.isEmpty) {
      continue;
    }
    bars.add(
      TemporaryAttachmentBar(
        attachmentId: attachment.attachmentId,
        fileName: attachment.fileName,
        fileTypeLabel: WorkAttachmentType.extensionOf(attachment.fileName),
        mediaUrl: mediaUrl,
        note: attachment.note,
        isVideo: type == WorkAttachmentType.video,
        startSeconds: cursor,
        endSeconds: cursor + provisionalBarSeconds,
      ),
    );
    cursor += provisionalBarSeconds;
  }
  return bars;
}
