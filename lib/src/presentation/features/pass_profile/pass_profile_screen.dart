import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/waveform_channel_charts.dart';
import '../../navigation/app_coordinator.dart';
import 'pass_profile_args.dart';
import 'pass_profile_view_model.dart';
import 'widgets/pass_compare_summary.dart';
import 'widgets/pass_context_bar.dart';
import 'widgets/pass_legend_toolbar.dart';
import 'widgets/pass_tabs_bar.dart';

class PassProfileScreen extends StatelessWidget {
  const PassProfileScreen({
    super.key,
    required this.commonKey,
    required this.historyId,
    this.passId = '',
  });

  final String commonKey;
  final String historyId;
  final String passId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<PassProfileViewModel>(
        param1: PassProfileArgs(
          commonKey: commonKey,
          historyId: historyId,
          passId: passId,
        ),
      )..loadBoard(),
      child: const _PassProfileBody(),
    );
  }
}

class _PassProfileBody extends StatelessWidget {
  const _PassProfileBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PassProfileViewModel>();
    final coordinator = context.watch<AppCoordinator>();
    final board = viewModel.board;
    final canOpenQuality = board != null && board.doesHaveCommonKey;
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          header: PageHeader(
            title: const Text('패스별 파라미터 프로파일'),
            commandBar: CommandBar(
              mainAxisAlignment: MainAxisAlignment.end,
              primaryItems: [
                if (coordinator.canPopWorkHistoryStack)
                  CommandBarButton(
                    icon: const Icon(FluentIcons.back),
                    label: Text(
                      _stepBackLabel(coordinator.previousWorkHistoryStack),
                    ),
                    onPressed: () =>
                        coordinator.didTapBackFromPassProfile(context),
                  ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.history),
                  label: const Text('작업 이력'),
                  onPressed: () => coordinator.didTapBackToWorkHistory(context),
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.report_document),
                  label: const Text('이 패스 품질 이슈'),
                  onPressed: !canOpenQuality
                      ? null
                      : () => _didTapOpenQualityIssue(
                          coordinator,
                          commonKey: board.commonKey,
                          historyId: board.historyId,
                          passId: board.selectedPass?.passId,
                        ),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: _content(context, viewModel, coordinator),
          ),
        ),
      ),
    );
  }

  String _stepBackLabel(WorkHistoryStack? previous) {
    switch (previous) {
      case WorkHistoryStack.detail:
        return '작업 상세';
      case WorkHistoryStack.qualityIssue:
        return '품질 이슈';
      case WorkHistoryStack.passProfile:
        return '뒤로';
      case WorkHistoryStack.list:
      case null:
        return '뒤로';
    }
  }

  void _didTapOpenQualityIssue(
    AppCoordinator coordinator, {
    required String commonKey,
    required String historyId,
    String? passId,
    String? linkId,
  }) {
    if (coordinator.isPassProfilePaneSelected) {
      coordinator.didTapOpenQualityIssueFromPane(
        commonKey: commonKey,
        historyId: historyId,
        passId: passId,
        linkId: linkId,
      );
      return;
    }
    coordinator.didTapOpenQualityIssue(
      commonKey: commonKey,
      historyId: historyId,
      passId: passId,
      linkId: linkId,
    );
  }

  Widget _content(
    BuildContext context,
    PassProfileViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return InfoBar(
        title: const Text('로드 실패'),
        content: Text(viewModel.errorMessage),
        severity: InfoBarSeverity.error,
        action: Button(
          onPressed: viewModel.didTapReload,
          child: const Text('재시도'),
        ),
      );
    }
    final board = viewModel.board;
    if (board == null || !board.doesHaveCommonKey) {
      return InfoBar(
        title: const Text('패스별 파라미터 프로파일'),
        content: const Text('작업 이력을 선택하세요. 키 없이 차트를 그리지 않습니다.'),
        severity: InfoBarSeverity.warning,
        action: Button(
          onPressed: () => coordinator.didTapBackToWorkHistory(context),
          child: const Text('작업 이력'),
        ),
      );
    }
    final isLegendEmpty =
        !board.doesHavePasses || !board.doesHaveSeries;
    return ListView(
      children: [
        const Text(
          '전류·전압·속도 파형 시계열, 명장 · 초보자 · 로봇 중첩 비교',
          style: TextStyle(color: AppTheme.STATUS_OFF),
        ),
        const SizedBox(height: 12),
        PassContextBar(contextData: board.context),
        const SizedBox(height: 12),
        PassTabsBar(
          passes: board.passes,
          selectedPassId: board.selectedPass?.passId ?? '',
          onSelectPass: viewModel.didSelectPass,
        ),
        const SizedBox(height: 12),
        PassLegendToolbar(
          showMaster: viewModel.showMaster,
          showBeginner: viewModel.showBeginner,
          showRobot: viewModel.showRobot,
          mastersForPass: board.mastersForPass,
          selectedMasterProfileId: board.selectedMasterProfileId,
          onToggleMaster: viewModel.didTapToggleMaster,
          onToggleBeginner: viewModel.didTapToggleBeginner,
          onToggleRobot: viewModel.didTapToggleRobot,
          onSelectMasterProfile: viewModel.didSelectMasterProfile,
          isEmpty: isLegendEmpty,
        ),
        const SizedBox(height: 8),
        for (final banner in board.banners) ...[
          InfoBar(title: Text(banner), severity: InfoBarSeverity.info),
          const SizedBox(height: 8),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final charts = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WaveformChannelCharts(
                  series: board.series,
                  links: board.links,
                  showMaster: viewModel.showMaster,
                  showBeginner: viewModel.showBeginner,
                  showRobot: viewModel.showRobot,
                  onBandTap: (linkId) => _didTapOpenQualityIssue(
                    coordinator,
                    commonKey: board.commonKey,
                    historyId: board.historyId,
                    passId: board.selectedPass?.passId,
                    linkId: linkId,
                  ),
                ),
              ],
            );
            final summary = PassCompareSummary(stats: board.compareStats);
            if (constraints.maxWidth >= 960) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 8, child: charts),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: summary),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [charts, const SizedBox(height: 12), summary],
            );
          },
        ),
      ],
    );
  }
}
