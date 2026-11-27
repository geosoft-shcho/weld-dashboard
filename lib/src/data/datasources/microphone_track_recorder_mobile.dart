import 'dart:io';
import 'dart:typed_data';

import 'package:record/record.dart';

import '../../domain/entities/camera_recording_exception.dart';

class MicrophoneTrackRecorder {
  AudioRecorder? _recorder;
  String? _path;

  String get mimeType => 'audio/mp4';

  Future<void> start() async {
    await cancel();
    final recorder = AudioRecorder();
    try {
      if (!await recorder.hasPermission()) {
        throw CameraRecordingException('마이크 권한을 허용해 주세요.');
      }
      final file = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'camera-audio-${DateTime.now().microsecondsSinceEpoch}.m4a',
      );
      await recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: file.path,
      );
      _recorder = recorder;
      _path = file.path;
    } catch (error) {
      await recorder.dispose();
      if (error is CameraRecordingException) {
        rethrow;
      }
      throw CameraRecordingException(error.toString());
    }
  }

  Future<Uint8List> stop() async {
    final recorder = _recorder;
    final path = _path;
    if (recorder == null || path == null) {
      throw CameraRecordingException('녹화를 시작하기 전에 음성을 저장할 수 없습니다.');
    }
    try {
      await recorder.stop();
      final file = File(path);
      final bytes = await file.readAsBytes();
      await file.delete();
      _path = null;
      await recorder.dispose();
      _recorder = null;
      if (bytes.isEmpty) {
        throw CameraRecordingException('음성 파일이 비어 있습니다.');
      }
      return bytes;
    } catch (error) {
      await cancel();
      if (error is CameraRecordingException) {
        rethrow;
      }
      throw CameraRecordingException(error.toString());
    }
  }

  Future<void> cancel() async {
    final recorder = _recorder;
    _recorder = null;
    if (recorder != null) {
      try {
        await recorder.cancel();
      } catch (_) {}
      await recorder.dispose();
    }
    final path = _path;
    _path = null;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
