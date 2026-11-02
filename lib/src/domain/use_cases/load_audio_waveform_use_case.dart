import 'dart:convert';

import '../entities/audio_waveform_load.dart';
import 'get_job_timeline_use_case.dart';

class LoadAudioWaveformUseCase {
  LoadAudioWaveformUseCase(this._getJobTimelineUseCase);

  final GetJobTimelineUseCase _getJobTimelineUseCase;

  Future<AudioWaveformLoad> execute({
    required String waveformUrl,
    String sourceStartNs = '',
    String sourceEndNs = '',
  }) async {
    if (waveformUrl.isEmpty) {
      return const AudioWaveformLoad(
        waveUrl: '',
        amplitudes: [],
        bodyLength: 0,
      );
    }
    try {
      final body = await _getJobTimelineUseCase.readContent(url: waveformUrl);
      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        return AudioWaveformLoad(
          waveUrl: waveformUrl,
          amplitudes: const [],
          bodyLength: body.length,
          errorMessage: '파형 JSON 형식이 아닙니다',
        );
      }
      final intervalMs = _asPositiveInt(decoded['interval_ms']);
      final raw = decoded['max_amplitudes'];
      if (intervalMs == null || raw is! List) {
        return AudioWaveformLoad(
          waveUrl: waveformUrl,
          amplitudes: const [],
          bodyLength: body.length,
          errorMessage: '파형 JSON에 interval_ms·max_amplitudes가 없습니다',
        );
      }
      final amplitudes = <double>[
        for (final item in raw) _asAmplitude(item),
      ];
      final sliced = _sliceForSource(
        amplitudes: amplitudes,
        intervalMs: intervalMs,
        sourceStartNs: sourceStartNs,
        sourceEndNs: sourceEndNs,
      );
      return AudioWaveformLoad(
        waveUrl: waveformUrl,
        amplitudes: sliced,
        bodyLength: body.length,
      );
    } catch (error) {
      return AudioWaveformLoad(
        waveUrl: waveformUrl,
        amplitudes: const [],
        bodyLength: 0,
        errorMessage: error.toString(),
      );
    }
  }

  List<double> _sliceForSource({
    required List<double> amplitudes,
    required int intervalMs,
    required String sourceStartNs,
    required String sourceEndNs,
  }) {
    if (amplitudes.isEmpty || intervalMs <= 0) {
      return amplitudes;
    }
    final startNs = int.tryParse(sourceStartNs.trim());
    final endNs = int.tryParse(sourceEndNs.trim());
    if (startNs == null || endNs == null || endNs <= startNs) {
      return amplitudes;
    }
    final startIndex = (startNs / 1e6 / intervalMs).floor();
    final endIndex = (endNs / 1e6 / intervalMs).ceil();
    final from = startIndex.clamp(0, amplitudes.length);
    final to = endIndex.clamp(0, amplitudes.length);
    if (from >= to) {
      return const [];
    }
    return amplitudes.sublist(from, to);
  }

  int? _asPositiveInt(Object? value) {
    if (value is int && value > 0) {
      return value;
    }
    if (value is num && value > 0) {
      return value.round();
    }
    if (value is String) {
      final parsed = int.tryParse(value.trim());
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }
    return null;
  }

  double _asAmplitude(Object? value) {
    if (value is num) {
      return value.toDouble().clamp(0.0, 1.0);
    }
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null) {
        return parsed.clamp(0.0, 1.0);
      }
    }
    return 0;
  }
}
