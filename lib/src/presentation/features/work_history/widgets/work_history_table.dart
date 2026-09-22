import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/work_history_board.dart';
import '../../../../domain/entities/work_history_item.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../../../navigation/app_coordinator.dart';
import '../work_history_view_model.dart';

class WorkHistoryTable extends StatefulWidget {
  const WorkHistoryTable({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final WorkHistoryViewModel viewModel;
  final WorkHistoryBoard board;

  @override
  State<WorkHistoryTable> createState() => _WorkHistoryTableState();
}

class _WorkHistoryTableState extends State<WorkHistoryTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryLoadMore());
  }

  @override
  void didUpdateWidget(covariant WorkHistoryTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.board.visibleRows.length != widget.board.visibleRows.length ||
        oldWidget.board.totalCount != widget.board.totalCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryLoadMore());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.extentAfter < 120) {
      widget.viewModel.didScrollNearEnd();
    }
  }

  void _tryLoadMore() {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }
    if (widget.board.doesHaveMore &&
        _scrollController.position.maxScrollExtent <= 0) {
      widget.viewModel.didScrollNearEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;
    final viewModel = widget.viewModel;
    if (board.query.doesHaveInvalidDateRange) {
      return const InfoBar(
        title: Text('기간 오류'),
        content: Text('시작일이 종료일보다 늦습니다.'),
        severity: InfoBarSeverity.error,
      );
    }
    if (board.totalCount == 0) {
      return InfoBar(
        title: const Text('조건에 맞는 작업 이력이 없습니다'),
        action: Button(
          onPressed: viewModel.didTapReset,
          child: const Text('필터 초기화'),
        ),
        severity: InfoBarSeverity.warning,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _HeaderRow(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: board.visibleRows.length + 1,
            itemBuilder: (context, index) {
              if (index == board.visibleRows.length) {
                return _Footer(
                  board: board,
                  isLoadingMore: viewModel.isLoadingMore,
                );
              }
              return _DataRow(
                item: board.visibleRows[index],
                isSelected:
                    board.visibleRows[index].historyId ==
                    board.query.selectedHistoryId,
                viewModel: viewModel,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF32363C),
        border: Border(bottom: BorderSide(color: Color(0xFF3E424A))),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            _Cell('공통키', flex: 18, isHeader: true),
            _Cell('작업지시', flex: 18, isHeader: true),
            _Cell('조인트', flex: 14, isHeader: true),
            _Cell('작업자', flex: 10, isHeader: true),
            _Cell('작업일시', flex: 14, isHeader: true),
            _Cell('장비', flex: 12, isHeader: true),
            _Cell('패스 수', flex: 6, isHeader: true),
            _Cell('첨부', flex: 6, isHeader: true),
            _Cell('', flex: 16, isHeader: true),
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.item,
    required this.isSelected,
    required this.viewModel,
  });

  final WorkHistoryItem item;
  final bool isSelected;
  final WorkHistoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () => _showMenu(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.22)
              : const Color(0x00000000),
          border: const Border(bottom: BorderSide(color: Color(0xFF3E424A))),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 98,
                child: HoverButton(
                  onPressed: () => viewModel.didSelectRow(item.historyId),
                  builder: (context, states) {
                    final isHovered = states.contains(WidgetState.hovered);
                    return ColoredBox(
                      color: isHovered && !isSelected
                          ? AppTheme.SURFACE_RAISED
                          : const Color(0x00000000),
                      child: Row(
                        children: [
                          _Cell(item.commonKey, flex: 18),
                          _Cell('${item.workOrderNo}\n${item.title}', flex: 18),
                          _Cell('${item.jointNo} ${item.jointName}', flex: 14),
                          _Cell(item.workerName, flex: 10),
                          _Cell(
                            DashboardFormatters.dateTime(item.workedAt),
                            flex: 14,
                          ),
                          _Cell(item.equipmentName, flex: 12),
                          _Cell('${item.passCount}', flex: 6),
                          _Cell(
                            item.doesHaveAttachments
                                ? '${item.attachmentCount}건'
                                : '—',
                            flex: 6,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 16,
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Button(
                      onPressed: () => _openDetail(context),
                      child: const Text('상세'),
                    ),
                    Button(
                      onPressed: () => _openPassProfile(context),
                      child: const Text('프로파일'),
                    ),
                    Button(
                      onPressed: () => _openQuality(context),
                      child: const Text('품질'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    viewModel.didSelectRow(item.historyId);
    context.read<AppCoordinator>().didTapOpenWorkDetail(
      context,
      historyId: item.historyId,
    );
  }

  void _openPassProfile(BuildContext context) {
    viewModel.didSelectRow(item.historyId);
    context.read<AppCoordinator>().didTapOpenPassProfile(
      commonKey: item.commonKey,
      historyId: item.historyId,
    );
  }

  void _openQuality(BuildContext context) {
    viewModel.didSelectRow(item.historyId);
    context.read<AppCoordinator>().didTapOpenQualityIssue(
      commonKey: item.commonKey,
      historyId: item.historyId,
    );
  }

  void _showMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ContentDialog(
          title: Text(item.commonKey),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _openDetail(context);
                },
                child: const Text('상세'),
              ),
              const SizedBox(height: 8),
              Button(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _openPassProfile(context);
                },
                child: const Text('프로파일'),
              ),
              const SizedBox(height: 8),
              Button(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _openQuality(context);
                },
                child: const Text('품질'),
              ),
            ],
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.board, required this.isLoadingMore});

  final WorkHistoryBoard board;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    final loaded = DashboardFormatters.count(board.visibleRows.length);
    final total = DashboardFormatters.count(board.totalCount);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: isLoadingMore
            ? const SizedBox(
                width: 20,
                height: 20,
                child: ProgressRing(),
              )
            : Text(
                board.doesHaveMore
                    ? '$loaded / $total건 · 스크롤하면 더 불러옵니다'
                    : '$total건 모두 표시',
                style: const TextStyle(fontSize: 12),
              ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {required this.flex, this.isHeader = false});

  final String text;
  final int flex;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        maxLines: isHeader ? 1 : 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
