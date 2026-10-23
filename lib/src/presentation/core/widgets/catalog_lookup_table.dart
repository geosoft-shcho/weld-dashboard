import 'package:fluent_ui/fluent_ui.dart';

import '../themes/app_theme.dart';

class CatalogLookupFrame extends StatelessWidget {
  const CatalogLookupFrame({
    super.key,
    required this.filters,
    required this.body,
    this.tableHeader,
  });

  final List<Widget> filters;
  final Widget body;
  final Widget? tableHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: filters,
        ),
        if (tableHeader != null) ...[const SizedBox(height: 12), tableHeader!],
        const SizedBox(height: 12),
        Expanded(child: body),
      ],
    );
  }
}

class LookupTableHeader extends StatelessWidget {
  const LookupTableHeader({
    super.key,
    required this.label,
    required this.count,
    required this.actionText,
    this.onAction,
  });

  final String label;
  final int count;
  final String actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label 검색 결과 $count건', style: const TextStyle(fontSize: 12)),
        const Spacer(),
        FilledButton(onPressed: onAction, child: Text(actionText)),
      ],
    );
  }
}

class CatalogLookupTable extends StatefulWidget {
  const CatalogLookupTable({
    super.key,
    required this.headers,
    required this.columnFlexes,
    required this.rows,
    required this.emptyTitle,
    this.onRowTap,
    this.onNearEnd,
    this.isLoadingMore = false,
  });

  final List<String> headers;
  final List<int> columnFlexes;
  final List<List<String>> rows;
  final String emptyTitle;
  final ValueChanged<int>? onRowTap;
  final VoidCallback? onNearEnd;
  final bool isLoadingMore;

  @override
  State<CatalogLookupTable> createState() => _CatalogLookupTableState();
}

class _CatalogLookupTableState extends State<CatalogLookupTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryLoadMore());
  }

  @override
  void didUpdateWidget(covariant CatalogLookupTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rows.length != widget.rows.length ||
        oldWidget.isLoadingMore != widget.isLoadingMore) {
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
    if (widget.onNearEnd == null || !_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.extentAfter < 120) {
      widget.onNearEnd!();
    }
  }

  /// 첫 페이지가 뷰포트에 다 들어가면 스크롤이 생기지 않아 이어받기가 멈춘다.
  void _tryLoadMore() {
    if (!mounted ||
        widget.onNearEnd == null ||
        !_scrollController.hasClients ||
        widget.isLoadingMore) {
      return;
    }
    if (_scrollController.position.maxScrollExtent <= 0) {
      widget.onNearEnd!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LookupRow(
          cells: widget.headers,
          flexes: widget.columnFlexes,
          isHeader: true,
        ),
        if (widget.rows.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: InfoBar(
              title: Text(widget.emptyTitle),
              severity: InfoBarSeverity.warning,
            ),
          )
        else
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                primary: false,
                itemCount: widget.rows.length + 1,
                itemBuilder: (context, index) {
                  if (index == widget.rows.length) {
                    if (!widget.isLoadingMore) {
                      return const SizedBox(height: 8);
                    }
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: ProgressRing(strokeWidth: 2)),
                    );
                  }
                  return HoverButton(
                    onPressed: widget.onRowTap == null
                        ? null
                        : () => widget.onRowTap!(index),
                    builder: (context, states) {
                      return ColoredBox(
                        color: AppTheme.tableRowColor(
                          index: index,
                          hovered: states.contains(WidgetState.hovered),
                        ),
                        child: _LookupRow(
                          cells: widget.rows[index],
                          flexes: widget.columnFlexes,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _LookupRow extends StatelessWidget {
  const _LookupRow({
    required this.cells,
    required this.flexes,
    this.isHeader = false,
  });

  final List<String> cells;
  final List<int> flexes;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFF32363C) : const Color(0x00000000),
        border: const Border(bottom: BorderSide(color: Color(0xFF3E424A))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < cells.length; index++)
              Expanded(
                flex: index < flexes.length ? flexes[index] : 1,
                child: Text(
                  cells[index].isEmpty ? '—' : cells[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
