import 'package:fluent_ui/fluent_ui.dart';

class WorkDetailEmptyBar extends StatelessWidget {
  const WorkDetailEmptyBar({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: InfoBar(title: Text(message), severity: InfoBarSeverity.warning),
    );
  }
}
