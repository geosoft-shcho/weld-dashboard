enum WorkAttachmentType {
  image,
  video,
  pdf,
  audio,
  text;

  static const Map<String, WorkAttachmentType> _TYPE_BY_EXTENSION = {
    'jpg': WorkAttachmentType.image,
    'jpeg': WorkAttachmentType.image,
    'png': WorkAttachmentType.image,
    'gif': WorkAttachmentType.image,
    'webp': WorkAttachmentType.image,
    'bmp': WorkAttachmentType.image,
    'mp4': WorkAttachmentType.video,
    'mov': WorkAttachmentType.video,
    'webm': WorkAttachmentType.video,
    'm4v': WorkAttachmentType.video,
    'avi': WorkAttachmentType.video,
    'mkv': WorkAttachmentType.video,
    'pdf': WorkAttachmentType.pdf,
    'wav': WorkAttachmentType.audio,
    'mp3': WorkAttachmentType.audio,
    'm4a': WorkAttachmentType.audio,
    'aac': WorkAttachmentType.audio,
    'ogg': WorkAttachmentType.audio,
    'flac': WorkAttachmentType.audio,
    'txt': WorkAttachmentType.text,
    'csv': WorkAttachmentType.text,
    'json': WorkAttachmentType.text,
    'md': WorkAttachmentType.text,
    'log': WorkAttachmentType.text,
  };

  String get label {
    for (final entry in _TYPE_BY_EXTENSION.entries) {
      if (entry.value == this) {
        return entry.key;
      }
    }
    return name;
  }

  static String extensionOf(String fileName) => _extensionOf(fileName);

  static WorkAttachmentType? fromFileName(String fileName) {
    final extension = _extensionOf(fileName);
    if (extension.isEmpty) {
      return null;
    }
    return _TYPE_BY_EXTENSION[extension];
  }

  static String _extensionOf(String fileName) {
    final value = fileName.trim();
    if (value.isEmpty || value.contains('\n') || value.contains('\r')) {
      return '';
    }
    final withoutQuery = value.split('?').first.split('#').first;
    final slash = withoutQuery.lastIndexOf(RegExp(r'[/\\]'));
    final base = slash < 0 ? withoutQuery : withoutQuery.substring(slash + 1);
    final dot = base.lastIndexOf('.');
    if (dot <= 0 || dot == base.length - 1) {
      return '';
    }
    return base.substring(dot + 1).toLowerCase();
  }
}
