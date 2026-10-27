import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/auth_user.dart';
import '../../../domain/entities/sign_in_result.dart';
import '../../../domain/use_cases/restore_auth_session_use_case.dart';
import '../../../domain/use_cases/sign_in_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

/// 앱 전역 로그인 세션. Web·모바일 prefs에 저장된 ID를 복원한다.
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
  bool get isSignedIn => _user != null;
  bool get isRestoring => _isRestoring;
  bool get isBusy => _isBusy;
  String get errorMessage => _errorMessage;
  bool get canAccessVideoMultimodal =>
      _user?.canAccessVideoMultimodal ?? false;

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
          SignInFailure.wrongPassword => '비밀번호가 올바르지 않습니다.',
          SignInFailure.unknownUser || null =>
            '사용할 수 없는 계정입니다. geosoft 또는 user를 입력하세요.',
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
}
