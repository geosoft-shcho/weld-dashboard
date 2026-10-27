import 'dart:typed_data';

/// 비웹에서는 이어 올리기를 쓰지 않는다.
Future<String> uploadAssetTus({
  required String endpoint,
  required String assetsUrl,
  required String metadataJson,
  required String fileName,
  required Uint8List bytes,
  void Function(double progressPercent)? onProgress,
}) {
  throw UnsupportedError('이어 올리기는 웹에서만 지원합니다.');
}
