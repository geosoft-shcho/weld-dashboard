import 'package:shared_preferences/shared_preferences.dart';

/// Web·iOS·Android·Desktop 공통 세션 저장.
/// [SharedPreferences]는 웹에서 localStorage, 모바일에선 플랫폼 prefs를 쓴다.
class AuthSessionLocalDataSource {
  AuthSessionLocalDataSource({SharedPreferences? preferences})
    : _cachedPreferences = preferences;

  static const String LOGIN_NAME_KEY = 'auth.session.user_id';
  static const String TOKEN_KEY = 'auth.session.token';

  SharedPreferences? _cachedPreferences;

  Future<SharedPreferences> _prefs() async {
    return _cachedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<String?> readLoginName() async {
    final prefs = await _prefs();
    final value = prefs.getString(LOGIN_NAME_KEY)?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  Future<String?> readToken() async {
    final prefs = await _prefs();
    final value = prefs.getString(TOKEN_KEY)?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  Future<void> writeSession({
    required String loginName,
    required String token,
  }) async {
    final name = loginName.trim();
    final sessionToken = token.trim();
    if (name.isEmpty || sessionToken.isEmpty) {
      return;
    }
    final prefs = await _prefs();
    await prefs.setString(LOGIN_NAME_KEY, name);
    await prefs.setString(TOKEN_KEY, sessionToken);
  }

  Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(LOGIN_NAME_KEY);
    await prefs.remove(TOKEN_KEY);
  }
}
