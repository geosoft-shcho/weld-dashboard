import '../entities/camera_recording.dart';
import '../repositories/camera_recording_repository.dart';

class StopCameraRecordingUseCase {
  StopCameraRecordingUseCase(this._repository);

  final CameraRecordingRepository _repository;

  Future<CameraRecording> execute() => _repository.stop();
}
