import 'dart:convert';
import 'dart:js_interop';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'asset_json_post_web.dart';

/// tus 1.0 — POST /uploads/ → PATCH 조각 → 마지막 응답(또는 POST /assets {uploadId}).
Future<String> uploadAssetTus({
  required String endpoint,
  required String assetsUrl,
  required String metadataJson,
  required String fileName,
  required Uint8List bytes,
  void Function(double progressPercent)? onProgress,
}) async {
  const chunkSize = 64 * 1024 * 1024;
  final createHeaders = web.Headers();
  createHeaders.set('Tus-Resumable', '1.0.0');
  createHeaders.set('Upload-Length', '${bytes.length}');
  createHeaders.set(
    'Upload-Metadata',
    'filename ${_b64(fileName)},metadata ${_b64(metadataJson)}',
  );
  final created = await web.window
      .fetch(
        endpoint.toJS,
        web.RequestInit(method: 'POST', headers: createHeaders),
      )
      .toDart;
  if (!created.ok) {
    throw StateError(await _errorBody(created, '이어 올리기 시작 실패'));
  }
  final location = created.headers.get('Location');
  if (location == null || location.isEmpty) {
    throw StateError('이어 올리기 주소를 받지 못했습니다.');
  }
  final uploadUrl = _absoluteUrl(endpoint, location);

  var offset = 0;
  var lastBody = '';
  while (offset < bytes.length) {
    final end = math.min(offset + chunkSize, bytes.length);
    final chunk = bytes.sublist(offset, end);
    final patchHeaders = web.Headers();
    patchHeaders.set('Tus-Resumable', '1.0.0');
    patchHeaders.set('Upload-Offset', '$offset');
    patchHeaders.set('Content-Type', 'application/offset+octet-stream');
    final patched = await web.window
        .fetch(
          uploadUrl.toJS,
          web.RequestInit(
            method: 'PATCH',
            headers: patchHeaders,
            body: chunk.toJS,
          ),
        )
        .toDart;
    final body = (await patched.text().toDart).toDart;
    if (!patched.ok) {
      throw StateError(
        body.trim().isEmpty ? '이어 올리기 실패 (${patched.status})' : body.trim(),
      );
    }
    offset = end;
    onProgress?.call(offset * 100.0 / bytes.length);
    lastBody = body;
  }

  if (lastBody.trim().isEmpty) {
    final uploadId = uploadUrl.split('/').where((p) => p.isNotEmpty).last;
    lastBody = await postAssetJson(
      url: assetsUrl,
      jsonBody: jsonEncode({'uploadId': uploadId}),
    );
  }
  return lastBody;
}

String _b64(String value) => base64Encode(utf8.encode(value));

String _absoluteUrl(String endpoint, String location) {
  if (location.startsWith('http://') || location.startsWith('https://')) {
    return location;
  }
  final base = Uri.parse(endpoint);
  return base.resolve(location).toString();
}

Future<String> _errorBody(web.Response response, String fallback) async {
  final body = (await response.text().toDart).toDart.trim();
  if (body.isEmpty) {
    return '$fallback (${response.status})';
  }
  return body;
}
