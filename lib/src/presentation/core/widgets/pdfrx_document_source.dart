import 'package:flutter/foundation.dart';

/// PDF 소스 종류. `PdfrxDocumentViewer`가 생성자별로 `PdfViewer`를 고른다.
sealed class PdfrxDocumentSource {
  const PdfrxDocumentSource();

  const factory PdfrxDocumentSource.asset(String assetPath) =
      PdfrxAssetDocumentSource;

  const factory PdfrxDocumentSource.file(String filePath) =
      PdfrxFileDocumentSource;

  const factory PdfrxDocumentSource.uri(Uri uri) = PdfrxUriDocumentSource;

  const factory PdfrxDocumentSource.data(
    Uint8List bytes, {
    required String sourceName,
  }) = PdfrxDataDocumentSource;
}

final class PdfrxAssetDocumentSource extends PdfrxDocumentSource {
  const PdfrxAssetDocumentSource(this.assetPath);

  final String assetPath;

  @override
  bool operator ==(Object other) =>
      other is PdfrxAssetDocumentSource && other.assetPath == assetPath;

  @override
  int get hashCode => assetPath.hashCode;
}

final class PdfrxFileDocumentSource extends PdfrxDocumentSource {
  const PdfrxFileDocumentSource(this.filePath);

  final String filePath;

  @override
  bool operator ==(Object other) =>
      other is PdfrxFileDocumentSource && other.filePath == filePath;

  @override
  int get hashCode => filePath.hashCode;
}

final class PdfrxUriDocumentSource extends PdfrxDocumentSource {
  const PdfrxUriDocumentSource(this.uri);

  final Uri uri;

  @override
  bool operator ==(Object other) =>
      other is PdfrxUriDocumentSource && other.uri == uri;

  @override
  int get hashCode => uri.hashCode;
}

final class PdfrxDataDocumentSource extends PdfrxDocumentSource {
  const PdfrxDataDocumentSource(this.bytes, {required this.sourceName});

  final Uint8List bytes;
  final String sourceName;

  @override
  bool operator ==(Object other) =>
      other is PdfrxDataDocumentSource &&
      other.sourceName == sourceName &&
      identical(other.bytes, bytes);

  @override
  int get hashCode => Object.hash(sourceName, identityHashCode(bytes));
}

/// 경로 문자열을 asset / file / uri 중 하나로 해석한다.
///
/// - `http(s)://` → uri
/// - 절대 파일 경로 → file (웹이면 null + [unsupportedReason])
/// - `assets/` · `data/` · 상대 경로 → asset
PdfrxDocumentSource? resolvePdfrxDocumentSource(
  String path, {
  void Function(String reason)? onUnsupported,
}) {
  final trimmed = path.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final lower = trimmed.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      onUnsupported?.call('잘못된 URL입니다');
      return null;
    }
    return PdfrxDocumentSource.uri(uri);
  }

  if (_looksLikeAbsoluteFilePath(trimmed)) {
    if (kIsWeb) {
      onUnsupported?.call('웹에서는 로컬 파일 경로 PDF를 열 수 없습니다');
      return null;
    }
    return PdfrxDocumentSource.file(trimmed);
  }

  final assetPath = resolvePdfrxAssetPath(trimmed);
  if (assetPath == null) {
    return null;
  }
  return PdfrxDocumentSource.asset(assetPath);
}

String? resolvePdfrxAssetPath(String scanFile) {
  final trimmed = scanFile.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  var relative = trimmed;
  if (relative.startsWith('assets/')) {
    return _preferUnderscoreAsset(relative);
  }
  if (relative.startsWith('data/')) {
    relative = 'assets/$relative';
  } else if (!relative.contains('/')) {
    relative = 'assets/data/attachments/$relative';
  } else {
    relative = 'assets/$relative';
  }
  return _preferUnderscoreAsset(relative);
}

bool _looksLikeAbsoluteFilePath(String path) {
  if (path.startsWith('/')) {
    return true;
  }
  // Windows: C:\... or C:/...
  if (path.length >= 3 &&
      path[1] == ':' &&
      (path[2] == '\\' || path[2] == '/')) {
    return true;
  }
  return false;
}

String _preferUnderscoreAsset(String assetPath) {
  final parts = assetPath.split('/');
  if (parts.isEmpty) {
    return assetPath;
  }
  final base = parts.last;
  if (!base.contains('-')) {
    return assetPath;
  }
  parts[parts.length - 1] = base.replaceAll('-', '_');
  return parts.join('/');
}
