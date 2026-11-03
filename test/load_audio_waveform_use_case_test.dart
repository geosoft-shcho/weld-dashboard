import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_audio_waveform_use_case.dart';

void main() {
  test('empty waveformUrl returns empty amplitudes without reading', () async {
    final repository = _JsonRepository('');
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(waveformUrl: '');

    expect(repository.readUrls, isEmpty);
    expect(load.amplitudes, isEmpty);
    expect(load.errorMessage, isEmpty);
  });

  test('json max_amplitudes fill amplitudes from waveformUrl', () async {
    final body = jsonEncode({
      'interval_ms': 10,
      'max_amplitudes': [0.1, 0.2, 0.3, 0.4],
    });
    final repository = _JsonRepository(body);
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    final load = await useCase.execute(
      waveformUrl: 'https://host/api/files/take.waveform.json',
    );

    expect(repository.readUrls, [
      'https://host/api/files/take.waveform.json',
    ]);
    expect(load.waveUrl, 'https://host/api/files/take.waveform.json');
    expect(load.errorMessage, isEmpty);
    expect(load.amplitudes, [0.1, 0.2, 0.3, 0.4]);
  });

  test('source ns slices amplitudes by interval_ms', () async {
    final body = jsonEncode({
      'interval_ms': 10,
      'max_amplitudes': [0.0, 0.1, 0.2, 0.3, 0.4, 0.5],
    });
    final repository = _JsonRepository(body);
    final useCase = LoadAudioWaveformUseCase(GetJobTimelineUseCase(repository));

    // 20ms..45ms → floor(20/10)=2, ceil(45/10)=5 → indices 2..4
    final load = await useCase.execute(
      waveformUrl: 'https://host/api/files/take.waveform.json',
      sourceStartNs: '20000000',
      sourceEndNs: '45000000',
    );

    expect(load.errorMessage, isEmpty);
    expect(load.amplitudes, [0.2, 0.3, 0.4]);
  });
}

class _JsonRepository implements JobTimelineRepository {
  _JsonRepository(this.body);

  final String body;
  final List<String> readUrls = [];

  @override
  Future<Uint8List> readBytes({
    required String url,
    int? startByte,
    int? endByte,
  }) async {
    readUrls.add(url);
    return Uint8List.fromList(utf8.encode(body));
  }

  @override
  Future<String> readContent({required String url}) async {
    readUrls.add(url);
    return body;
  }

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
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) async {}

  @override
  Future<void> deleteTimeline({required String jobId}) async {}
}
