import 'waveform_point.dart';
import 'waveform_series_bundle.dart';

class DiffStat {
  const DiffStat({this.mean, this.max});

  final double? mean;
  final double? max;

  bool get isComparable => mean != null && max != null;
}

class ChannelCompareStats {
  const ChannelCompareStats({
    required this.currentBeginner,
    required this.currentRobot,
    required this.voltageBeginner,
    required this.voltageRobot,
    required this.speedBeginner,
    required this.speedRobot,
    required this.rotationBeginner,
    required this.rotationRobot,
  });

  final DiffStat currentBeginner;
  final DiffStat currentRobot;
  final DiffStat voltageBeginner;
  final DiffStat voltageRobot;
  final DiffStat speedBeginner;
  final DiffStat speedRobot;
  final DiffStat rotationBeginner;
  final DiffStat rotationRobot;

  static ChannelCompareStats fromSeries(WaveformSeriesBundle series) {
    return ChannelCompareStats(
      currentBeginner: _pairDiff(
        series.master,
        series.beginner,
        (point) => point.currentA,
      ),
      currentRobot: _pairDiff(
        series.master,
        series.robot,
        (point) => point.currentA,
      ),
      voltageBeginner: _pairDiff(
        series.master,
        series.beginner,
        (point) => point.voltageV,
      ),
      voltageRobot: _pairDiff(
        series.master,
        series.robot,
        (point) => point.voltageV,
      ),
      speedBeginner: _pairDiff(
        series.master,
        series.beginner,
        (point) => point.speedValue,
      ),
      speedRobot: _pairDiff(
        series.master,
        series.robot,
        (point) => point.speedValue,
      ),
      rotationBeginner: _pairDiff(
        series.master,
        series.beginner,
        (point) => point.rotationSpeedRpm,
      ),
      rotationRobot: _pairDiff(
        series.master,
        series.robot,
        (point) => point.rotationSpeedRpm,
      ),
    );
  }

  static DiffStat _pairDiff(
    List<WaveformPoint> master,
    List<WaveformPoint> other,
    double? Function(WaveformPoint point) channelOf,
  ) {
    final count = master.length < other.length ? master.length : other.length;
    if (count == 0 || master.isEmpty || other.isEmpty) {
      return const DiffStat();
    }
    var sum = 0.0;
    var max = 0.0;
    var sampleCount = 0;
    for (var index = 0; index < count; index++) {
      final left = channelOf(master[index]);
      final right = channelOf(other[index]);
      if (left == null || right == null) {
        continue;
      }
      final diff = (right - left).abs();
      sum += diff;
      if (diff > max) {
        max = diff;
      }
      sampleCount += 1;
    }
    if (sampleCount == 0) {
      return const DiffStat();
    }
    return DiffStat(mean: sum / sampleCount, max: max);
  }
}
