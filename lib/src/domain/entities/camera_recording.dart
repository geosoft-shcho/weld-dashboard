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

/// 웹 파일 선택 결과. 읽기 실패한 파일은 [warnings]에만 남긴다.
class AssetPickResult {
  const AssetPickResult({
    this.files = const [],
    this.warnings = const [],
  });

  final List<CameraRecordingFile> files;
  final List<String> warnings;
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
