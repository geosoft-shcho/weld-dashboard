import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/channel_compare_stats.dart';
import '../../../domain/entities/pass_joint_context.dart';
import '../../../domain/entities/quality_link.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
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
    //             coordinator.didTapBackFromPassProfile(context),
    //       ),
    //     CommandBarButton(
    //       icon: const Icon(FluentIcons.history),
    //       label: const CommandBarLabel('작업 이력'),
    //       onPressed: () => coordinator.didTapBackToWorkHistory(context),
    //     ),
    //     CommandBarButton(
    //       icon: const Icon(FluentIcons.report_document),
    //       label: const CommandBarLabel('이 패스 품질 이슈'),
    //       onPressed: !canOpenQuality
    //           ? null
    //           : () => _didTapOpenQualityIssue(
    //               coordinator,
    //               commonKey: board.commonKey,
    //               historyId: board.historyId,
    //               passId: board.selectedPass?.passId,
    //             ),
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
    return InfoBar(
      title: const Text('로드 실패'),
      content: Text(message),
      severity: InfoBarSeverity.error,
      action: Button(
        onPressed: () => context.read<PassProfileViewModel>().didTapReload(),
        child: const Text('재시도'),
      ),
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
    return ListView(
      children: const [
        // Text(
        //   '전류·전압·속도 파형 시계열, 명장 · 초보자 · 로봇 중첩 비교',
        //   style: TextStyle(color: AppTheme.STATUS_OFF),
        // ),
        // SizedBox(height: 12),
        _PassContextSection(),
        SizedBox(height: 12),
        _PassTabsSection(),
        SizedBox(height: 12),
        _NormalizeCombo(),
        SizedBox(height: 12),
        _PassLegendSection(),
        SizedBox(height: 8),
        _PassChartPane(),
      ],
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
    final board = context.read<PassProfileViewModel>().board;
    return PassTabsBar(
      key: ValueKey(key),
      passes: board?.passes ?? const [],
      selectedPassId: board?.selectedPass?.passId ?? '',
      onSelectPass: (passId) =>
          context.read<PassProfileViewModel>().didSelectPass(passId),
    );
  }
}

class _NormalizeCombo extends StatelessWidget {
  const _NormalizeCombo();

  @override
  Widget build(BuildContext context) {
    final normalize = context.select<PassProfileViewModel, String>(
      (viewModel) => viewModel.normalize,
    );
    return Row(
      children: [
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
                context.read<PassProfileViewModel>().didSelectNormalize(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _PassLegendSection extends StatelessWidget {
  const _PassLegendSection();

  @override
  Widget build(BuildContext context) {
    final selection = context.select<PassProfileViewModel, _LegendSelection>(
      _LegendSelection.from,
    );
    final board = context.read<PassProfileViewModel>().board;
    final viewModel = context.read<PassProfileViewModel>();
    return PassLegendToolbar(
      showMaster: selection.showMaster,
      showBeginner: selection.showBeginner,
      showRobot: selection.showRobot,
      mastersForPass: board?.mastersForPass ?? const [],
      selectedMasterProfileId: board?.selectedMasterProfileId ?? '',
      onToggleMaster: viewModel.didTapToggleMaster,
      onToggleBeginner: viewModel.didTapToggleBeginner,
      onToggleRobot: viewModel.didTapToggleRobot,
      onSelectMasterProfile: viewModel.didSelectMasterProfile,
      isEmpty: selection.isEmpty,
    );
  }
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
        LayoutBuilder(
          builder: (context, constraints) {
            final charts = WaveformChannelCharts(
              series: snapshot.series,
              links: snapshot.links,
              showMaster: snapshot.showMaster,
              showBeginner: snapshot.showBeginner,
              showRobot: snapshot.showRobot,
              onBandTap: (linkId) => _openQualityIssue(
                context,
                commonKey: snapshot.commonKey,
                historyId: snapshot.historyId,
                passId: snapshot.passId,
                linkId: linkId,
              ),
            );
            final summary = PassCompareSummary(stats: snapshot.stats);
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

void _openQualityIssue(
  BuildContext context, {
  required String commonKey,
  required String historyId,
  required String passId,
  required String linkId,
}) {
  final coordinator = context.read<AppCoordinator>();
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

String _contextKey(PassJointContext? data) {
  if (data == null) {
    return '';
  }
  return [
    data.commonKey,
    data.workOrderNo,
    data.title,
    data.jointNo,
    data.jointName,
    data.workerName,
    data.equipmentName,
  ].join('\u001f');
}

String _passKey(PassProfileViewModel viewModel) {
  final board = viewModel.board;
  if (board == null) {
    return '';
  }
  return '${board.selectedPass?.passId ?? ''}\u001f'
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
          '${board?.selectedMasterProfileId ?? ''}\u001f${masters.join(',')}',
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
  int get hashCode => Object.hash(
    showMaster,
    showBeginner,
    showRobot,
    masterKey,
    isEmpty,
  );
}

class _ChartSnapshot {
  const _ChartSnapshot({
    required this.series,
    required this.links,
    required this.stats,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.isSeriesLoading,
    required this.seriesError,
    required this.banners,
    required this.commonKey,
    required this.historyId,
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
      stats:
          board?.compareStats ??
          ChannelCompareStats.fromSeries(
            const WaveformSeriesBundle(
              masterProfileId: '',
              master: [],
              beginner: [],
              robot: [],
            ),
          ),
      showMaster: viewModel.showMaster,
      showBeginner: viewModel.showBeginner,
      showRobot: viewModel.showRobot,
      isSeriesLoading: viewModel.isSeriesLoading,
      seriesError: viewModel.seriesError,
      banners: board?.banners ?? const [],
      commonKey: board?.commonKey ?? '',
      historyId: board?.historyId ?? '',
      passId: board?.selectedPass?.passId ?? '',
    );
  }

  final WaveformSeriesBundle series;
  final List<QualityLink> links;
  final ChannelCompareStats stats;
  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final bool isSeriesLoading;
  final String seriesError;
  final List<String> banners;
  final String commonKey;
  final String historyId;
  final String passId;

  @override
  bool operator ==(Object other) {
    return other is _ChartSnapshot &&
        other.series == series &&
        other.links == links &&
        other.stats == stats &&
        other.showMaster == showMaster &&
        other.showBeginner == showBeginner &&
        other.showRobot == showRobot &&
        other.isSeriesLoading == isSeriesLoading &&
        other.seriesError == seriesError &&
        _sameBanners(other.banners, banners) &&
        other.commonKey == commonKey &&
        other.historyId == historyId &&
        other.passId == passId;
  }

  @override
  int get hashCode => Object.hash(
    series,
    links,
    stats,
    showMaster,
    showBeginner,
    showRobot,
    isSeriesLoading,
    seriesError,
    Object.hashAll(banners),
    commonKey,
    historyId,
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
