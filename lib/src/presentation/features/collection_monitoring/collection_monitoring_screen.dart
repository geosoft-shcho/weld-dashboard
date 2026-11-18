import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/collection_board.dart';
import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/query_failure_pane.dart';
import 'collection_monitoring_view_model.dart';
import 'pipeline_trace_view_model.dart';
import 'widgets/collection_command_bar.dart';
import 'widgets/collection_kpi_cards.dart';
import 'widgets/collection_timeline_host.dart';
import 'widgets/pipeline_trace_tab_body.dart';

class CollectionMonitoringScreen extends StatelessWidget {
  const CollectionMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => locator<CollectionMonitoringViewModel>()..loadBoard(),
        ),
        ChangeNotifierProvider(
          create: (_) => locator<PipelineTraceViewModel>(),
        ),
      ],
      child: const _TraceRefreshIntervalBinder(
        child: _CollectionMonitoringBody(),
      ),
    );
  }
}

/// 커맨드바 새로고침 주기를 TraceService 폴링에 맞춘다.
class _TraceRefreshIntervalBinder extends StatefulWidget {
  const _TraceRefreshIntervalBinder({required this.child});

  final Widget child;

  @override
  State<_TraceRefreshIntervalBinder> createState() =>
      _TraceRefreshIntervalBinderState();
}

class _TraceRefreshIntervalBinderState extends State<_TraceRefreshIntervalBinder> {
  CollectionMonitoringViewModel? _board;
  int? _appliedInterval;
  int? _pendingInterval;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final board = context.read<CollectionMonitoringViewModel>();
    if (!identical(_board, board)) {
      _board?.removeListener(_onBoardChanged);
      _board = board;
      _board!.addListener(_onBoardChanged);
      _scheduleApplyInterval(board.query.refreshIntervalSeconds);
    }
  }

  void _onBoardChanged() {
    final board = _board;
    if (board == null) {
      return;
    }
    _scheduleApplyInterval(board.query.refreshIntervalSeconds);
  }

  /// 빌드/`didChangeDependencies` 중 notifyListeners를 피한다.
  void _scheduleApplyInterval(int seconds) {
    if (_appliedInterval == seconds || _pendingInterval == seconds) {
      return;
    }
    _pendingInterval = seconds;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingInterval = null;
      if (!mounted || _appliedInterval == seconds) {
        return;
      }
      _appliedInterval = seconds;
      context.read<PipelineTraceViewModel>().applyRefreshInterval(seconds);
    });
  }

  @override
  void dispose() {
    _board?.removeListener(_onBoardChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _CollectionMonitoringBody extends StatelessWidget {
  const _CollectionMonitoringBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionMonitoringViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    CollectionMonitoringViewModel viewModel,
  ) {
    if (viewModel.isLoading && viewModel.board == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return QueryFailurePane(
        title: '조회 실패',
        message: viewModel.errorMessage,
        onRetry: () {
          viewModel.didTapReload();
          context.read<PipelineTraceViewModel>().refresh();
        },
      );
    }
    final board = viewModel.board;
    if (board == null) {
      return const InfoBar(
        title: Text('카탈로그 없음'),
        content: Text('아직 조회되지 않았습니다.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (viewModel.isAutoRefreshOn)
          InfoBar(
            title: const Text('자동 갱신 중'),
            content: Text(
              '${viewModel.query.refreshIntervalSeconds == 5 ? '5초' : '1분'} · 보드·파이프라인 재조회',
            ),
            severity: InfoBarSeverity.info,
          ),
        if (viewModel.doesHaveInvalidTimeRange)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: InfoBar(
              title: Text('시간 범위 오류'),
              content: Text(
                '시작 시각이 종료 시각보다 늦습니다. 일자·시간 범위는 타임라인에만 반영됩니다.',
              ),
              severity: InfoBarSeverity.error,
            ),
          ),
        const SizedBox(height: 8),
        CollectionCommandBar(viewModel: viewModel, board: board),
        const SizedBox(height: 16),
        CollectionKpiCards(viewModel: viewModel, kpi: board.kpi),
        const SizedBox(height: 16),
        Expanded(
          child: _MonitoringTabView(viewModel: viewModel, board: board),
        ),
      ],
    );
  }
}

class _MonitoringTabView extends StatefulWidget {
  const _MonitoringTabView({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  State<_MonitoringTabView> createState() => _MonitoringTabViewState();
}

class _MonitoringTabViewState extends State<_MonitoringTabView> {
  /// 0 = 적재 파이프라인, 1 = 일자별 수집 타임라인
  int currentIndex = 0;

  static final Color _line = AppTheme.STATUS_OFF.withValues(alpha: 0.45);

  @override
  Widget build(BuildContext context) {
    final pipeline = context.watch<PipelineTraceViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: _line, width: 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _MonitoringTab(
                label: '적재 파이프라인',
                isSelected: currentIndex == 0,
                onPressed: () => setState(() => currentIndex = 0),
              ),
              _MonitoringTab(
                label: '일자별 수집 타임라인',
                isSelected: currentIndex == 1,
                onPressed: () => setState(() => currentIndex = 1),
              ),
            ],
          ),
        ),
        Expanded(
          child: currentIndex == 0
              ? PipelineTraceTabBody(viewModel: pipeline)
              : CollectionTimelineHost(
                  viewModel: widget.viewModel,
                  board: widget.board,
                ),
        ),
      ],
    );
  }
}

class _MonitoringTab extends StatelessWidget {
  const _MonitoringTab({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final isHovered = states.isHovered;
        final color = isSelected || isHovered
            ? AppTheme.INK
            : AppTheme.STATUS_OFF;
        return Transform.translate(
          offset: const Offset(0, 1),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: isSelected
                  ? const Border(
                      bottom: BorderSide(color: AppTheme.INK, width: 2),
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
