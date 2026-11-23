class AuthUser {
  const AuthUser({
    required this.accountId,
    required this.loginName,
    required this.displayName,
    required this.permissions,
  });

  final int accountId;
  final String loginName;
  final String displayName;
  final List<String> permissions;

  /// 셸·기존 코드 호환. 로그인 아이디.
  String get userId => loginName;

  String get shellDisplayName =>
      displayName.trim().isNotEmpty ? displayName.trim() : loginName;

  bool get canAccessVideoMultimodal =>
      permissions.contains('timeline.edit');

  bool get hasAccountManage => permissions.contains('account.manage');
}
