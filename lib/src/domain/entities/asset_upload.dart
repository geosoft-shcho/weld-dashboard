class AssetUploadResult {
  const AssetUploadResult({
    required this.assetId,
    required this.fileName,
    required this.runId,
    this.warnings = const [],
  });

  final String assetId;
  final String fileName;
  final String runId;
  final List<String> warnings;
}

class AssetUploadException implements Exception {
  const AssetUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}
