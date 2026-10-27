import '../../domain/entities/auth_user.dart';
import '../../domain/entities/sign_in_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_session_local_data_source.dart';

/// 서버 계약 전 임시 계정.
/// `geosoft` 비밀번호 [AuthUser.GEO_SOFT_PASSWORD], `user` 비밀번호 [AuthUser.GUEST_PASSWORD].
class HardcodedAuthRepository implements AuthRepository {
  HardcodedAuthRepository(this._sessionLocal);

  final AuthSessionLocalDataSource _sessionLocal;

  /// prefs에 남아 있을 수 있는 구 제한 계정 ID (`GUEST_USER_ID` 변경 전).
  static const String _legacyGuestUserId = 'guest';

  static final Map<String, AuthUser> _usersById = {
    AuthUser.GEO_SOFT_USER_ID: AuthUser.geoSoft,
    AuthUser.GUEST_USER_ID: AuthUser.guest,
  };

  @override
  Future<AuthUser?> restoreSession() async {
    final userId = await _sessionLocal.readUserId();
    if (userId == null) {
      return null;
    }
    final normalizedId = userId.toLowerCase();
    // 구 세션 `guest` → `user` (로그인 ID 변경 호환).
    if (normalizedId == _legacyGuestUserId) {
      await _sessionLocal.writeUserId(AuthUser.GUEST_USER_ID);
      return AuthUser.guest;
    }
    return _usersById[normalizedId];
  }

  @override
  Future<SignInResult> signIn({
    required String userId,
    required String password,
  }) async {
    final normalizedId = _normalizeUserId(userId);
    final user = _usersById[normalizedId];
    if (user == null) {
      return const SignInResult.failure(SignInFailure.unknownUser);
    }
    final expectedPassword = AuthUser.passwordForUserId(user.userId);
    final normalizedPassword = _normalizePassword(
      password,
      expectedPassword: expectedPassword,
    );
    if (normalizedPassword != expectedPassword) {
      return const SignInResult.failure(SignInFailure.wrongPassword);
    }
    // 정규화된 계정 ID만 저장 (빈 입력을 geosoft로 보정한 경우 포함).
    await _sessionLocal.writeUserId(user.userId);
    return SignInResult.success(user);
  }

  @override
  Future<void> signOut() {
    return _sessionLocal.clear();
  }

  /// 비어 있으면 hint 기본값 `geosoft`.
  String _normalizeUserId(String userId) {
    final trimmed = userId.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return AuthUser.GEO_SOFT_USER_ID;
    }
    return trimmed;
  }

  /// 비어 있으면 해당 계정의 기대 비밀번호로 보정.
  String _normalizePassword(
    String password, {
    required String expectedPassword,
  }) {
    final trimmed = password.trim();
    if (trimmed.isEmpty) {
      return expectedPassword;
    }
    return trimmed;
  }
}
