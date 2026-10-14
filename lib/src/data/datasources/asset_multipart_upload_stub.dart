import 'dart:typed_data';

Future<String> uploadAssetMultipart({
  required String url,
  required String metadata,
  required String fileName,
  required String mimeType,
  required Uint8List bytes,
}) {
  throw UnsupportedError('파일 업로드는 웹 브라우저에서만 지원합니다.');
}
