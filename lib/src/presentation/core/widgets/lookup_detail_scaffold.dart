import 'package:fluent_ui/fluent_ui.dart';

import '../themes/app_theme.dart';
import 'screen_command_bar.dart';

/// 조회 상세 공통 셸: 뒤로 · 제목 · 우측 액션 · 스크롤 본문.
class LookupDetailScaffold extends StatelessWidget {
  const LookupDetailScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.body,
    this.subtitle = '',
    this.actions = const [],
    this.commandBarExtra = const [],
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget body;
  final List<Widget> actions;
  final List<CommandBarItem> commandBarExtra;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenCommandBar(
                title: title,
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.back),
                    label: const CommandBarLabel('목록으로'),
                    onPressed: onBack,
                  ),
                  ...commandBarExtra,
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (subtitle.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.STATUS_OFF,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          ...actions,
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(child: body),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LookupDetailKvGrid extends StatelessWidget {
  const LookupDetailKvGrid({super.key, required this.entries});

  final List<(String, String)> entries;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        for (final entry in entries)
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.$1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.STATUS_OFF,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.$2.isEmpty ? '—' : entry.$2,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class LookupDetailSectionTitle extends StatelessWidget {
  const LookupDetailSectionTitle(this.label, {super.key, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

class LookupDetailPlainTable extends StatelessWidget {
  const LookupDetailPlainTable({
    super.key,
    required this.headers,
    required this.rows,
    this.emptyText = '항목이 없습니다',
    this.onRowTap,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final String emptyText;
  final ValueChanged<int>? onRowTap;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Text(
        emptyText,
        style: const TextStyle(color: AppTheme.STATUS_OFF, fontSize: 13),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row(headers, isHeader: true),
        for (var index = 0; index < rows.length; index++)
          HoverButton(
            onPressed: onRowTap == null ? null : () => onRowTap!(index),
            builder: (context, states) {
              return ColoredBox(
                color: AppTheme.tableRowColor(
                  index: index,
                  hovered: states.contains(WidgetState.hovered),
                ),
                child: _row(rows[index]),
              );
            },
          ),
      ],
    );
  }

  Widget _row(List<String> cells, {bool isHeader = false}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFF32363C) : const Color(0x00000000),
        border: const Border(bottom: BorderSide(color: Color(0xFF3E424A))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            for (final cell in cells)
              Expanded(
                child: Text(
                  cell.isEmpty ? '—' : cell,
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
