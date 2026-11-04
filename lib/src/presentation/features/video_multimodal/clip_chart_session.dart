import '../../../domain/entities/waveform_series_bundle.dart';
import '../../../domain/use_cases/load_timeseries_waveform_use_case.dart';
import 'clip_chart_kind.dart';

/// 타임라인에 펼쳐진 음성·시계열 차트 한 건의 상태.
class ClipChartSession {
  String clipId = '';
  ClipChartKind? kind;
  int epoch = 0;
  bool isLoading = false;
  String error = '';
  List<double> audioAmplitudes = const [];
  WaveformSeriesBundle timeseriesSeries =
      LoadTimeseriesWaveformUseCase.emptySeries;

  bool get isExpanded => clipId.isNotEmpty && kind != null;

  bool get isAudioLoading => kind == ClipChartKind.audio && isLoading;

  bool get isTimeseriesLoading =>
      kind == ClipChartKind.timeseries && isLoading;

  String get audioError => kind == ClipChartKind.audio ? error : '';

  String get timeseriesError =>
      kind == ClipChartKind.timeseries ? error : '';

  void collapse() {
    epoch += 1;
    clipId = '';
    kind = null;
    isLoading = false;
    error = '';
    audioAmplitudes = const [];
    timeseriesSeries = LoadTimeseriesWaveformUseCase.emptySeries;
  }

  /// 차트 UI만 연다. 네트워크는 호출하지 않는다.
  void prepare({required String clipId, required ClipChartKind kind}) {
    epoch += 1;
    this.clipId = clipId;
    this.kind = kind;
    isLoading = true;
    error = '';
    audioAmplitudes = const [];
    timeseriesSeries = LoadTimeseriesWaveformUseCase.emptySeries;
  }

  int beginLoad() {
    epoch += 1;
    isLoading = true;
    error = '';
    if (kind == ClipChartKind.audio) {
      audioAmplitudes = const [];
    } else if (kind == ClipChartKind.timeseries) {
      timeseriesSeries = LoadTimeseriesWaveformUseCase.emptySeries;
    }
    return epoch;
  }

  bool isCurrentEpoch(int epoch) => epoch == this.epoch;
}
