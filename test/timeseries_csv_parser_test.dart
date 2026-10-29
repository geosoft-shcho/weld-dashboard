import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/timeseries_csv_parser.dart';

void main() {
  test('properties channel names map onto the csv columns', () {
    const body = '''
frame,current_A,wire_speed_mpm,voltage_V,rpm
1,10.5,1.2,22.0,30
''';

    final parsed = TimeseriesCsvParser.parse(
      body,
      channelNames: const [
        'frame',
        'current_A',
        'wire_speed_mpm',
        'voltage_V',
        'rpm',
      ],
    );

    expect(parsed.points, hasLength(1));
    expect(parsed.points.first.currentA, 10.5);
    expect(parsed.points.first.voltageV, 22);
    expect(parsed.points.first.speedValue, 1.2);
    expect(parsed.points.first.rotationSpeedRpm, 30);
    expect(parsed.matchedSpeedHeader, 'wire_speed_mpm');
  });

  test('a korean wire-speed channel name maps onto the speed column', () {
    const body = '''
전류_A,와이어송급속도_m_min,전압_V
4,8,16
''';

    final parsed = TimeseriesCsvParser.parse(
      body,
      channelNames: const ['전류_A', '와이어송급속도_m_min', '전압_V'],
    );

    expect(parsed.points.single.currentA, 4);
    expect(parsed.points.single.speedValue, 8);
    expect(parsed.points.single.voltageV, 16);
  });
}
