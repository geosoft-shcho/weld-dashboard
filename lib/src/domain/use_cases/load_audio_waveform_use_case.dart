import '../audio_waveform_data.dart';
import '../entities/audio_waveform_load.dart';
import '../wav_pcm_peaks.dart';
import 'get_job_timeline_use_case.dart';

class LoadAudioWaveformUseCase {
  LoadAudioWaveformUseCase(this._getJobTimelineUseCase);

  final GetJobTimelineUseCase _getJobTimelineUseCase;

  static const int sampleCount = 120;
  static const int _headerBytes = 4096;
  static const int _windowBytes = 4096;
  static const int _rangeBatchSize = 16;

  Future<AudioWaveformLoad> execute({required String contentUrl}) async {
    if (contentUrl.isEmpty) {
      return const AudioWaveformLoad(
        waveUrl: '',
        amplitudes: [],
        bodyLength: 0,
        errorMessage: '파형 주소가 없습니다',
      );
    }
    final waveUrl = AudioWaveformData.assetPathFor(contentUrl);
    final fromWave = await _loadWavePeaks(waveUrl);
    if (fromWave != null) {
      return fromWave;
    }
    return _loadWavPeaks(contentUrl);
  }

  Future<AudioWaveformLoad?> _loadWavePeaks(String waveUrl) async {
    try {
      final bytes = await _getJobTimelineUseCase.readBytes(url: waveUrl);
      if (bytes.isEmpty) {
        return null;
      }
      final waveform = AudioWaveformData.parse(bytes);
      final amplitudes = waveform.sampledAmplitudes(sampleCount);
      if (amplitudes.isEmpty) {
        return null;
      }
      return AudioWaveformLoad(
        waveUrl: waveUrl,
        amplitudes: amplitudes,
        bodyLength: bytes.length,
      );
    } catch (_) {
      return null;
    }
  }

  Future<AudioWaveformLoad> _loadWavPeaks(String contentUrl) async {
    try {
      final header = await _getJobTimelineUseCase.readBytes(
        url: contentUrl,
        startByte: 0,
        endByte: _headerBytes - 1,
      );
      final layout = wavPcmLayoutFromHeader(header);
      if (layout == null) {
        return AudioWaveformLoad(
          waveUrl: contentUrl,
          amplitudes: const [],
          bodyLength: header.length,
          errorMessage: 'PCM WAV 파형을 읽을 수 없습니다',
        );
      }
      final offsets = wavPcmSampleOffsets(
        layout: layout,
        sampleCount: sampleCount,
        windowBytes: _windowBytes,
      );
      if (offsets.isEmpty) {
        return AudioWaveformLoad(
          waveUrl: contentUrl,
          amplitudes: const [],
          bodyLength: layout.dataSize,
          errorMessage: '파형 데이터 없음',
        );
      }
      final amplitudes = List<double>.filled(sampleCount, 0);
      for (var start = 0; start < offsets.length; start += _rangeBatchSize) {
        final end = (start + _rangeBatchSize).clamp(0, offsets.length);
        final chunk = await Future.wait([
          for (var index = start; index < end; index++)
            _peakAt(contentUrl, layout, offsets[index]),
        ]);
        for (var index = 0; index < chunk.length; index++) {
          amplitudes[start + index] = chunk[index];
        }
      }
      return AudioWaveformLoad(
        waveUrl: contentUrl,
        amplitudes: amplitudes,
        bodyLength: layout.dataSize,
      );
    } catch (error) {
      return AudioWaveformLoad(
        waveUrl: contentUrl,
        amplitudes: const [],
        bodyLength: 0,
        errorMessage: error.toString(),
      );
    }
  }

  Future<double> _peakAt(
    String contentUrl,
    WavPcmLayout layout,
    int fileOffset,
  ) async {
    final end = (fileOffset + _windowBytes - 1).clamp(
      fileOffset,
      layout.dataOffset + layout.dataSize - 1,
    );
    final bytes = await _getJobTimelineUseCase.readBytes(
      url: contentUrl,
      startByte: fileOffset,
      endByte: end,
    );
    return wavPcmPeakAmplitude(bytes, layout.channels);
  }
}
