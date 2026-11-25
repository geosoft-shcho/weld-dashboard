import 'dart:convert';

import 'package:connectrpc/connect.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/account_admin.dart';
import '../../../domain/repositories/account_admin_repository.dart';

class AccountsAdminViewModel extends ChangeNotifier {
  AccountsAdminViewModel({
    required AccountAdminRepository repository,
  }) : _repository = repository;

  final AccountAdminRepository _repository;

  List<AccountRow> _accounts = const [];
  List<RoleRow> _roles = const [];
  bool _hasLoaded = false;
  bool _isLoading = false;
  String _errorMessage = '';

  List<AccountRow> get accounts => _accounts;
  List<RoleRow> get roles => _roles;
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
      final accounts = await _repository.listAccounts();
      final roles = await _repository.listRoles();
      _accounts = accounts;
      _roles = roles;
      _hasLoaded = true;
    } catch (error) {
      _errorMessage = _messageOf(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createAccount({
    required String loginName,
    required String displayName,
    required int roleId,
    required String password,
  }) async {
    final name = loginName.trim().toLowerCase();
    final display = displayName.trim();
    if (name.isEmpty) {
      return '로그인 아이디를 넣으세요.';
    }
    if (roleId <= 0) {
      return '역할을 고르세요.';
    }
    final byteLength = utf8.encode(password).length;
    if (byteLength < 8 || byteLength > 72) {
      return '비밀번호는 8~72바이트여야 합니다.';
    }
    try {
      await _repository.createAccount(
        loginName: name,
        displayName: display,
        roleId: roleId,
        password: password,
      );
      await load();
      return null;
    } catch (error) {
      return _messageOf(error);
    }
  }

  Future<String?> updateAccount({
    required AccountRow account,
    required String displayName,
    required int roleId,
    required bool isInactive,
    String password = '',
  }) async {
    final display = displayName.trim();
    final pathsNeeded = <String>[];
    String? nextDisplay;
    int? nextRoleId;
    bool? nextInactive;
    String? nextPassword;

    if (display != account.displayName) {
      nextDisplay = display;
      pathsNeeded.add('display_name');
    }
    if (roleId != account.roleId) {
      nextRoleId = roleId;
      pathsNeeded.add('role_id');
    }
    if (isInactive != account.isInactive) {
      nextInactive = isInactive;
      pathsNeeded.add('inactive');
    }
    if (password.isNotEmpty) {
      final byteLength = utf8.encode(password).length;
      if (byteLength < 8 || byteLength > 72) {
        return '비밀번호는 8~72바이트여야 합니다.';
      }
      nextPassword = password;
      pathsNeeded.add('password');
    }
    if (pathsNeeded.isEmpty) {
      return '바꾼 내용이 없습니다.';
    }
    try {
      await _repository.updateAccount(
        accountId: account.accountId,
        displayName: nextDisplay,
        roleId: nextRoleId,
        isInactive: nextInactive,
        password: nextPassword,
      );
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
