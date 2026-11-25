void openBrowserUrl(String url) {
  throw UnsupportedError('URL 열기는 웹 브라우저에서만 지원합니다.');
}

Future<String?> downloadBrowserUrl(String url, {String fileName = ''}) async {
  throw UnsupportedError('URL 내려받기는 웹 브라우저에서만 지원합니다.');
}
