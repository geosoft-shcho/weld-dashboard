import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/waveform_channel_charts.dart';
import '../../navigation/app_coordinator.dart';
import '../pass_profile/widgets/pass_context_bar.dart';
import '../pass_profile/widgets/pass_legend_toolbar.dart';
import '../pass_profile/widgets/pass_tabs_bar.dart';
import 'quality_issue_args.dart';
import 'quality_issue_view_model.dart';
import 'widgets/paper_scan_host.dart';
import 'widgets/quality_links_table.dart';
import 'widgets/quality_paper_meta.dart';

class QualityIssueScreen extends StatelessWidget {
  const QualityIssueScreen({
    super.key,
    required this.commonKey,
    required this.historyId,
    this.passId = '',
    this.linkId = '',
  });

  final String commonKey;
  final String historyId;
  final String passId;
  final String linkId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<QualityIssueViewModel>(
        param1: QualityIssueArgs(
          commonKey: commonKey,
          historyId: historyId,
          passId: passId,
          linkId: linkId,
        ),
      )..loadBoard(),
      child: const _QualityIssueBody(),
    );
  }
}

class _QualityIssueBody extends StatelessWidget {
  const _QualityIssueBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QualityIssueViewModel>();
    final coordinator = context.watch<AppCoordinator>();
    final board = viewModel.board;
    final canOpenPassProfile = board != null && board.doesHaveCommonKey;
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          header: PageHeader(
            title: const Text('품질 이슈 연계'),
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
                        coordinator.didTapBackFromQualityIssue(context),
                  ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.history),
                  label: const Text('작업 이력'),
                  onPressed: () =>
                      coordinator.didTapBackToWorkHistory(context),
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.line_chart),
                  label: const Text('패스 프로파일'),
                  onPressed: !canOpenPassProfile
                      ? null
                      : () => coordinator.didTapOpenPassProfile(
                          commonKey: board.commonKey,
                          historyId: board.historyId,
                          passId: board.selectedPass?.passId ??
                              board.selectedGroup?.passId,
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
      case WorkHistoryStack.passProfile:
        return '패스 프로파일';
      case WorkHistoryStack.qualityIssue:
        return '뒤로';
      case WorkHistoryStack.list:
      case null:
        return '뒤로';
    }
  }

  Widget _content(
    BuildContext context,
    QualityIssueViewModel viewModel,
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
        title: const Text('품질 이슈 연계'),
        content: const Text('연결된 품질 결과·파형이 없습니다. 공통키를 고르세요.'),
        severity: InfoBarSeverity.warning,
        action: Button(
          onPressed: () => coordinator.didTapBackToWorkHistory(context),
          child: const Text('작업 이력'),
        ),
      );
    }
    final group = board.selectedGroup;
    return ListView(
      children: [
        const Text(
          '페이퍼 기반 품질 결과와 해당 구간 용접 파형 연결 조회',
          style: TextStyle(color: AppTheme.STATUS_OFF),
        ),
        const SizedBox(height: 12),
        PassContextBar(contextData: board.context),
        const SizedBox(height: 12),
        PassTabsBar(
          passes: board.passes,
          selectedPassId: board.selectedPass?.passId ??
              board.selectedGroup?.passId ??
              '',
          onSelectPass: viewModel.didSelectPass,
        ),
        const SizedBox(height: 12),
        PassLegendToolbar(
          showMaster: viewModel.showMaster,
          showBeginner: viewModel.showBeginner,
          showRobot: viewModel.showRobot,
          mastersForPass: const [],
          selectedMasterProfileId: '',
          onToggleMaster: viewModel.didTapToggleMaster,
          onToggleBeginner: viewModel.didTapToggleBeginner,
          onToggleRobot: viewModel.didTapToggleRobot,
          onSelectMasterProfile: (_) {},
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 960;
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaperScanHost(
                  key: ValueKey(group?.qualityResultId ?? 'empty'),
                  scanFile: group?.scanFile ?? '',
                  scanPages: group?.scanPages ?? 0,
                ),
                const SizedBox(height: 12),
                QualityPaperMeta(group: group),
              ],
            );
            final right = WaveformChannelCharts(
              series: board.series,
              links: board.links,
              showMaster: viewModel.showMaster,
              showBeginner: viewModel.showBeginner,
              showRobot: viewModel.showRobot,
              selectedLinkId: viewModel.selectedLinkId,
              onBandTap: viewModel.didTapBand,
            );
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: left),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: right),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                left,
                const SizedBox(height: 16),
                right,
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        QualityLinksTable(
          links: board.allLinks,
          selectedLinkId: viewModel.selectedLinkId,
          onSelectLink: viewModel.didSelectLink,
        ),
      ],
    );
  }
}
