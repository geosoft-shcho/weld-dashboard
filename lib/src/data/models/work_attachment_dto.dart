import '../../domain/entities/work_attachment.dart';
import '../../domain/entities/work_attachment_type.dart';

class WorkAttachmentDto {
  const WorkAttachmentDto({
    required this.attachmentId,
    required this.historyId,
    required this.fileType,
    required this.fileName,
    required this.note,
    required this.content,
  });

  factory WorkAttachmentDto.fromRow(Map<String, String> row) {
    return WorkAttachmentDto(
      attachmentId: row['attachment_id'] ?? '',
      historyId: row['history_id'] ?? '',
      fileType: row['file_type'] ?? '',
      fileName: row['file_name'] ?? '',
      note: row['note'] ?? '',
      content: row['content'] ?? '',
    );
  }

  final String attachmentId;
  final String historyId;
  final String fileType;
  final String fileName;
  final String note;
  final String content;

  WorkAttachment? toDomain() {
    final type = WorkAttachmentType.fromCsv(fileType);
    if (type == null || attachmentId.isEmpty || historyId.isEmpty) {
      return null;
    }
    return WorkAttachment(
      attachmentId: attachmentId,
      historyId: historyId,
      fileType: type,
      fileName: fileName,
      note: note,
      content: content,
    );
  }
}
