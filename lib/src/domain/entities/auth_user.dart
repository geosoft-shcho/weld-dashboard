class AuthUser {
  const AuthUser({
    required this.userId,
    required this.canAccessVideoMultimodal,
  });

  final String userId;
  final bool canAccessVideoMultimodal;

  static const String GEO_SOFT_USER_ID = 'geosoft';
  static const String GUEST_USER_ID = 'user';

  /// `geosoft` 계정 검증용 비밀번호 (폼 기본값·hint에 쓰지 않음).
  static const String GEO_SOFT_PASSWORD = '56781234';

  /// `user`(게스트) 계정 검증용 비밀번호.
  static const String GUEST_PASSWORD = '1234';

  /// [GEO_SOFT_PASSWORD] 별칭.
  static const String TEMP_PASSWORD = GEO_SOFT_PASSWORD;

  static const AuthUser geoSoft = AuthUser(
    userId: GEO_SOFT_USER_ID,
    canAccessVideoMultimodal: true,
  );

  static const AuthUser guest = AuthUser(
    userId: GUEST_USER_ID,
    canAccessVideoMultimodal: false,
  );

  /// 계정 ID에 맞는 임시 비밀번호. 모르면 빈 문자열.
  static String passwordForUserId(String userId) {
    switch (userId) {
      case GEO_SOFT_USER_ID:
        return GEO_SOFT_PASSWORD;
      case GUEST_USER_ID:
        return GUEST_PASSWORD;
      default:
        return '';
    }
  }
}
