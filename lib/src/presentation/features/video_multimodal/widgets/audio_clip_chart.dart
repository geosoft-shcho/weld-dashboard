import 'package:fluent_ui/fluent_ui.dart';
import 'package:waveform_pro/waveform_pro.dart';

import '../../../core/widgets/waveform_channel_charts.dart';
import '../../../core/widgets/waveform_material_scope.dart';
import 'multimodal_studio_palette.dart';

/// 타임라인 음성 클립 자리에 넣는 정적 진폭 차트.
class AudioClipChart extends StatelessWidget {
  const AudioClipChart({
    super.key,
    required this.amplitudes,
    required this.isLoading,
    required this.errorMessage,
    required this.durationMs,
    this.selectedTimeMs,
    this.onTimeTapMs,
  });

  final List<double> amplitudes;
  final bool isLoading;
  final String errorMessage;
  final int durationMs;
  final int? selectedTimeMs;
  final WaveformTimeTapHandler? onTimeTapMs;

  @override
  Widget build(BuildContext context) {
    final durationMs = this.durationMs;
    final selected = selectedTimeMs;
    final playheadSeconds = selected != null && durationMs > 0
        ? (selected / 1000.0).clamp(0.0, durationMs / 1000.0)
        : -1.0;

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
          if (!isLoading && errorMessage.isEmpty && amplitudes.isEmpty)
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: amplitudes.isEmpty || durationMs <= 0
                  ? const SizedBox.shrink()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final data = WaveformData(
                          samples: _normalizedAmplitudes(amplitudes),
                          durationSeconds: durationMs / 1000.0,
                        );
                        return WaveformMaterialScope(
                          child: WaveformTimeline(
                            data: data,
                            height: constraints.maxHeight,
                            showTimeRuler: false,
                            enableZoom: false,
                            enableRegionSelection: false,
                            enableMarkers: false,
                            playheadPosition: playheadSeconds,
                            playheadColor: MultimodalStudioPalette.GRAPE_500,
                            style: const WaveformStyle(
                              renderMode: WaveformRenderMode.continuous,
                              waveColor: MultimodalStudioPalette.KALE_300,
                              playedWaveColor: MultimodalStudioPalette.KALE_300,
                              backgroundColor: MultimodalStudioPalette.SAND_0,
                              centerLineColor: Color(0x00000000),
                              fillWaveform: false,
                              waveStrokeWidth: 1.5,
                            ),
                            onTap: onTimeTapMs == null
                                ? null
                                : (seconds) {
                                    onTimeTapMs!(
                                      (seconds * 1000).round().clamp(
                                        0,
                                        durationMs,
                                      ),
                                    );
                                  },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

List<double> _normalizedAmplitudes(List<double> amplitudes) {
  var peak = 0.0;
  for (final value in amplitudes) {
    if (value > peak) {
      peak = value;
    }
  }
  if (peak <= 0) {
    return amplitudes;
  }
  return [for (final value in amplitudes) value / peak];
}
