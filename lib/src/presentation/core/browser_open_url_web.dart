import 'package:web/web.dart' as web;

void openBrowserUrl(String url) {
  if (url.isEmpty) {
    return;
  }
  web.window.open(url, '_blank');
}
