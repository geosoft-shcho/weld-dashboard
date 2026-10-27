import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/auth_user.dart';
import '../../core/di/locator.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../features/app_shell/widgets/shell_title_leading.dart';
import 'auth_session_view_model.dart';
import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          LoginViewModel(authSession: locator<AuthSessionViewModel>()),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  late final TextEditingController _userIdController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<LoginViewModel>();
    _userIdController = TextEditingController(text: viewModel.userIdText);
    _passwordController = TextEditingController(text: viewModel.passwordText);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final theme = FluentTheme.of(context);
    return ScaffoldPage(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ShellTitleLeading.APP_TITLE,
                style: theme.typography.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              InfoLabel(
                label: 'ID',
                child: LookupSearchField(
                  controller: _userIdController,
                  value: viewModel.userIdText,
                  hintText: AuthUser.GEO_SOFT_USER_ID,
                  textInputAction: TextInputAction.next,
                  onChanged: viewModel.didChangeUserId,
                  onSubmitted: (_) => _didSubmit(context),
                ),
              ),
              const SizedBox(height: 12),
              InfoLabel(
                label: 'Password',
                child: LookupSearchField(
                  controller: _passwordController,
                  value: viewModel.passwordText,
                  hintText: AuthUser.GEO_SOFT_PASSWORD,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  onChanged: viewModel.didChangePassword,
                  onSubmitted: (_) => _didSubmit(context),
                  suffixIcon: Tooltip(
                    message: _isPasswordVisible ? '비밀번호 가리기' : '비밀번호 보기',
                    child: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? FluentIcons.hide
                            : FluentIcons.red_eye,
                        size: 14,
                      ),
                      onPressed: _didTapPasswordVisibility,
                    ),
                  ),
                ),
              ),
              if (viewModel.doesHaveError) ...[
                const SizedBox(height: 12),
                InfoBar(
                  title: const Text('로그인 실패'),
                  content: Text(viewModel.errorMessage),
                  severity: InfoBarSeverity.error,
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: viewModel.isBusy ? null : () => _didSubmit(context),
                child: viewModel.isBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: ProgressRing(strokeWidth: 2),
                      )
                    : const Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _didTapPasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _didSubmit(BuildContext context) async {
    final viewModel = context.read<LoginViewModel>();
    // Chrome 자동완성·포커스 중 onChanged 누락 대비: 컨트롤러 문구를 기준으로 로그인.
    await viewModel.didTapSignIn(
      userId: _userIdController.text,
      password: _passwordController.text,
    );
  }
}
