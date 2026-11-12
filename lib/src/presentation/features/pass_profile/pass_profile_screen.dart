import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/pass_joint_context.dart';
import '../../../domain/entities/quality_link.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../core/widgets/waveform_channel_charts.dart';
import '../../core/widgets/waveform_control_toolbar.dart';
import '../../navigation/app_coordinator.dart';
import '../video_multimodal/widgets/camera_recording_dialog.dart';
import 'pass_profile_args.dart';
import 'pass_profile_view_model.dart';
import 'widgets/pass_compare_summary.dart';
import 'widgets/pass_tabs_bar.dart';

class PassProfileScreen extends StatelessWidget {
  const PassProfileScreen({
    super.key,
    required this.commonKey,
    required this.jobId,
    this.passId = '',
  });

  final String commonKey;
  final String jobId;
  final String passId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<PassProfileViewModel>(
        param1: PassProfileArgs(
          commonKey: commonKey,
          jobId: jobId,
          passId: passId,
        ),
      )..loadBoard(),
      child: const _PassProfileBody(),
    );
  }
}

enum _PassPageMode { loading, error, empty, ready }

_PassPageMode _pageMode(PassProfileViewModel viewModel) {
  if (viewModel.isLoading) {
    return _PassPageMode.loading;
  }
  if (viewModel.hasError && viewModel.board == null) {
    return _PassPageMode.error;
  }
  final board = viewModel.board;
  if (board == null || !board.doesHaveCommonKey) {
    return _PassPageMode.empty;
  }
  return _PassPageMode.ready;
}

class _PassProfileBody extends StatelessWidget {
  const _PassProfileBody();

  @override
  Widget build(BuildContext context) {
    final mode = context.select<PassProfileViewModel, _PassPageMode>(_pageMode);
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: switch (mode) {
              _PassPageMode.loading => const Center(child: ProgressRing()),
              _PassPageMode.error => const _PassProfileError(),
              _PassPageMode.empty => const _PassProfileEmpty(),
              _PassPageMode.ready => const _PassProfileReady(),
            },
          ),
        ),
      ),
    );
  }
}

class _PassProfileError extends StatelessWidget {
  const _PassProfileError();

  @override
  Widget build(BuildContext context) {
    final message = context.select<PassProfileViewModel, String>(
      (viewModel) => viewModel.errorMessage,
    );
    return QueryFailurePane(
      title: '로드 실패',
      message: message,
      onRetry: () => context.read<PassProfileViewModel>().didTapReload(),
    );
  }
}

class _PassProfileEmpty extends StatelessWidget {
  const _PassProfileEmpty();

  @override
  Widget build(BuildContext context) {
    return InfoBar(
      title: const Text('패스별 파라미터 프로파일'),
      content: const Text('작업 이력을 선택하세요. 키 없이 차트를 그리지 않습니다.'),
      severity: InfoBarSeverity.warning,
      action: Button(
        onPressed: () =>
            context.read<AppCoordinator>().didTapBackToWorkHistory(context),
        child: const Text('작업 이력'),
      ),
    );
  }
}

class _PassProfileReady extends StatelessWidget {
  const _PassProfileReady();

  @override
  Widget build(BuildContext context) {
    final jobId = context.select<PassProfileViewModel, String>(
      (viewModel) => viewModel.jobId,
    );
    final passId = context.select<PassProfileViewModel, String>(
      (viewModel) => viewModel.selectedPassId,
    );
    return CameraRecordingScope(
      jobId: jobId,
      passId: passId,
      capturesScreenComment: true,
      commentScreen: 'pass',
      builder: (context, recordButton) {
        return ListView(
          children: [
            Align(alignment: Alignment.centerRight, child: recordButton),
            const SizedBox(height: 12),
            const _PassContextSection(),
            const SizedBox(height: 12),
            const _PassTabsSection(),
            const SizedBox(height: 12),
            const _PassWaveformToolbar(),
            const SizedBox(height: 12),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 8, child: _PassChartPane()),
                SizedBox(width: 16),
                Expanded(flex: 2, child: PassCompareSummary()),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _PassContextSection extends StatelessWidget {
  const _PassContextSection();

  @override
  Widget build(BuildContext context) {
    final key = context.select<PassProfileViewModel, String>(
      (viewModel) => _contextKey(viewModel.board?.context),
    );
    final data = context.read<PassProfileViewModel>().board?.context;
    return PassContextBar(key: ValueKey(key), contextData: data);
  }
}

class _PassTabsSection extends StatelessWidget {
  const _PassTabsSection();

  @override
  Widget build(BuildContext context) {
    final key = context.select<PassProfileViewModel, String>(
      (viewModel) => _passKey(viewModel),
    );
    final viewModel = context.read<PassProfileViewModel>();
    final board = viewModel.board;
    return PassTabsBar(
      key: ValueKey(key),
      passes: board?.passes ?? const [],
      selectedPassId: viewModel.selectedPassId,
      onSelectPass: (passId) =>
          context.read<PassProfileViewModel>().didSelectPass(passId),
    );
  }
}

class _PassWaveformToolbar extends StatelessWidget {
  const _PassWaveformToolbar();

  @override
  Widget build(BuildContext context) {
    final normalize = context.select<PassProfileViewModel, String>(
      (viewModel) => viewModel.normalize,
    );
    context.select<PassProfileViewModel, String>(_waveformToolbarKey);
    final selection = context.select<PassProfileViewModel, _LegendSelection>(
      _LegendSelection.from,
    );
    final viewModel = context.read<PassProfileViewModel>();
    final board = viewModel.board;
    return WaveformControlToolbar(
      jobs: viewModel.comparisonJobs,
      selectedJobId: viewModel.selectedComparisonJobId,
      normalize: normalize,
      comparisonError: viewModel.comparisonError,
      onOpenJobs: viewModel.didOpenComparisonJobs,
      onSelectJob: viewModel.didSelectComparisonJob,
      onSelectNormalize: viewModel.didSelectNormalize,
      showMaster: selection.showMaster,
      showBeginner: selection.showBeginner,
      showRobot: selection.showRobot,
      mastersForPass: board?.mastersForPass ?? const [],
      selectedMasterProfileId: viewModel.selectedMasterProfileId,
      onToggleMaster: viewModel.didTapToggleMaster,
      onToggleBeginner: viewModel.didTapToggleBeginner,
      onToggleRobot: viewModel.didTapToggleRobot,
      onSelectMasterProfile: viewModel.didSelectMasterProfile,
      legendIsEmpty: selection.isEmpty,
    );
  }
}

String _waveformToolbarKey(PassProfileViewModel viewModel) {
  return [
    viewModel.selectedComparisonJobId,
    viewModel.comparisonError,
    for (final job in viewModel.comparisonJobs)
      '${job.jobId}|${job.workerKind}',
  ].join('\u001f');
}

class _PassChartPane extends StatelessWidget {
  const _PassChartPane();

  @override
  Widget build(BuildContext context) {
    final snapshot = context.select<PassProfileViewModel, _ChartSnapshot>(
      _ChartSnapshot.from,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (snapshot.isSeriesLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: ProgressBar(),
          ),
        if (snapshot.seriesError.isNotEmpty) ...[
          InfoBar(
            title: const Text('파형 조회 실패'),
            content: Text(snapshot.seriesError),
            severity: InfoBarSeverity.error,
          ),
          const SizedBox(height: 8),
        ],
        for (final banner in snapshot.banners) ...[
          InfoBar(title: Text(banner), severity: InfoBarSeverity.info),
          const SizedBox(height: 8),
        ],
        WaveformChannelCharts(
          series: snapshot.series,
          links: snapshot.links,
          showMaster: snapshot.showMaster,
          showBeginner: snapshot.showBeginner,
          showRobot: snapshot.showRobot,
          onBandTap: (linkId) => _openQualityIssue(
            context,
            commonKey: snapshot.commonKey,
            jobId: snapshot.jobId,
            passId: snapshot.passId,
            linkId: linkId,
          ),
        ),
      ],
    );
  }
}

void _openQualityIssue(
  BuildContext context, {
  required String commonKey,
  required String jobId,
  required String passId,
  required String linkId,
}) {
  final coordinator = context.read<AppCoordinator>();
  if (coordinator.isPassProfilePaneSelected) {
    coordinator.didTapOpenQualityIssueFromPane(
      commonKey: commonKey,
      jobId: jobId,
      passId: passId,
      linkId: linkId,
    );
    return;
  }
  coordinator.didTapOpenQualityIssue(
    commonKey: commonKey,
    jobId: jobId,
    passId: passId,
    linkId: linkId,
  );
}

String _contextKey(PassJointContext? data) {
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

String _passKey(PassProfileViewModel viewModel) {
  final board = viewModel.board;
  if (board == null) {
    return '';
  }
  return '${viewModel.selectedPassId}\u001f'
      '${[for (final pass in board.passes) pass.passId].join(',')}';
}

class _LegendSelection {
  const _LegendSelection({
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.masterKey,
    required this.isEmpty,
  });

  factory _LegendSelection.from(PassProfileViewModel viewModel) {
    final board = viewModel.board;
    final masters = board?.mastersForPass ?? const <String>[];
    return _LegendSelection(
      showMaster: viewModel.showMaster,
      showBeginner: viewModel.showBeginner,
      showRobot: viewModel.showRobot,
      masterKey:
          '${viewModel.selectedMasterProfileId}\u001f${masters.join(',')}',
      isEmpty: board == null || !board.doesHavePasses || !board.doesHaveSeries,
    );
  }

  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final String masterKey;
  final bool isEmpty;

  @override
  bool operator ==(Object other) {
    return other is _LegendSelection &&
        other.showMaster == showMaster &&
        other.showBeginner == showBeginner &&
        other.showRobot == showRobot &&
        other.masterKey == masterKey &&
        other.isEmpty == isEmpty;
  }

  @override
  int get hashCode =>
      Object.hash(showMaster, showBeginner, showRobot, masterKey, isEmpty);
}

class _ChartSnapshot {
  const _ChartSnapshot({
    required this.series,
    required this.links,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.isSeriesLoading,
    required this.seriesError,
    required this.banners,
    required this.commonKey,
    required this.jobId,
    required this.passId,
  });

  factory _ChartSnapshot.from(PassProfileViewModel viewModel) {
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
      isSeriesLoading: viewModel.isSeriesLoading,
      seriesError: viewModel.seriesError,
      banners: board?.banners ?? const [],
      commonKey: board?.commonKey ?? '',
      jobId: board?.jobId ?? '',
      passId: board?.selectedPass?.passId ?? '',
    );
  }

  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final bool isSeriesLoading;
  final String seriesError;
  final List<String> banners;
  final String commonKey;
  final String jobId;
  final String passId;

  @override
  bool operator ==(Object other) {
    return other is _ChartSnapshot &&
        other.series == series &&
        other.links == links &&
        other.showMaster == showMaster &&
        other.showBeginner == showBeginner &&
        other.showRobot == showRobot &&
        other.isSeriesLoading == isSeriesLoading &&
        other.seriesError == seriesError &&
        _sameBanners(other.banners, banners) &&
        other.commonKey == commonKey &&
        other.jobId == jobId &&
        other.passId == passId;
  }

  @override
  int get hashCode => Object.hash(
    series,
    links,
    showMaster,
    showBeginner,
    showRobot,
    isSeriesLoading,
    seriesError,
    Object.hashAll(banners),
    commonKey,
    jobId,
    passId,
  );
}

bool _sameBanners(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
