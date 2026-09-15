import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/preview_state.dart';
import '../../features/collection_monitoring/collection_monitoring_screen.dart';
import '../../features/pass_profile/pass_profile_screen.dart';
import '../../features/quality_issue/quality_issue_screen.dart';
import '../../features/work_detail/work_detail_screen.dart';
import '../../features/work_history/work_history_screen.dart';
import '../../navigation/app_coordinator.dart';
import 'shell_view_model.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShellViewModel>().loadCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final coordinator = context.watch<AppCoordinator>();
    final viewModel = context.watch<ShellViewModel>();
    return NavigationView(
      titleBar: TitleBar(
        isBackButtonVisible: false,
        height: 48,
        title: const Text('용접 수집 모니터링'),
        endHeader: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('미리보기 상태'),
              const SizedBox(width: 8),
              SizedBox(
                width: 140,
                child: ComboBox<PreviewState>(
                  value: viewModel.previewState,
                  items: PreviewState.values
                      .map(
                        (state) => ComboBoxItem(
                          value: state,
                          child: Text(_previewLabel(state)),
                        ),
                      )
                      .toList(),
                  onChanged: (state) {
                    if (state != null) {
                      viewModel.didSelectPreviewState(state);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      pane: NavigationPane(
        selected: coordinator.selectedPaneIndex,
        onChanged: coordinator.didSelectPane,
        displayMode: PaneDisplayMode.expanded,
        size: const NavigationPaneSize(openWidth: 240),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.server_processes),
            title: const Text('수집 모니터링'),
            body: const CollectionMonitoringScreen(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.history),
            title: const Text('작업 이력 조회'),
            body: coordinator.isWorkDetailOpen
                ? WorkDetailScreen(
                    key: ValueKey(coordinator.historyId),
                    historyId: coordinator.historyId,
                  )
                : const WorkHistoryScreen(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.line_chart),
            title: const Text('패스별 파라미터 프로파일'),
            body: const PassProfileScreen(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.report_document),
            title: const Text('품질 이슈 연계'),
            body: const QualityIssueScreen(),
          ),
        ],
      ),
    );
  }

  String _previewLabel(PreviewState state) {
    switch (state) {
      case PreviewState.live:
        return '정상';
      case PreviewState.loading:
        return '로딩';
      case PreviewState.empty:
        return '빈 상태';
      case PreviewState.error:
        return '오류';
    }
  }
}
