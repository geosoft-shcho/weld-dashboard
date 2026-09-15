import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/preview_state.dart';
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
    switch (viewModel.previewState) {
      case PreviewState.loading:
        return const Center(child: ProgressRing());
      case PreviewState.empty:
        return const InfoBar(
          title: Text('빈 상태'),
          content: Text('미리보기: 표시할 데이터가 없습니다.'),
          severity: InfoBarSeverity.warning,
        );
      case PreviewState.error:
        return const InfoBar(
          title: Text('오류'),
          content: Text('미리보기: CSV 로드 실패 상태입니다.'),
          severity: InfoBarSeverity.error,
        );
      case PreviewState.live:
        if (viewModel.isLoading) {
          return const Center(child: ProgressRing());
        }
        if (viewModel.hasError) {
          return InfoBar(
            title: const Text('CSV 로드 실패'),
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
              title: const Text('CSV 로드됨'),
              content: Text(
                '${catalog.tableCount}개 테이블 · ${catalog.totalRowCount}행 · 스냅샷 ${catalog.snapshotAt.toIso8601String()} · pdfrx ${catalog.pdfrxReady ? "준비됨" : "미기동"}',
              ),
              severity: InfoBarSeverity.success,
            ),
          ],
        );
    }
  }
}
