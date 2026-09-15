enum WorkAttachmentType {
  image,
  video,
  pdf,
  audio,
  text;

  String get label {
    switch (this) {
      case WorkAttachmentType.image:
        return '이미지';
      case WorkAttachmentType.video:
        return '비디오';
      case WorkAttachmentType.pdf:
        return 'PDF';
      case WorkAttachmentType.audio:
        return '오디오';
      case WorkAttachmentType.text:
        return '텍스트';
    }
  }

  static WorkAttachmentType? fromCsv(String value) {
    for (final type in values) {
      if (type.name == value) {
        return type;
      }
    }
    return null;
  }
}
