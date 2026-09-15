enum ConnectionStatus {
  connected,
  disconnected,
  error;

  static ConnectionStatus parse(String value) {
    switch (value) {
      case 'connected':
        return ConnectionStatus.connected;
      case 'disconnected':
        return ConnectionStatus.disconnected;
      case 'error':
        return ConnectionStatus.error;
      default:
        return ConnectionStatus.disconnected;
    }
  }

  String get label {
    switch (this) {
      case ConnectionStatus.connected:
        return '연결';
      case ConnectionStatus.disconnected:
        return '단절';
      case ConnectionStatus.error:
        return '오류';
    }
  }
}
