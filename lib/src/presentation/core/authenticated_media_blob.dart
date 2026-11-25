export 'authenticated_media_blob_stub.dart'
    if (dart.library.js_interop) 'authenticated_media_blob_web.dart';

String mimeTypeForMediaUrl(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  if (path.endsWith('.webm')) {
    return 'video/webm';
  }
  if (path.endsWith('.mov')) {
    return 'video/quicktime';
  }
  return 'video/mp4';
}
