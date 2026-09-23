import '../../domain/entities/series_role.dart';
import '../../domain/entities/waveform_row.dart';

class WaveformRowDto {
  const WaveformRowDto({
    required this.seriesId,
    required this.passId,
    required this.commonKey,
    required this.seriesRole,
    required this.masterProfileId,
    required this.workerId,
    required this.robotId,
    required this.timeMs,
    required this.currentA,
    required this.voltageV,
    required this.speedValue,
    required this.rotationSpeedRpm,
  });

  factory WaveformRowDto.fromRow(Map<String, String> row) {
    return WaveformRowDto(
      seriesId: row['series_id'] ?? '',
      passId: row['pass_id'] ?? '',
      commonKey: row['common_key'] ?? '',
      seriesRole: row['series_role'] ?? '',
      masterProfileId: row['master_profile_id'] ?? '',
      workerId: row['worker_id'] ?? '',
      robotId: row['robot_id'] ?? '',
      timeMs: int.tryParse(row['time_ms'] ?? '') ?? 0,
      currentA: row['current_a'] ?? '',
      voltageV: row['voltage_v'] ?? '',
      speedValue: row['speed_value'] ?? '',
      rotationSpeedRpm: row['rotation_speed_rpm'] ?? '',
    );
  }

  final String seriesId;
  final String passId;
  final String commonKey;
  final String seriesRole;
  final String masterProfileId;
  final String workerId;
  final String robotId;
  final int timeMs;
  final String currentA;
  final String voltageV;
  final String speedValue;
  final String rotationSpeedRpm;

  WaveformRow? toDomain() {
    final role = SeriesRole.fromCsv(seriesRole);
    if (role == null || passId.isEmpty) {
      return null;
    }
    return WaveformRow(
      seriesId: seriesId,
      passId: passId,
      commonKey: commonKey,
      seriesRole: role,
      masterProfileId: masterProfileId,
      workerId: workerId,
      robotId: robotId,
      timeMs: timeMs,
      currentA: _nullableDouble(currentA),
      voltageV: _nullableDouble(voltageV),
      speedValue: _nullableDouble(speedValue),
      rotationSpeedRpm: _nullableDouble(rotationSpeedRpm),
    );
  }

  double? _nullableDouble(String raw) {
    if (raw.trim().isEmpty) {
      return null;
    }
    return double.tryParse(raw);
  }
}
