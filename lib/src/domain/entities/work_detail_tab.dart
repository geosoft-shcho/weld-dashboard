import 'work_attachment_type.dart';

enum WorkDetailTab {
  overview,
  image,
  video,
  pdf,
  audio,
  text;

  String get label {
    switch (this) {
      case WorkDetailTab.overview:
        return '개요';
      case WorkDetailTab.image:
        return WorkAttachmentType.image.label;
      case WorkDetailTab.video:
        return WorkAttachmentType.video.label;
      case WorkDetailTab.pdf:
        return WorkAttachmentType.pdf.label;
      case WorkDetailTab.audio:
        return WorkAttachmentType.audio.label;
      case WorkDetailTab.text:
        return WorkAttachmentType.text.label;
    }
  }

  WorkAttachmentType? get attachmentType {
    switch (this) {
      case WorkDetailTab.overview:
        return null;
      case WorkDetailTab.image:
        return WorkAttachmentType.image;
      case WorkDetailTab.video:
        return WorkAttachmentType.video;
      case WorkDetailTab.pdf:
        return WorkAttachmentType.pdf;
      case WorkDetailTab.audio:
        return WorkAttachmentType.audio;
      case WorkDetailTab.text:
        return WorkAttachmentType.text;
    }
  }
}
