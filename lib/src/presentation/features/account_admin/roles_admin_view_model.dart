import 'package:connectrpc/connect.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/account_admin.dart';
import '../../../domain/repositories/account_admin_repository.dart';

class RolesAdminViewModel extends ChangeNotifier {
  RolesAdminViewModel({required AccountAdminRepository repository})
    : _repository = repository;

  final AccountAdminRepository _repository;

  List<RoleRow> _roles = const [];
  List<PermissionRow> _permissions = const [];
  bool _hasLoaded = false;
  bool _isLoading = false;
  String _errorMessage = '';

  List<RoleRow> get roles => _roles;
  List<PermissionRow> get permissions => _permissions;
  bool get hasLoaded => _hasLoaded;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage.isNotEmpty;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final roles = await _repository.listRoles();
      final permissions = await _repository.listPermissions();
      _roles = roles;
      _permissions = permissions;
      _hasLoaded = true;
    } catch (error) {
      _errorMessage = _messageOf(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createRole({
    required String roleName,
    required String description,
    required List<String> permissions,
  }) async {
    final name = roleName.trim();
    if (name.isEmpty) {
      return '권한 이름을 넣으세요.';
    }
    try {
      await _repository.createRole(
        roleName: name,
        description: description.trim(),
        permissions: permissions,
      );
      await load();
      return null;
    } catch (error) {
      return _messageOf(error);
    }
  }

  Future<String?> updateRole({
    required RoleRow role,
    required String roleName,
    required String description,
    required List<String> permissions,
  }) async {
    final name = roleName.trim();
    if (name.isEmpty) {
      return '권한 이름을 넣으세요.';
    }
    try {
      await _repository.updateRole(
        roleId: role.roleId,
        roleName: name,
        description: description.trim(),
        permissions: permissions,
      );
      await load();
      return null;
    } catch (error) {
      return _messageOf(error);
    }
  }

  Future<String?> deleteRole({required RoleRow role}) async {
    try {
      await _repository.deleteRole(roleId: role.roleId);
      await load();
      return null;
    } catch (error) {
      return _messageOf(error);
    }
  }

  String _messageOf(Object error) {
    if (error is ConnectException) {
      return error.message.isNotEmpty ? error.message : error.toString();
    }
    return error.toString();
  }
}
