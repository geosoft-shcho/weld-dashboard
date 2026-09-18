import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/channel_compare_stats.dart';
import 'package:weld_dashboard/src/domain/entities/series_role.dart';
import 'package:weld_dashboard/src/domain/entities/waveform_point.dart';
import 'package:weld_dashboard/src/domain/entities/waveform_row.dart';
import 'package:weld_dashboard/src/domain/entities/waveform_series_bundle.dart';

void main() {
  test('seriesForPass filters master by profile and keeps beginner robot', () {
    final rows = [
      _row(
        passId: 'P1',
        role: SeriesRole.master,
        masterProfileId: 'MP-A',
        timeMs: 100,
        currentA: 10,
      ),
      _row(
        passId: 'P1',
        role: SeriesRole.master,
        masterProfileId: 'MP-B',
        timeMs: 100,
        currentA: 20,
      ),
      _row(
        passId: 'P1',
        role: SeriesRole.beginner,
        masterProfileId: '',
        timeMs: 100,
        currentA: 12,
      ),
      _row(
        passId: 'P1',
        role: SeriesRole.robot,
        masterProfileId: '',
        timeMs: 100,
        currentA: 11,
      ),
      _row(
        passId: 'P2',
        role: SeriesRole.beginner,
        masterProfileId: '',
        timeMs: 100,
        currentA: 99,
      ),
    ];
    final bundle = WaveformSeriesBundle.fromRows(
      rows: rows,
      passId: 'P1',
      masterProfileId: 'MP-B',
    );
    expect(bundle.masterProfileId, 'MP-B');
    expect(bundle.master.single.currentA, 20);
    expect(bundle.beginner.single.currentA, 12);
    expect(bundle.robot.single.currentA, 11);
    expect(WaveformSeriesBundle.mastersForPass(rows, 'P1'), ['MP-A', 'MP-B']);
  });

  test('compareStats mean and max use same index absolute diffs', () {
    const series = WaveformSeriesBundle(
      masterProfileId: 'MP-A',
      master: [
        WaveformPoint(timeMs: 0, currentA: 10, voltageV: 20, speedValue: 30),
        WaveformPoint(timeMs: 100, currentA: 12, voltageV: 22, speedValue: 32),
      ],
      beginner: [
        WaveformPoint(timeMs: 0, currentA: 11, voltageV: 18, speedValue: 30),
        WaveformPoint(timeMs: 100, currentA: 15, voltageV: 22, speedValue: null),
      ],
      robot: [
        WaveformPoint(timeMs: 0, currentA: 10, voltageV: 25, speedValue: 34),
        WaveformPoint(timeMs: 100, currentA: 14, voltageV: 20, speedValue: 30),
      ],
    );
    final stats = ChannelCompareStats.fromSeries(series);
    expect(stats.currentBeginner.mean, closeTo(2.0, 0.0001));
    expect(stats.currentBeginner.max, 3);
    expect(stats.currentRobot.mean, closeTo(1.0, 0.0001));
    expect(stats.currentRobot.max, 2);
    expect(stats.voltageBeginner.mean, closeTo(1.0, 0.0001));
    expect(stats.voltageBeginner.max, 2);
    expect(stats.speedBeginner.isComparable, isFalse);
    expect(stats.speedRobot.mean, closeTo(3.0, 0.0001));
    expect(stats.speedRobot.max, 4);
  });

  test('empty cell becomes null and empty series is not comparable', () {
    final bundle = WaveformSeriesBundle.fromRows(
      rows: [
        const WaveformRow(
          seriesId: 'S1',
          passId: 'P1',
          commonKey: 'K',
          seriesRole: SeriesRole.master,
          masterProfileId: 'MP-A',
          workerId: '',
          robotId: '',
          timeMs: 0,
          currentA: null,
          voltageV: 1,
          speedValue: 2,
        ),
      ],
      passId: 'P1',
      masterProfileId: 'MP-A',
    );
    expect(bundle.master.single.currentA, isNull);
    final stats = ChannelCompareStats.fromSeries(bundle);
    expect(stats.currentBeginner.isComparable, isFalse);
    expect(stats.currentRobot.isComparable, isFalse);
  });
}

WaveformRow _row({
  required String passId,
  required SeriesRole role,
  required String masterProfileId,
  required int timeMs,
  required double currentA,
}) {
  return WaveformRow(
    seriesId: '$passId-$role-$timeMs-$masterProfileId',
    passId: passId,
    commonKey: 'K',
    seriesRole: role,
    masterProfileId: masterProfileId,
    workerId: '',
    robotId: '',
    timeMs: timeMs,
    currentA: currentA,
    voltageV: 0,
    speedValue: 0,
  );
}
