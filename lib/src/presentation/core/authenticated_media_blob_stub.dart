import 'dart:typed_data';

/// non-Web: blob URL을 쓰지 않는다. 호출되면 빈 문자열.
String createAuthenticatedMediaBlobUrl(
  Uint8List bytes, {
  String mimeType = 'video/mp4',
}) {
  return '';
}

void revokeAuthenticatedMediaBlobUrl(String url) {}
