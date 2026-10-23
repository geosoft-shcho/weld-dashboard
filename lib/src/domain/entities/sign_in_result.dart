import 'auth_user.dart';

enum SignInFailure { unknownUser, wrongPassword }

class SignInResult {
  const SignInResult.success(this.user) : failure = null;

  const SignInResult.failure(this.failure) : user = null;

  final AuthUser? user;
  final SignInFailure? failure;

  bool get isSuccess => user != null;
}
