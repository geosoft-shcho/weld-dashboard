//
//  Generated code. Do not modify.
//  source: mediatag/auth/v1/auth.proto
//

import "package:connectrpc/connect.dart" as connect;
import "auth.pb.dart" as mediatagauthv1auth;
import "auth.connect.spec.dart" as specs;

extension type AuthServiceClient (connect.Transport _transport) {
  /// 로그인. 아이디나 비밀번호가 틀리면 Unauthenticated(어느 쪽이 틀렸는지는 알려주지 않는다), 막힌 계정도 같다.
  /// 같은 아이디로 5번 연달아 틀리면 1분 동안 ResourceExhausted. 응답과 함께 세션 쿠키를 심는다.
  Future<mediatagauthv1auth.LoginResponse> login(
    mediatagauthv1auth.LoginRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.login,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 로그아웃 — 지금 세션을 지우고 쿠키를 비운다. 로그인하지 않았어도 성공한다.
  Future<mediatagauthv1auth.LogoutResponse> logout(
    mediatagauthv1auth.LogoutRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.logout,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 지금 로그인한 계정. 화면이 처음 뜰 때 로그인 여부 · 역할을 알아내는 용도 — 로그인하지 않았으면 Unauthenticated.
  Future<mediatagauthv1auth.GetCurrentAccountResponse> getCurrentAccount(
    mediatagauthv1auth.GetCurrentAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.getCurrentAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 내 비밀번호 바꾸기. 지금 비밀번호가 틀리면 PermissionDenied. 바꾸면 이 계정의 다른 세션은 모두 끊긴다.
  Future<mediatagauthv1auth.ChangePasswordResponse> changePassword(
    mediatagauthv1auth.ChangePasswordRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.changePassword,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// 계정 · 역할 관리 — account.manage 권한이 있어야 부를 수 있다.
extension type AccountServiceClient (connect.Transport _transport) {
  /// 계정 전부(막힌 계정 포함), 아이디 순.
  Future<mediatagauthv1auth.ListAccountsResponse> listAccounts(
    mediatagauthv1auth.ListAccountsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.listAccounts,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 계정을 만든다. account.login_name · account.role_id · password 필수. 같은 아이디가 있으면 AlreadyExists.
  Future<mediatagauthv1auth.CreateAccountResponse> createAccount(
    mediatagauthv1auth.CreateAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.createAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 계정을 고친다(update_mask: display_name, role_id, inactive, password). account.account_id 필수. 아이디는 못 바꾼다.
  /// password를 바꾸면 그 계정의 세션이 모두 끊긴다. 자기 계정의 role_id · inactive는 못 바꾼다(FailedPrecondition) —
  /// 관리자가 하나도 남지 않는 일을 막는다. 계정은 지우지 않고 inactive로 막는다.
  Future<mediatagauthv1auth.UpdateAccountResponse> updateAccount(
    mediatagauthv1auth.UpdateAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.updateAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 서버가 아는 권한 전부(이름과 설명) — 역할 편집 화면의 체크 목록.
  Future<mediatagauthv1auth.ListPermissionsResponse> listPermissions(
    mediatagauthv1auth.ListPermissionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.listPermissions,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 역할 전부, 번호 순.
  Future<mediatagauthv1auth.ListRolesResponse> listRoles(
    mediatagauthv1auth.ListRolesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.listRoles,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 역할을 만든다. role.role_name 필수. 같은 이름이 있으면 AlreadyExists, 목록에 없는 권한은 InvalidArgument.
  Future<mediatagauthv1auth.CreateRoleResponse> createRole(
    mediatagauthv1auth.CreateRoleRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.createRole,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 역할을 고친다(update_mask: role_name, description, permissions — permissions는 통째로 바꾼다). role.role_id 필수.
  /// 그 역할의 계정들에게 다음 요청부터 바로 먹는다. 자기 역할에서 account.manage는 뺄 수 없다(FailedPrecondition).
  Future<mediatagauthv1auth.UpdateRoleResponse> updateRole(
    mediatagauthv1auth.UpdateRoleRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.updateRole,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 역할을 지운다. 그 역할을 쓰는 계정이 있으면 FailedPrecondition — 계정들의 역할을 먼저 바꾼다.
  Future<mediatagauthv1auth.DeleteRoleResponse> deleteRole(
    mediatagauthv1auth.DeleteRoleRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.deleteRole,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 서버 연동 토큰 전부(폐기한 것 포함), 번호 순. 토큰 원문은 없다.
  Future<mediatagauthv1auth.ListServiceTokensResponse> listServiceTokens(
    mediatagauthv1auth.ListServiceTokensRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.listServiceTokens,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 토큰을 발급한다. name 필수(예: "ai-server"). 원문(token)은 이 응답에서 한 번만 준다 — 다시 볼 수 없다.
  /// 같은 이름으로 여럿을 둘 수 있다: 교체는 새로 발급 → 상대 서버에 넣기 → 옛 토큰의 last_used_at이 멈춘 것을 보고 폐기.
  Future<mediatagauthv1auth.CreateServiceTokenResponse> createServiceToken(
    mediatagauthv1auth.CreateServiceTokenRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.createServiceToken,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 토큰을 폐기한다(다음 요청부터 401). 되살리지 못한다 — 새로 발급한다. 없는 번호면 NotFound.
  /// 토큰을 한 번도 발급하지 않았으면 서버는 X-Internal-Token을 검사하지 않는다(처음 붙일 때의 전환용).
  /// 한 번이라도 발급했으면 전부 폐기해도 검사한다 — 통지 · 파일 받기는 401(새로 발급해 넣을 때까지 멈춤).
  Future<mediatagauthv1auth.RevokeServiceTokenResponse> revokeServiceToken(
    mediatagauthv1auth.RevokeServiceTokenRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AccountService.revokeServiceToken,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
