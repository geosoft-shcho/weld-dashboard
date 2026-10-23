class AuthUser {
  const AuthUser({
    required this.userId,
    required this.canAccessVideoMultimodal,
  });

  final String userId;
  final bool canAccessVideoMultimodal;

  static const String GEO_SOFT_USER_ID = 'geosoft';
  static const String GUEST_USER_ID = 'guest';

  /// 서버 계약 전 임시 비밀번호 (hint·기본 전달값과 동일).
  static const String TEMP_PASSWORD = '1234';

  static const AuthUser geoSoft = AuthUser(
    userId: GEO_SOFT_USER_ID,
    canAccessVideoMultimodal: true,
  );

  static const AuthUser guest = AuthUser(
    userId: GUEST_USER_ID,
    canAccessVideoMultimodal: false,
  );
}
