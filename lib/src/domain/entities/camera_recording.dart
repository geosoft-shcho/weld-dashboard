import 'dart:typed_data';

class CameraRecordingFile {
  const CameraRecordingFile({
    required this.bytes,
    required this.mimeType,
    required this.fileName,
    this.lastModifiedAt,
  });

  final Uint8List bytes;
  final String mimeType;
  final String fileName;
  final DateTime? lastModifiedAt;
}

class CameraRecording {
  const CameraRecording({
    required this.video,
    required this.audio,
    required this.recordedAt,
  });

  final CameraRecordingFile video;
  final CameraRecordingFile audio;
  final DateTime recordedAt;
}
