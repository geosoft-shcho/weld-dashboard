import 'package:fluent_ui/fluent_ui.dart';

import 'auth_session_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthSessionViewModel authSession})
    : _authSession = authSession;

  final AuthSessionViewModel _authSession;

  String _userIdText = '';
  String _passwordText = '';
  String _errorMessage = '';

  String get userIdText => _userIdText;
  String get passwordText => _passwordText;
  String get errorMessage =>
      _errorMessage.isNotEmpty ? _errorMessage : _authSession.errorMessage;
  bool get isBusy => _authSession.isBusy;
  bool get doesHaveError => errorMessage.isNotEmpty;

  void didChangeUserId(String value) {
    _userIdText = value;
    _clearLocalError();
  }

  void didChangePassword(String value) {
    _passwordText = value;
    _clearLocalError();
  }

  void _clearLocalError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  /// [userId]/[password]를 넘기면 입력란 최신 문구를 우선 사용한다.
  Future<bool> didTapSignIn({String? userId, String? password}) async {
    if (userId != null) {
      _userIdText = userId;
    }
    if (password != null) {
      _passwordText = password;
    }
    _errorMessage = '';
    notifyListeners();
    final ok = await _authSession.signIn(
      userId: _userIdText,
      password: _passwordText,
    );
    if (!ok) {
      notifyListeners();
    }
    return ok;
  }
}
