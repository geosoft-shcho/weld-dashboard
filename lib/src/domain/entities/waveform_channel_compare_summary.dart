/// GetPassWaveform DTW 비교의 채널별 평균 차이·유사도.
class WaveformChannelCompareSummary {
  const WaveformChannelCompareSummary({
    required this.channelName,
    required this.unit,
    this.meanDiff,
    this.similarity,
  });

  final String channelName;
  final String unit;

  /// mean(비교) − mean(대상). 서버 NaN이면 null.
  final double? meanDiff;

  /// 0~1. 구 DTW 서버처럼 비어 있으면 null.
  final double? similarity;
}
