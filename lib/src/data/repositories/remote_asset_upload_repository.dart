import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/asset_upload.dart';
import '../../domain/entities/camera_recording.dart';
import '../../domain/repositories/asset_upload_repository.dart';
import '../datasources/asset_file_picker.dart';
import '../datasources/asset_multipart_upload.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/remote/media_tag_data_source.dart';

typedef AssetMultipartUpload =
    Future<String> Function({
      required String url,
      required String metadata,
      required String fileName,
      required String mimeType,
      required Uint8List bytes,
    });

class RemoteAssetUploadRepository implements AssetUploadRepository {
  RemoteAssetUploadRepository(
    this._mediaTag, [
    this._upload = uploadAssetMultipart,
  ]);

  final MediaTagDataSource _mediaTag;
  final AssetMultipartUpload _upload;

  @override
  Future<AssetUploadResult> upload({
    required String jobId,
    required DateTime timeOrigin,
    required CameraRecordingFile file,
  }) {
    return uploadFile(
      jobId: jobId,
      passId: '',
      equipmentId: '',
      timeOrigin: timeOrigin,
      file: file,
    );
  }

  @override
  Future<AssetUploadFormats> listUploadFormats() async {
    final response = await _mediaTag.assetService.listUploadFormats(
      asset_pb.ListUploadFormatsRequest(),
    );
    return AssetUploadFormats(
      formats: [
        for (final format in response.formats)
          AssetUploadFormat(
            label: format.label.isEmpty ? format.name : format.label,
            extensions: format.extensions,
            steps: format.steps,
            timeOriginRequired: format.timeOriginRequired,
          ),
      ],
      maxBytes: response.maxBytes.toInt(),
    );
  }

  @override
  Future<CameraRecordingFile?> pickFile() => pickAssetFile();

  @override
  Future<AssetUploadResult> uploadFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
  }) async {
    try {
      final body = await _upload(
        url: _mediaTag.resolveContentUrl('/assets'),
        metadata: jsonEncode({
          if (_hasId(jobId)) 'jobId': jobId,
          if (_hasId(passId)) 'passId': passId,
          if (_hasId(equipmentId)) 'equipmentId': equipmentId,
          if (timeOrigin != null)
            'timeOrigin': timeOrigin.toUtc().toIso8601String(),
        }),
        fileName: file.fileName,
        mimeType: file.mimeType,
        bytes: file.bytes,
      );
      final decoded = jsonDecode(body);
      if (decoded is! Map || decoded['asset'] is! Map) {
        throw const AssetUploadException('업로드 응답에 파일 정보가 없습니다.');
      }
      final asset = decoded['asset'] as Map;
      final assetId = _text(asset['assetId']);
      if (assetId.isEmpty) {
        throw const AssetUploadException('업로드 응답에 파일 번호가 없습니다.');
      }
      final warnings = decoded['warnings'];
      final duplicates = decoded['duplicateOf'];
      return AssetUploadResult(
        assetId: assetId,
        fileName: _text(asset['fileName']).isEmpty
            ? file.fileName
            : _text(asset['fileName']),
        runId: _text(decoded['runId']),
        warnings: warnings is List
            ? [for (final warning in warnings) warning.toString()]
            : const [],
        duplicateAssetIds: duplicates is List
            ? [for (final id in duplicates) id.toString()]
            : const [],
      );
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  bool _hasId(String id) => id.isNotEmpty && id != '0';

  String _text(Object? value) => value?.toString().trim() ?? '';
}
