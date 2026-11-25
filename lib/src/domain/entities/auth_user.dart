import 'auth_permission_policy.dart' as policy;

class AuthUser {
  const AuthUser({
    required this.accountId,
    required this.loginName,
    required this.displayName,
    required this.roleId,
    required this.roleName,
    required this.permissions,
  });

  final int accountId;
  final String loginName;
  final String displayName;
  final int roleId;
  final String roleName;
  final List<String> permissions;

  /// 셸·기존 코드 호환. 로그인 아이디.
  String get userId => loginName;

  String get shellDisplayName =>
      displayName.trim().isNotEmpty ? displayName.trim() : loginName;

  bool get canAccessVideoMultimodal => policy.canAccessVideoMultimodal(
    permissions: permissions,
    roleId: roleId,
    roleName: roleName,
  );

  bool get hasAccountManage =>
      policy.hasAccountManage(permissions: permissions);
}
