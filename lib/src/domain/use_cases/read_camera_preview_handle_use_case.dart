import '../repositories/camera_recording_repository.dart';

class ReadCameraPreviewHandleUseCase {
  ReadCameraPreviewHandleUseCase(this._repository);

  final CameraRecordingRepository _repository;

  Object? execute() => _repository.previewHandle;
}
