import '../entities/camera_recording.dart';
import '../entities/camera_recording_exception.dart';
import '../repositories/camera_recording_repository.dart';

class DownloadCameraRecordingFileUseCase {
  DownloadCameraRecordingFileUseCase(this._repository);

  final CameraRecordingRepository _repository;

  Future<void> execute(CameraRecordingFile file) {
    if (file.bytes.isEmpty) {
      throw CameraRecordingException('저장할 파일이 비어 있습니다.');
    }
    return _repository.downloadFile(file);
  }
}
