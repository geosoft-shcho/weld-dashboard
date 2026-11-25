class AccountRow {
  const AccountRow({
    required this.accountId,
    required this.loginName,
    required this.displayName,
    required this.roleId,
    required this.roleName,
    required this.isInactive,
    required this.permissions,
  });

  final int accountId;
  final String loginName;
  final String displayName;
  final int roleId;
  final String roleName;
  final bool isInactive;
  final List<String> permissions;
}

class RoleRow {
  const RoleRow({
    required this.roleId,
    required this.roleName,
    required this.description,
    required this.permissions,
  });

  final int roleId;
  final String roleName;
  final String description;
  final List<String> permissions;
}

class PermissionRow {
  const PermissionRow({required this.key, required this.description});

  final String key;
  final String description;
}

class ServiceTokenRow {
  const ServiceTokenRow({
    required this.tokenId,
    required this.name,
    this.createdAt,
    this.revokedAt,
    this.lastUsedAt,
  });

  final int tokenId;
  final String name;
  final DateTime? createdAt;
  final DateTime? revokedAt;
  final DateTime? lastUsedAt;

  bool get isRevoked => revokedAt != null;
}

class CreatedServiceToken {
  const CreatedServiceToken({required this.token, required this.plaintext});

  final ServiceTokenRow token;
  final String plaintext;
}
