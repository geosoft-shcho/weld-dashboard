import 'package:flutter/foundation.dart';

/// `/api/files`(또는 `/files/`) HTTP 조회 디버그. 멀티모달 최초 로드 창을 표시한다.
class MediaFilesDebugLog {
  MediaFilesDebugLog._();

  static int _initialUntilMs = 0;

  static void beginInitialLoad({
    String jobId = '',
    Duration window = const Duration(seconds: 30),
  }) {
    if (!kDebugMode) {
      return;
    }
    _initialUntilMs =
        DateTime.now().millisecondsSinceEpoch + window.inMilliseconds;
    // ignore: avoid_print
    print(
      '[MM-FILES] initial_load_begin jobId=$jobId '
      'windowMs=${window.inMilliseconds}',
    );
  }

  static bool get isInitialLoad {
    return DateTime.now().millisecondsSinceEpoch < _initialUntilMs;
  }

  static bool isFilesUrl(String url) {
    if (url.isEmpty) {
      return false;
    }
    final lower = url.toLowerCase();
    return lower.contains('/api/files/') || lower.contains('/files/');
  }

  static String shortUrl(String url) {
    if (url.length <= 96) {
      return url;
    }
    return '…${url.substring(url.length - 96)}';
  }

  static void fetchStart({
    required String source,
    required String url,
  }) {
    if (!kDebugMode || !isFilesUrl(url)) {
      return;
    }
    final initial = isInitialLoad ? ' initial=1' : '';
    // ignore: avoid_print
    print('[MM-FILES] → $source$initial ${shortUrl(url)}');
  }

  static void fetchDone({
    required String source,
    required String url,
    required int elapsedMs,
    int? bytes,
    Object? error,
  }) {
    if (!kDebugMode || !isFilesUrl(url)) {
      return;
    }
    final initial = isInitialLoad ? ' initial=1' : '';
    if (error != null) {
      // ignore: avoid_print
      print(
        '[MM-FILES] ← $source$initial ${elapsedMs}ms error=$error '
        '${shortUrl(url)}',
      );
      return;
    }
    final size = bytes == null ? '' : ' bytes=$bytes';
    // ignore: avoid_print
    print(
      '[MM-FILES] ← $source$initial ${elapsedMs}ms$size ${shortUrl(url)}',
    );
  }
}
