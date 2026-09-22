import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/pdfrx_document_source.dart';
import '../../../core/widgets/pdfrx_document_viewer.dart';
import '../work_detail_view_model.dart';
import 'work_detail_empty_bar.dart';
import 'work_detail_file_strip.dart';
import 'work_detail_host.dart';

class WorkDetailPdfViewer extends StatelessWidget {
  const WorkDetailPdfViewer({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final files = viewModel.visibleAttachments;
    final attachment = viewModel.selectedAttachment;
    if (attachment == null) {
      return const WorkDetailEmptyBar(message: '이 작업에 PDF 파일이 없습니다');
    }
    final assetPath = attachment.networkUrl ?? attachment.assetPath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkDetailFileStrip(viewModel: viewModel, files: files),
        const SizedBox(height: 8),
        Expanded(
          child: WorkDetailHost(
            packageName: 'pdfrx',
            attachment: attachment,
            index: viewModel.selectedFileIndex,
            total: files.length,
            child: assetPath == null
                ? const Center(child: Text('열 PDF 파일이 없습니다'))
                : WorkDetailPdfrxStage(
                    key: ValueKey(attachment.attachmentId),
                    assetPath: assetPath,
                  ),
          ),
        ),
      ],
    );
  }
}

class WorkDetailPdfrxStage extends StatelessWidget {
  const WorkDetailPdfrxStage({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return PdfrxDocumentViewer(
      source:
          resolvePdfrxDocumentSource(assetPath) ??
          PdfrxDocumentSource.asset(assetPath),
      backgroundColor: AppTheme.SURFACE,
      expandViewport: true,
    );
  }
}
