import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/collection_board.dart';
import '../../core/di/locator.dart';
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
    final viewModel = context.watch<CollectionMonitoringViewModel>();
    return ScaffoldPage(
      header: const PageHeader(title: Text('수집 모니터링')),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(viewModel),
      ),
    );
  }

  Widget _content(CollectionMonitoringViewModel viewModel) {
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
        CollectionCommandBar(viewModel: viewModel, board: board),
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
            text: const Text('장비별 수집 타임라인', style: TextStyle(fontSize: 14)),
            body: CollectionTimelineHost(
              viewModel: widget.viewModel,
              board: widget.board,
            ),
          ),
          Tab(
            text: const Text('실시간 수집 상태', style: TextStyle(fontSize: 14)),
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
        child: const Text('공장 전체', style: TextStyle(fontSize: 14)),
      ),
    ];
    if (query.isUnassignedOnly) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapProjectCrumb,
          child: const Text('미배정', style: TextStyle(fontSize: 14)),
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
          child: Text(projectName, style: const TextStyle(fontSize: 14)),
        ),
      ]);
    } else if (query.projectIds.length > 1) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapProjectCrumb,
          child: Text(
            '프로젝트 ${query.projectIds.length}개',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ]);
    }
    if (query.lineNames.length == 1) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapLineCrumb,
          child: Text(
            query.lineNames.first,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ]);
    } else if (query.lineNames.length > 1) {
      crumbs.addAll([
        const Text(' › '),
        HyperlinkButton(
          onPressed: viewModel.didTapLineCrumb,
          child: Text(
            '${query.lineNames.length}개 라인',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ]);
    }
    if (query.equipmentIds.length == 1) {
      crumbs.addAll([
        const Text(' › '),
        Text(query.equipmentIds.first, style: const TextStyle(fontSize: 14)),
      ]);
    } else if (query.equipmentIds.length > 1) {
      crumbs.addAll([
        const Text(' › '),
        Text(
          '장비 ${query.equipmentIds.length}개',
          style: const TextStyle(fontSize: 14),
        ),
      ]);
    }

    // 작업자 필터 표시
    if (query.workerIds.isNotEmpty) {
      for (final workerId in query.workerIds) {
        crumbs.addAll([
          const Text(' › '),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Button(
              onPressed: () => viewModel.didClearWorker(workerId),
              child: Text(
                _workerName(workerId),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ]);
      }
    }

    // 연결 상태 필터 표시
    if (query.connectionStatuses.isNotEmpty) {
      for (final status in query.connectionStatuses) {
        crumbs.addAll([
          const Text(' › '),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Button(
              onPressed: () => viewModel.didToggleConnection(status),
              child: Text(
                '연결 ${status.label}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ]);
      }
    }

    // 새로고침 주기 표시
    if (query.refreshIntervalSeconds > 0) {
      final label = query.refreshIntervalSeconds == 5
          ? '5초'
          : query.refreshIntervalSeconds == 60
          ? '1분'
          : '${query.refreshIntervalSeconds}초';
      crumbs.addAll([
        const Text(' › '),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Button(
            onPressed: () => viewModel.didSelectRefreshInterval(0),
            child: Text('자동갱신 $label', style: const TextStyle(fontSize: 14)),
          ),
        ),
      ]);
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: crumbs,
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
