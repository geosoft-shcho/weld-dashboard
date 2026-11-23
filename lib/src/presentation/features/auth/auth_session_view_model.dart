import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/auth_user.dart';
import '../../../domain/entities/sign_in_result.dart';
import '../../../domain/use_cases/restore_auth_session_use_case.dart';
import '../../../domain/use_cases/sign_in_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

/// 앱 전역 로그인 세션. AuthService 토큰·계정을 복원한다.
class AuthSessionViewModel extends ChangeNotifier {
  AuthSessionViewModel({
    required RestoreAuthSessionUseCase restoreAuthSessionUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _restoreAuthSessionUseCase = restoreAuthSessionUseCase,
       _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase;

  final RestoreAuthSessionUseCase _restoreAuthSessionUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthUser? _user;
  bool _isRestoring = true;
  bool _isBusy = false;
  String _errorMessage = '';

  AuthUser? get user => _user;
  String get userId => _user?.userId ?? '';
  String get shellDisplayName => _user?.shellDisplayName ?? '';
  bool get isSignedIn => _user != null;
  bool get isRestoring => _isRestoring;
  bool get isBusy => _isBusy;
  String get errorMessage => _errorMessage;
  bool get canAccessVideoMultimodal =>
      _user?.canAccessVideoMultimodal ?? false;
  bool get hasAccountManage => _user?.hasAccountManage ?? false;

  Future<void> restore() async {
    _isRestoring = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _user = await _restoreAuthSessionUseCase.execute();
    } catch (_) {
      _user = null;
    } finally {
      _isRestoring = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({
    required String userId,
    required String password,
  }) async {
    if (_isBusy) {
      return false;
    }
    _isBusy = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final result = await _signInUseCase.execute(
        userId: userId,
        password: password,
      );
      if (!result.isSuccess) {
        _errorMessage = switch (result.failure) {
          SignInFailure.rateLimited =>
            '같은 아이디로 여러 번 틀려 잠시 막혔습니다. 1분 뒤 다시 시도하세요.',
          SignInFailure.invalidCredentials || null =>
            '아이디 또는 비밀번호가 올바르지 않습니다.',
        };
        return false;
      }
      _user = result.user;
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (_isBusy) {
      return;
    }
    _isBusy = true;
    notifyListeners();
    try {
      await _signOutUseCase.execute();
      _user = null;
      _errorMessage = '';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  /// Connect 401 공통 처리. Logout RPC는 호출하지 않는다.
  void didReceiveUnauthenticated() {
    if (_user == null && !_isRestoring) {
      return;
    }
    _user = null;
    _errorMessage = '';
    _isRestoring = false;
    _isBusy = false;
    notifyListeners();
  }
}
