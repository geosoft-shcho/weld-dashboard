import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

Future<String> uploadAssetMultipart({
  required String url,
  required String metadata,
  required String fileName,
  required String mimeType,
  required Uint8List bytes,
  String? bearerToken,
}) async {
  final boundary = _boundary();
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers.contentType = ContentType(
      'multipart',
      'form-data',
      parameters: {'boundary': boundary},
    );
    final token = bearerToken?.trim() ?? '';
    if (token.isNotEmpty) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    }

    request.add(utf8.encode('--$boundary\r\n'));
    request.add(
      utf8.encode('Content-Disposition: form-data; name="metadata"\r\n\r\n'),
    );
    request.add(utf8.encode(metadata));
    request.add(utf8.encode('\r\n--$boundary\r\n'));
    request.add(
      utf8.encode(
        'Content-Disposition: form-data; name="file"; '
        'filename="${_safeFileName(fileName)}"\r\n'
        'Content-Type: $mimeType\r\n\r\n',
      ),
    );
    request.add(bytes);
    request.add(utf8.encode('\r\n--$boundary--\r\n'));

    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode < HttpStatus.ok ||
        response.statusCode >= HttpStatus.multipleChoices) {
      final message = body.trim();
      throw StateError(
        message.isEmpty ? '파일 업로드 실패 (${response.statusCode})' : message,
      );
    }
    return body;
  } finally {
    client.close(force: true);
  }
}

String _boundary() {
  final random = Random.secure();
  final suffix = List.generate(
    24,
    (_) => random.nextInt(16).toRadixString(16),
  ).join();
  return 'weld-dashboard-$suffix';
}

String _safeFileName(String fileName) {
  return fileName.replaceAll(RegExp(r'[\r\n"]'), '_').replaceAll('\\', '_');
}
