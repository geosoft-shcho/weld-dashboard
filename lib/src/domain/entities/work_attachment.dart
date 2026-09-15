import 'work_attachment_type.dart';

class WorkAttachment {
  const WorkAttachment({
    required this.attachmentId,
    required this.historyId,
    required this.fileType,
    required this.fileName,
    required this.note,
    required this.content,
  });

  final String attachmentId;
  final String historyId;
  final WorkAttachmentType fileType;
  final String fileName;
  final String note;
  final String content;

  bool get doesHaveSourcePath {
    final value = content.trim();
    if (value.isEmpty || value.contains('\n')) {
      return false;
    }
    return RegExp(
      r'^(data/|assets/|\./|https?:)|(\.(png|jpe?g|gif|webp|pdf|mp4|wav|m4a)$)',
      caseSensitive: false,
    ).hasMatch(value);
  }

  String get displayText {
    final value = content
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();
    if (value.isNotEmpty && !doesHaveSourcePath) {
      return value;
    }
    final fallback = StringBuffer(fileName);
    if (note.isNotEmpty) {
      fallback.write('\n\n');
      fallback.write(note);
    }
    if (fallback.isEmpty) {
      return '(목업 텍스트)';
    }
    return fallback.toString();
  }

  String? get networkUrl {
    final value = content.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return null;
  }

  String? get assetPath {
    if (!doesHaveSourcePath || networkUrl != null) {
      return null;
    }
    final value = content.trim();
    if (value.startsWith('assets/')) {
      return value;
    }
    if (value.startsWith('data/')) {
      return 'assets/$value';
    }
    if (value.startsWith('./')) {
      return 'assets/${value.substring(2)}';
    }
    return 'assets/data/attachments/$value';
  }
}
