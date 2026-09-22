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
    // lastDataUpdatedAt는 타이틀 전용 위젯만 구독한다. Shell 전체가
    // 주기적으로 rebuild되면 작업이력 TextBox 입력이 Web에서 끊긴다.
    final nav = context.select<AppCoordinator, _ShellNavSnapshot>(
      _ShellNavSnapshot.from,
    );
    final coordinator = context.read<AppCoordinator>();

    return Stack(
      children: [
        NavigationView(
          titleBar: TitleBar(
            isBackButtonVisible: false,
            height: 48,
            leftHeader: ShellTitleLeading(onTogglePane: _didTapTogglePane),
            endHeader: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: _LastDataUpdatedLabel(),
            ),
          ),
          pane: NavigationPane(
            selected: nav.selectedPaneIndex,
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
                body: _workHistoryBody(nav),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.line_chart),
                title: Tooltip(
                  message: nav.canOpenLatestPassProfile
                      ? '스냅샷 기준 최신 패스 프로파일'
                      : '표시할 패스 프로파일이 없습니다',
                  child: const Text('패스별 파라미터 프로파일'),
                ),
                enabled: nav.canOpenLatestPassProfile,
                body: _panePassProfileBody(nav),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.report_document),
                title: Tooltip(
                  message: nav.canOpenLatestQualityIssue
                      ? '스냅샷 기준 최신 품질 이슈'
                      : '표시할 품질 이슈가 없습니다',
                  child: const Text('품질 이슈 연계'),
                ),
                enabled: nav.canOpenLatestQualityIssue,
                body: _paneQualityIssueBody(nav),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _panePassProfileBody(_ShellNavSnapshot nav) {
    if (!nav.canOpenLatestPassProfile || nav.panePassCommonKey.isEmpty) {
      return const SizedBox.shrink();
    }
    return PassProfileScreen(
      key: ValueKey(
        'pane-pass|${nav.panePassCommonKey}|${nav.panePassHistoryId}|${nav.panePassPassId}',
      ),
      commonKey: nav.panePassCommonKey,
      historyId: nav.panePassHistoryId,
      passId: nav.panePassPassId,
    );
  }

  Widget _paneQualityIssueBody(_ShellNavSnapshot nav) {
    if (nav.paneQualityCommonKey.isEmpty) {
      return const SizedBox.shrink();
    }
    return QualityIssueScreen(
      key: ValueKey(
        'pane-quality|${nav.paneQualityCommonKey}|${nav.paneQualityHistoryId}|${nav.paneQualityPassId}|${nav.paneQualityLinkId}',
      ),
      commonKey: nav.paneQualityCommonKey,
      historyId: nav.paneQualityHistoryId,
      passId: nav.paneQualityPassId,
      linkId: nav.paneQualityLinkId,
    );
  }

  Widget _workHistoryBody(_ShellNavSnapshot nav) {
    switch (nav.workHistoryStack) {
      case WorkHistoryStack.list:
        return const WorkHistoryScreen();
      case WorkHistoryStack.detail:
        return WorkDetailScreen(
          key: ValueKey('detail|${nav.historyId}'),
          historyId: nav.historyId,
        );
      case WorkHistoryStack.passProfile:
        return PassProfileScreen(
          key: ValueKey(
            'pass|${nav.historyCommonKey}|${nav.historyId}|${nav.passId}',
          ),
          commonKey: nav.historyCommonKey,
          historyId: nav.historyId,
          passId: nav.passId,
        );
      case WorkHistoryStack.qualityIssue:
        return QualityIssueScreen(
          key: ValueKey(
            'quality|${nav.historyCommonKey}|${nav.historyId}|${nav.passId}|${nav.linkId}',
          ),
          commonKey: nav.historyCommonKey,
          historyId: nav.historyId,
          passId: nav.passId,
          linkId: nav.linkId,
        );
    }
  }
}

class _ShellNavSnapshot {
  const _ShellNavSnapshot({
    required this.selectedPaneIndex,
    required this.workHistoryStack,
    required this.historyCommonKey,
    required this.historyId,
    required this.passId,
    required this.linkId,
    required this.canOpenLatestPassProfile,
    required this.canOpenLatestQualityIssue,
    required this.panePassCommonKey,
    required this.panePassHistoryId,
    required this.panePassPassId,
    required this.paneQualityCommonKey,
    required this.paneQualityHistoryId,
    required this.paneQualityPassId,
    required this.paneQualityLinkId,
  });

  factory _ShellNavSnapshot.from(AppCoordinator coordinator) {
    return _ShellNavSnapshot(
      selectedPaneIndex: coordinator.selectedPaneIndex,
      workHistoryStack: coordinator.workHistoryStack,
      historyCommonKey: coordinator.historyCommonKey,
      historyId: coordinator.historyId,
      passId: coordinator.passId,
      linkId: coordinator.linkId,
      canOpenLatestPassProfile: coordinator.canOpenLatestPassProfile,
      canOpenLatestQualityIssue: coordinator.canOpenLatestQualityIssue,
      panePassCommonKey: coordinator.panePassCommonKey,
      panePassHistoryId: coordinator.panePassHistoryId,
      panePassPassId: coordinator.panePassPassId,
      paneQualityCommonKey: coordinator.paneQualityCommonKey,
      paneQualityHistoryId: coordinator.paneQualityHistoryId,
      paneQualityPassId: coordinator.paneQualityPassId,
      paneQualityLinkId: coordinator.paneQualityLinkId,
    );
  }

  final int selectedPaneIndex;
  final WorkHistoryStack workHistoryStack;
  final String historyCommonKey;
  final String historyId;
  final String passId;
  final String linkId;
  final bool canOpenLatestPassProfile;
  final bool canOpenLatestQualityIssue;
  final String panePassCommonKey;
  final String panePassHistoryId;
  final String panePassPassId;
  final String paneQualityCommonKey;
  final String paneQualityHistoryId;
  final String paneQualityPassId;
  final String paneQualityLinkId;

  @override
  bool operator ==(Object other) {
    return other is _ShellNavSnapshot &&
        selectedPaneIndex == other.selectedPaneIndex &&
        workHistoryStack == other.workHistoryStack &&
        historyCommonKey == other.historyCommonKey &&
        historyId == other.historyId &&
        passId == other.passId &&
        linkId == other.linkId &&
        canOpenLatestPassProfile == other.canOpenLatestPassProfile &&
        canOpenLatestQualityIssue == other.canOpenLatestQualityIssue &&
        panePassCommonKey == other.panePassCommonKey &&
        panePassHistoryId == other.panePassHistoryId &&
        panePassPassId == other.panePassPassId &&
        paneQualityCommonKey == other.paneQualityCommonKey &&
        paneQualityHistoryId == other.paneQualityHistoryId &&
        paneQualityPassId == other.paneQualityPassId &&
        paneQualityLinkId == other.paneQualityLinkId;
  }

  @override
  int get hashCode => Object.hash(
    selectedPaneIndex,
    workHistoryStack,
    historyCommonKey,
    historyId,
    passId,
    linkId,
    canOpenLatestPassProfile,
    canOpenLatestQualityIssue,
    panePassCommonKey,
    panePassHistoryId,
    panePassPassId,
    paneQualityCommonKey,
    paneQualityHistoryId,
    paneQualityPassId,
    paneQualityLinkId,
  );
}

class _LastDataUpdatedLabel extends StatelessWidget {
  const _LastDataUpdatedLabel();

  @override
  Widget build(BuildContext context) {
    final updatedAt = context.select<AppCoordinator, DateTime>(
      (coordinator) => coordinator.lastDataUpdatedAt,
    );
    return Text(
      '최신 업데이트 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt)}',
      style: const TextStyle(fontSize: 12),
    );
  }
}
