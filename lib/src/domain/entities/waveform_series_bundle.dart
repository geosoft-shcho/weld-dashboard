import 'waveform_point.dart';
import 'waveform_row.dart';
import 'series_role.dart';

class WaveformSeriesBundle {
  const WaveformSeriesBundle({
    required this.masterProfileId,
    required this.master,
    required this.beginner,
    required this.robot,
  });

  final String masterProfileId;
  final List<WaveformPoint> master;
  final List<WaveformPoint> beginner;
  final List<WaveformPoint> robot;

  bool get doesHaveAnySeries =>
      master.isNotEmpty || beginner.isNotEmpty || robot.isNotEmpty;

  static List<String> mastersForPass(
    List<WaveformRow> rows,
    String passId,
  ) {
    final ids = <String>{};
    for (final row in rows) {
      if (row.passId != passId || row.seriesRole != SeriesRole.master) {
        continue;
      }
      if (row.masterProfileId.isEmpty) {
        continue;
      }
      ids.add(row.masterProfileId);
    }
    return ids.toList();
  }

  static WaveformSeriesBundle fromRows({
    required List<WaveformRow> rows,
    required String passId,
    required String masterProfileId,
  }) {
    final masters = mastersForPass(rows, passId);
    final useMaster =
        masterProfileId.isNotEmpty ? masterProfileId : (masters.isEmpty ? '' : masters.first);
    final masterRows = <WaveformRow>[];
    final beginnerRows = <WaveformRow>[];
    final robotRows = <WaveformRow>[];
    for (final row in rows) {
      if (row.passId != passId) {
        continue;
      }
      switch (row.seriesRole) {
        case SeriesRole.master:
          if (useMaster.isEmpty || row.masterProfileId == useMaster) {
            masterRows.add(row);
          }
        case SeriesRole.beginner:
          beginnerRows.add(row);
        case SeriesRole.robot:
          robotRows.add(row);
      }
    }
    return WaveformSeriesBundle(
      masterProfileId: useMaster,
      master: _toPoints(masterRows),
      beginner: _toPoints(beginnerRows),
      robot: _toPoints(robotRows),
    );
  }

  static List<WaveformPoint> _toPoints(List<WaveformRow> rows) {
    final sorted = [...rows]..sort((a, b) => a.timeMs.compareTo(b.timeMs));
    return [
      for (final row in sorted)
        WaveformPoint(
          timeMs: row.timeMs,
          currentA: row.currentA,
          voltageV: row.voltageV,
          speedValue: row.speedValue,
        ),
    ];
  }
}
