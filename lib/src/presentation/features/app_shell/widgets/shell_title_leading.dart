import 'package:fluent_ui/fluent_ui.dart';

/// Leading chrome for [ShellScreen]: menu toggle + app title on one row.
class ShellTitleLeading extends StatelessWidget {
  const ShellTitleLeading({
    super.key,
    required this.onTogglePane,
  });

  final VoidCallback onTogglePane;

  static const String APP_TITLE = '용접 수집 모니터링';

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PaneToggleButton(onPressed: onTogglePane),
        const SizedBox(width: 8),
        Text(
          APP_TITLE,
          style: theme.typography.body?.copyWith(
            color: theme.resources.textFillColorPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
