import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../domain/entities/work_attachment.dart';
import '../../../core/themes/app_theme.dart';
import '../work_detail_view_model.dart';
import 'work_detail_empty_bar.dart';
import 'work_detail_file_strip.dart';
import 'work_detail_host.dart';
import 'work_detail_material_scope.dart';

class WorkDetailImageViewer extends StatefulWidget {
  const WorkDetailImageViewer({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  State<WorkDetailImageViewer> createState() => _WorkDetailImageViewerState();
}

class _WorkDetailImageViewerState extends State<WorkDetailImageViewer> {
  late final PhotoViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController();
  }

  @override
  void didUpdateWidget(covariant WorkDetailImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldId = oldWidget.viewModel.selectedAttachment?.attachmentId;
    final nextId = widget.viewModel.selectedAttachment?.attachmentId;
    if (oldId != nextId) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final files = viewModel.visibleAttachments;
    final attachment = viewModel.selectedAttachment;
    if (attachment == null) {
      return const WorkDetailEmptyBar(message: '이 작업에 이미지 파일이 없습니다');
    }
    final provider = WorkDetailImageFrame.providerFor(attachment);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkDetailFileStrip(viewModel: viewModel, files: files),
        const SizedBox(height: 8),
        Expanded(
          child: WorkDetailHost(
            packageName: 'photo_view + cached_network_image',
            attachment: attachment,
            index: viewModel.selectedFileIndex,
            total: files.length,
            child: Column(
              children: [
                Expanded(
                  child: ColoredBox(
                    color: AppTheme.SURFACE,
                    child: provider == null
                        ? const WorkDetailImageSwatch()
                        : WorkDetailMaterialScope(
                            child: PhotoView(
                              key: ValueKey(attachment.attachmentId),
                              controller: _controller,
                              enablePanAlways: false,
                              imageProvider: provider,
                              minScale: PhotoViewComputedScale.contained * 0.5,
                              maxScale: PhotoViewComputedScale.covered * 4,
                              initialScale: PhotoViewComputedScale.contained,
                              backgroundDecoration: const BoxDecoration(
                                color: AppTheme.SURFACE,
                              ),
                              errorBuilder: (_, _, _) =>
                                  const WorkDetailImageSwatch(),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Button(
                      onPressed: () =>
                          _controller.scale = (_controller.scale ?? 1) / 1.25,
                      child: const Text('축소'),
                    ),
                    Button(
                      onPressed: () => _controller.reset(),
                      child: const Text('맞춤'),
                    ),
                    Button(
                      onPressed: () =>
                          _controller.scale = (_controller.scale ?? 1) * 1.25,
                      child: const Text('확대'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkDetailImageFrame extends StatelessWidget {
  const WorkDetailImageFrame({super.key, required this.attachment});

  final WorkAttachment attachment;

  static ImageProvider? providerFor(WorkAttachment attachment) {
    final networkUrl = attachment.networkUrl;
    if (networkUrl != null) {
      return CachedNetworkImageProvider(networkUrl);
    }
    final assetPath = attachment.assetPath;
    if (assetPath != null) {
      return AssetImage(assetPath);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = providerFor(attachment);
    if (provider == null) {
      return const WorkDetailImageSwatch();
    }
    return Image(
      image: provider,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const WorkDetailImageSwatch(),
    );
  }
}

class WorkDetailImageSwatch extends StatelessWidget {
  const WorkDetailImageSwatch({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF32363C),
      child: Center(
        child: Icon(FluentIcons.photo2, size: 36, color: Color(0xFF8E949E)),
      ),
    );
  }
}
