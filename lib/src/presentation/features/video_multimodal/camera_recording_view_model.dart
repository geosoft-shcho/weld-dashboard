import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/camera_recording_exception.dart';
import '../../../domain/use_cases/download_camera_recording_file_use_case.dart';
import '../../../domain/use_cases/prepare_camera_recording_use_case.dart';
import '../../../domain/use_cases/read_camera_preview_handle_use_case.dart';
import '../../../domain/use_cases/release_camera_recording_use_case.dart';
import '../../../domain/use_cases/start_camera_recording_use_case.dart';
import '../../../domain/use_cases/stop_camera_recording_use_case.dart';

enum CameraRecordingPhase { preparing, ready, recording, stopped, failed }

class CameraRecordingViewModel extends ChangeNotifier {
  CameraRecordingViewModel({
    required this._prepareCameraRecordingUseCase,
    required this._startCameraRecordingUseCase,
    required this._stopCameraRecordingUseCase,
    required this._downloadCameraRecordingFileUseCase,
    required this._releaseCameraRecordingUseCase,
    required this._readCameraPreviewHandleUseCase,
  });

  final PrepareCameraRecordingUseCase _prepareCameraRecordingUseCase;
  final StartCameraRecordingUseCase _startCameraRecordingUseCase;
  final StopCameraRecordingUseCase _stopCameraRecordingUseCase;
  final DownloadCameraRecordingFileUseCase _downloadCameraRecordingFileUseCase;
  final ReleaseCameraRecordingUseCase _releaseCameraRecordingUseCase;
  final ReadCameraPreviewHandleUseCase _readCameraPreviewHandleUseCase;

  CameraRecordingPhase phase = CameraRecordingPhase.preparing;
  String noticeText = '';
  bool isNoticeError = false;
  CameraRecording? recording;
  bool _isDisposed = false;

  CameraController? get cameraController {
    final handle = _readCameraPreviewHandleUseCase.execute();
    if (handle is CameraController && handle.value.isInitialized) {
      return handle;
    }
    return null;
  }

  bool get canStart =>
      phase == CameraRecordingPhase.ready ||
      phase == CameraRecordingPhase.stopped;

  bool get canStop => phase == CameraRecordingPhase.recording;

  bool get canSaveVideo => recording != null && !canStop;

  bool get canSaveAudio => recording != null && !canStop;

  bool get canRetry => phase == CameraRecordingPhase.failed;

  Future<void> prepare() async {
    phase = CameraRecordingPhase.preparing;
    noticeText = '';
    recording = null;
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
