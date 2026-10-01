import 'dart:typed_data';

import '../../domain/entities/camera_recording_exception.dart';

class MicrophoneTrackRecorder {
  String get mimeType => 'audio/webm';

  Future<void> start() async {
    throw CameraRecordingException('카메라 녹화 파일 저장은 웹 브라우저에서만 할 수 있습니다.');
  }

  Future<Uint8List> stop() async {
    throw CameraRecordingException('카메라 녹화 파일 저장은 웹 브라우저에서만 할 수 있습니다.');
  }

  Future<void> cancel() async {}
}
