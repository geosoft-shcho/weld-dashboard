enum TimeSyncStatus {
  synced,
  delayed,
  unsynced;

  static TimeSyncStatus parse(String value) {
    switch (value) {
      case 'synced':
        return TimeSyncStatus.synced;
      case 'delayed':
        return TimeSyncStatus.delayed;
      case 'unsynced':
        return TimeSyncStatus.unsynced;
      default:
        return TimeSyncStatus.unsynced;
    }
  }

  String get label {
    switch (this) {
      case TimeSyncStatus.synced:
        return '동기';
      case TimeSyncStatus.delayed:
        return '지연';
      case TimeSyncStatus.unsynced:
        return '미동기';
    }
  }
}
