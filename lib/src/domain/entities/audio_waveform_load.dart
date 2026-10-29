/// 타임라인 음성 클립용 `.wave` 피크 로드 결과.
class AudioWaveformLoad {
  const AudioWaveformLoad({
    required this.waveUrl,
    required this.amplitudes,
    required this.bodyLength,
    this.errorMessage = '',
  });

  static const empty = AudioWaveformLoad(
    waveUrl: '',
    amplitudes: [],
    bodyLength: 0,
  );

  final String waveUrl;
  final List<double> amplitudes;
  final int bodyLength;
  final String errorMessage;

  bool get doesHaveAmplitudes => amplitudes.isNotEmpty;
}
