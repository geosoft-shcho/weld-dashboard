import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/work_attachment.dart';

class WorkDetailHost extends StatelessWidget {
  const WorkDetailHost({
    super.key,
    required this.packageName,
    required this.attachment,
    required this.index,
    required this.total,
    required this.child,
  });

  final String packageName;
  final WorkAttachment attachment;
  final int index;
  final int total;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFF32363C),
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                packageName,
                style: const TextStyle(fontSize: 11, color: Color(0xFF8E949E)),
              ),
              Text(
                attachment.fileName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (attachment.note.isNotEmpty)
                Text(attachment.note, style: const TextStyle(fontSize: 12)),
              Text(
                '${index + 1} / $total',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
