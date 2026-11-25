import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/account_admin.dart';
import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../core/widgets/query_failure_pane.dart';
import 'roles_admin_view_model.dart';

class RolesAdminScreen extends StatelessWidget {
  const RolesAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<RolesAdminViewModel>()..load(),
      child: const _RolesAdminBody(),
    );
  }
}

class _RolesAdminBody extends StatelessWidget {
  const _RolesAdminBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RolesAdminViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, RolesAdminViewModel viewModel) {
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
        label: '권한',
        count: viewModel.roles.length,
        actionText: '+ 새 권한',
        onAction: () => _didTapCreate(context, viewModel),
      ),
      filters: const [],
      body: CatalogLookupTable(
        headers: const ['이름', '설명', '권한 수'],
        columnFlexes: const [14, 20, 8],
        emptyTitle: '권한이 없습니다',
        rows: [
          for (final role in viewModel.roles)
            [
              role.roleName,
              role.description.isEmpty ? '—' : role.description,
              '${role.permissions.length}',
            ],
        ],
        actionsBuilder: (context, index) {
          final role = viewModel.roles[index];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                onPressed: () => _didTapEdit(context, viewModel, role),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.edit, size: 12),
                    SizedBox(width: 6),
                    Text('수정'),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Button(
                onPressed: () => _didTapDelete(context, viewModel, role),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.delete, size: 12),
                    SizedBox(width: 6),
                    Text('삭제'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _didTapCreate(
    BuildContext context,
    RolesAdminViewModel viewModel,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _RoleEditDialog(viewModel: viewModel),
    );
  }

  Future<void> _didTapEdit(
    BuildContext context,
    RolesAdminViewModel viewModel,
    RoleRow role,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _RoleEditDialog(viewModel: viewModel, role: role),
    );
  }

  Future<void> _didTapDelete(
    BuildContext context,
    RolesAdminViewModel viewModel,
    RoleRow role,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('권한 삭제'),
        content: Text('${role.roleName} 권한을 삭제할까요?'),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('지우기'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final message = await viewModel.deleteRole(role: role);
    if (message != null && context.mounted) {
      await displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('지우기 실패'),
          content: Text(message),
          severity: InfoBarSeverity.error,
          onClose: close,
        ),
      );
    }
  }
}

class _RoleEditDialog extends StatefulWidget {
  const _RoleEditDialog({required this.viewModel, this.role});

  final RolesAdminViewModel viewModel;
  final RoleRow? role;

  @override
  State<_RoleEditDialog> createState() => _RoleEditDialogState();
}

class _RoleEditDialogState extends State<_RoleEditDialog> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final Set<String> _selected;
  bool _isSaving = false;
  String _error = '';

  bool get _isCreate => widget.role == null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.role?.roleName ?? '');
    _description = TextEditingController(text: widget.role?.description ?? '');
    _selected = {...?widget.role?.permissions};
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _didTapSave() async {
    setState(() {
      _isSaving = true;
      _error = '';
    });
    final permissions = _selected.toList()..sort();
    final String? message;
    if (_isCreate) {
      message = await widget.viewModel.createRole(
        roleName: _name.text,
        description: _description.text,
        permissions: permissions,
      );
    } else {
      message = await widget.viewModel.updateRole(
        role: widget.role!,
        roleName: _name.text,
        description: _description.text,
        permissions: permissions,
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    // ContentDialog.actions는 Expanded로 constraints.maxWidth까지 늘어난다.
    // 버튼은 content 안에 두어 IntrinsicWidth(권한 행)에 맞춘다.
    return ContentDialog(
      title: Text(_isCreate ? '새 권한' : '권한 수정'),
      constraints: BoxConstraints(
        maxWidth: viewSize.width * 0.9,
        maxHeight: viewSize.height * 0.85,
      ),
      content: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoLabel(
              label: '이름',
              child: LookupSearchField(
                controller: _name,
                value: _name.text,
                hintText: '권한 이름',
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 12),
            InfoLabel(
              label: '설명',
              child: LookupSearchField(
                controller: _description,
                value: _description.text,
                hintText: '설명',
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 12),
            const Text('권한', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: viewSize.height * 0.45),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final permission in widget.viewModel.permissions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Checkbox(
                          checked: _selected.contains(permission.key),
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _PermissionKeyBadge(label: permission.key),
                              const SizedBox(width: 8),
                              Text(
                                permission.description.isEmpty
                                    ? '—'
                                    : permission.description,
                                softWrap: false,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          onChanged: _isSaving
                              ? null
                              : (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selected.add(permission.key);
                                    } else {
                                      _selected.remove(permission.key);
                                    }
                                  });
                                },
                        ),
                      ),
                  ],
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionKeyBadge extends StatelessWidget {
  const _PermissionKeyBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.ACCENT_STEEL.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.ACCENT_STEEL,
          ),
        ),
      ),
    );
  }
}
