import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../navigation/app_coordinator.dart';

/// Leading chrome for [ShellScreen]: menu toggle + app title on one row.
class ShellTitleLeading extends StatelessWidget {
  const ShellTitleLeading({super.key, required this.onTogglePane});

  final VoidCallback onTogglePane;

  static const String APP_TITLE = '용접 수집 대시보드';

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final pageTitle = context.select<AppCoordinator, String>(
      (coordinator) => coordinator.pageTitle,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PaneToggleButton(onPressed: onTogglePane),
        const SizedBox(width: 8),
        Text(
          '$APP_TITLE : $pageTitle',
          style: theme.typography.body?.copyWith(
            color: theme.resources.textFillColorPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
