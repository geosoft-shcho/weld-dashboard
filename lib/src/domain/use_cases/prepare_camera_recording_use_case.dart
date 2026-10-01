import '../repositories/camera_recording_repository.dart';

class PrepareCameraRecordingUseCase {
  PrepareCameraRecordingUseCase(this._repository);

  final CameraRecordingRepository _repository;

  Future<void> execute() => _repository.prepare();
}
