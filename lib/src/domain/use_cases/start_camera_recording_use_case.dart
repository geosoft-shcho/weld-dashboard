import '../repositories/camera_recording_repository.dart';

class StartCameraRecordingUseCase {
  StartCameraRecordingUseCase(this._repository);

  final CameraRecordingRepository _repository;

  Future<void> execute() => _repository.start();
}
