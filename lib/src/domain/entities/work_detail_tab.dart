import 'work_attachment_type.dart';

enum WorkDetailTab {
  overview,
  report,
  image,
  video,
  pdf,
  audio,
  text;

  String get label {
    switch (this) {
      case WorkDetailTab.overview:
        return '개요';
      case WorkDetailTab.report:
        return '성적서';
      case WorkDetailTab.image:
        return '이미지';
      case WorkDetailTab.video:
        return '비디오';
      case WorkDetailTab.pdf:
        return 'PDF';
      case WorkDetailTab.audio:
        return '오디오';
      case WorkDetailTab.text:
        return '텍스트';
    }
  }

  WorkAttachmentType? get attachmentType {
    switch (this) {
      case WorkDetailTab.overview:
      case WorkDetailTab.report:
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
