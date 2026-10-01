import '../repositories/camera_recording_repository.dart';

class ReleaseCameraRecordingUseCase {
  ReleaseCameraRecordingUseCase(this._repository);

  final CameraRecordingRepository _repository;

  Future<void> execute() => _repository.release();
}
