class AssetUploadResult {
  const AssetUploadResult({
    required this.assetId,
    required this.fileName,
    required this.runId,
    this.warnings = const [],
    this.duplicateAssetIds = const [],
  });

  final String assetId;
  final String fileName;
  final String runId;
  final List<String> warnings;
  final List<String> duplicateAssetIds;
}

class AssetUploadException implements Exception {
  const AssetUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AssetUploadFormat {
  const AssetUploadFormat({
    required this.label,
    required this.extensions,
    required this.steps,
    required this.timeOriginRequired,
  });

  final String label;
  final List<String> extensions;
  final List<String> steps;
  final bool timeOriginRequired;
}

class AssetUploadFormats {
  const AssetUploadFormats({required this.formats, required this.maxBytes});

  final List<AssetUploadFormat> formats;
  final int maxBytes;

  AssetUploadFormat? formatOf(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    for (final format in formats) {
      if (format.extensions.contains(extension)) {
        return format;
      }
    }
    return null;
  }
}
