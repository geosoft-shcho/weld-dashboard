import 'entities/waveform_point.dart';

/// Asset CSV 본문을 전류·전압·속도·rpm 점으로 바꾼다.
class TimeseriesCsvParseResult {
  const TimeseriesCsvParseResult({
    required this.headers,
    required this.points,
    required this.rawPointCount,
    required this.lineCount,
    required this.matchedTimeHeader,
    required this.matchedCurrentHeader,
    required this.matchedVoltageHeader,
    required this.matchedSpeedHeader,
    required this.matchedRpmHeader,
  });

  final List<String> headers;
  final List<WaveformPoint> points;
  final int rawPointCount;
  final int lineCount;
  final String matchedTimeHeader;
  final String matchedCurrentHeader;
  final String matchedVoltageHeader;
  final String matchedSpeedHeader;
  final String matchedRpmHeader;
}

class TimeseriesCsvParser {
  const TimeseriesCsvParser._();

  static const int maxPointCount = 2000;

  static TimeseriesCsvParseResult parse(
    String body, {
    List<String> channelNames = const [],
  }) {
    final lines = [
      for (final line in body.split(RegExp(r'\r?\n')))
        if (line.trim().isNotEmpty) line.trim(),
    ];
    if (lines.length < 2) {
      return TimeseriesCsvParseResult(
        headers: lines.isEmpty
            ? const []
            : [
                for (final cell in lines.first.split(','))
                  cell.trim().toLowerCase(),
              ],
        points: const [],
        rawPointCount: 0,
        lineCount: lines.length,
        matchedTimeHeader: '',
        matchedCurrentHeader: '',
        matchedVoltageHeader: '',
        matchedSpeedHeader: '',
        matchedRpmHeader: '',
      );
    }
    final headers = [
      for (final cell in lines.first.split(',')) cell.trim().toLowerCase(),
    ];
    final timeMatch = _columnMatch(headers, const [
      'time_ms',
      't_ms',
      't_offset_ms',
      'time',
      't',
      't_offset_ns',
      'timestamp',
    ]);
    final currentMatch = _fieldMatch(
      headers,
      channelNames,
      _isCurrentChannel,
      const ['current_a', 'current', '전류_a', '전류'],
    );
    final voltageMatch = _fieldMatch(
      headers,
      channelNames,
      _isVoltageChannel,
      const ['voltage_v', 'voltage', '전압_v', '전압'],
    );
    final speedMatch = _fieldMatch(
      headers,
      channelNames,
      _isSpeedChannel,
      const ['wire_feed_speed_mpm', 'speed', 'speed_mpm', '속도'],
    );
    final rpmMatch = _fieldMatch(headers, channelNames, _isRpmChannel, const [
      'rotation_speed_rpm',
      'rpm',
      '회전속도',
    ]);
    final timeIndex = timeMatch.index;
    final timeIsNs = timeIndex >= 0 && headers[timeIndex].contains('ns');
    final points = <WaveformPoint>[];
    for (var rowIndex = 1; rowIndex < lines.length; rowIndex++) {
      final cells = lines[rowIndex].split(',');
      final timeMs = timeIndex < 0
          ? (rowIndex - 1) * 10
          : _timeMs(cells, timeIndex, timeIsNs);
      if (timeMs == null) {
        continue;
      }
      points.add(
        WaveformPoint(
          timeMs: timeMs,
          currentA: _number(cells, currentMatch.index),
          voltageV: _number(cells, voltageMatch.index),
          speedValue: _number(cells, speedMatch.index),
          rotationSpeedRpm: _number(cells, rpmMatch.index),
        ),
      );
    }
    final rawPointCount = points.length;
    final sampled = rawPointCount <= maxPointCount
        ? points
        : [
            for (
              var index = 0;
              index < points.length;
              index += (points.length / maxPointCount).ceil()
            )
              points[index],
          ];
    return TimeseriesCsvParseResult(
      headers: headers,
      points: sampled,
      rawPointCount: rawPointCount,
      lineCount: lines.length,
      matchedTimeHeader: timeMatch.name,
      matchedCurrentHeader: currentMatch.name,
      matchedVoltageHeader: voltageMatch.name,
      matchedSpeedHeader: speedMatch.name,
      matchedRpmHeader: rpmMatch.name,
    );
  }

  static List<WaveformPoint> pointsFrom(String body) => parse(body).points;

  static ({int index, String name}) _fieldMatch(
    List<String> headers,
    List<String> channelNames,
    bool Function(String key) matches,
    List<String> fallbackNames,
  ) {
    if (channelNames.isEmpty) {
      return _columnMatch(headers, fallbackNames);
    }
    for (final name in channelNames) {
      final key = _channelKey(name);
      if (!matches(key)) {
        continue;
      }
      final index = headers.indexOf(key);
      if (index >= 0) {
        return (index: index, name: headers[index]);
      }
    }
    return (index: -1, name: '');
  }

  static String _channelKey(String name) {
    final slash = name.lastIndexOf('/');
    final bare = slash < 0 ? name : name.substring(slash + 1);
    return bare.trim().toLowerCase();
  }

  static bool _isCurrentChannel(String key) {
    return key == 'current_a' || key == '전류_a';
  }

  static bool _isVoltageChannel(String key) {
    return key == 'voltage_v' || key == '전압_v';
  }

  static bool _isSpeedChannel(String key) {
    return key == 'wire_feed_speed_mpm' ||
        key == 'wire_speed_mpm' ||
        key == '와이어송급속도_m_min';
  }

  static bool _isRpmChannel(String key) {
    return key == 'rotation_speed_rpm' || key == 'rpm';
  }

  static ({int index, String name}) _columnMatch(
    List<String> headers,
    List<String> names,
  ) {
    for (final name in names) {
      final index = headers.indexOf(name);
      if (index >= 0) {
        return (index: index, name: name);
      }
    }
    return (index: -1, name: '');
  }

  static int? _timeMs(List<String> cells, int index, bool timeIsNs) {
    final value = _number(cells, index);
    if (value == null) {
      return null;
    }
    if (timeIsNs) {
      return (value / 1e6).round();
    }
    return value.round();
  }

  static double? _number(List<String> cells, int index) {
    if (index < 0 || index >= cells.length) {
      return null;
    }
    return double.tryParse(cells[index].trim());
  }
}
