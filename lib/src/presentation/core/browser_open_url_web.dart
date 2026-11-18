import 'dart:js_interop';

import 'package:web/web.dart' as web;

void openBrowserUrl(String url) {
  if (url.isEmpty) {
    return;
  }
  web.window.open(url, '_blank');
}

Future<void> downloadBrowserUrl(String url, {String fileName = ''}) async {
  if (url.isEmpty) {
    return;
  }
  final name = fileName.trim().isEmpty ? 'download' : fileName.trim();
  try {
    final response = await web.window.fetch(url.toJS).toDart;
    if (!response.ok) {
      openBrowserUrl(url);
      return;
    }
    final blob = await response.blob().toDart;
    final objectUrl = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = objectUrl
      ..download = name
      ..style.display = 'none';
    web.document.body!.appendChild(anchor);
    anchor.click();
    anchor.remove();
    web.URL.revokeObjectURL(objectUrl);
  } catch (_) {
    openBrowserUrl(url);
  }
}
