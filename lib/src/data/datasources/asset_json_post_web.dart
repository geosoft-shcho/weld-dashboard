import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<String> postAssetJson({
  required String url,
  required String jsonBody,
}) async {
  final headers = web.Headers();
  headers.set('Content-Type', 'application/json');
  final response = await web.window
      .fetch(
        url.toJS,
        web.RequestInit(method: 'POST', headers: headers, body: jsonBody.toJS),
      )
      .toDart;
  final body = (await response.text().toDart).toDart;
  if (!response.ok) {
    final message = body.trim();
    throw StateError(
      message.isEmpty ? '등록 실패 (${response.status})' : message,
    );
  }
  return body;
}
