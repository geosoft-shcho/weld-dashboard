import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/account_admin.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../core/widgets/query_failure_pane.dart';
import 'service_tokens_admin_view_model.dart';

class ServiceTokensAdminScreen extends StatelessWidget {
  const ServiceTokensAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ServiceTokensAdminViewModel>()..load(),
      child: const _ServiceTokensAdminBody(),
    );
  }
}

class _ServiceTokensAdminBody extends StatelessWidget {
  const _ServiceTokensAdminBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ServiceTokensAdminViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, ServiceTokensAdminViewModel viewModel) {
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
        label: '서버 연동 토큰',
        count: viewModel.tokens.length,
        actionText: '+ 토큰 발급',
        onAction: () => _didTapCreate(context, viewModel),
      ),
      filters: [],
      body: CatalogLookupTable(
        headers: const ['이름', '만든 시각', '마지막 사용', '상태'],
        columnFlexes: const [14, 16, 16, 10],
        emptyTitle: '토큰이 없습니다',
        rows: [
          for (final token in viewModel.tokens)
            [
              token.name,
              DashboardFormatters.dateTime(token.createdAt),
              DashboardFormatters.dateTime(token.lastUsedAt),
              token.isRevoked ? '폐기' : '사용',
            ],
        ],
        actionsBuilder: (context, index) {
          final token = viewModel.tokens[index];
          if (token.isRevoked) {
            return const Text('—');
          }
          return Button(
            onPressed: () => _didTapRevoke(context, viewModel, token),
            child: const Text('폐기'),
          );
        },
      ),
    );
  }

  Future<void> _didTapCreate(
    BuildContext context,
    ServiceTokensAdminViewModel viewModel,
  ) async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('토큰 발급'),
        content: InfoLabel(
          label: '연동 이름',
          child: LookupSearchField(
            controller: nameController,
            value: nameController.text,
            hintText: '예: ai-server',
            onChanged: (_) {},
          ),
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(nameController.text.trim()),
            child: const Text('발급'),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (name == null || name.isEmpty || !context.mounted) {
      return;
    }
    try {
      final created = await viewModel.createToken(name: name);
      if (created == null || !context.mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => ContentDialog(
          title: const Text('토큰 원문 (한 번만)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '이 값은 다시 보여 주지 수 없습니다. 상대 서버의 X-Internal-Token에 넣으세요.',
              ),
              const SizedBox(height: 12),
              SelectableText(
                created.plaintext,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
          ),
          actions: [
            Button(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: created.plaintext));
              },
              child: const Text('복사'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('닫기'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('발급 실패'),
          content: Text(error.toString()),
          severity: InfoBarSeverity.error,
          onClose: close,
        ),
      );
    }
  }

  Future<void> _didTapRevoke(
    BuildContext context,
    ServiceTokensAdminViewModel viewModel,
    ServiceTokenRow token,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('토큰 폐기'),
        content: Text('${token.name} 토큰을 폐기할까요? 되돌릴 수 없습니다.'),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('폐기'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final message = await viewModel.revokeToken(token: token);
    if (message != null && context.mounted) {
      await displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('폐기 실패'),
          content: Text(message),
          severity: InfoBarSeverity.error,
          onClose: close,
        ),
      );
    }
  }
}
