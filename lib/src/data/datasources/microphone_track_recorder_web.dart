import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import '../../domain/entities/camera_recording_exception.dart';

class MicrophoneTrackRecorder {
  web.MediaRecorder? _recorder;
  web.MediaStream? _audioStream;
  final List<web.Blob> _chunks = [];
  String _mimeType = 'audio/webm';

  String get mimeType => _mimeType.split(';').first;

  Future<void> start() async {
    await cancel();
    final source = await _waitForPreviewStream();
    final audioStream = web.MediaStream();
    for (final track in source.getAudioTracks().toDart) {
      audioStream.addTrack(track.clone());
    }
    final mimeType = _supportedAudioMimeType();
    final recorder = web.MediaRecorder(
      audioStream,
      web.MediaRecorderOptions(mimeType: mimeType),
    );
    _chunks.clear();
    recorder.ondataavailable = ((web.Event event) {
      final blobEvent = event as web.BlobEvent;
      if (blobEvent.data.size > 0) {
        _chunks.add(blobEvent.data);
      }
    }).toJS;
    recorder.start(1000);
    _recorder = recorder;
    _audioStream = audioStream;
    _mimeType = mimeType;
  }

  Future<Uint8List> stop() async {
    final recorder = _recorder;
    if (recorder == null || recorder.state == 'inactive') {
      throw CameraRecordingException('녹화를 시작하기 전에 음성을 저장할 수 없습니다.');
    }
    final completer = Completer<void>();
    recorder.onstop = ((web.Event _) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }).toJS;
    recorder.stop();
    await completer.future.timeout(const Duration(seconds: 5));
    _recorder = null;
    final bytes = await _bytesFromChunks();
    _releaseTracks();
    if (bytes.isEmpty) {
      throw CameraRecordingException('음성 파일이 비어 있습니다.');
    }
    return bytes;
  }

  Future<void> cancel() async {
    final recorder = _recorder;
    _recorder = null;
    if (recorder != null && recorder.state != 'inactive') {
      try {
        recorder.stop();
      } catch (_) {}
    }
    _chunks.clear();
    _releaseTracks();
  }

  Future<Uint8List> _bytesFromChunks() async {
    if (_chunks.isEmpty) {
      return Uint8List(0);
    }
    final blob = web.Blob(_chunks.toJS, web.BlobPropertyBag(type: mimeType));
    final buffer = await blob.arrayBuffer().toDart;
    return buffer.toDart.asUint8List();
  }

  void _releaseTracks() {
    final stream = _audioStream;
    _audioStream = null;
    if (stream == null) {
      return;
    }
    for (final track in stream.getTracks().toDart) {
      track.stop();
    }
  }

  String _supportedAudioMimeType() {
    const candidates = ['audio/webm;codecs=opus', 'audio/webm', 'audio/mp4'];
    for (final candidate in candidates) {
      if (web.MediaRecorder.isTypeSupported(candidate)) {
        return candidate;
      }
    }
    throw CameraRecordingException('이 브라우저에서는 음성 파일을 녹화할 수 없습니다.');
  }

  Future<web.MediaStream> _waitForPreviewStream() async {
    for (var attempt = 0; attempt < 20; attempt++) {
      final stream = _findPreviewStream();
      if (stream != null) {
        return stream;
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    throw CameraRecordingException(
      '마이크 트랙을 찾지 못했습니다. 브라우저에서 카메라와 마이크를 허용했는지 확인해 주세요.',
    );
  }

  web.MediaStream? _findPreviewStream() {
    final videos = <web.HTMLVideoElement>[];
    final listed = web.document.querySelectorAll('video');
    for (var index = 0; index < listed.length; index++) {
      final node = listed.item(index);
      if (node != null && node.isA<web.HTMLVideoElement>()) {
        videos.add(node as web.HTMLVideoElement);
      }
    }
    final root = web.document.documentElement;
    if (root != null) {
      _collectVideos(root, videos);
    }
    for (final video in videos.reversed) {
      final stream = _audioStreamOf(video);
      if (stream != null) {
        return stream;
      }
    }
    return null;
  }

  void _collectVideos(web.Node node, List<web.HTMLVideoElement> videos) {
    if (node.isA<web.HTMLVideoElement>()) {
      final video = node as web.HTMLVideoElement;
      if (!videos.contains(video)) {
        videos.add(video);
      }
    }
    if (node.isA<web.Element>()) {
      final shadow = (node as web.Element).shadowRoot;
      if (shadow != null) {
        _collectVideos(shadow, videos);
      }
    }
    var child = node.firstChild;
    while (child != null) {
      _collectVideos(child, videos);
      child = child.nextSibling;
    }
  }

  web.MediaStream? _audioStreamOf(web.HTMLVideoElement video) {
    final source = video.srcObject;
    if (source == null || !source.isA<web.MediaStream>()) {
      return null;
    }
    final stream = source as web.MediaStream;
    if (stream.getAudioTracks().toDart.isEmpty) {
      return null;
    }
    return stream;
  }
}
