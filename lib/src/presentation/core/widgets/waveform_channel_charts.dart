import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/quality_link.dart';
import '../../../domain/entities/waveform_point.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../themes/app_theme.dart';
import 'waveform_material_scope.dart';

typedef BandTapHandler = void Function(String linkId);
typedef WaveformTimeTapHandler = void Function(int timeMs);

class WaveformChannelCharts extends StatelessWidget {
  const WaveformChannelCharts({
    super.key,
    required this.series,
    required this.links,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    this.selectedLinkId = '',
    this.selectedTimeMs,
    this.onBandTap,
    this.onTimeTapMs,
  });

  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final String selectedLinkId;
  final int? selectedTimeMs;
  final BandTapHandler? onBandTap;
  final WaveformTimeTapHandler? onTimeTapMs;

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WaveformChannelChart(
            title: '전류 (A)',
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            valueOf: (point) => point.currentA,
          ),
          const SizedBox(height: 12),
          _WaveformChannelChart(
            title: '전압 (V)',
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            valueOf: (point) => point.voltageV,
          ),
          const SizedBox(height: 12),
          _WaveformChannelChart(
            title: '속도 (m/min)',
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            valueOf: (point) => point.speedValue,
          ),
          const SizedBox(height: 12),
          _WaveformChannelChart(
            title: '회전 속도 (rpm)',
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            valueOf: (point) => point.rotationSpeedRpm,
          ),
        ],
      ),
    );
  }
}

class _WaveformChannelChart extends StatelessWidget {
  const _WaveformChannelChart({
    required this.title,
    required this.series,
    required this.links,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.selectedLinkId,
    required this.valueOf,
    this.selectedTimeMs,
    this.onBandTap,
    this.onTimeTapMs,
  });

  final String title;
  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final String selectedLinkId;
  final int? selectedTimeMs;
  final double? Function(WaveformPoint point) valueOf;
  final BandTapHandler? onBandTap;
  final WaveformTimeTapHandler? onTimeTapMs;

  @override
  Widget build(BuildContext context) {
    final bars = <LineChartBarData>[];
    if (showMaster) {
      bars.add(_bar(series.master, AppTheme.CHART_MASTER));
    }
    if (showBeginner) {
      bars.add(_bar(series.beginner, AppTheme.CHART_BEGINNER));
    }
    if (showRobot) {
      bars.add(_bar(series.robot, AppTheme.CHART_ROBOT));
    }
    final spots = [for (final bar in bars) ...bar.spots];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SizedBox(
          height: 140,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.CHART_PLOT,
              borderRadius: BorderRadius.circular(4),
            ),
            child: spots.isEmpty
                ? const Center(child: Text('데이터 없음'))
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 12, 8),
                    child: LineChart(
                      LineChartData(
                        minX: _minX(spots),
                        maxX: _maxX(spots),
                        minY: _minY(spots),
                        maxY: _maxY(spots),
                        clipData: const FlClipData.all(),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: AppTheme.STATUS_OFF),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTitlesWidget: (value, meta) {
                                if (value != meta.min && value != meta.max) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  '${value.toInt()}ms',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                        rangeAnnotations: RangeAnnotations(
                          verticalRangeAnnotations: [
                            for (final link in links)
                              VerticalRangeAnnotation(
                                x1: link.startMs.toDouble(),
                                x2: link.endMs.toDouble(),
                                color: link.linkId == selectedLinkId
                                    ? AppTheme.CHART_BAND_ACTIVE
                                    : AppTheme.CHART_BAND,
                              ),
                          ],
                        ),
                        extraLinesData: ExtraLinesData(
                          verticalLines: [
                            if (selectedTimeMs != null)
                              VerticalLine(
                                x: selectedTimeMs!.toDouble(),
                                color: AppTheme.CHART_CURSOR,
                                strokeWidth: 1.5,
                                dashArray: const [5, 4],
                                label: VerticalLineLabel(
                                  show: true,
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    bottom: 2,
                                  ),
                                  style: const TextStyle(
                                    color: AppTheme.CHART_CURSOR,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  labelResolver: (_) => '$selectedTimeMs ms',
                                ),
                              ),
                          ],
                        ),
                        lineBarsData: bars,
                        lineTouchData: LineTouchData(
                          handleBuiltInTouches: false,
                          touchCallback: (event, response) {
                            if (onTimeTapMs == null && onBandTap == null) {
                              return;
                            }
                            if (event is! FlTapUpEvent) {
                              return;
                            }
                            final spot = response?.lineBarSpots?.firstOrNull;
                            final x = spot?.x;
                            if (x == null) {
                              return;
                            }
                            onTimeTapMs?.call(x.round());
                            final bandTap = onBandTap;
                            if (bandTap == null) {
                              return;
                            }
                            for (final link in links) {
                              final start = link.startMs.toDouble();
                              final end = link.endMs.toDouble();
                              final low = start < end ? start : end;
                              final high = start < end ? end : start;
                              if (x >= low && x <= high) {
                                bandTap(link.linkId);
                                return;
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _bar(List<WaveformPoint> points, Color color) {
    return LineChartBarData(
      spots: [
        for (final point in points)
          if (valueOf(point) != null)
            FlSpot(point.timeMs.toDouble(), valueOf(point)!),
      ],
      isCurved: false,
      color: color,
      barWidth: 2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  double _minX(List<FlSpot> spots) {
    var min = spots.first.x;
    for (final spot in spots) {
      if (spot.x < min) {
        min = spot.x;
      }
    }
    return min;
  }

  double _maxX(List<FlSpot> spots) {
    var max = spots.first.x;
    for (final spot in spots) {
      if (spot.x > max) {
        max = spot.x;
      }
    }
    return max;
  }

  double _minY(List<FlSpot> spots) {
    var min = spots.first.y;
    for (final spot in spots) {
      if (spot.y < min) {
        min = spot.y;
      }
    }
    return min;
  }

  double _maxY(List<FlSpot> spots) {
    var min = spots.first.y;
    var max = spots.first.y;
    for (final spot in spots) {
      if (spot.y < min) {
        min = spot.y;
      }
      if (spot.y > max) {
        max = spot.y;
      }
    }
    return max == min ? max + 1 : max;
  }
}
