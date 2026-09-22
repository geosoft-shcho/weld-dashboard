import 'quality_media_tab.dart';

class QualityMedia {
  const QualityMedia({
    required this.type,
    required this.url,
    required this.filePath,
    required this.pageCount,
  });

  final QualityMediaTab type;
  final String url;
  final String filePath;
  final int pageCount;

  String get displayName {
    final path = filePath.isNotEmpty ? filePath : url;
    return Uri.tryParse(path)?.pathSegments.lastOrNull ?? path;
  }
}
