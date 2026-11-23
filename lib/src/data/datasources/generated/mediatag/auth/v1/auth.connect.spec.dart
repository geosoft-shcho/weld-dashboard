//
//  Generated code. Do not modify.
//  source: mediatag/auth/v1/auth.proto
//

import "package:connectrpc/connect.dart" as connect;
import "auth.pb.dart" as mediatagauthv1auth;

abstract final class AuthService {
  /// Fully-qualified name of the AuthService service.
  static const name = 'mediatag.auth.v1.AuthService';

  /// 로그인. 아이디나 비밀번호가 틀리면 Unauthenticated(어느 쪽이 틀렸는지는 알려주지 않는다), 막힌 계정도 같다.
  /// 같은 아이디로 5번 연달아 틀리면 1분 동안 ResourceExhausted. 응답과 함께 세션 쿠키를 심는다.
  static const login = connect.Spec(
    '/$name/Login',
    connect.StreamType.unary,
    mediatagauthv1auth.LoginRequest.new,
    mediatagauthv1auth.LoginResponse.new,
  );

  /// 로그아웃 — 지금 세션을 지우고 쿠키를 비운다. 로그인하지 않았어도 성공한다.
  static const logout = connect.Spec(
    '/$name/Logout',
    connect.StreamType.unary,
    mediatagauthv1auth.LogoutRequest.new,
    mediatagauthv1auth.LogoutResponse.new,
  );

  /// 지금 로그인한 계정. 화면이 처음 뜰 때 로그인 여부 · 역할을 알아내는 용도 — 로그인하지 않았으면 Unauthenticated.
  static const getCurrentAccount = connect.Spec(
    '/$name/GetCurrentAccount',
    connect.StreamType.unary,
    mediatagauthv1auth.GetCurrentAccountRequest.new,
    mediatagauthv1auth.GetCurrentAccountResponse.new,
  );

  /// 내 비밀번호 바꾸기. 지금 비밀번호가 틀리면 PermissionDenied. 바꾸면 이 계정의 다른 세션은 모두 끊긴다.
  static const changePassword = connect.Spec(
    '/$name/ChangePassword',
    connect.StreamType.unary,
    mediatagauthv1auth.ChangePasswordRequest.new,
    mediatagauthv1auth.ChangePasswordResponse.new,
  );
}
/// 계정 · 역할 관리 — account.manage 권한이 있어야 부를 수 있다.
abstract final class AccountService {
  /// Fully-qualified name of the AccountService service.
  static const name = 'mediatag.auth.v1.AccountService';

  /// 계정 전부(막힌 계정 포함), 아이디 순.
  static const listAccounts = connect.Spec(
    '/$name/ListAccounts',
    connect.StreamType.unary,
    mediatagauthv1auth.ListAccountsRequest.new,
    mediatagauthv1auth.ListAccountsResponse.new,
  );

  /// 계정을 만든다. account.login_name · account.role_id · password 필수. 같은 아이디가 있으면 AlreadyExists.
  static const createAccount = connect.Spec(
    '/$name/CreateAccount',
    connect.StreamType.unary,
    mediatagauthv1auth.CreateAccountRequest.new,
    mediatagauthv1auth.CreateAccountResponse.new,
  );

  /// 계정을 고친다(update_mask: display_name, role_id, inactive, password). account.account_id 필수. 아이디는 못 바꾼다.
  /// password를 바꾸면 그 계정의 세션이 모두 끊긴다. 자기 계정의 role_id · inactive는 못 바꾼다(FailedPrecondition) —
  /// 관리자가 하나도 남지 않는 일을 막는다. 계정은 지우지 않고 inactive로 막는다.
  static const updateAccount = connect.Spec(
    '/$name/UpdateAccount',
    connect.StreamType.unary,
    mediatagauthv1auth.UpdateAccountRequest.new,
    mediatagauthv1auth.UpdateAccountResponse.new,
  );

  /// 서버가 아는 권한 전부(이름과 설명) — 역할 편집 화면의 체크 목록.
  static const listPermissions = connect.Spec(
    '/$name/ListPermissions',
    connect.StreamType.unary,
    mediatagauthv1auth.ListPermissionsRequest.new,
    mediatagauthv1auth.ListPermissionsResponse.new,
  );

  /// 역할 전부, 번호 순.
  static const listRoles = connect.Spec(
    '/$name/ListRoles',
    connect.StreamType.unary,
    mediatagauthv1auth.ListRolesRequest.new,
    mediatagauthv1auth.ListRolesResponse.new,
  );

  /// 역할을 만든다. role.role_name 필수. 같은 이름이 있으면 AlreadyExists, 목록에 없는 권한은 InvalidArgument.
  static const createRole = connect.Spec(
    '/$name/CreateRole',
    connect.StreamType.unary,
    mediatagauthv1auth.CreateRoleRequest.new,
    mediatagauthv1auth.CreateRoleResponse.new,
  );

  /// 역할을 고친다(update_mask: role_name, description, permissions — permissions는 통째로 바꾼다). role.role_id 필수.
  /// 그 역할의 계정들에게 다음 요청부터 바로 먹는다. 자기 역할에서 account.manage는 뺄 수 없다(FailedPrecondition).
  static const updateRole = connect.Spec(
    '/$name/UpdateRole',
    connect.StreamType.unary,
    mediatagauthv1auth.UpdateRoleRequest.new,
    mediatagauthv1auth.UpdateRoleResponse.new,
  );

  /// 역할을 지운다. 그 역할을 쓰는 계정이 있으면 FailedPrecondition — 계정들의 역할을 먼저 바꾼다.
  static const deleteRole = connect.Spec(
    '/$name/DeleteRole',
    connect.StreamType.unary,
    mediatagauthv1auth.DeleteRoleRequest.new,
    mediatagauthv1auth.DeleteRoleResponse.new,
  );

  /// 서버 연동 토큰 전부(폐기한 것 포함), 번호 순. 토큰 원문은 없다.
  static const listServiceTokens = connect.Spec(
    '/$name/ListServiceTokens',
    connect.StreamType.unary,
    mediatagauthv1auth.ListServiceTokensRequest.new,
    mediatagauthv1auth.ListServiceTokensResponse.new,
  );

  /// 토큰을 발급한다. name 필수(예: "ai-server"). 원문(token)은 이 응답에서 한 번만 준다 — 다시 볼 수 없다.
  /// 같은 이름으로 여럿을 둘 수 있다: 교체는 새로 발급 → 상대 서버에 넣기 → 옛 토큰의 last_used_at이 멈춘 것을 보고 폐기.
  static const createServiceToken = connect.Spec(
    '/$name/CreateServiceToken',
    connect.StreamType.unary,
    mediatagauthv1auth.CreateServiceTokenRequest.new,
    mediatagauthv1auth.CreateServiceTokenResponse.new,
  );

  /// 토큰을 폐기한다(다음 요청부터 401). 되살리지 못한다 — 새로 발급한다. 없는 번호면 NotFound.
  /// 토큰을 한 번도 발급하지 않았으면 서버는 X-Internal-Token을 검사하지 않는다(처음 붙일 때의 전환용).
  /// 한 번이라도 발급했으면 전부 폐기해도 검사한다 — 통지 · 파일 받기는 401(새로 발급해 넣을 때까지 멈춤).
  static const revokeServiceToken = connect.Spec(
    '/$name/RevokeServiceToken',
    connect.StreamType.unary,
    mediatagauthv1auth.RevokeServiceTokenRequest.new,
    mediatagauthv1auth.RevokeServiceTokenResponse.new,
  );
}
