import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/screen_command_bar.dart';

/// 작업 상세 탭 본문 맨 위에 두는 액션바.
/// ScreenCommandBar와 같은 높이·버튼 패턴을 탭 카드 표면에 맞춘 것이다.
class JobDetailActionBar extends StatelessWidget {
  const JobDetailActionBar({super.key, required this.items, this.leading});

  final List<CommandBarItem> items;
  final Widget? leading;

  static const TextStyle _textStyle = TextStyle(fontSize: 13);

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final typography = theme.typography;
    return Container(
      height: ScreenCommandBar.BAR_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: FluentTheme(
        data: theme.copyWith(
          typography: Typography.raw(
            display: typography.display,
            titleLarge: typography.titleLarge,
            title: typography.title,
            subtitle: typography.subtitle,
            bodyLarge: typography.bodyLarge,
            bodyStrong: typography.bodyStrong?.copyWith(fontSize: 12),
            body: typography.body?.copyWith(fontSize: 12),
            caption: typography.caption?.copyWith(fontSize: 12),
          ),
        ),
        child: DefaultTextStyle.merge(
          style: _textStyle,
          child: leading == null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: CommandBar(
                    mainAxisAlignment: MainAxisAlignment.end,
                    primaryItems: items,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: leading!,
                      ),
                    ),
                    Flexible(
                      child: CommandBar(
                        mainAxisAlignment: MainAxisAlignment.end,
                        primaryItems: items,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
