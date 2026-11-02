import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_audio_waveform_use_case.dart';

void main() {
  test('empty contentUrl returns an error without reading', () async {
    final repository = _WavRepository(Uint8List(0));
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(contentUrl: '');

    expect(repository.readUrls, isEmpty);
    expect(load.errorMessage, '파형 주소가 없습니다');
    expect(load.amplitudes, isEmpty);
  });

  test('pcm wav ranges fill amplitudes from contentUrl only', () async {
    final wav = _pcmWavFile();
    final repository = _WavRepository(wav);
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(
      contentUrl: 'https://host/files/take.wav',
    );

    expect(repository.readUrls, isNotEmpty);
    expect(
      repository.readUrls.every((url) => url == 'https://host/files/take.wav'),
      isTrue,
    );
    expect(
      repository.readUrls.any((url) => url.endsWith('.wave')),
      isFalse,
    );
    expect(load.waveUrl, 'https://host/files/take.wav');
    expect(load.errorMessage, isEmpty);
    expect(load.amplitudes, hasLength(LoadAudioWaveformUseCase.sampleCount));
    expect(load.amplitudes.any((value) => value > 0), isTrue);
  });
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

class _WavRepository implements JobTimelineRepository {
  _WavRepository(this.wavBytes);

  final Uint8List wavBytes;
  final List<String> readUrls = [];

  @override
  Future<Uint8List> readBytes({
    required String url,
    int? startByte,
    int? endByte,
  }) async {
    readUrls.add(url);
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
