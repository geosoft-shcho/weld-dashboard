import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/account_admin.dart';
import '../../core/di/locator.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../auth/auth_session_view_model.dart';
import 'accounts_admin_view_model.dart';

class AccountsAdminScreen extends StatelessWidget {
  const AccountsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AccountsAdminViewModel>()..load(),
      child: const _AccountsAdminBody(),
    );
  }
}

class _AccountsAdminBody extends StatelessWidget {
  const _AccountsAdminBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AccountsAdminViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, AccountsAdminViewModel viewModel) {
    if (!viewModel.hasLoaded) {
      if (viewModel.isLoading) {
        return const Center(child: ProgressRing());
      }
      if (viewModel.hasError) {
        return QueryFailurePane(
          title: '조회 실패',
          message: viewModel.errorMessage,
          onRetry: viewModel.load,
        );
      }
    }
    return CatalogLookupFrame(
      tableHeader: LookupTableHeader(
        label: '계정',
        count: viewModel.accounts.length,
        actionText: '+ 새 계정',
        onAction: () => _didTapCreate(context, viewModel),
      ),
      filters: const [],
      body: CatalogLookupTable(
        headers: const ['아이디', '이름', '역할', '상태'],
        columnFlexes: const [14, 14, 14, 10],
        emptyTitle: '계정이 없습니다',
        rows: [
          for (final account in viewModel.accounts)
            [
              account.loginName,
              account.displayName.isEmpty ? '—' : account.displayName,
              account.roleName.isEmpty ? '—' : account.roleName,
              account.isInactive ? '막힘' : '사용',
            ],
        ],
        actionsBuilder: (context, index) {
          final account = viewModel.accounts[index];
          return Button(
            onPressed: () => _didTapEdit(context, viewModel, account),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.edit, size: 12),
                SizedBox(width: 6),
                Text('수정'),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _didTapCreate(
    BuildContext context,
    AccountsAdminViewModel viewModel,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _AccountEditDialog(viewModel: viewModel),
    );
  }

  Future<void> _didTapEdit(
    BuildContext context,
    AccountsAdminViewModel viewModel,
    AccountRow account,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          _AccountEditDialog(viewModel: viewModel, account: account),
    );
  }
}

class _AccountEditDialog extends StatefulWidget {
  const _AccountEditDialog({required this.viewModel, this.account});

  final AccountsAdminViewModel viewModel;
  final AccountRow? account;

  @override
  State<_AccountEditDialog> createState() => _AccountEditDialogState();
}

class _AccountEditDialogState extends State<_AccountEditDialog> {
  late final TextEditingController _loginName;
  late final TextEditingController _displayName;
  late final TextEditingController _password;
  late int _roleId;
  late bool _isInactive;
  bool _isSaving = false;
  bool _isPasswordVisible = false;
  String _error = '';

  bool get _isCreate => widget.account == null;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _loginName = TextEditingController(text: account?.loginName ?? '');
    _displayName = TextEditingController(text: account?.displayName ?? '');
    _password = TextEditingController();
    _roleId = account?.roleId ??
        (widget.viewModel.roles.isEmpty ? 0 : widget.viewModel.roles.first.roleId);
    _isInactive = account?.isInactive ?? false;
  }

  @override
  void dispose() {
    _loginName.dispose();
    _displayName.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _didTapSave() async {
    setState(() {
      _isSaving = true;
      _error = '';
    });
    final String? message;
    if (_isCreate) {
      message = await widget.viewModel.createAccount(
        loginName: _loginName.text,
        displayName: _displayName.text,
        roleId: _roleId,
        password: _password.text,
      );
    } else {
      message = await widget.viewModel.updateAccount(
        account: widget.account!,
        displayName: _displayName.text,
        roleId: _roleId,
        isInactive: _isInactive,
        password: _password.text,
      );
    }
    if (!mounted) {
      return;
    }
    if (message != null) {
      final errorText = message;
      setState(() {
        _error = errorText;
        _isSaving = false;
      });
      return;
    }
    if (!_isCreate) {
      final auth = context.read<AuthSessionViewModel>();
      if (widget.account!.accountId == auth.accountId) {
        await auth.refreshCurrentAccount();
      }
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final roles = widget.viewModel.roles;
    return ContentDialog(
      title: Text(_isCreate ? '새 계정' : '계정 고치기'),
      constraints: const BoxConstraints(maxWidth: 440),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoLabel(
            label: '로그인 아이디',
            child: _isCreate
                ? LookupSearchField(
                    controller: _loginName,
                    value: _loginName.text,
                    hintText: '영문 소문자 · 숫자 · . _ -',
                    onChanged: (_) {},
                  )
                : Text(widget.account!.loginName),
          ),
          const SizedBox(height: 12),
          InfoLabel(
            label: '표시 이름',
            child: LookupSearchField(
              controller: _displayName,
              value: _displayName.text,
              hintText: '표시 이름',
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 12),
          InfoLabel(
            label: '역할',
            child: ComboBox<int>(
              isExpanded: true,
              value: roles.any((role) => role.roleId == _roleId)
                  ? _roleId
                  : null,
              items: [
                for (final role in roles)
                  ComboBoxItem(
                    value: role.roleId,
                    child: Text(role.roleName),
                  ),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _roleId = value);
                      }
                    },
            ),
          ),
          if (!_isCreate) ...[
            const SizedBox(height: 12),
            Checkbox(
              checked: _isInactive,
              content: const Text('막기 (inactive)'),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _isInactive = value);
                      }
                    },
            ),
          ],
          const SizedBox(height: 12),
          InfoLabel(
            label: _isCreate ? '비밀번호 (8~72바이트)' : '비밀번호 재설정 (비우면 유지)',
            // Fluent PasswordBox는 Web에서 ContentDialog 입력이 끊긴다.
            // 로그인과 같이 Material LookupSearchField(obscure)를 쓴다.
            child: LookupSearchField(
              controller: _password,
              value: _password.text,
              hintText: _isCreate ? '비밀번호' : '비우면 유지',
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onChanged: (_) {},
              suffixIcon: Tooltip(
                message: _isPasswordVisible ? '비밀번호 가리기' : '비밀번호 보기',
                child: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? FluentIcons.hide
                        : FluentIcons.red_eye,
                    size: 14,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 12),
            InfoBar(
              title: const Text('저장 실패'),
              content: Text(_error),
              severity: InfoBarSeverity.error,
            ),
          ],
        ],
      ),
      actions: [
        Button(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _didTapSave,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: ProgressRing(strokeWidth: 2),
                )
              : Text(_isCreate ? '만들기' : '저장'),
        ),
      ],
    );
  }
}
