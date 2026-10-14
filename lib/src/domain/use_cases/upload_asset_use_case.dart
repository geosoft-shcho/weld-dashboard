import '../entities/asset_upload.dart';
import '../entities/camera_recording.dart';
import '../repositories/asset_upload_repository.dart';

class UploadAssetUseCase {
  const UploadAssetUseCase(this._repository);

  final AssetUploadRepository _repository;

  Future<AssetUploadResult> execute({
    required String jobId,
    required DateTime timeOrigin,
    required CameraRecordingFile file,
  }) {
    if (jobId.isEmpty) {
      throw const AssetUploadException('작업을 열지 못했습니다.');
    }
    if (file.bytes.isEmpty) {
      throw const AssetUploadException('업로드할 파일이 비어 있습니다.');
    }
    return _repository.upload(jobId: jobId, timeOrigin: timeOrigin, file: file);
  }
}
