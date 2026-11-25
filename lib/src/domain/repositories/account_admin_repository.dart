import '../entities/account_admin.dart';

abstract class AccountAdminRepository {
  Future<List<AccountRow>> listAccounts();

  Future<AccountRow> createAccount({
    required String loginName,
    required String displayName,
    required int roleId,
    required String password,
  });

  Future<AccountRow> updateAccount({
    required int accountId,
    String? displayName,
    int? roleId,
    bool? isInactive,
    String? password,
  });

  Future<List<PermissionRow>> listPermissions();

  Future<List<RoleRow>> listRoles();

  Future<RoleRow> createRole({
    required String roleName,
    required String description,
    required List<String> permissions,
  });

  Future<RoleRow> updateRole({
    required int roleId,
    String? roleName,
    String? description,
    List<String>? permissions,
  });

  Future<void> deleteRole({required int roleId});

  Future<List<ServiceTokenRow>> listServiceTokens();

  Future<CreatedServiceToken> createServiceToken({required String name});

  Future<ServiceTokenRow> revokeServiceToken({required int tokenId});
}
