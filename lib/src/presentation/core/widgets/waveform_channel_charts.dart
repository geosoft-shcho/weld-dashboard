import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/quality_link.dart';
import '../../../domain/entities/waveform_point.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../../features/video_multimodal/timeline_playhead_clock.dart';
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
    this.doesStartAtZero = false,
    this.showAxisTitles = true,
    this.axisMaxXMs,
    this.selectedTimeLabel = '',
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
  final bool doesStartAtZero;
  final bool showAxisTitles;
  final int? axisMaxXMs;
  final String selectedTimeLabel;

  @override
  Widget build(BuildContext context) {
    final gap = showAxisTitles ? 12.0 : 8.0;
    return WaveformMaterialScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WaveformChannelChart(
            channelName: '전류',
            valueUnit: 'A',
            accentColor: AppTheme.CHART_MASTER,
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            doesStartAtZero: doesStartAtZero,
            showAxisTitles: showAxisTitles,
            axisMaxXMs: axisMaxXMs,
            selectedTimeLabel: selectedTimeLabel,
            valueOf: (point) => point.currentA,
          ),
          SizedBox(height: gap),
          _WaveformChannelChart(
            channelName: '전압',
            valueUnit: 'V',
            accentColor: AppTheme.STATUS_WARN,
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            doesStartAtZero: doesStartAtZero,
            showAxisTitles: showAxisTitles,
            axisMaxXMs: axisMaxXMs,
            selectedTimeLabel: selectedTimeLabel,
            valueOf: (point) => point.voltageV,
          ),
          SizedBox(height: gap),
          _WaveformChannelChart(
            channelName: '속도',
            valueUnit: 'm/min',
            accentColor: AppTheme.STATUS_OK,
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            doesStartAtZero: doesStartAtZero,
            showAxisTitles: showAxisTitles,
            axisMaxXMs: axisMaxXMs,
            selectedTimeLabel: selectedTimeLabel,
            valueOf: (point) => point.speedValue,
          ),
          SizedBox(height: gap),
          _WaveformChannelChart(
            channelName: '회전 속도',
            valueUnit: 'rpm',
            accentColor: AppTheme.CHART_ROBOT,
            series: series,
            links: links,
            showMaster: showMaster,
            showBeginner: showBeginner,
            showRobot: showRobot,
            selectedLinkId: selectedLinkId,
            selectedTimeMs: selectedTimeMs,
            onBandTap: onBandTap,
            onTimeTapMs: onTimeTapMs,
            doesStartAtZero: doesStartAtZero,
            showAxisTitles: showAxisTitles,
            axisMaxXMs: axisMaxXMs,
            selectedTimeLabel: selectedTimeLabel,
            valueOf: (point) => point.rotationSpeedRpm,
          ),
        ],
      ),
    );
  }
}

class _WaveformChannelChart extends StatelessWidget {
  const _WaveformChannelChart({
    required this.channelName,
    required this.valueUnit,
    required this.accentColor,
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
    this.doesStartAtZero = false,
    this.showAxisTitles = true,
    this.axisMaxXMs,
    this.selectedTimeLabel = '',
  });

  final String channelName;
  final String valueUnit;
  final Color accentColor;
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
  final bool doesStartAtZero;
  final bool showAxisTitles;
  final int? axisMaxXMs;
  final String selectedTimeLabel;

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
    final chartHeight = showAxisTitles ? 140.0 : 96.0;
    final panelPadding = showAxisTitles ? 12.0 : 8.0;
    final plotPadding = showAxisTitles
        ? const EdgeInsets.fromLTRB(8, 12, 12, 8)
        : const EdgeInsets.fromLTRB(2, 4, 2, 4);
    final cursorLabel = selectedTimeMs == null
        ? ''
        : (selectedTimeLabel.isNotEmpty
            ? selectedTimeLabel
            : formatPlayheadClock(selectedTimeMs! / 1000.0));
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(panelPadding),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(color: accentColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                channelName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: showAxisTitles ? 14 : 11,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                valueUnit,
                style: TextStyle(
                  fontSize: showAxisTitles ? 12 : 10,
                  color: AppTheme.STATUS_OFF,
                ),
              ),
            ],
          ),
          SizedBox(height: showAxisTitles ? 8 : 4),
          SizedBox(
            height: chartHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.CHART_PLOT,
                borderRadius: BorderRadius.circular(4),
              ),
              child: spots.isEmpty
                  ? const Center(child: Text('데이터 없음'))
                  : Padding(
                      padding: plotPadding,
                      child: LineChart(
                      duration: showAxisTitles
                          ? const Duration(milliseconds: 150)
                          : Duration.zero,
                      LineChartData(
                        minX: _minX(spots),
                        maxX: _maxX(spots),
                        minY: _minY(spots),
                        maxY: _maxY(spots),
                        clipData: const FlClipData.all(),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(
                          show: showAxisTitles,
                          border: Border.all(color: AppTheme.STATUS_OFF),
                        ),

                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: showAxisTitles,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 11),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: showAxisTitles,
                              reservedSize: 44,
                              getTitlesWidget: (value, meta) {
                                if (value != meta.min && value != meta.max) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  formatPlayheadClock(value / 1000.0),
                                  style: const TextStyle(fontSize: 11),
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
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  labelResolver: (_) => cursorLabel,
                                ),
                              ),
                          ],
                        ),
                        lineBarsData: bars,
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: true,
                          getTouchedSpotIndicator: (barData, spotIndexes) {
                            final lineColor = barData.gradient?.colors.first ??
                                barData.color ??
                                AppTheme.CHART_CURSOR;
                            return [
                              for (final _ in spotIndexes)
                                TouchedSpotIndicatorData(
                                  FlLine(
                                    color: lineColor,
                                    strokeWidth: 1,
                                  ),
                                  FlDotData(
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                      radius: 5,
                                      color: lineColor,
                                      strokeWidth: 0,
                                    ),
                                  ),
                                ),
                            ];
                          },
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return [
                                for (final spot in touchedSpots)
                                  LineTooltipItem(
                                    't=${formatPlayheadClock(spot.x / 1000.0)}\n'
                                    'y=${spot.y.toStringAsFixed(1)} $valueUnit',
                                    const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ];
                            },
                          ),
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
      ),
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
    if (doesStartAtZero && min >= 0) {
      return 0;
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
    final axisMax = axisMaxXMs;
    if (axisMax != null && axisMax.toDouble() > max) {
      return axisMax.toDouble();
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
