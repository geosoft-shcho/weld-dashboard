import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<String> uploadAssetMultipart({
  required String url,
  required String metadata,
  required String fileName,
  required String mimeType,
  required Uint8List bytes,
  String? bearerToken,
}) async {
  final form = web.FormData();
  form.append('metadata', metadata.toJS);
  final file = web.File(
    [bytes.toJS].toJS,
    fileName,
    web.FilePropertyBag(type: mimeType),
  );
  form.append('file', file, fileName);
  final headers = web.Headers();
  final token = bearerToken?.trim() ?? '';
  if (token.isNotEmpty) {
    headers.set('Authorization', 'Bearer $token');
  }
  final response = await web.window
      .fetch(
        url.toJS,
        web.RequestInit(method: 'POST', headers: headers, body: form),
      )
      .toDart;
  final body = (await response.text().toDart).toDart;
  if (!response.ok) {
    final message = body.trim();
    throw StateError(
      message.isEmpty ? '파일 업로드 실패 (${response.status})' : message,
    );
  }
  return body;
}
