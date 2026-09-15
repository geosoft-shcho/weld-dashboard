import 'connection_status.dart';
import 'time_sync_status.dart';

class CollectionBoardRow {
  const CollectionBoardRow({
    required this.equipmentId,
    required this.equipmentName,
    required this.lineName,
    required this.connectionStatus,
    required this.receivedCount,
    required this.windowLabel,
    required this.lossRatePercent,
    required this.timeSyncStatus,
    required this.clockOffsetMs,
    required this.lastReceivedAt,
    required this.projectName,
    required this.workerName,
  });

  final String equipmentId;
  final String equipmentName;
  final String lineName;
  final ConnectionStatus connectionStatus;
  final int receivedCount;
  final String windowLabel;
  final double? lossRatePercent;
  final TimeSyncStatus timeSyncStatus;
  final int? clockOffsetMs;
  final DateTime? lastReceivedAt;
  final String projectName;
  final String workerName;

  bool get isLossWarning => lossRatePercent != null && lossRatePercent! >= 10;

  bool get isDisconnectedOrError =>
      connectionStatus != ConnectionStatus.connected;
}
