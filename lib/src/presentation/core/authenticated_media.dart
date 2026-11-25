import 'dart:typed_data';

import '../../data/datasources/remote/media_tag_data_source.dart';
import 'authenticated_media_blob.dart';
import 'di/locator.dart';
import 'formatters/dashboard_formatters.dart';

export 'authenticated_media_blob.dart'
    show createAuthenticatedMediaBlobUrl, revokeAuthenticatedMediaBlobUrl;

/// Web에서 통째로 메모리에 올리는 `/api/files` 상한.
const int webInMemoryMediaMaxBytes = 100 * 1024 * 1024;

class AuthenticatedMediaTooLargeException implements Exception {
  AuthenticatedMediaTooLargeException(this.byteLength);

  final int byteLength;

  @override
  String toString() => webInMemoryMediaTooLargeMessage(byteLength);
}

bool isWebInMemoryMediaTooLarge(int sizeBytes) {
  return sizeBytes > webInMemoryMediaMaxBytes;
}

String webInMemoryMediaTooLargeMessage(int sizeBytes) {
  final sizeLabel = DashboardFormatters.byteSize(sizeBytes);
  return '브라우저에서 열기에는 파일이 너무 큽니다($sizeLabel). '
      '미리보기와 내려받기는 이 크기에서 지원하지 않습니다.';
}

String webInMemoryMediaPreviewMessage(int sizeBytes) {
  final sizeLabel = DashboardFormatters.byteSize(sizeBytes);
  return '브라우저에서 미리볼 수 없습니다.\n파일이 너무 큽니다($sizeLabel).';
}

/// `/api/files` 등 http(s) 미디어 GET — `Authorization: Bearer` 포함.
Future<Uint8List> readAuthenticatedMediaBytes(String url) {
  return locator<MediaTagDataSource>().readBytes(url);
}

Future<int?> probeAuthenticatedMediaLength(String url) {
  return locator<MediaTagDataSource>().probeContentLength(url);
}

Future<void> ensureAuthenticatedMediaFitsInMemory(
  String url, {
  int knownSizeBytes = 0,
}) async {
  if (isWebInMemoryMediaTooLarge(knownSizeBytes)) {
    throw AuthenticatedMediaTooLargeException(knownSizeBytes);
  }
  if (knownSizeBytes > 0) {
    return;
  }
  final probed = await probeAuthenticatedMediaLength(url);
  if (probed != null && isWebInMemoryMediaTooLarge(probed)) {
    throw AuthenticatedMediaTooLargeException(probed);
  }
}

String mimeTypeForMediaUrl(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  if (path.endsWith('.webm')) {
    return 'video/webm';
  }
  if (path.endsWith('.mov')) {
    return 'video/quicktime';
  }
  if (path.endsWith('.mkv')) {
    return 'video/x-matroska';
  }
  if (path.endsWith('.pdf')) {
    return 'application/pdf';
  }
  return 'video/mp4';
}

/// Web `<video>`용: Bearer `readBytes` → blob URL.
Future<String> createAuthenticatedMediaBlobPlaybackUrl(String url) async {
  await ensureAuthenticatedMediaFitsInMemory(url);
  final bytes = await readAuthenticatedMediaBytes(url);
  return createAuthenticatedMediaBlobUrl(
    bytes,
    mimeType: mimeTypeForMediaUrl(url),
  );
}
