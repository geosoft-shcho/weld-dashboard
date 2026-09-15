import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/work_attachment.dart';
import '../work_detail_view_model.dart';

class WorkDetailFileStrip extends StatelessWidget {
  const WorkDetailFileStrip({
    super.key,
    required this.viewModel,
    required this.files,
  });

  final WorkDetailViewModel viewModel;
  final List<WorkAttachment> files;

  @override
  Widget build(BuildContext context) {
    if (files.length < 2) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final file = files[index];
          final isSelected = index == viewModel.selectedFileIndex;
          return Button(
            onPressed: () => viewModel.didSelectFileIndex(index),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                isSelected ? const Color(0xFF3A4558) : const Color(0xFF2A2D32),
              ),
            ),
            child: Text(file.fileName),
          );
        },
      ),
    );
  }
}
