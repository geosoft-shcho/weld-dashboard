import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

String createAuthenticatedMediaBlobUrl(
  Uint8List bytes, {
  String mimeType = 'video/mp4',
}) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  return web.URL.createObjectURL(blob);
}

void revokeAuthenticatedMediaBlobUrl(String url) {
  if (url.isEmpty) {
    return;
  }
  web.URL.revokeObjectURL(url);
}
