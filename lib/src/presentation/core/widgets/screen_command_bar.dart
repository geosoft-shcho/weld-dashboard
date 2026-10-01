import 'package:fluent_ui/fluent_ui.dart';

import '../themes/app_theme.dart';

/// 페이지 제목과 이동 버튼을 한 줄에 둔다.
class ScreenCommandBar extends StatelessWidget {
  const ScreenCommandBar({
    super.key,
    required this.title,
    required this.primaryItems,
  });

  static const double BAR_HEIGHT = 48;

  final String title;
  final List<CommandBarItem> primaryItems;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        border: Border(
          bottom: BorderSide(color: theme.resources.cardStrokeColorDefault),
        ),
      ),
      child: SizedBox(
        height: BAR_HEIGHT,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: theme.typography.body?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: CommandBar(
                  mainAxisAlignment: MainAxisAlignment.end,
                  primaryItems: primaryItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 명령 버튼 글자가 가운데 정렬로 다시 줄바꿈되지 않게 한다.
class CommandBarLabel extends StatelessWidget {
  const CommandBarLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: TextAlign.start, softWrap: false);
  }
}
