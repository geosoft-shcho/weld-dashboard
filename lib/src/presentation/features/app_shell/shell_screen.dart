import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
      _loadCatalogAndLatestPaneTargets();
    });
  }

  Future<void> _loadCatalogAndLatestPaneTargets() async {
    final viewModel = context.read<ShellViewModel>();
    final coordinator = context.read<AppCoordinator>();
    await viewModel.loadCatalog();
    if (!mounted) {
      return;
    }
    coordinator.didApplyLatestPaneCandidates(
      passProfile: viewModel.latestPassProfile,
      qualityIssue: viewModel.latestQualityIssue,
    );
  }

  void _didTapTogglePane() {
    setState(() {
      _isPaneOpen = !_isPaneOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final coordinator = context.watch<AppCoordinator>();

    return Stack(
      children: [
        NavigationView(
          titleBar: TitleBar(
            isBackButtonVisible: false,
            height: 48,
            leftHeader: ShellTitleLeading(onTogglePane: _didTapTogglePane),
            endHeader: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                '최신 업데이트 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}',
                style: const TextStyle(fontSize: 12),
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
              PaneItem(
                icon: const Icon(FluentIcons.line_chart),
                title: Tooltip(
                  message: coordinator.canOpenLatestPassProfile
                      ? '스냅샷 기준 최신 패스 프로파일'
                      : '표시할 패스 프로파일이 없습니다',
                  child: const Text('패스별 파라미터 프로파일'),
                ),
                enabled: coordinator.canOpenLatestPassProfile,
                body: _panePassProfileBody(coordinator),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.report_document),
                title: Tooltip(
                  message: coordinator.canOpenLatestQualityIssue
                      ? '스냅샷 기준 최신 품질 이슈'
                      : '표시할 품질 이슈가 없습니다',
                  child: const Text('품질 이슈 연계'),
                ),
                enabled: coordinator.canOpenLatestQualityIssue,
                body: _paneQualityIssueBody(coordinator),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _panePassProfileBody(AppCoordinator coordinator) {
    if (!coordinator.canOpenLatestPassProfile ||
        coordinator.panePassCommonKey.isEmpty) {
      return const SizedBox.shrink();
    }
    return PassProfileScreen(
      key: ValueKey(
        'pane-pass|${coordinator.panePassCommonKey}|${coordinator.panePassHistoryId}|${coordinator.panePassPassId}',
      ),
      commonKey: coordinator.panePassCommonKey,
      historyId: coordinator.panePassHistoryId,
      passId: coordinator.panePassPassId,
    );
  }

  Widget _paneQualityIssueBody(AppCoordinator coordinator) {
    if (coordinator.paneQualityCommonKey.isEmpty) {
      return const SizedBox.shrink();
    }
    return QualityIssueScreen(
      key: ValueKey(
        'pane-quality|${coordinator.paneQualityCommonKey}|${coordinator.paneQualityHistoryId}|${coordinator.paneQualityPassId}|${coordinator.paneQualityLinkId}',
      ),
      commonKey: coordinator.paneQualityCommonKey,
      historyId: coordinator.paneQualityHistoryId,
      passId: coordinator.paneQualityPassId,
      linkId: coordinator.paneQualityLinkId,
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
}
