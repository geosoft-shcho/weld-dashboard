import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/collection_board.dart';
import '../../../domain/entities/preview_state.dart';
import '../../core/di/locator.dart';
import '../app_shell/shell_view_model.dart';
import 'collection_monitoring_view_model.dart';
import 'widgets/collection_command_bar.dart';
import 'widgets/collection_kpi_cards.dart';
import 'widgets/collection_status_table.dart';
import 'widgets/collection_timeline_host.dart';

class CollectionMonitoringScreen extends StatelessWidget {
  const CollectionMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CollectionMonitoringViewModel>()..loadBoard(),
      child: const _CollectionMonitoringBody(),
    );
  }
}

class _CollectionMonitoringBody extends StatelessWidget {
  const _CollectionMonitoringBody();

  @override
  Widget build(BuildContext context) {
    final previewState = context.watch<ShellViewModel>().previewState;
    final viewModel = context.watch<CollectionMonitoringViewModel>();
    return ScaffoldPage(
      header: const PageHeader(title: Text('수집 모니터링')),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(previewState, viewModel),
      ),
    );
  }

  Widget _content(
    PreviewState previewState,
    CollectionMonitoringViewModel viewModel,
  ) {
    switch (previewState) {
      case PreviewState.loading:
        return const Center(child: ProgressRing());
      case PreviewState.empty:
        return const InfoBar(
          title: Text('빈 상태'),
          content: Text('미리보기: 표시할 수집 데이터가 없습니다.'),
          severity: InfoBarSeverity.warning,
        );
      case PreviewState.error:
        return InfoBar(
          title: const Text('CSV 로드 실패'),
          content: const Text(
            'collection_status.csv / collection_assignments.csv를 확인하세요.',
          ),
          action: Button(
            onPressed: viewModel.didTapReload,
            child: const Text('재시도'),
          ),
          severity: InfoBarSeverity.error,
        );
      case PreviewState.live:
        if (viewModel.isLoading && viewModel.board == null) {
          return const Center(child: ProgressRing());
        }
        if (viewModel.hasError) {
          return InfoBar(
            title: const Text('CSV 로드 실패'),
            content: Text(viewModel.errorMessage),
            action: Button(
              onPressed: viewModel.didTapReload,
              child: const Text('재시도'),
            ),
            severity: InfoBarSeverity.error,
          );
        }
        final board = viewModel.board;
        if (board == null) {
          return const InfoBar(
            title: Text('카탈로그 없음'),
            content: Text('아직 CSV를 불러오지 않았습니다.'),
          );
        }
        return ListView(
          children: [
            if (viewModel.isAutoRefreshOn)
              InfoBar(
                title: const Text('자동 갱신 중'),
                content: Text(
                  '${viewModel.query.refreshIntervalSeconds == 5 ? '5초' : '1분'} · CSV 재로드 목업',
                ),
                severity: InfoBarSeverity.info,
              ),
            if (viewModel.doesHaveInvalidTimeRange)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: InfoBar(
                  title: Text('시간 범위 오류'),
                  content: Text('시작 시각이 종료 시각보다 늦습니다. 일자·시간 범위는 타임라인에만 반영됩니다.'),
                  severity: InfoBarSeverity.error,
                ),
              ),
            const SizedBox(height: 8),
            CollectionCommandBar(viewModel: viewModel),
            const SizedBox(height: 12),
            _Breadcrumb(viewModel: viewModel),
            const SizedBox(height: 16),
            CollectionKpiCards(viewModel: viewModel, kpi: board.kpi),
            const SizedBox(height: 16),
            _MonitoringTabView(viewModel: viewModel, board: board),
          ],
        );
    }
  }
}

// TabView 상태 관리를 위한 독립적인 StatefulWidget
class _MonitoringTabView extends StatefulWidget {
  const _MonitoringTabView({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  State<_MonitoringTabView> createState() => _MonitoringTabViewState();
}

class _MonitoringTabViewState extends State<_MonitoringTabView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 660,
      child: TabView(
        currentIndex: currentIndex,
        onChanged: (index) => setState(() => currentIndex = index),
        tabWidthBehavior: TabWidthBehavior.sizeToContent,
        closeButtonVisibility: CloseButtonVisibilityMode.never,
        tabs: [
          Tab(
            text: const Text('장비별 수집 타임라인'),
            body: CollectionTimelineHost(
              viewModel: widget.viewModel,
              board: widget.board,
            ),
          ),
          Tab(
            text: const Text('실시간 수집 상태'),
            body: CollectionStatusTable(
              viewModel: widget.viewModel,
              board: widget.board,
            ),
          ),
        ],
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.viewModel});

  final CollectionMonitoringViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final query = viewModel.query;
    final board = viewModel.board;
    final crumbs = <Widget>[
      HyperlinkButton(
        onPressed: viewModel.didTapFactoryCrumb,
        child: const Text('공장 전체'),
      ),
    ];
    if (query.isUnassignedOnly) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapProjectCrumb,
          child: const Text('미배정'),
        ),
      ]);
    } else if (query.projectIds.length == 1) {
      var projectName = query.projectIds.first;
      for (final project in board?.options.projects ?? const []) {
        if (project.projectId == query.projectIds.first) {
          projectName = project.projectName;
        }
      }
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapProjectCrumb,
          child: Text(projectName),
        ),
      ]);
    } else if (query.projectIds.length > 1) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapProjectCrumb,
          child: Text('프로젝트 ${query.projectIds.length}개'),
        ),
      ]);
    }
    if (query.lineNames.length == 1) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapLineCrumb,
          child: Text(query.lineNames.first),
        ),
      ]);
    } else if (query.lineNames.length > 1) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapLineCrumb,
          child: Text('${query.lineNames.length}개 라인'),
        ),
      ]);
    }
    if (query.equipmentIds.length == 1) {
      crumbs.addAll([const Text(' › '), Text(query.equipmentIds.first)]);
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...crumbs,
        for (final workerId in query.workerIds)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Button(
              onPressed: () => viewModel.didClearWorker(workerId),
              child: Text(_workerName(workerId)),
            ),
          ),
      ],
    );
  }

  String _workerName(String workerId) {
    for (final worker in viewModel.board?.options.workers ?? const []) {
      if (worker.workerId == workerId) {
        return worker.workerName;
      }
    }
    return workerId;
  }
}
