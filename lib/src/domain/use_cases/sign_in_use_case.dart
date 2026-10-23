import '../entities/sign_in_result.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<SignInResult> execute({
    required String userId,
    required String password,
  }) {
    return _repository.signIn(userId: userId, password: password);
  }
}
