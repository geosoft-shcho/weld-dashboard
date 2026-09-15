import '../../domain/entities/collection_status.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/entities/time_sync_status.dart';

class CollectionStatusDto {
  const CollectionStatusDto({
    required this.equipmentId,
    required this.snapshotAt,
    required this.connectionStatus,
    required this.receivedCount,
    required this.windowLabel,
    required this.lossRatePercent,
    required this.timeSyncStatus,
    required this.clockOffsetMs,
    required this.lastReceivedAt,
  });

  factory CollectionStatusDto.fromRow(Map<String, String> row) {
    return CollectionStatusDto(
      equipmentId: row['equipment_id'] ?? '',
      snapshotAt: DateTime.parse(row['snapshot_at'] ?? ''),
      connectionStatus: ConnectionStatus.parse(row['connection_status'] ?? ''),
      receivedCount: int.tryParse(row['received_count'] ?? '') ?? 0,
      windowLabel: row['window_label'] ?? '',
      lossRatePercent: _parseDouble(row['loss_rate_pct']),
      timeSyncStatus: TimeSyncStatus.parse(row['time_sync_status'] ?? ''),
      clockOffsetMs: _parseInt(row['clock_offset_ms']),
      lastReceivedAt: _parseDate(row['last_received_at']),
    );
  }

  final String equipmentId;
  final DateTime snapshotAt;
  final ConnectionStatus connectionStatus;
  final int receivedCount;
  final String windowLabel;
  final double? lossRatePercent;
  final TimeSyncStatus timeSyncStatus;
  final int? clockOffsetMs;
  final DateTime? lastReceivedAt;

  CollectionStatus toDomain() {
    return CollectionStatus(
      equipmentId: equipmentId,
      snapshotAt: snapshotAt,
      connectionStatus: connectionStatus,
      receivedCount: receivedCount,
      windowLabel: windowLabel,
      lossRatePercent: lossRatePercent,
      timeSyncStatus: timeSyncStatus,
      clockOffsetMs: clockOffsetMs,
      lastReceivedAt: lastReceivedAt,
    );
  }

  static double? _parseDouble(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return double.tryParse(raw);
  }

  static int? _parseInt(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return int.tryParse(raw);
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }
}
