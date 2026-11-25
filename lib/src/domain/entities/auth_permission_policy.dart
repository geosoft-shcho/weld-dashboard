/// 로그인 계정의 화면·액션 노출 판정. UI는 [AuthUser] getter만 본다.
bool canAccessVideoMultimodal({
  required List<String> permissions,
  required int roleId,
  required String roleName,
}) {
  if (_isViewerRole(roleId: roleId, roleName: roleName)) {
    return false;
  }
  return permissions.contains('timeline.edit');
}

bool hasAccountManage({required List<String> permissions}) {
  return permissions.contains('account.manage');
}

bool _isViewerRole({required int roleId, required String roleName}) {
  if (roleId == 1) {
    return true;
  }
  return roleName.trim().toLowerCase() == 'viewer';
}
