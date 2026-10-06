class QualityJobMedia {
  const QualityJobMedia({
    required this.assetId,
    required this.fileName,
    required this.url,
    required this.passId,
    required this.isVideo,
  });

  final String assetId;
  final String fileName;
  final String url;
  final String passId;
  final bool isVideo;

  String get label {
    final name = fileName.isEmpty ? assetId : fileName;
    if (passId.isEmpty) {
      return '$name 공용';
    }
    return name;
  }
}
