import 'package:fluent_ui/fluent_ui.dart';

import '../work_detail_view_model.dart';
import 'work_detail_empty_bar.dart';
import 'work_detail_file_strip.dart';
import 'work_detail_host.dart';

class WorkDetailTextViewer extends StatelessWidget {
  const WorkDetailTextViewer({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final files = viewModel.visibleAttachments;
    final attachment = viewModel.selectedAttachment;
    if (attachment == null) {
      return const WorkDetailEmptyBar(message: '이 작업에 텍스트 파일이 없습니다');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkDetailFileStrip(viewModel: viewModel, files: files),
        const SizedBox(height: 8),
        Expanded(
          child: WorkDetailHost(
            packageName: 'SelectableText',
            attachment: attachment,
            index: viewModel.selectedFileIndex,
            total: files.length,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                attachment.displayText,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Mono',
                  fontFamilyFallback: ['Menlo', 'Consolas', 'monospace'],
                  height: 1.45,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
