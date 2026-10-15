import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/camera_recording_exception.dart';
import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/tool_run.dart';
import '../../../domain/use_cases/download_camera_recording_file_use_case.dart';
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
  });

  final String jobId;
  final Future<void> Function() onUploaded;
  final Future<void> Function({required String assetId, required bool isVideo})
  onRecordingPlaced;
}

class CameraRecordingViewModel extends ChangeNotifier {
  CameraRecordingViewModel({
    required this._prepareCameraRecordingUseCase,
    required this._startCameraRecordingUseCase,
    required this._stopCameraRecordingUseCase,
    required this._downloadCameraRecordingFileUseCase,
    required this._releaseCameraRecordingUseCase,
    required this._readCameraPreviewHandleUseCase,
    required this._uploadAssetUseCase,
    required this._toolRunUseCase,
    required this.jobId,
    required this.onUploaded,
    required this.onRecordingPlaced,
  });

  final PrepareCameraRecordingUseCase _prepareCameraRecordingUseCase;
  final StartCameraRecordingUseCase _startCameraRecordingUseCase;
  final StopCameraRecordingUseCase _stopCameraRecordingUseCase;
  final DownloadCameraRecordingFileUseCase _downloadCameraRecordingFileUseCase;
  final ReleaseCameraRecordingUseCase _releaseCameraRecordingUseCase;
  final ReadCameraPreviewHandleUseCase _readCameraPreviewHandleUseCase;
  final UploadAssetUseCase _uploadAssetUseCase;
  final ToolRunUseCase _toolRunUseCase;
  final String jobId;
  final Future<void> Function() onUploaded;
  final Future<void> Function({required String assetId, required bool isVideo})
  onRecordingPlaced;

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

  bool get canSaveVideo => recording != null && !canStop && !isUploading;

  bool get canSaveAudio => recording != null && !canStop && !isUploading;

  bool get canUpload =>
      recording != null &&
      !canStop &&
      !isUploading &&
      (!videoUploaded || !audioUploaded);

  bool get canRetry => phase == CameraRecordingPhase.failed;

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
      noticeText = '영상 저장과 음성 저장을 각각 눌러 파일을 내려받으세요.';
      isNoticeError = false;
    } catch (error) {
      phase = CameraRecordingPhase.ready;
      recording = null;
      noticeText = _message(error);
      isNoticeError = true;
    }
    _publish();
  }

  void didTapSaveVideo() {
    final file = recording?.video;
    if (file == null || !canSaveVideo) {
      return;
    }
    _save(file, '영상 파일 저장 창을 열었습니다.');
  }

  void didTapSaveAudio() {
    final file = recording?.audio;
    if (file == null || !canSaveAudio) {
      return;
    }
    _save(file, '음성 파일 저장 창을 열었습니다.');
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
    if (!videoUploaded) {
      final assetId = await _uploadFile(
        label: '영상',
        file: value.video,
        recordedAt: value.recordedAt,
        onSuccess: () => videoUploaded = true,
        errors: errors,
        warnings: warnings,
      );
      await _placeUploaded(
        assetId: assetId,
        isVideo: true,
        label: '영상',
        errors: errors,
      );
    }
    if (!audioUploaded) {
      final assetId = await _uploadFile(
        label: '음성',
        file: value.audio,
        recordedAt: value.recordedAt,
        onSuccess: () => audioUploaded = true,
        errors: errors,
        warnings: warnings,
      );
      await _placeUploaded(
        assetId: assetId,
        isVideo: false,
        label: '음성',
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
    if (errors.isEmpty && videoUploaded && audioUploaded) {
      noticeText = ['영상과 음성 업로드가 완료되었습니다.', ...warnings].join(' ');
      isNoticeError = false;
    } else {
      noticeText = details.join(' ');
      isNoticeError = errors.isNotEmpty;
    }
    _publish();
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

  Future<void> _placeUploaded({
    required String? assetId,
    required bool isVideo,
    required String label,
    required List<String> errors,
  }) async {
    if (assetId == null || assetId.isEmpty || _isDisposed) {
      return;
    }
    try {
      await onRecordingPlaced(assetId: assetId, isVideo: isVideo);
    } catch (error) {
      errors.add('$label 타임라인 배치 실패: ${_message(error)}');
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
      if (run.status == ToolRunStatus.succeeded) {
        return;
      }
      if (run.status == ToolRunStatus.failed) {
        throw AssetUploadException(
          run.errorMessage.isEmpty ? '파일 후처리에 실패했습니다.' : run.errorMessage,
        );
      }
      if (run.status == ToolRunStatus.canceled) {
        throw const AssetUploadException('파일 후처리가 취소되었습니다.');
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> didTapRetry() => prepare();

  void _save(CameraRecordingFile file, String successText) {
    try {
      unawaited(_downloadCameraRecordingFileUseCase.execute(file));
      noticeText = '$successText ${file.fileName}';
      isNoticeError = false;
    } catch (error) {
      noticeText = _message(error);
      isNoticeError = true;
    }
    _publish();
  }

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
