import 'connection_status.dart';
import 'time_sync_status.dart';

class CollectionStatus {
  const CollectionStatus({
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

  final String equipmentId;
  final DateTime snapshotAt;
  final ConnectionStatus connectionStatus;
  final int receivedCount;
  final String windowLabel;
  final double? lossRatePercent;
  final TimeSyncStatus timeSyncStatus;
  final int? clockOffsetMs;
  final DateTime? lastReceivedAt;
}
