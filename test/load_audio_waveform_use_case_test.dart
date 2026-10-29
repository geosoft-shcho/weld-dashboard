import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/audio_waveform_data.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_audio_waveform_use_case.dart';

void main() {
  test('audio contentUrl becomes a sibling .wave url', () {
    expect(
      AudioWaveformData.assetPathFor('https://host/files/devseed/take.wav'),
      'https://host/files/devseed/take.wave',
    );
    expect(
      AudioWaveformData.assetPathFor('/files/clip.mp3'),
      '/files/clip.wave',
    );
  });

  test('load reads .wave bytes and fills amplitudes', () async {
    final bytes = _waveBytes();
    final repository = _BytesTimelineRepository(bytes);
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(
      contentUrl: 'https://host/files/take.wav',
    );

    expect(repository.readUrls, ['https://host/files/take.wave']);
    expect(load.waveUrl, 'https://host/files/take.wave');
    expect(load.errorMessage, isEmpty);
    expect(load.amplitudes, hasLength(LoadAudioWaveformUseCase.sampleCount));
    expect(load.doesHaveAmplitudes, isTrue);
  });

  test('empty contentUrl returns an error without reading', () async {
    final repository = _BytesTimelineRepository(Uint8List(0));
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(contentUrl: '');

    expect(repository.readUrls, isEmpty);
    expect(load.errorMessage, '파형 주소가 없습니다');
    expect(load.amplitudes, isEmpty);
  });

  test('when .wave is missing, pcm wav ranges fill amplitudes', () async {
    final wav = _pcmWavFile();
    final repository = _WavFallbackRepository(wav);
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(
      contentUrl: 'https://host/files/take.wav',
    );

    expect(repository.readUrls.first, 'https://host/files/take.wave');
    expect(repository.readUrls.any((url) => url.endsWith('.wav')), isTrue);
    expect(load.errorMessage, isEmpty);
    expect(load.amplitudes, hasLength(LoadAudioWaveformUseCase.sampleCount));
    expect(load.amplitudes.any((value) => value > 0), isTrue);
  });
}

Uint8List _waveBytes() {
  final data = ByteData(20 + 8);
  data.setUint32(0, 1, Endian.little);
  data.setUint32(4, 0, Endian.little);
  data.setUint32(8, 48000, Endian.little);
  data.setUint32(12, 100, Endian.little);
  data.setUint32(16, 2, Endian.little);
  data.setInt16(20, -100, Endian.little);
  data.setInt16(22, 200, Endian.little);
  data.setInt16(24, -50, Endian.little);
  data.setInt16(26, 80, Endian.little);
  return data.buffer.asUint8List();
}

Uint8List _pcmWavFile() {
  const dataSize = 4000;
  final bytes = Uint8List(44 + dataSize);
  final view = ByteData.sublistView(bytes);
  bytes.setRange(0, 4, 'RIFF'.codeUnits);
  view.setUint32(4, 36 + dataSize, Endian.little);
  bytes.setRange(8, 12, 'WAVE'.codeUnits);
  bytes.setRange(12, 16, 'fmt '.codeUnits);
  view.setUint32(16, 16, Endian.little);
  view.setUint16(20, 1, Endian.little);
  view.setUint16(22, 2, Endian.little);
  view.setUint32(24, 44100, Endian.little);
  view.setUint32(28, 44100 * 4, Endian.little);
  view.setUint16(32, 4, Endian.little);
  view.setUint16(34, 16, Endian.little);
  bytes.setRange(36, 40, 'data'.codeUnits);
  view.setUint32(40, dataSize, Endian.little);
  for (var index = 0; index < dataSize ~/ 2; index++) {
    view.setInt16(44 + index * 2, index.isEven ? 8000 : -4000, Endian.little);
  }
  return bytes;
}

class _BytesTimelineRepository implements JobTimelineRepository {
  _BytesTimelineRepository(this.bytes);

  final Uint8List bytes;
  final List<String> readUrls = [];

  @override
  Future<Uint8List> readBytes({
    required String url,
    int? startByte,
    int? endByte,
  }) async {
    readUrls.add(url);
    return bytes;
  }

  @override
  Future<String> readContent({required String url}) async => '';

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async =>
      JobTimeline.empty;

  @override
  Future<ClipDetail> getClip({required String clipId}) async =>
      ClipDetail.empty;

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> deleteTrack({required String trackId}) async {}

  @override
  Future<void> createClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    String fromClipId = '',
    String toClipId = '',
    String sourceStartNs = '',
    String sourceEndNs = '',
  }) async {}

  @override
  Future<void> updateClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) async {}

  @override
  Future<void> deleteClip({required String clipId}) async {}

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) async {}

  @override
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) async {}

  @override
  Future<void> deleteTimeline({required String jobId}) async {}
}

class _WavFallbackRepository implements JobTimelineRepository {
  _WavFallbackRepository(this.wavBytes);

  final Uint8List wavBytes;
  final List<String> readUrls = [];

  @override
  Future<Uint8List> readBytes({
    required String url,
    int? startByte,
    int? endByte,
  }) async {
    readUrls.add(url);
    if (url.endsWith('.wave')) {
      throw StateError('content 404');
    }
    final start = startByte ?? 0;
    final endExclusive = (endByte ?? (wavBytes.length - 1)) + 1;
    return Uint8List.fromList(
      wavBytes.sublist(start, endExclusive.clamp(0, wavBytes.length)),
    );
  }

  @override
  Future<String> readContent({required String url}) async => '';

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async =>
      JobTimeline.empty;

  @override
  Future<ClipDetail> getClip({required String clipId}) async =>
      ClipDetail.empty;

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> deleteTrack({required String trackId}) async {}

  @override
  Future<void> createClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    String fromClipId = '',
    String toClipId = '',
    String sourceStartNs = '',
    String sourceEndNs = '',
  }) async {}

  @override
  Future<void> updateClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) async {}

  @override
  Future<void> deleteClip({required String clipId}) async {}

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) async {}

  @override
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) async {}

  @override
  Future<void> deleteTimeline({required String jobId}) async {}
}
