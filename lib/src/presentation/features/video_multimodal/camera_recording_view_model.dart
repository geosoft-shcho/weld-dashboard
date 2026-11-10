import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/camera_recording_exception.dart';
import '../../../domain/use_cases/create_screen_comment_use_case.dart';
import '../../../domain/use_cases/prepare_camera_recording_use_case.dart';
import '../../../domain/use_cases/read_camera_preview_handle_use_case.dart';
import '../../../domain/use_cases/release_camera_recording_use_case.dart';
import '../../../domain/use_cases/start_camera_recording_use_case.dart';
import '../../../domain/use_cases/stop_camera_recording_use_case.dart';

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
    required CreateScreenCommentUseCase createScreenCommentUseCase,
    required this.jobId,
    this.passId = '',
    required this.onUploaded,
    required this.onRecordingPlaced,
    this.onUploadCompleted,
    this.capturesScreenComment = false,
    this.onRecordingStarted,
    this.takeScreenCommentContext,
  }) : _createScreenCommentUseCase = createScreenCommentUseCase;

  final PrepareCameraRecordingUseCase _prepareCameraRecordingUseCase;
  final StartCameraRecordingUseCase _startCameraRecordingUseCase;
  final StopCameraRecordingUseCase _stopCameraRecordingUseCase;
  final ReleaseCameraRecordingUseCase _releaseCameraRecordingUseCase;
  final ReadCameraPreviewHandleUseCase _readCameraPreviewHandleUseCase;
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
  DateTime? _recordingStartedAt;
  Timer? _recordingElapsedTimer;
  int _recordingElapsedSeconds = 0;

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

  /// 아직 안 올린 녹화 파일(다이얼로그 초기 첨부용).
  List<CameraRecordingFile> pendingUploadFiles() {
    final value = recording;
    if (value == null) {
      return const [];
    }
    return [if (!videoUploaded) value.video, if (!audioUploaded) value.audio];
  }

  /// 녹화 중일 때만 `M:SS` 또는 `H:MM:SS`.
  String get recordingElapsedLabel {
    if (phase != CameraRecordingPhase.recording) {
      return '';
    }
    return _formatElapsed(_recordingElapsedSeconds);
  }

  void didBeginPreparingUploadDialog() {
    isUploading = true;
    noticeText = '타임라인에 올리기 창을 준비하고 있습니다.';
    isNoticeError = false;
    _publish();
  }

  void didFailPreparingUploadDialog(String message) {
    isUploading = false;
    noticeText = message;
    isNoticeError = true;
    _publish();
  }

  void didReadyUploadDialog() {
    isUploading = false;
    _publish();
  }

  Future<void> prepare() async {
    _stopRecordingElapsedTimer();
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
      _startRecordingElapsedTimer();
    } catch (error) {
      _stopRecordingElapsedTimer();
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
    _stopRecordingElapsedTimer();
    try {
      recording = await _stopCameraRecordingUseCase.execute();
      phase = CameraRecordingPhase.stopped;
      noticeText = '타임라인에 올리기를 눌러 저장하세요.';
      isNoticeError = false;
    } catch (error) {
      phase = CameraRecordingPhase.ready;
      recording = null;
      noticeText = _message(error);
      isNoticeError = true;
    }
    _publish();
  }

  /// 타임라인에 올리기 다이얼로그 성공 후 배치·화면 코멘트.
  Future<void> didFinishAssetUpload(AssetUploadBatchResult batch) async {
    final value = recording;
    if (value == null || _isDisposed) {
      return;
    }
    commentBody = batch.screenCommentBody;
    isUploading = true;
    noticeText = '타임라인에 배치하고 있습니다.';
    isNoticeError = false;
    _publish();

    final errors = <String>[];
    final warnings = <String>[];
    for (final note in batch.warningNotes) {
      warnings.add(note);
    }
    for (final note in batch.failureNotes) {
      errors.add(note);
    }

    String? videoAssetId;
    String? audioAssetId;
    for (final item in batch.items) {
      final result = item.result;
      if (result == null || result.assetId.isEmpty) {
        continue;
      }
      final isAudio = _isAudioFile(
        fileName: result.fileName,
        fallbackName: item.fileName,
        recording: value,
      );
      if (isAudio) {
        audioAssetId = result.assetId;
        audioUploaded = true;
      } else {
        videoAssetId = result.assetId;
        videoUploaded = true;
      }
    }

    var videoPlaced = videoAssetId == null || videoAssetId.isEmpty;
    var audioPlaced = audioAssetId == null || audioAssetId.isEmpty;
    if (videoAssetId != null && videoAssetId.isNotEmpty) {
      videoPlaced = await _placeUploaded(
        assetId: videoAssetId,
        isVideo: true,
        label: '영상',
        errors: errors,
      );
    }
    if (audioAssetId != null && audioAssetId.isNotEmpty) {
      audioPlaced = await _placeUploaded(
        assetId: audioAssetId,
        isVideo: false,
        label: '음성',
        errors: errors,
      );
    }
    var didCreateComment = false;
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
      didCreateComment = errors.isEmpty;
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
      final parts = <String>['타임라인에 올렸습니다.'];
      if (didCreateComment) {
        parts.add('코멘트도 등록되었습니다.');
      }
      parts.addAll(warnings);
      noticeText = parts.join(' ');
      isNoticeError = false;
    } else if (details.isEmpty) {
      noticeText = '일부만 올렸습니다. 다시 타임라인에 올리기를 눌러 나머지를 올리세요.';
      isNoticeError = true;
    } else {
      noticeText = details.join(' ');
      isNoticeError = errors.isNotEmpty;
    }
    _publish();
    if (didFinish && !_isDisposed) {
      await onUploadCompleted?.call();
    }
  }

  bool _isAudioFile({
    required String fileName,
    required String fallbackName,
    required CameraRecording recording,
  }) {
    final name = fileName.isEmpty ? fallbackName : fileName;
    if (name == recording.audio.fileName) {
      return true;
    }
    if (name == recording.video.fileName) {
      return false;
    }
    return name.toLowerCase().contains('audio');
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

  Future<void> didTapRetry() => prepare();

  void _startRecordingElapsedTimer() {
    _stopRecordingElapsedTimer();
    _recordingStartedAt = DateTime.now();
    _recordingElapsedSeconds = 0;
    _recordingElapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final started = _recordingStartedAt;
      if (_isDisposed ||
          started == null ||
          phase != CameraRecordingPhase.recording) {
        _stopRecordingElapsedTimer();
        return;
      }
      _recordingElapsedSeconds = DateTime.now()
          .difference(started)
          .inSeconds
          .clamp(0, 24 * 60 * 60);
      _publish();
    });
  }

  void _stopRecordingElapsedTimer() {
    _recordingElapsedTimer?.cancel();
    _recordingElapsedTimer = null;
    _recordingStartedAt = null;
    _recordingElapsedSeconds = 0;
  }

  String _formatElapsed(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final ss = seconds.toString().padLeft(2, '0');
    if (hours > 0) {
      final mm = minutes.toString().padLeft(2, '0');
      return '$hours:$mm:$ss';
    }
    return '$minutes:$ss';
  }

  String _message(Object error) {
    if (error is CameraRecordingException) {
      return error.message;
    }
    if (error is AssetUploadException) {
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
    _stopRecordingElapsedTimer();
    unawaited(_releaseCameraRecordingUseCase.execute());
    super.dispose();
  }
}
