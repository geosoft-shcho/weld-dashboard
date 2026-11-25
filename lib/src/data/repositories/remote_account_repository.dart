import 'package:fixnum/fixnum.dart';

import '../../domain/entities/account_admin.dart';
import '../../domain/repositories/account_admin_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/mediatag/auth/v1/auth.pb.dart' as auth_pb;
import '../datasources/remote/media_tag_data_source.dart';

class RemoteAccountRepository implements AccountAdminRepository {
  RemoteAccountRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<AccountRow>> listAccounts() async {
    final response = await _mediaTag.accountService.listAccounts(
      auth_pb.ListAccountsRequest(),
    );
    return [for (final account in response.accounts) _accountRow(account)];
  }

  @override
  Future<AccountRow> createAccount({
    required String loginName,
    required String displayName,
    required int roleId,
    required String password,
  }) async {
    final response = await _mediaTag.accountService.createAccount(
      auth_pb.CreateAccountRequest(
        account: auth_pb.Account(
          loginName: loginName,
          displayName: displayName,
          roleId: Int64(roleId),
        ),
        password: password,
      ),
    );
    return _accountRow(response.account);
  }

  @override
  Future<AccountRow> updateAccount({
    required int accountId,
    String? displayName,
    int? roleId,
    bool? isInactive,
    String? password,
  }) async {
    final paths = <String>[
      if (displayName != null) 'display_name',
      if (roleId != null) 'role_id',
      if (isInactive != null) 'inactive',
      if (password != null) 'password',
    ];
    final account = auth_pb.Account(accountId: Int64(accountId));
    if (displayName != null) {
      account.displayName = displayName;
    }
    if (roleId != null) {
      account.roleId = Int64(roleId);
    }
    if (isInactive != null) {
      account.inactive = isInactive;
    }
    final response = await _mediaTag.accountService.updateAccount(
      auth_pb.UpdateAccountRequest(
        account: account,
        updateMask: FieldMask(paths: paths),
        password: password ?? '',
      ),
    );
    return _accountRow(response.account);
  }

  @override
  Future<List<PermissionRow>> listPermissions() async {
    final response = await _mediaTag.accountService.listPermissions(
      auth_pb.ListPermissionsRequest(),
    );
    return [
      for (final permission in response.permissions)
        PermissionRow(key: permission.key, description: permission.description),
    ];
  }

  @override
  Future<List<RoleRow>> listRoles() async {
    final response = await _mediaTag.accountService.listRoles(
      auth_pb.ListRolesRequest(),
    );
    return [for (final role in response.roles) _roleRow(role)];
  }

  @override
  Future<RoleRow> createRole({
    required String roleName,
    required String description,
    required List<String> permissions,
  }) async {
    final response = await _mediaTag.accountService.createRole(
      auth_pb.CreateRoleRequest(
        role: auth_pb.Role(
          roleName: roleName,
          description: description,
          permissions: permissions,
        ),
      ),
    );
    return _roleRow(response.role);
  }

  @override
  Future<RoleRow> updateRole({
    required int roleId,
    String? roleName,
    String? description,
    List<String>? permissions,
  }) async {
    final paths = <String>[
      if (roleName != null) 'role_name',
      if (description != null) 'description',
      if (permissions != null) 'permissions',
    ];
    final role = auth_pb.Role(roleId: Int64(roleId));
    if (roleName != null) {
      role.roleName = roleName;
    }
    if (description != null) {
      role.description = description;
    }
    if (permissions != null) {
      role.permissions.addAll(permissions);
    }
    final response = await _mediaTag.accountService.updateRole(
      auth_pb.UpdateRoleRequest(
        role: role,
        updateMask: FieldMask(paths: paths),
      ),
    );
    return _roleRow(response.role);
  }

  @override
  Future<void> deleteRole({required int roleId}) async {
    await _mediaTag.accountService.deleteRole(
      auth_pb.DeleteRoleRequest(roleId: Int64(roleId)),
    );
  }

  @override
  Future<List<ServiceTokenRow>> listServiceTokens() async {
    final response = await _mediaTag.accountService.listServiceTokens(
      auth_pb.ListServiceTokensRequest(),
    );
    return [for (final token in response.tokens) _serviceTokenRow(token)];
  }

  @override
  Future<CreatedServiceToken> createServiceToken({required String name}) async {
    final response = await _mediaTag.accountService.createServiceToken(
      auth_pb.CreateServiceTokenRequest(name: name),
    );
    return CreatedServiceToken(
      token: _serviceTokenRow(response.serviceToken),
      plaintext: response.token,
    );
  }

  @override
  Future<ServiceTokenRow> revokeServiceToken({required int tokenId}) async {
    final response = await _mediaTag.accountService.revokeServiceToken(
      auth_pb.RevokeServiceTokenRequest(tokenId: Int64(tokenId)),
    );
    return _serviceTokenRow(response.serviceToken);
  }

  AccountRow _accountRow(auth_pb.Account account) {
    return AccountRow(
      accountId: account.accountId.toInt(),
      loginName: account.loginName,
      displayName: account.displayName,
      roleId: account.roleId.toInt(),
      roleName: account.roleName,
      isInactive: account.inactive,
      permissions: List<String>.from(account.permissions),
    );
  }

  RoleRow _roleRow(auth_pb.Role role) {
    return RoleRow(
      roleId: role.roleId.toInt(),
      roleName: role.roleName,
      description: role.description,
      permissions: List<String>.from(role.permissions),
    );
  }

  ServiceTokenRow _serviceTokenRow(auth_pb.ServiceToken token) {
    return ServiceTokenRow(
      tokenId: token.tokenId.toInt(),
      name: token.name,
      createdAt: token.hasCreatedAt()
          ? token.createdAt.toDateTime().toLocal()
          : null,
      revokedAt: token.hasRevokedAt()
          ? token.revokedAt.toDateTime().toLocal()
          : null,
      lastUsedAt: token.hasLastUsedAt()
          ? token.lastUsedAt.toDateTime().toLocal()
          : null,
    );
  }
}
