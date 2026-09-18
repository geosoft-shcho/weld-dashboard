import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/preview_state.dart';
import '../../features/collection_monitoring/collection_monitoring_screen.dart';
import '../../features/pass_profile/pass_profile_screen.dart';
import '../../features/quality_issue/quality_issue_screen.dart';
import '../../features/work_detail/work_detail_screen.dart';
import '../../features/work_history/work_history_screen.dart';
import '../../navigation/app_coordinator.dart';
import 'shell_view_model.dart';
import 'widgets/shell_title_leading.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  /// Compact rail when false; open pane with labels when true.
  bool _isPaneOpen = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShellViewModel>().loadCatalog();
    });
  }

  void _didTapTogglePane() {
    setState(() {
      _isPaneOpen = !_isPaneOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final coordinator = context.watch<AppCoordinator>();
    final viewModel = context.watch<ShellViewModel>();

    return Stack(
      children: [
        NavigationView(
          titleBar: TitleBar(
            isBackButtonVisible: false,
            height: 48,
            leftHeader: ShellTitleLeading(
              onTogglePane: _didTapTogglePane,
            ),
            endHeader: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CSV 로드 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  const Text('미리보기 상태', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
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
            displayMode: _isPaneOpen
                ? PaneDisplayMode.expanded
                : PaneDisplayMode.compact,
            // Single toggle lives in the title bar leading row.
            toggleButton: null,
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
                body: _workHistoryBody(coordinator),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _workHistoryBody(AppCoordinator coordinator) {
    switch (coordinator.workHistoryStack) {
      case WorkHistoryStack.list:
        return const WorkHistoryScreen();
      case WorkHistoryStack.detail:
        return WorkDetailScreen(
          key: ValueKey('detail|${coordinator.historyId}'),
          historyId: coordinator.historyId,
        );
      case WorkHistoryStack.passProfile:
        return PassProfileScreen(
          key: ValueKey(
            'pass|${coordinator.historyCommonKey}|${coordinator.historyId}|${coordinator.passId}',
          ),
          commonKey: coordinator.historyCommonKey,
          historyId: coordinator.historyId,
          passId: coordinator.passId,
        );
      case WorkHistoryStack.qualityIssue:
        return QualityIssueScreen(
          key: ValueKey(
            'quality|${coordinator.historyCommonKey}|${coordinator.historyId}|${coordinator.passId}|${coordinator.linkId}',
          ),
          commonKey: coordinator.historyCommonKey,
          historyId: coordinator.historyId,
          passId: coordinator.passId,
          linkId: coordinator.linkId,
        );
    }
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
