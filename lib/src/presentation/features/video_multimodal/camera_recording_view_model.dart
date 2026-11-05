import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/camera_recording_exception.dart';
import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/tool_run.dart';
import '../../../domain/use_cases/create_screen_comment_use_case.dart';
import '../../../domain/use_cases/prepare_camera_recording_use_case.dart';
import '../../../domain/use_cases/read_camera_preview_handle_use_case.dart';
import '../../../domain/use_cases/release_camera_recording_use_case.dart';
import '../../../domain/use_cases/start_camera_recording_use_case.dart';
import '../../../domain/use_cases/stop_camera_recording_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/upload_asset_use_case.dart';

enum CameraRecordingPhase { preparing, ready, recording, stopped, failed }

class CameraRecordingArgs {
  const CameraRecordingArgs({
    required this.jobId,
    required this.onUploaded,
    required this.onRecordingPlaced,
    this.onUploadCompleted,
    this.passId = '',
    this.capturesScreenComment = false,
    this.onRecordingStarted,
    this.takeScreenCommentContext,
  });

  final String jobId;
  final String passId;
  final Future<void> Function() onUploaded;
  final Future<void> Function({required String assetId, required bool isVideo})
  onRecordingPlaced;
  final Future<void> Function()? onUploadCompleted;
  final bool capturesScreenComment;
  final void Function()? onRecordingStarted;
  final List<Map<String, Object?>> Function()? takeScreenCommentContext;
}

class CameraRecordingViewModel extends ChangeNotifier {
  CameraRecordingViewModel({
    required this._prepareCameraRecordingUseCase,
    required this._startCameraRecordingUseCase,
    required this._stopCameraRecordingUseCase,
    required this._releaseCameraRecordingUseCase,
    required this._readCameraPreviewHandleUseCase,
    required UploadAssetUseCase uploadAssetUseCase,
    required ToolRunUseCase toolRunUseCase,
    required CreateScreenCommentUseCase createScreenCommentUseCase,
    required this.jobId,
    this.passId = '',
    required this.onUploaded,
    required this.onRecordingPlaced,
    this.onUploadCompleted,
    this.capturesScreenComment = false,
    this.onRecordingStarted,
    this.takeScreenCommentContext,
  }) : _uploadAssetUseCase = uploadAssetUseCase,
       _toolRunUseCase = toolRunUseCase,
       _createScreenCommentUseCase = createScreenCommentUseCase;

  final PrepareCameraRecordingUseCase _prepareCameraRecordingUseCase;
  final StartCameraRecordingUseCase _startCameraRecordingUseCase;
  final StopCameraRecordingUseCase _stopCameraRecordingUseCase;
  final ReleaseCameraRecordingUseCase _releaseCameraRecordingUseCase;
  final ReadCameraPreviewHandleUseCase _readCameraPreviewHandleUseCase;
  final UploadAssetUseCase _uploadAssetUseCase;
  final ToolRunUseCase _toolRunUseCase;
  final CreateScreenCommentUseCase _createScreenCommentUseCase;
  final String jobId;
  final String passId;
  final Future<void> Function() onUploaded;
  final Future<void> Function({required String assetId, required bool isVideo})
  onRecordingPlaced;
  final Future<void> Function()? onUploadCompleted;
  final bool capturesScreenComment;
  final void Function()? onRecordingStarted;
  final List<Map<String, Object?>> Function()? takeScreenCommentContext;

  String commentBody = '';

  CameraRecordingPhase phase = CameraRecordingPhase.preparing;
  String noticeText = '';
  bool isNoticeError = false;
  CameraRecording? recording;
  bool _isDisposed = false;
  bool isUploading = false;
  bool videoUploaded = false;
  bool audioUploaded = false;

  CameraController? get cameraController {
    final handle = _readCameraPreviewHandleUseCase.execute();
    if (handle is CameraController && handle.value.isInitialized) {
      return handle;
    }
    return null;
  }

  bool get canStart =>
      !isUploading &&
      (phase == CameraRecordingPhase.ready ||
          phase == CameraRecordingPhase.stopped);

  bool get canStop => phase == CameraRecordingPhase.recording;

  bool get canUpload =>
      recording != null &&
      !canStop &&
      !isUploading &&
      (!videoUploaded || !audioUploaded);

  bool get canRetry => phase == CameraRecordingPhase.failed;

  void didChangeCommentBody(String value) {
    commentBody = value;
  }

  Future<void> prepare() async {
    phase = CameraRecordingPhase.preparing;
    noticeText = '';
    recording = null;
    videoUploaded = false;
    audioUploaded = false;
    _publish();
    try {
      await _prepareCameraRecordingUseCase.execute();
      if (_isDisposed) {
        return;
      }
      phase = CameraRecordingPhase.ready;
      noticeText = '미리보기가 보이면 시작을 누르세요.';
      isNoticeError = false;
    } catch (error) {
      phase = CameraRecordingPhase.failed;
      noticeText = _message(error);
      isNoticeError = true;
    }
    _publish();
  }

  Future<void> didTapStart() async {
    if (!canStart) {
      return;
    }
    noticeText = '';
    _publish();
    try {
      await _startCameraRecordingUseCase.execute();
      phase = CameraRecordingPhase.recording;
      recording = null;
      videoUploaded = false;
      audioUploaded = false;
      onRecordingStarted?.call();
      noticeText = '녹화 중입니다.';
      isNoticeError = false;
    } catch (error) {
      phase = CameraRecordingPhase.ready;
      noticeText = _message(error);
      isNoticeError = true;
    }
    _publish();
  }

  Future<void> didTapStop() async {
    if (!canStop) {
      return;
    }
    try {
      recording = await _stopCameraRecordingUseCase.execute();
      phase = CameraRecordingPhase.stopped;
      noticeText = '녹화 파일 업로드를 눌러 서버에 저장하세요.';
      isNoticeError = false;
    } catch (error) {
      phase = CameraRecordingPhase.ready;
      recording = null;
      noticeText = _message(error);
      isNoticeError = true;
    }
    _publish();
  }

  Future<void> didTapUpload() async {
    final value = recording;
    if (value == null || !canUpload) {
      return;
    }
    isUploading = true;
    noticeText = '녹화 파일을 업로드하고 있습니다.';
    isNoticeError = false;
    _publish();

    final errors = <String>[];
    final warnings = <String>[];
    String? videoAssetId;
    String? audioAssetId;
    var videoPlaced = true;
    var audioPlaced = true;
    if (!videoUploaded) {
      videoAssetId = await _uploadFile(
        label: '영상',
        file: value.video,
        recordedAt: value.recordedAt,
        onSuccess: () => videoUploaded = true,
        errors: errors,
        warnings: warnings,
      );
      videoPlaced = await _placeUploaded(
        assetId: videoAssetId,
        isVideo: true,
        label: '영상',
        errors: errors,
      );
    }
    if (!audioUploaded) {
      audioAssetId = await _uploadFile(
        label: '음성',
        file: value.audio,
        recordedAt: value.recordedAt,
        onSuccess: () => audioUploaded = true,
        errors: errors,
        warnings: warnings,
      );
      audioPlaced = await _placeUploaded(
        assetId: audioAssetId,
        isVideo: false,
        label: '음성',
        errors: errors,
      );
    }
    if (capturesScreenComment &&
        audioAssetId != null &&
        audioAssetId.isNotEmpty &&
        audioPlaced &&
        videoPlaced &&
        errors.isEmpty) {
      await _createScreenComment(
        audioAssetId: audioAssetId,
        videoAssetId: videoAssetId ?? '',
        startedAt: value.recordedAt,
        errors: errors,
      );
    }
    if (_isDisposed) {
      return;
    }
    isUploading = false;
    if (videoUploaded || audioUploaded) {
      try {
        await onUploaded();
      } catch (error) {
        errors.add('새로고침 실패: ${_message(error)}');
      }
    }
    if (_isDisposed) {
      return;
    }
    final details = [...errors, ...warnings];
    final didFinish = errors.isEmpty && videoUploaded && audioUploaded;
    if (didFinish) {
      noticeText = ['영상과 음성 업로드가 완료되었습니다.', ...warnings].join(' ');
      isNoticeError = false;
    } else {
      noticeText = details.join(' ');
      isNoticeError = errors.isNotEmpty;
    }
    _publish();
    if (didFinish && !_isDisposed) {
      await onUploadCompleted?.call();
    }
  }

  Future<String?> _uploadFile({
    required String label,
    required CameraRecordingFile file,
    required DateTime recordedAt,
    required VoidCallback onSuccess,
    required List<String> errors,
    required List<String> warnings,
  }) async {
    try {
      noticeText = '$label 파일을 업로드하고 있습니다. ${file.fileName}';
      _publish();
      final result = await _uploadAssetUseCase.execute(
        jobId: jobId,
        timeOrigin: recordedAt,
        file: file,
      );
      onSuccess();
      warnings.addAll(result.warnings.map((warning) => '$label: $warning'));
      await _waitForPostprocess(result.runId);
      return result.assetId;
    } catch (error) {
      errors.add('$label 업로드 실패: ${_message(error)}');
      return null;
    }
  }

  Future<bool> _placeUploaded({
    required String? assetId,
    required bool isVideo,
    required String label,
    required List<String> errors,
  }) async {
    if (assetId == null || assetId.isEmpty || _isDisposed) {
      return false;
    }
    try {
      await onRecordingPlaced(assetId: assetId, isVideo: isVideo);
      return true;
    } catch (error) {
      errors.add('$label 타임라인 배치 실패: ${_message(error)}');
      return false;
    }
  }

  Future<void> _createScreenComment({
    required String audioAssetId,
    required String videoAssetId,
    required DateTime startedAt,
    required List<String> errors,
  }) async {
    try {
      final context =
          takeScreenCommentContext?.call() ??
          [
            {'t_ms': 0, 'screen': 'multimodal'},
          ];
      await _createScreenCommentUseCase.execute(
        jobId: jobId,
        passId: passId,
        audioAssetId: audioAssetId,
        videoAssetId: videoAssetId,
        body: commentBody.trim(),
        startedAt: startedAt,
        context: context,
      );
    } catch (error) {
      errors.add('화면 코멘트 실패: ${_message(error)}');
    }
  }

  Future<void> _waitForPostprocess(String runId) async {
    if (runId.isEmpty) {
      return;
    }
    noticeText = '업로드한 파일을 처리하고 있습니다.';
    _publish();
    while (!_isDisposed) {
      final run = await _toolRunUseCase.getRun(runId: runId);
      if (run.status == ToolRunStatus.queued) {
        final detail = run.queueWaitLabel;
        noticeText = detail.isEmpty
            ? '업로드한 파일을 처리하고 있습니다.'
            : '후처리 대기 · $detail';
        _publish();
      } else if (run.status == ToolRunStatus.running) {
        noticeText = '업로드한 파일을 처리하고 있습니다.';
        _publish();
      } else if (run.status == ToolRunStatus.succeeded) {
        return;
      } else if (run.status == ToolRunStatus.failed) {
        throw AssetUploadException(
          run.errorMessage.isEmpty ? '파일 후처리에 실패했습니다.' : run.errorMessage,
        );
      } else if (run.status == ToolRunStatus.canceled) {
        throw const AssetUploadException('파일 후처리가 취소되었습니다.');
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> didTapRetry() => prepare();

  String _message(Object error) {
    if (error is CameraRecordingException) {
      return error.message;
    }
    if (error is AssetUploadException) {
      return error.message;
    }
    if (error is ToolRunException) {
      return error.message;
    }
    return error.toString();
  }

  void _publish() {
    if (_isDisposed) {
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_releaseCameraRecordingUseCase.execute());
    super.dispose();
  }
}
