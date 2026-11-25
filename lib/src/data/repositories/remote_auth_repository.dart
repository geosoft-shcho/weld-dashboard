import 'package:connectrpc/connect.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/entities/sign_in_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/generated/mediatag/auth/v1/auth.pb.dart' as auth_pb;
import '../datasources/local/auth_session_local_data_source.dart';
import '../datasources/remote/media_tag_data_source.dart';

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._mediaTag, this._sessionLocal);

  final MediaTagDataSource _mediaTag;
  final AuthSessionLocalDataSource _sessionLocal;

  @override
  Future<AuthUser?> restoreSession() async {
    final token = await _sessionLocal.readToken();
    if (token == null || token.isEmpty) {
      _mediaTag.sessionToken = null;
      return null;
    }
    _mediaTag.sessionToken = token;
    try {
      final response = await _mediaTag.authService.getCurrentAccount(
        auth_pb.GetCurrentAccountRequest(),
      );
      if (!response.hasAccount()) {
        await _clearLocal();
        return null;
      }
      return _userFromAccount(response.account);
    } on ConnectException catch (error) {
      if (error.code == Code.unauthenticated) {
        await _clearLocal();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<SignInResult> signIn({
    required String userId,
    required String password,
  }) async {
    final loginName = userId.trim().toLowerCase();
    final trimmedPassword = password.trim();
    if (loginName.isEmpty || trimmedPassword.isEmpty) {
      return const SignInResult.failure(SignInFailure.invalidCredentials);
    }
    try {
      final response = await _mediaTag.authService.login(
        auth_pb.LoginRequest(
          loginName: loginName,
          password: trimmedPassword,
        ),
      );
      if (!response.hasAccount() || response.token.trim().isEmpty) {
        return const SignInResult.failure(SignInFailure.invalidCredentials);
      }
      final user = _userFromAccount(response.account);
      await _sessionLocal.writeSession(
        loginName: user.loginName,
        token: response.token,
      );
      _mediaTag.sessionToken = response.token;
      return SignInResult.success(user);
    } on ConnectException catch (error) {
      if (error.code == Code.resourceExhausted) {
        return const SignInResult.failure(SignInFailure.rateLimited);
      }
      if (error.code == Code.unauthenticated) {
        return const SignInResult.failure(SignInFailure.invalidCredentials);
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _mediaTag.authService.logout(auth_pb.LogoutRequest());
    } on ConnectException {
      // 로컬 세션은 무조건 비운다.
    } finally {
      await _clearLocal();
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _mediaTag.authService.changePassword(
      auth_pb.ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<void> _clearLocal() async {
    _mediaTag.sessionToken = null;
    await _sessionLocal.clear();
  }

  AuthUser _userFromAccount(auth_pb.Account account) {
    return AuthUser(
      accountId: account.accountId.toInt(),
      loginName: account.loginName,
      displayName: account.displayName,
      permissions: List<String>.from(account.permissions),
    );
  }
}
