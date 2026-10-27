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

  Future<List<CameraRecordingFile>> pickFiles();

  Future<AssetUploadResult> uploadFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
    String subject = '',
    String situation = '',
    void Function(double progressPercent)? onProgress,
  });

  /// tus로 이미 받은 파일을 재전송 없이 등록(§4.3).
  Future<AssetUploadResult> registerUploaded({
    required String uploadId,
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    String subject = '',
    String situation = '',
    String fallbackFileName = '',
  });
}
