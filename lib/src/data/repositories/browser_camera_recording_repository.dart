import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/camera_recording.dart';
import '../../domain/entities/camera_recording_exception.dart';
import '../../domain/repositories/camera_recording_repository.dart';
import '../datasources/browser_file_download.dart';
import '../datasources/microphone_track_recorder.dart';

class BrowserCameraRecordingRepository implements CameraRecordingRepository {
  CameraController? _controller;
  final MicrophoneTrackRecorder _audioRecorder = MicrophoneTrackRecorder();
  DateTime? _recordedAt;
  int _generation = 0;

  @override
  Object? get previewHandle => _controller;

  @override
  Future<void> prepare() async {
    final generation = ++_generation;
    await _releaseController();
    if (!kIsWeb) {
      throw CameraRecordingException('카메라 녹화 파일 저장은 웹 브라우저에서만 할 수 있습니다.');
    }
    try {
      final cameras = await availableCameras();
      if (generation != _generation) {
        return;
      }
      if (cameras.isEmpty) {
        throw CameraRecordingException('사용할 수 있는 카메라가 없습니다.');
      }
      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: true,
      );
      try {
        await controller.initialize();
      } catch (error) {
        await controller.dispose();
        throw _asRecordingException(error);
      }
      if (generation != _generation) {
        await controller.dispose();
        return;
      }
      _controller = controller;
    } catch (error) {
      if (generation != _generation) {
        return;
      }
      throw _asRecordingException(error);
    }
  }

  @override
  Future<void> start() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw CameraRecordingException('카메라가 준비되지 않았습니다.');
    }
    if (controller.value.isRecordingVideo) {
      throw CameraRecordingException('이미 녹화 중입니다.');
    }
    _recordedAt = DateTime.now();
    try {
      await _audioRecorder.start();
      await controller.startVideoRecording();
    } catch (error) {
      await _audioRecorder.cancel();
      if (controller.value.isRecordingVideo) {
        try {
          await controller.stopVideoRecording();
        } catch (_) {}
      }
      throw _asRecordingException(error);
    }
  }

  @override
  Future<CameraRecording> stop() async {
    final controller = _controller;
    if (controller == null || !controller.value.isRecordingVideo) {
      throw CameraRecordingException('녹화를 시작하기 전에 정지할 수 없습니다.');
    }
    final recordedAt = _recordedAt ?? DateTime.now();
    try {
      final videoFile = await controller.stopVideoRecording();
      final videoBytes = await videoFile.readAsBytes();
      final audioBytes = await _audioRecorder.stop();
      if (videoBytes.isEmpty) {
        throw CameraRecordingException('영상 파일이 비어 있습니다.');
      }
      final videoMimeType = _videoMimeType(videoFile.mimeType);
      final audioMimeType = _audioRecorder.mimeType;
      final stamp = _stamp(recordedAt);
      return CameraRecording(
        recordedAt: recordedAt,
        video: CameraRecordingFile(
          bytes: videoBytes,
          mimeType: videoMimeType,
          fileName: 'camera-$stamp-video.${_extensionFor(videoMimeType)}',
        ),
        audio: CameraRecordingFile(
          bytes: audioBytes,
          mimeType: audioMimeType,
          fileName: 'camera-$stamp-audio.${_extensionFor(audioMimeType)}',
        ),
      );
    } catch (error) {
      await _audioRecorder.cancel();
      throw _asRecordingException(error);
    }
  }

  @override
  Future<void> downloadFile(CameraRecordingFile file) {
    return downloadBrowserFile(
      bytes: file.bytes,
      mimeType: file.mimeType,
      fileName: file.fileName,
    );
  }

  @override
  Future<void> release() async {
    _generation++;
    await _releaseController();
  }

  Future<void> _releaseController() async {
    final controller = _controller;
    _controller = null;
    if (controller != null && controller.value.isRecordingVideo) {
      try {
        await controller.stopVideoRecording();
      } catch (_) {}
    }
    await _audioRecorder.cancel();
    if (controller != null) {
      await controller.dispose();
    }
  }

  String _videoMimeType(String? mimeType) {
    final value = mimeType?.trim() ?? '';
    if (value.isEmpty) {
      return 'video/webm';
    }
    return value;
  }

  String _extensionFor(String mimeType) {
    final mime = mimeType.toLowerCase().split(';').first.trim();
    if (mime == 'audio/mp4') {
      return 'm4a';
    }
    if (mime == 'video/mp4') {
      return 'mp4';
    }
    return 'webm';
  }

  String _stamp(DateTime recordedAt) {
    final local = recordedAt.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${local.year}${two(local.month)}${two(local.day)}-'
        '${two(local.hour)}${two(local.minute)}${two(local.second)}';
  }

  CameraRecordingException _asRecordingException(Object error) {
    if (error is CameraRecordingException) {
      return error;
    }
    if (error is CameraException) {
      final description = error.description?.trim() ?? '';
      if (description.isNotEmpty) {
        return CameraRecordingException(description);
      }
      return CameraRecordingException(error.code);
    }
    return CameraRecordingException(error.toString());
  }
}
