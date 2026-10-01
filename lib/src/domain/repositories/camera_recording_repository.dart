import '../entities/camera_recording.dart';

abstract class CameraRecordingRepository {
  Object? get previewHandle;

  Future<void> prepare();

  Future<void> start();

  Future<CameraRecording> stop();

  Future<void> downloadFile(CameraRecordingFile file);

  Future<void> release();
}
