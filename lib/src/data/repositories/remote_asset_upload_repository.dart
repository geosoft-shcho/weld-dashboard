import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../../domain/entities/asset_upload.dart';
import '../../domain/entities/camera_recording.dart';
import '../../domain/entities/screen_comment.dart';
import '../../domain/repositories/asset_upload_repository.dart';
import '../datasources/asset_file_picker.dart';
import '../datasources/asset_json_post.dart';
import '../datasources/asset_multipart_upload.dart';
import '../datasources/asset_tus_upload.dart';
import '../datasources/generated/google/protobuf/struct.pb.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/remote/asset_upload_debug_log.dart';
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

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

  /// 이 크기 이상이면 tus 이어 올리기(§4.3). 작으면 multipart.
  static const int tusMinBytes = 32 * 1024 * 1024;

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
  Future<List<CameraRecordingFile>> pickFiles() => pickAssetFiles();

  @override
  Future<AssetUploadResult> uploadFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
    String subject = '',
    String situation = '',
    void Function(double progressPercent)? onProgress,
  }) async {
    try {
      final metadata = _metadataJson(
        jobId: jobId,
        passId: passId,
        equipmentId: equipmentId,
        timeOrigin: timeOrigin,
        subject: subject,
        situation: situation,
      );
      final body = await _send(
        file: file,
        metadata: metadata,
        onProgress: onProgress,
      );
      return _resultFrom(body, file.fileName);
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  Future<String> _send({
    required CameraRecordingFile file,
    required String metadata,
    void Function(double progressPercent)? onProgress,
  }) async {
    final assetsUrl = _mediaTag.resolveContentUrl('/assets');
    final useTus = file.bytes.length >= tusMinBytes;
    if (useTus) {
      try {
        AssetUploadDebugLog.post(
          transport: 'tus',
          fileName: file.fileName,
          metadata: metadata,
          url: assetsUrl,
        );
        return await uploadAssetTus(
          endpoint: _mediaTag.resolveContentUrl('/uploads/'),
          assetsUrl: assetsUrl,
          metadataJson: metadata,
          fileName: file.fileName,
          bytes: file.bytes,
          onProgress: onProgress,
        );
      } on UnsupportedError {
        // 비웹 등 — multipart로 이어 간다.
      }
    }
    AssetUploadDebugLog.post(
      transport: 'multipart',
      fileName: file.fileName,
      metadata: metadata,
      url: assetsUrl,
    );
    return _upload(
      url: assetsUrl,
      metadata: metadata,
      fileName: file.fileName,
      mimeType: file.mimeType,
      bytes: file.bytes,
    );
  }

  String _metadataJson({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required String subject,
    required String situation,
  }) {
    final subjectText = subject.trim();
    final situationText = situation.trim();
    return jsonEncode({
      if (_hasId(jobId)) 'jobId': jobId,
      if (_hasId(passId)) 'passId': passId,
      if (_hasId(equipmentId)) 'equipmentId': equipmentId,
      if (timeOrigin != null)
        'timeOrigin': timeOrigin.toUtc().toIso8601String(),
      if (subjectText.isNotEmpty) 'subject': subjectText,
      if (situationText.isNotEmpty) 'situation': situationText,
    });
  }

  AssetUploadResult _resultFrom(String body, String fallbackName) {
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
          ? fallbackName
          : _text(asset['fileName']),
      runId: _text(decoded['runId']),
      warnings: warnings is List
          ? [for (final warning in warnings) warning.toString()]
          : const [],
      duplicateAssetIds: duplicates is List
          ? [for (final id in duplicates) id.toString()]
          : const [],
    );
  }

  @override
  Future<AssetUploadResult> registerUploaded({
    required String uploadId,
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    String subject = '',
    String situation = '',
    String fallbackFileName = '',
  }) async {
    if (uploadId.isEmpty) {
      throw const AssetUploadException('uploadId가 없습니다.');
    }
    try {
      final metadata = <String, Object?>{
        'uploadId': uploadId,
        ...jsonDecode(
              _metadataJson(
                jobId: jobId,
                passId: passId,
                equipmentId: equipmentId,
                timeOrigin: timeOrigin,
                subject: subject,
                situation: situation,
              ),
            )
            as Map<String, dynamic>,
      };
      final metadataJson = jsonEncode(metadata);
      AssetUploadDebugLog.post(
        transport: 'register',
        fileName: fallbackFileName,
        metadata: metadataJson,
        url: _mediaTag.resolveContentUrl('/assets'),
      );
      final body = await _postJsonAssets(metadataJson);
      return _resultFrom(body, fallbackFileName);
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  Future<String> _postJsonAssets(String jsonBody) async {
    return postAssetJson(
      url: _mediaTag.resolveContentUrl('/assets'),
      jsonBody: jsonBody,
    );
  }

  @override
  Future<String> retryPostprocess({required String assetId}) async {
    if (!_hasId(assetId)) {
      throw const AssetUploadException('다시 걸 에셋 번호가 없습니다.');
    }
    try {
      final response = await _mediaTag.assetService.retryPostprocess(
        asset_pb.RetryPostprocessRequest(assetId: protoId(assetId)),
      );
      final runId = idText(response.runId);
      if (runId.isEmpty) {
        throw const AssetUploadException('후처리 재시도 응답에 실행 번호가 없습니다.');
      }
      return runId;
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  @override
  Future<ScreenComment> createScreenComment({
    required String jobId,
    String passId = '',
    required String audioAssetId,
    String videoAssetId = '',
    String body = '',
    required DateTime startedAt,
    required List<Map<String, Object?>> context,
  }) async {
    final rows = ListValue();
    rows.mergeFromProto3Json(context);
    try {
      final response = await _mediaTag.assetService.createComment(
        asset_pb.CreateCommentRequest(
          jobId: protoId(jobId),
          passId: protoId(passId),
          audioAssetId: protoId(audioAssetId),
          videoAssetId: protoId(videoAssetId),
          body: body.trim(),
          startedAt: Timestamp.fromDateTime(startedAt.toUtc()),
          context: rows,
        ),
      );
      return _screenComment(response.comment);
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  @override
  Future<List<ScreenComment>> listScreenComments({
    required String jobId,
  }) async {
    try {
      final response = await _mediaTag.assetService.listComments(
        asset_pb.ListCommentsRequest(jobId: protoId(jobId), pageSize: 50),
      );
      return [for (final comment in response.comments) _screenComment(comment)];
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  @override
  Future<ScreenComment> updateScreenComment({
    required String commentId,
    required String body,
  }) async {
    try {
      final response = await _mediaTag.assetService.updateComment(
        asset_pb.UpdateCommentRequest(
          commentId: protoId(commentId),
          body: body.trim(),
        ),
      );
      return _screenComment(response.comment);
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  @override
  Future<void> deleteScreenComment({required String commentId}) async {
    try {
      await _mediaTag.assetService.deleteComment(
        asset_pb.DeleteCommentRequest(commentId: protoId(commentId)),
      );
    } on AssetUploadException {
      rethrow;
    } catch (error) {
      throw AssetUploadException(error.toString());
    }
  }

  ScreenComment _screenComment(asset_pb.Comment comment) {
    final hasRun = comment.hasStt() && comment.stt.runId != Int64.ZERO;
    final rawContext = comment.context.toProto3Json();
    final playback = screenCommentPlayback(
      rawContext is List ? rawContext : const [],
    );
    return ScreenComment(
      commentId: idText(comment.commentId),
      body: comment.body.trim(),
      sttLabel: screenCommentSttLabel(
        hasRun ? _sttKind(comment.stt.status) : ScreenCommentSttKind.missing,
      ),
      sttMessage: hasRun ? comment.stt.errorMessage.trim() : '',
      playClipId: playback.clipId,
      playheadNs: playback.playheadNs,
      videoAssetId: idText(comment.videoAssetId),
    );
  }

  ScreenCommentSttKind _sttKind(asset_pb.PostprocessStatus status) {
    switch (status) {
      case asset_pb.PostprocessStatus.POSTPROCESS_STATUS_QUEUED:
        return ScreenCommentSttKind.queued;
      case asset_pb.PostprocessStatus.POSTPROCESS_STATUS_RUNNING:
        return ScreenCommentSttKind.running;
      case asset_pb.PostprocessStatus.POSTPROCESS_STATUS_SUCCEEDED:
        return ScreenCommentSttKind.succeeded;
      case asset_pb.PostprocessStatus.POSTPROCESS_STATUS_FAILED:
        return ScreenCommentSttKind.failed;
      case asset_pb.PostprocessStatus.POSTPROCESS_STATUS_CANCELED:
        return ScreenCommentSttKind.canceled;
      case asset_pb.PostprocessStatus.POSTPROCESS_STATUS_UNSPECIFIED:
        return ScreenCommentSttKind.missing;
    }
    return ScreenCommentSttKind.missing;
  }

  bool _hasId(String id) => id.isNotEmpty && id != '0';

  String _text(Object? value) => value?.toString().trim() ?? '';
}
