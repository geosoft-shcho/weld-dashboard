import '../entities/asset_upload.dart';
import '../entities/camera_recording.dart';

abstract class AssetUploadRepository {
  Future<AssetUploadResult> upload({
    required String jobId,
    required DateTime timeOrigin,
    required CameraRecordingFile file,
  });

  Future<AssetUploadFormats> listUploadFormats();

  Future<CameraRecordingFile?> pickFile();

  Future<AssetUploadResult> uploadFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
  });
}
