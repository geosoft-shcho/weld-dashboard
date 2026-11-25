import 'package:web/web.dart' as web;

import 'authenticated_media.dart';

void openBrowserUrl(String url) {
  if (url.isEmpty) {
    return;
  }
  web.window.open(url, '_blank');
}

/// 성공 시 null, 실패 시 사용자용 안내 문구.
Future<String?> downloadBrowserUrl(String url, {String fileName = ''}) async {
  if (url.isEmpty) {
    return '받을 주소가 없습니다';
  }
  final name = fileName.trim().isEmpty ? 'download' : fileName.trim();
  final trimmed = url.trim();
  final isNetwork =
      trimmed.startsWith('http://') || trimmed.startsWith('https://');
  if (!isNetwork) {
    return '받을 수 있는 주소가 아닙니다';
  }
  try {
    await ensureAuthenticatedMediaFitsInMemory(trimmed);
    final bytes = await readAuthenticatedMediaBytes(trimmed);
    final objectUrl = createAuthenticatedMediaBlobUrl(
      bytes,
      mimeType: mimeTypeForMediaUrl(trimmed),
    );
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = objectUrl
      ..download = name
      ..style.display = 'none';
    web.document.body!.appendChild(anchor);
    anchor.click();
    anchor.remove();
    revokeAuthenticatedMediaBlobUrl(objectUrl);
    return null;
  } on AuthenticatedMediaTooLargeException catch (error) {
    return webInMemoryMediaTooLargeMessage(error.byteLength);
  } catch (_) {
    return '파일을 받지 못했습니다';
  }
}
