import 'package:web/web.dart' as web;

String? readAskSessionValue(String key) {
  return web.window.localStorage.getItem(key);
}

void writeAskSessionValue(String key, String value) {
  web.window.localStorage.setItem(key, value);
}

void removeAskSessionValue(String key) {
  web.window.localStorage.removeItem(key);
}
