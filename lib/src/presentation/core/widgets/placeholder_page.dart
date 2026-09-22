import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../features/app_shell/shell_view_model.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ShellViewModel>();
    return ScaffoldPage(
      header: PageHeader(title: Text(title)),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _body(viewModel),
      ),
    );
  }

  Widget _body(ShellViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.errorMessage),
        severity: InfoBarSeverity.error,
      );
    }
    final catalog = viewModel.catalog;
    if (catalog == null) {
      return const InfoBar(
        title: Text('카탈로그 없음'),
        content: Text('아직 CSV를 불러오지 않았습니다.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(body),
        const SizedBox(height: 12),
        InfoBar(
          title: const Text('조회됨'),
          content: Text(
            '${catalog.tableCount}개 테이블 · ${catalog.totalRowCount}행 · 스냅샷 ${catalog.snapshotAt.toIso8601String()} · pdfrx ${catalog.pdfrxReady ? "준비됨" : "미기동"}',
          ),
          severity: InfoBarSeverity.success,
        ),
      ],
    );
  }
}
