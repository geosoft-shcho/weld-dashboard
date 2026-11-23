// This is a generated file - do not edit.
//
// Generated from mediatag/auth/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $2;
import 'auth.pbjson.dart';

export 'auth.pb.dart';

abstract class AuthServiceBase extends $pb.GeneratedService {
  $async.Future<$2.LoginResponse> login(
      $pb.ServerContext ctx, $2.LoginRequest request);
  $async.Future<$2.LogoutResponse> logout(
      $pb.ServerContext ctx, $2.LogoutRequest request);
  $async.Future<$2.GetCurrentAccountResponse> getCurrentAccount(
      $pb.ServerContext ctx, $2.GetCurrentAccountRequest request);
  $async.Future<$2.ChangePasswordResponse> changePassword(
      $pb.ServerContext ctx, $2.ChangePasswordRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login':
        return $2.LoginRequest();
      case 'Logout':
        return $2.LogoutRequest();
      case 'GetCurrentAccount':
        return $2.GetCurrentAccountRequest();
      case 'ChangePassword':
        return $2.ChangePasswordRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login':
        return login(ctx, request as $2.LoginRequest);
      case 'Logout':
        return logout(ctx, request as $2.LogoutRequest);
      case 'GetCurrentAccount':
        return getCurrentAccount(ctx, request as $2.GetCurrentAccountRequest);
      case 'ChangePassword':
        return changePassword(ctx, request as $2.ChangePasswordRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AuthServiceBase$messageJson;
}

abstract class AccountServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ListAccountsResponse> listAccounts(
      $pb.ServerContext ctx, $2.ListAccountsRequest request);
  $async.Future<$2.CreateAccountResponse> createAccount(
      $pb.ServerContext ctx, $2.CreateAccountRequest request);
  $async.Future<$2.UpdateAccountResponse> updateAccount(
      $pb.ServerContext ctx, $2.UpdateAccountRequest request);
  $async.Future<$2.ListPermissionsResponse> listPermissions(
      $pb.ServerContext ctx, $2.ListPermissionsRequest request);
  $async.Future<$2.ListRolesResponse> listRoles(
      $pb.ServerContext ctx, $2.ListRolesRequest request);
  $async.Future<$2.CreateRoleResponse> createRole(
      $pb.ServerContext ctx, $2.CreateRoleRequest request);
  $async.Future<$2.UpdateRoleResponse> updateRole(
      $pb.ServerContext ctx, $2.UpdateRoleRequest request);
  $async.Future<$2.DeleteRoleResponse> deleteRole(
      $pb.ServerContext ctx, $2.DeleteRoleRequest request);
  $async.Future<$2.ListServiceTokensResponse> listServiceTokens(
      $pb.ServerContext ctx, $2.ListServiceTokensRequest request);
  $async.Future<$2.CreateServiceTokenResponse> createServiceToken(
      $pb.ServerContext ctx, $2.CreateServiceTokenRequest request);
  $async.Future<$2.RevokeServiceTokenResponse> revokeServiceToken(
      $pb.ServerContext ctx, $2.RevokeServiceTokenRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListAccounts':
        return $2.ListAccountsRequest();
      case 'CreateAccount':
        return $2.CreateAccountRequest();
      case 'UpdateAccount':
        return $2.UpdateAccountRequest();
      case 'ListPermissions':
        return $2.ListPermissionsRequest();
      case 'ListRoles':
        return $2.ListRolesRequest();
      case 'CreateRole':
        return $2.CreateRoleRequest();
      case 'UpdateRole':
        return $2.UpdateRoleRequest();
      case 'DeleteRole':
        return $2.DeleteRoleRequest();
      case 'ListServiceTokens':
        return $2.ListServiceTokensRequest();
      case 'CreateServiceToken':
        return $2.CreateServiceTokenRequest();
      case 'RevokeServiceToken':
        return $2.RevokeServiceTokenRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListAccounts':
        return listAccounts(ctx, request as $2.ListAccountsRequest);
      case 'CreateAccount':
        return createAccount(ctx, request as $2.CreateAccountRequest);
      case 'UpdateAccount':
        return updateAccount(ctx, request as $2.UpdateAccountRequest);
      case 'ListPermissions':
        return listPermissions(ctx, request as $2.ListPermissionsRequest);
      case 'ListRoles':
        return listRoles(ctx, request as $2.ListRolesRequest);
      case 'CreateRole':
        return createRole(ctx, request as $2.CreateRoleRequest);
      case 'UpdateRole':
        return updateRole(ctx, request as $2.UpdateRoleRequest);
      case 'DeleteRole':
        return deleteRole(ctx, request as $2.DeleteRoleRequest);
      case 'ListServiceTokens':
        return listServiceTokens(ctx, request as $2.ListServiceTokensRequest);
      case 'CreateServiceToken':
        return createServiceToken(ctx, request as $2.CreateServiceTokenRequest);
      case 'RevokeServiceToken':
        return revokeServiceToken(ctx, request as $2.RevokeServiceTokenRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AccountServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AccountServiceBase$messageJson;
}
