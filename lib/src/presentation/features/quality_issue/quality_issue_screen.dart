import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/comparison_job_candidate.dart';
import '../../../domain/entities/quality_link.dart';
import '../../../domain/entities/quality_result_report.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/waveform_channel_charts.dart';
import '../../navigation/app_coordinator.dart';
import '../pass_profile/widgets/pass_context_bar.dart';
import '../pass_profile/widgets/pass_legend_toolbar.dart';
import '../pass_profile/widgets/pass_tabs_bar.dart';
import 'quality_issue_args.dart';
import 'quality_issue_view_model.dart';
import 'widgets/quality_results_tables.dart';
import 'widgets/quality_media_host.dart';

class QualityIssueScreen extends StatelessWidget {
  const QualityIssueScreen({
    super.key,
    required this.commonKey,
    required this.jobId,
    this.passId = '',
    this.linkId = '',
  });

  final String commonKey;
  final String jobId;
  final String passId;
  final String linkId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<QualityIssueViewModel>(
        param1: QualityIssueArgs(
          commonKey: commonKey,
          jobId: jobId,
          passId: passId,
          linkId: linkId,
        ),
      )..loadBoard(),
      child: const _QualityIssueBody(),
    );
  }
}

enum _QualityPageMode { loading, error, empty, ready }

_QualityPageMode _pageMode(QualityIssueViewModel viewModel) {
  if (viewModel.isLoading) {
    return _QualityPageMode.loading;
  }
  if (viewModel.hasError && !viewModel.didLoadQualityResults) {
    return _QualityPageMode.error;
  }
  final board = viewModel.board;
  final doesHaveWaveform = board != null && board.doesHaveCommonKey;
  if (!doesHaveWaveform && !viewModel.didLoadQualityResults) {
    return _QualityPageMode.empty;
  }
  return _QualityPageMode.ready;
}

class _QualityIssueBody extends StatelessWidget {
  const _QualityIssueBody();

  @override
  Widget build(BuildContext context) {
    final mode = context.select<QualityIssueViewModel, _QualityPageMode>(
      _pageMode,
    );
    // ScreenCommandBar(
    //   title: coordinator.pageTitle,
    //   primaryItems: [
    //     if (coordinator.canPopWorkHistoryStack)
    //       CommandBarButton(
    //         icon: const Icon(FluentIcons.back),
    //         label: CommandBarLabel(
    //           _stepBackLabel(coordinator.previousWorkHistoryStack),
    //         ),
    //         onPressed: () =>
    //             coordinator.didTapBackFromQualityIssue(context),
    //       ),
    //     CommandBarButton(
    //       icon: const Icon(FluentIcons.history),
    //       label: const CommandBarLabel('작업 이력'),
    //       onPressed: () =>
    //           coordinator.didTapBackToWorkHistory(context),
    //     ),
    //     CommandBarButton(
    //       icon: const Icon(FluentIcons.line_chart),
    //       label: const CommandBarLabel('패스 프로파일'),
    //       onPressed: !canOpenPassProfile
    //           ? null
    //           : () {
    //               final passId =
    //                   board.selectedPass?.passId ??
    //                   board.selectedGroup?.passId;
    //               if (coordinator.isQualityIssuePaneSelected) {
    //                 coordinator.didTapOpenPassProfileFromPane(
    //                   commonKey: board.commonKey,
    //                   jobId: board.jobId,
    //                   passId: passId,
    //                 );
    //                 return;
    //               }
    //               coordinator.didTapOpenPassProfile(
    //                 commonKey: board.commonKey,
    //                 jobId: board.jobId,
    //                 passId: passId,
    //               );
    //             },
    //     ),
    //   ],
    // ),
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: switch (mode) {
              _QualityPageMode.loading => const Center(child: ProgressRing()),
              _QualityPageMode.error => const _QualityIssueError(),
              _QualityPageMode.empty => const _QualityIssueEmpty(),
              _QualityPageMode.ready => const _QualityIssueReady(),
            },
          ),
        ),
      ),
    );
  }
}

class _QualityIssueError extends StatelessWidget {
  const _QualityIssueError();

  @override
  Widget build(BuildContext context) {
    final message = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.errorMessage,
    );
    return InfoBar(
      title: const Text('로드 실패'),
      content: Text(message),
      severity: InfoBarSeverity.error,
      action: Button(
        onPressed: () => context.read<QualityIssueViewModel>().didTapReload(),
        child: const Text('재시도'),
      ),
    );
  }
}

class _QualityIssueEmpty extends StatelessWidget {
  const _QualityIssueEmpty();

  @override
  Widget build(BuildContext context) {
    return InfoBar(
      title: const Text('품질 이슈 연계'),
      content: const Text('연결된 품질 결과·파형이 없습니다. 공통키를 고르세요.'),
      severity: InfoBarSeverity.warning,
      action: Button(
        onPressed: () =>
            context.read<AppCoordinator>().didTapBackToWorkHistory(context),
        child: const Text('작업 이력'),
      ),
    );
  }
}

class _QualityIssueReady extends StatelessWidget {
  const _QualityIssueReady();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        // Text(
        //   '페이퍼 기반 품질 결과와 해당 구간 용접 파형 연결 조회',
        //   style: TextStyle(color: AppTheme.STATUS_OFF),
        // ),
        // SizedBox(height: 12),
        _QualityContextSection(),
        SizedBox(height: 12),
        _QualityTabsSection(),
        SizedBox(height: 12),
        _QualityComparisonJob(),
        SizedBox(height: 12),
        _QualityLegendSection(),
        SizedBox(height: 12),
        _QualityContentProgress(),
        _QualityContentError(),
        _QualityMediaAndCharts(),
        SizedBox(height: 16),
        _QualityResultsSection(),
      ],
    );
  }
}

class _QualityContextSection extends StatelessWidget {
  const _QualityContextSection();

  @override
  Widget build(BuildContext context) {
    final key = context.select<QualityIssueViewModel, String>(
      (viewModel) => _contextKey(viewModel),
    );
    final data = context.read<QualityIssueViewModel>().board?.context;
    return PassContextBar(key: ValueKey(key), contextData: data);
  }
}

class _QualityTabsSection extends StatelessWidget {
  const _QualityTabsSection();

  @override
  Widget build(BuildContext context) {
    final key = context.select<QualityIssueViewModel, String>(
      (viewModel) => _passKey(viewModel),
    );
    final viewModel = context.read<QualityIssueViewModel>();
    return PassTabsBar(
      key: ValueKey(key),
      passes: viewModel.board?.passes ?? const [],
      selectedPassId: viewModel.selectedPassId,
      onSelectPass: (passId) =>
          context.read<QualityIssueViewModel>().didSelectPass(passId),
    );
  }
}

class _QualityComparisonJob extends StatelessWidget {
  const _QualityComparisonJob();

  @override
  Widget build(BuildContext context) {
    final normalize = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.normalize,
    );
    final notice = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.waveformNotice,
    );
    context.select<QualityIssueViewModel, String>(_comparisonKey);
    final viewModel = context.read<QualityIssueViewModel>();
    final selectedJobId = viewModel.selectedComparisonJobId;
    final jobs = viewModel.comparisonJobs;
    final knownIds = {for (final job in jobs) job.jobId};
    final comparisonValue = knownIds.contains(selectedJobId)
        ? selectedJobId
        : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('비교 작업'),
            const SizedBox(width: 8),
            Expanded(
              child: ComboBox<String>(
                value: comparisonValue,
                isExpanded: true,
                items: [
                  const ComboBoxItem(value: '', child: Text('비교 없음')),
                  for (final job in jobs)
                    ComboBoxItem(
                      value: job.jobId,
                      child: Text(
                        _comparisonJobLabel(job),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onTap: viewModel.didOpenComparisonJobs,
                onChanged: (value) {
                  if (value != null) {
                    viewModel.didSelectComparisonJob(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            const Text('파형 기준'),
            const SizedBox(width: 8),
            SizedBox(
              width: 160,
              child: ComboBox<String>(
                value: normalize,
                items: const [
                  ComboBoxItem(value: 'raw', child: Text('원본')),
                  ComboBoxItem(value: 'dtw', child: Text('DTW 정규화')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<QualityIssueViewModel>().didSelectNormalize(
                      value,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        if (notice.isNotEmpty) ...[
          const SizedBox(height: 8),
          InfoBar(title: Text(notice), severity: InfoBarSeverity.info),
        ],
        if (viewModel.comparisonError.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            viewModel.comparisonError,
            style: const TextStyle(color: AppTheme.STATUS_ERROR),
          ),
        ],
      ],
    );
  }
}

String _comparisonKey(QualityIssueViewModel viewModel) {
  return [
    viewModel.selectedComparisonJobId,
    viewModel.comparisonError,
    for (final job in viewModel.comparisonJobs) '${job.jobId}|${job.isMaster}',
  ].join('\u001f');
}

String _comparisonJobLabel(ComparisonJobCandidate job) {
  final worker = job.workerName.isEmpty ? '작업자 없음' : job.workerName;
  final role = DashboardFormatters.masterRole(job.isMaster);
  final title = job.jobKey.isEmpty ? '작업' : job.jobKey;
  return '$title · $worker · $role · ${DashboardFormatters.dateTime(job.startedAt)} · ${job.passCount}패스';
}

class _QualityLegendSection extends StatelessWidget {
  const _QualityLegendSection();

  @override
  Widget build(BuildContext context) {
    final selection = context.select<QualityIssueViewModel, _LegendSelection>(
      _LegendSelection.from,
    );
    final viewModel = context.read<QualityIssueViewModel>();
    return PassLegendToolbar(
      showMaster: selection.showMaster,
      showBeginner: selection.showBeginner,
      showRobot: selection.showRobot,
      mastersForPass: const [],
      selectedMasterProfileId: '',
      onToggleMaster: viewModel.didTapToggleMaster,
      onToggleBeginner: viewModel.didTapToggleBeginner,
      onToggleRobot: viewModel.didTapToggleRobot,
      onSelectMasterProfile: (_) {},
      isEmpty: selection.isEmpty,
    );
  }
}

class _QualityContentProgress extends StatelessWidget {
  const _QualityContentProgress();

  @override
  Widget build(BuildContext context) {
    final isContentLoading = context.select<QualityIssueViewModel, bool>(
      (viewModel) => viewModel.isContentLoading,
    );
    if (!isContentLoading) {
      return const SizedBox.shrink();
    }
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: ProgressBar(),
    );
  }
}

class _QualityContentError extends StatelessWidget {
  const _QualityContentError();

  @override
  Widget build(BuildContext context) {
    final message = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.contentError,
    );
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InfoBar(
        title: const Text('패스 조회 실패'),
        content: Text(message),
        severity: InfoBarSeverity.error,
      ),
    );
  }
}

class _QualityMediaAndCharts extends StatefulWidget {
  const _QualityMediaAndCharts();

  @override
  State<_QualityMediaAndCharts> createState() => _QualityMediaAndChartsState();
}

class _QualityMediaAndChartsState extends State<_QualityMediaAndCharts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const media = _QualityMediaSection();
        const charts = _QualityChartSection();
        if (constraints.maxWidth >= 960) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: media),
              SizedBox(width: 16),
              Expanded(flex: 5, child: charts),
            ],
          );
        }
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [media, SizedBox(height: 16), charts],
        );
      },
    );
  }
}

class _QualityMediaSection extends StatelessWidget {
  const _QualityMediaSection();

  @override
  Widget build(BuildContext context) {
    context.select<QualityIssueViewModel, String>(_mediaKey);
    final viewModel = context.read<QualityIssueViewModel>();
    return QualityMediaHost(
      group: viewModel.board?.selectedGroup,
      selectedTab: viewModel.selectedMediaTab,
      selectedMediaIndex: viewModel.selectedMediaIndex,
      onSelectTab: viewModel.didSelectMediaTab,
      onSelectMediaIndex: viewModel.didSelectMediaIndex,
      reportPdfs: viewModel.reportPdfs,
      selectedReportSetId: viewModel.selectedReportSetId,
      reportPdfPage: viewModel.reportPdfPage,
      jobMedia: viewModel.jobMedia,
      selectedJobMediaId: viewModel.selectedJobMediaId,
      focusedMediaId: viewModel.focusedMediaId,
      onSelectFocusedMedia: viewModel.didSelectFocusedMedia,
      seekToMs: viewModel.pendingSeekToMs,
      seekToken: viewModel.seekToken,
      videoSeekMs: viewModel.videoSeekMs,
      videoSeekAssetId: viewModel.videoSeekAssetId,
      videoSeekNotice: viewModel.videoSeekNotice,
    );
  }
}

class _QualityChartSection extends StatelessWidget {
  const _QualityChartSection();

  @override
  Widget build(BuildContext context) {
    final snapshot = context.select<QualityIssueViewModel, _ChartSnapshot>(
      _ChartSnapshot.from,
    );
    final viewModel = context.read<QualityIssueViewModel>();
    return WaveformChannelCharts(
      series: snapshot.series,
      links: snapshot.links,
      showMaster: snapshot.showMaster,
      showBeginner: snapshot.showBeginner,
      showRobot: snapshot.showRobot,
      selectedLinkId: snapshot.selectedLinkId,
      selectedTimeMs: snapshot.selectedTimeMs,
      onBandTap: viewModel.didTapBand,
      onTimeTapMs: viewModel.didTapWaveformTime,
      doesStartAtZero: true,
    );
  }
}

class _QualityResultsSection extends StatelessWidget {
  const _QualityResultsSection();

  @override
  Widget build(BuildContext context) {
    final reports = context
        .select<QualityIssueViewModel, List<QualityResultReport>>(
          (viewModel) => viewModel.qualityReports,
        );
    return QualityResultsTables(
      reports: reports,
      onSelectInspection: (reportSetId, pageStart) {
        context.read<QualityIssueViewModel>().didSelectInspection(
          reportSetId: reportSetId,
          originalPage: pageStart,
        );
      },
    );
  }
}

String _contextKey(QualityIssueViewModel viewModel) {
  final data = viewModel.board?.context;
  if (data == null) {
    return '';
  }
  return [
    data.commonKey,
    data.projectNo,
    data.unitNo,
    data.itemCode,
    data.itemName,
    data.workerName,
    '${data.isMaster}',
    data.equipmentName,
  ].join('\u001f');
}

String _passKey(QualityIssueViewModel viewModel) {
  final board = viewModel.board;
  if (board == null) {
    return '';
  }
  return '${viewModel.selectedPassId}\u001f'
      '${[for (final pass in board.passes) pass.passId].join(',')}';
}

String _mediaKey(QualityIssueViewModel viewModel) {
  final group = viewModel.board?.selectedGroup;
  final media = [
    for (final item in group?.media ?? const [])
      '${item.type.label}|${item.url}|${item.pageCount}',
  ].join(',');
  return [
    group?.qualityResultId ?? '',
    viewModel.selectedMediaTab.label,
    '${viewModel.selectedMediaIndex}',
    viewModel.selectedReportSetId ?? '',
    '${viewModel.reportPdfPage}',
    viewModel.selectedJobMediaId,
    viewModel.focusedMediaId,
    [
      for (final item in viewModel.jobMedia)
        '${item.assetId}|${item.url}|${item.passId}|${item.isVideo}',
    ].join(','),
    [
      for (final pdf in viewModel.reportPdfs)
        '${pdf.reportSetId}|${pdf.url}|${pdf.setPageStart ?? ''}',
    ].join(','),
    '${viewModel.pendingSeekToMs ?? ''}',
    '${viewModel.chartTimeNs ?? ''}',
    '${viewModel.videoSeekMs ?? ''}',
    viewModel.videoSeekAssetId,
    viewModel.videoSeekNotice,
    '${viewModel.seekToken}',
    media,
  ].join('\u001f');
}

class _LegendSelection {
  const _LegendSelection({
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.isEmpty,
  });

  factory _LegendSelection.from(QualityIssueViewModel viewModel) {
    final board = viewModel.board;
    return _LegendSelection(
      showMaster: viewModel.showMaster,
      showBeginner: viewModel.showBeginner,
      showRobot: viewModel.showRobot,
      isEmpty:
          board == null ||
          !board.doesHavePasses ||
          !board.series.doesHaveAnySeries,
    );
  }

  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final bool isEmpty;

  @override
  bool operator ==(Object other) {
    return other is _LegendSelection &&
        other.showMaster == showMaster &&
        other.showBeginner == showBeginner &&
        other.showRobot == showRobot &&
        other.isEmpty == isEmpty;
  }

  @override
  int get hashCode => Object.hash(showMaster, showBeginner, showRobot, isEmpty);
}

class _ChartSnapshot {
  const _ChartSnapshot({
    required this.series,
    required this.links,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.selectedLinkId,
    required this.selectedTimeMs,
  });

  factory _ChartSnapshot.from(QualityIssueViewModel viewModel) {
    final board = viewModel.board;
    return _ChartSnapshot(
      series:
          board?.series ??
          const WaveformSeriesBundle(
            masterProfileId: '',
            master: [],
            beginner: [],
            robot: [],
          ),
      links: board?.links ?? const [],
      showMaster: viewModel.showMaster,
      showBeginner: viewModel.showBeginner,
      showRobot: viewModel.showRobot,
      selectedLinkId: viewModel.selectedLinkId,
      selectedTimeMs: viewModel.chartTimeNs,
    );
  }

  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final String selectedLinkId;
  final int? selectedTimeMs;

  @override
  bool operator ==(Object other) {
    return other is _ChartSnapshot &&
        identical(other.series, series) &&
        identical(other.links, links) &&
        other.showMaster == showMaster &&
        other.showBeginner == showBeginner &&
        other.showRobot == showRobot &&
        other.selectedLinkId == selectedLinkId &&
        other.selectedTimeMs == selectedTimeMs;
  }

  @override
  int get hashCode => Object.hash(
    identityHashCode(series),
    identityHashCode(links),
    showMaster,
    showBeginner,
    showRobot,
    selectedLinkId,
    selectedTimeMs,
  );
}
