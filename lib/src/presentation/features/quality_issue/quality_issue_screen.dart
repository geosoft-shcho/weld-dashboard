import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/quality_link.dart';
import '../../../domain/entities/quality_result_report.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../core/widgets/waveform_channel_charts.dart';
import '../../core/widgets/waveform_control_toolbar.dart';
import '../../navigation/app_coordinator.dart';
import '../pass_profile/widgets/pass_tabs_bar.dart';
import '../video_multimodal/widgets/camera_recording_dialog.dart';
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
    return QueryFailurePane(
      title: '로드 실패',
      message: message,
      onRetry: () => context.read<QualityIssueViewModel>().didTapReload(),
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
    final jobId = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.jobId,
    );
    final passId = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.selectedPassId,
    );
    return CameraRecordingScope(
      jobId: jobId,
      passId: passId,
      capturesScreenComment: true,
      commentScreen: 'quality',
      builder: (context, recordButton) {
        return ListView(
          children: [
            Align(alignment: Alignment.centerRight, child: recordButton),
            const SizedBox(height: 12),
            const _QualityContextSection(),
            const SizedBox(height: 12),
            const _QualityTabsSection(),
            const SizedBox(height: 12),
            const _QualityWaveformToolbar(),
            const SizedBox(height: 12),
            const _QualityContentProgress(),
            const _QualityContentError(),
            const _QualityMediaAndCharts(),
            const SizedBox(height: 16),
            const _QualityResultsSection(),
          ],
        );
      },
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

class _QualityWaveformToolbar extends StatelessWidget {
  const _QualityWaveformToolbar();

  @override
  Widget build(BuildContext context) {
    final normalize = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.normalize,
    );
    final notice = context.select<QualityIssueViewModel, String>(
      (viewModel) => viewModel.waveformNotice,
    );
    context.select<QualityIssueViewModel, String>(_waveformToolbarKey);
    final selection = context.select<QualityIssueViewModel, _LegendSelection>(
      _LegendSelection.from,
    );
    final viewModel = context.read<QualityIssueViewModel>();
    return WaveformControlToolbar(
      jobs: viewModel.comparisonJobs,
      selectedJobId: viewModel.selectedComparisonJobId,
      normalize: normalize,
      comparisonError: viewModel.comparisonError,
      notice: notice,
      onOpenJobs: viewModel.didOpenComparisonJobs,
      onSelectJob: viewModel.didSelectComparisonJob,
      onSelectNormalize: viewModel.didSelectNormalize,
      showMaster: selection.showMaster,
      showBeginner: selection.showBeginner,
      showRobot: selection.showRobot,
      mastersForPass: const [],
      selectedMasterProfileId: '',
      onToggleMaster: viewModel.didTapToggleMaster,
      onToggleBeginner: viewModel.didTapToggleBeginner,
      onToggleRobot: viewModel.didTapToggleRobot,
      onSelectMasterProfile: (_) {},
      legendIsEmpty: selection.isEmpty,
    );
  }
}

String _waveformToolbarKey(QualityIssueViewModel viewModel) {
  return [
    viewModel.selectedComparisonJobId,
    viewModel.comparisonError,
    viewModel.waveformNotice,
    for (final job in viewModel.comparisonJobs)
      '${job.jobId}|${job.workerKind}',
  ].join('\u001f');
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
      reportPdfs: viewModel.reportPdfs,
      selectedReportSetId: viewModel.selectedReportSetId,
      reportPdfPage: viewModel.reportPdfPage,
      jobMedia: viewModel.jobMedia,
      selectedJobMediaId: viewModel.selectedJobMediaId,
      focusedMediaId: viewModel.focusedMediaId,
      onSelectFocusedMedia: viewModel.didSelectFocusedMedia,
      hasMoreJobMedia: viewModel.hasMoreJobMedia,
      isLoadingMoreJobMedia: viewModel.isLoadingMoreJobMedia,
      onLoadMoreJobMedia: viewModel.didTapLoadMoreJobMedia,
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
    final selectedReportSetId = context.select<QualityIssueViewModel, String?>(
      (viewModel) => viewModel.selectedReportSetId,
    );
    return QualityResultsTables(
      reports: reports,
      selectedReportSetId: selectedReportSetId,
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
    '${data.workerKind}',
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
        '${pdf.reportSetId}|${pdf.url}|${pdf.fileName}|${pdf.setPageStart ?? ''}',
    ].join(','),
    '${viewModel.pendingSeekToMs ?? ''}',
    '${viewModel.chartTimeNs ?? ''}',
    '${viewModel.videoSeekMs ?? ''}',
    viewModel.videoSeekAssetId,
    viewModel.videoSeekNotice,
    '${viewModel.seekToken}',
    '${viewModel.hasMoreJobMedia}',
    '${viewModel.isLoadingMoreJobMedia}',
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
