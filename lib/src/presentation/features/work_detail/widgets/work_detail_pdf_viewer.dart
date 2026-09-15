import 'package:fluent_ui/fluent_ui.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../core/themes/app_theme.dart';
import '../work_detail_view_model.dart';
import 'work_detail_empty_bar.dart';
import 'work_detail_file_strip.dart';
import 'work_detail_host.dart';
import 'work_detail_material_scope.dart';

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
    final assetPath = attachment.assetPath;
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

class WorkDetailPdfrxStage extends StatefulWidget {
  const WorkDetailPdfrxStage({super.key, required this.assetPath});

  final String assetPath;

  @override
  State<WorkDetailPdfrxStage> createState() => _WorkDetailPdfrxStageState();
}

class _WorkDetailPdfrxStageState extends State<WorkDetailPdfrxStage> {
  late final PdfViewerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _controller.addListener(_didChangePdf);
  }

  @override
  void dispose() {
    _controller.removeListener(_didChangePdf);
    super.dispose();
  }

  void _didChangePdf() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _didTapPrevious() async {
    if (!_controller.isReady) {
      return;
    }
    final pageNumber = _controller.pageNumber ?? 1;
    if (pageNumber <= 1) {
      return;
    }
    await _controller.goToPage(pageNumber: pageNumber - 1);
  }

  Future<void> _didTapNext() async {
    if (!_controller.isReady) {
      return;
    }
    final pageNumber = _controller.pageNumber ?? 1;
    if (pageNumber >= _controller.pageCount) {
      return;
    }
    await _controller.goToPage(pageNumber: pageNumber + 1);
  }

  Future<void> _didTapZoomOut() async {
    if (!_controller.isReady) {
      return;
    }
    await _controller.zoomDown();
  }

  Future<void> _didTapZoomIn() async {
    if (!_controller.isReady) {
      return;
    }
    await _controller.zoomUp();
  }

  @override
  Widget build(BuildContext context) {
    final pageNumber = _controller.isReady ? (_controller.pageNumber ?? 1) : 1;
    final pageCount = _controller.isReady ? _controller.pageCount : 0;
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Button(onPressed: _didTapPrevious, child: const Text('이전 쪽')),
            Text(pageCount == 0 ? '불러오는 중' : '$pageNumber / $pageCount'),
            Button(onPressed: _didTapNext, child: const Text('다음 쪽')),
            Button(onPressed: _didTapZoomOut, child: const Text('축소')),
            Button(onPressed: _didTapZoomIn, child: const Text('확대')),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: WorkDetailMaterialScope(
            child: ColoredBox(
              color: AppTheme.SURFACE,
              child: PdfViewer.asset(
                widget.assetPath,
                controller: _controller,
                params: const PdfViewerParams(
                  backgroundColor: AppTheme.SURFACE,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
