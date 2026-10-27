import '../../domain/entities/camera_recording.dart';

Future<CameraRecordingFile?> pickAssetFile() {
  throw UnsupportedError('파일 선택은 웹 브라우저에서만 지원합니다.');
}

Future<List<CameraRecordingFile>> pickAssetFiles({bool multiple = true}) {
  throw UnsupportedError('파일 선택은 웹 브라우저에서만 지원합니다.');
}
