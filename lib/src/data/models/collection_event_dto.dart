import '../../domain/entities/collection_event.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/entities/time_sync_status.dart';

class CollectionEventDto {
  const CollectionEventDto({
    required this.eventId,
    required this.equipmentId,
    required this.eventAt,
    required this.durationSec,
    required this.connectionStatus,
    required this.receivedCount,
    required this.windowLabel,
    required this.lossRatePercent,
    required this.timeSyncStatus,
    required this.clockOffsetMs,
  });

  factory CollectionEventDto.fromRow(Map<String, String> row) {
    return CollectionEventDto(
      eventId: row['event_id'] ?? '',
      equipmentId: row['equipment_id'] ?? '',
      eventAt: DateTime.parse(row['event_at'] ?? ''),
      durationSec: int.tryParse(row['duration_sec'] ?? '') ?? 0,
      connectionStatus: ConnectionStatus.parse(row['connection_status'] ?? ''),
      receivedCount: int.tryParse(row['received_count'] ?? '') ?? 0,
      windowLabel: row['window_label'] ?? '',
      lossRatePercent: _parseDouble(row['loss_rate_pct']),
      timeSyncStatus: TimeSyncStatus.parse(row['time_sync_status'] ?? ''),
      clockOffsetMs: _parseInt(row['clock_offset_ms']),
    );
  }

  final String eventId;
  final String equipmentId;
  final DateTime eventAt;
  final int durationSec;
  final ConnectionStatus connectionStatus;
  final int receivedCount;
  final String windowLabel;
  final double? lossRatePercent;
  final TimeSyncStatus timeSyncStatus;
  final int? clockOffsetMs;

  CollectionEvent toDomain({
    required String equipmentName,
    required String lineName,
  }) {
    return CollectionEvent(
      eventId: eventId,
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      lineName: lineName,
      eventAt: eventAt,
      durationSec: durationSec,
      connectionStatus: connectionStatus,
      receivedCount: receivedCount,
      windowLabel: windowLabel,
      lossRatePercent: lossRatePercent,
      timeSyncStatus: timeSyncStatus,
      clockOffsetMs: clockOffsetMs,
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
}
