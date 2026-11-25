import '../entities/auth_user.dart';
import '../entities/sign_in_result.dart';

abstract class AuthRepository {
  /// 저장된 세션이 있으면 사용자, 없으면 null.
  Future<AuthUser?> restoreSession();

  /// AuthService.Login. 세션 토큰은 로컬에 두고 비밀번호는 저장하지 않는다.
  Future<SignInResult> signIn({
    required String userId,
    required String password,
  });

  Future<void> signOut();

  /// AuthService.ChangePassword. 현재 비번이 틀리면 예외(PermissionDenied).
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
