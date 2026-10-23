import 'package:shared_preferences/shared_preferences.dart';

/// Web·iOS·Android·Desktop 공통 세션 저장.
/// [SharedPreferences]는 웹에서 localStorage, 모바일에선 플랫폼 prefs를 쓴다.
class AuthSessionLocalDataSource {
  AuthSessionLocalDataSource({SharedPreferences? preferences})
    : _cachedPreferences = preferences;

  static const String USER_ID_KEY = 'auth.session.user_id';

  SharedPreferences? _cachedPreferences;

  Future<SharedPreferences> _prefs() async {
    return _cachedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<String?> readUserId() async {
    final prefs = await _prefs();
    final value = prefs.getString(USER_ID_KEY)?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  Future<void> writeUserId(String userId) async {
    final id = userId.trim();
    if (id.isEmpty) {
      return;
    }
    final prefs = await _prefs();
    await prefs.setString(USER_ID_KEY, id);
  }

  Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(USER_ID_KEY);
  }
}
