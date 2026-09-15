import 'connection_status.dart';
import 'time_sync_status.dart';

class CollectionEvent {
  const CollectionEvent({
    required this.eventId,
    required this.equipmentId,
    required this.equipmentName,
    required this.lineName,
    required this.eventAt,
    required this.durationSec,
    required this.connectionStatus,
    required this.receivedCount,
    required this.windowLabel,
    required this.lossRatePercent,
    required this.timeSyncStatus,
    required this.clockOffsetMs,
  });

  final String eventId;
  final String equipmentId;
  final String equipmentName;
  final String lineName;
  final DateTime eventAt;
  final int durationSec;
  final ConnectionStatus connectionStatus;
  final int receivedCount;
  final String windowLabel;
  final double? lossRatePercent;
  final TimeSyncStatus timeSyncStatus;
  final int? clockOffsetMs;

  DateTime get endedAt => eventAt.add(Duration(seconds: durationSec));

  bool get isLossWarning => lossRatePercent != null && lossRatePercent! >= 10;

  bool get isDesynced =>
      timeSyncStatus == TimeSyncStatus.delayed ||
      timeSyncStatus == TimeSyncStatus.unsynced;

  double get startMinutes {
    return eventAt.hour * 60 + eventAt.minute + eventAt.second / 60;
  }

  double get durationMinutes {
    return durationSec / 60;
  }
}
