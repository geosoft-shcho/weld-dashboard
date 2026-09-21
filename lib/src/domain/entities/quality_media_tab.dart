enum QualityMediaTab {
  pdf,
  video;

  String get label {
    switch (this) {
      case QualityMediaTab.pdf:
        return 'PDF';
      case QualityMediaTab.video:
        return 'Video';
    }
  }
}
