import 'package:fluent_ui/fluent_ui.dart';

class CatalogLookupFrame extends StatelessWidget {
  const CatalogLookupFrame({
    super.key,
    required this.filters,
    required this.actionLabel,
    required this.body,
  });

  final List<Widget> filters;
  final String actionLabel;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: filters,
              ),
            ),
            const SizedBox(width: 12),
            Button(onPressed: null, child: Text(actionLabel)),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(child: body),
      ],
    );
  }
}

class CatalogLookupTable extends StatelessWidget {
  const CatalogLookupTable({
    super.key,
    required this.headers,
    required this.columnFlexes,
    required this.rows,
    required this.emptyTitle,
  });

  final List<String> headers;
  final List<int> columnFlexes;
  final List<List<String>> rows;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LookupRow(cells: headers, flexes: columnFlexes, isHeader: true),
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: InfoBar(
              title: Text(emptyTitle),
              severity: InfoBarSeverity.warning,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return _LookupRow(cells: rows[index], flexes: columnFlexes);
              },
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
