import '../entities/asset_upload.dart';
import '../entities/camera_recording.dart';

abstract class AssetUploadRepository {
  Future<AssetUploadResult> upload({
    required String jobId,
    required DateTime timeOrigin,
    required CameraRecordingFile file,
  });
}
