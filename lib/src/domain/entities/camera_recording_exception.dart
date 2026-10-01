class CameraRecordingException implements Exception {
  CameraRecordingException(this.message);

  final String message;

  @override
  String toString() => message;
}
