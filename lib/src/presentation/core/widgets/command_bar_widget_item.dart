import 'package:fluent_ui/fluent_ui.dart';

class CommandBarWidgetItem extends CommandBarItem {
  const CommandBarWidgetItem({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, CommandBarItemDisplayMode displayMode) {
    return CommandBarItemInPrimary(child: child);
  }
}
