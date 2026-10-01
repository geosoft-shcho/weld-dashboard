import 'dart:typed_data';

import '../../domain/entities/camera_recording_exception.dart';

Future<void> downloadBrowserFile({
  required Uint8List bytes,
  required String mimeType,
  required String fileName,
}) {
  throw CameraRecordingException('카메라 녹화 파일 저장은 웹 브라우저에서만 할 수 있습니다.');
}
