import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/waveform_series_bundle.dart';
import '../../../core/widgets/waveform_channel_charts.dart';
import 'multimodal_studio_palette.dart';

/// 타임라인 클립 자리에 넣는 시계열 차트.
class TimeseriesClipChart extends StatelessWidget {
  const TimeseriesClipChart({
    super.key,
    required this.series,
    required this.isLoading,
    required this.errorMessage,
    this.selectedTimeMs,
    this.onTimeTapMs,
  });

  final WaveformSeriesBundle series;
  final bool isLoading;
  final String errorMessage;
  final int? selectedTimeMs;
  final WaveformTimeTapHandler? onTimeTapMs;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MultimodalStudioPalette.SAND_0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading) const ProgressBar(),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: MultimodalStudioPalette.PERSIMMON_300,
                  fontSize: 11,
                ),
              ),
            ),
          if (!isLoading &&
              errorMessage.isEmpty &&
              !series.doesHaveAnySeries)
            const Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                '파형 데이터 없음',
                style: TextStyle(
                  color: MultimodalStudioPalette.SAND_600,
                  fontSize: 11,
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: WaveformChannelCharts(
                series: series,
                links: const [],
                showMaster: false,
                showBeginner: false,
                showRobot: true,
                selectedTimeMs: selectedTimeMs,
                onTimeTapMs: onTimeTapMs,
                doesStartAtZero: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
