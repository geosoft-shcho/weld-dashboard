import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/collection_board.dart';
import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
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
        title: const Text('조회 실패'),
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
        content: Text('아직 조회되지 않았습니다.'),
      );
    }
    return ListView(
      children: [
        if (viewModel.isAutoRefreshOn)
          InfoBar(
            title: const Text('자동 갱신 중'),
            content: Text(
              '${viewModel.query.refreshIntervalSeconds == 5 ? '5초' : '1분'} · 재조회',
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

  static final Color _LINE = AppTheme.STATUS_OFF.withValues(alpha: 0.45);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 660,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _LINE, width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _MonitoringTab(
                  label: '일자별 수집 타임라인',
                  isSelected: currentIndex == 0,
                  onPressed: () => setState(() => currentIndex = 0),
                ),

                // 탭 현재 수집 상태 임시 주석. 삭제 금지

                // _MonitoringTab(
                //   label: '현재 수집 상태',
                //   isSelected: currentIndex == 1,
                //   onPressed: () => setState(() => currentIndex = 1),
                // ),
              ],
            ),
          ),
          Expanded(
            child: currentIndex == 0
                ? CollectionTimelineHost(
                    viewModel: widget.viewModel,
                    board: widget.board,
                  )
                : CollectionStatusTable(
                    viewModel: widget.viewModel,
                    board: widget.board,
                  ),
          ),
        ],
      ),
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
