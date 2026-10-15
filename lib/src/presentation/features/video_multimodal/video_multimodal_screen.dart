import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../navigation/app_coordinator.dart';
import 'video_multimodal_view_model.dart';
import 'widgets/camera_recording_dialog.dart';
import 'widgets/multimodal_inference_panel.dart';
import 'widgets/multimodal_page_toolbar.dart';
import 'widgets/multimodal_side_panel.dart';
import 'widgets/multimodal_timeline_board.dart';
import 'widgets/multimodal_video_stage.dart';
import 'widgets/vector_db_saved_dialog.dart';

class VideoMultimodalScreen extends StatelessWidget {
  const VideoMultimodalScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<VideoMultimodalViewModel>(param1: jobId)..loadAttachments(),
      child: const _VideoMultimodalBody(),
    );
  }
}

class _VideoMultimodalBody extends StatelessWidget {
  const _VideoMultimodalBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VideoMultimodalViewModel>();
    final coordinator = context.read<AppCoordinator>();
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _VectorSaveNoticeListener(viewModel: viewModel),
              MultimodalPageToolbar(
                viewModel: viewModel,
                title: viewModel.pageTitle,
                onBack: () =>
                    coordinator.didTapBackFromVideoMultimodal(context),
              ),
              if (viewModel.hasError)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: InfoBar(
                    title: const Text('타임라인 조회 실패'),
                    content: Text(viewModel.errorMessage),
                    severity: InfoBarSeverity.error,
                    action: Button(
                      onPressed: viewModel.loadAttachments,
                      child: const Text('다시 시도'),
                    ),
                  ),
                ),
              if (viewModel.hasNotice)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: InfoBar(
                    title: const Text('안내'),
                    content: Text(viewModel.noticeText),
                    severity: InfoBarSeverity.warning,
                    onClose: viewModel.didDismissNotice,
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: MultimodalVideoStage(
                                  viewModel: viewModel,
                                ),
                              ),
                              MultimodalTimelineBoard(viewModel: viewModel),
                            ],
                          ),
                        ),
                        if (viewModel.side != VideoMultimodalSide.none)
                          MultimodalSidePanel(
                            viewModel: viewModel,
                            onClose: viewModel.didTapCloseSide,
                          ),
                      ],
                    ),
                    MultimodalInferencePanel(viewModel: viewModel),
                    if (viewModel.isCameraRecordingOpen)
                      Positioned(
                        left: viewModel.cameraRecordingOffsetX,
                        top: viewModel.cameraRecordingOffsetY,
                        child: CameraRecordingOverlay(
                          jobId: viewModel.jobId,
                          onUploaded: viewModel.loadAttachments,
                          onRecordingPlaced:
                              viewModel.didPlaceUploadedRecording,
                          onClose: viewModel.didCloseCameraRecording,
                          isMinimized: viewModel.isCameraRecordingMinimized,
                          onMove: viewModel.didMoveCameraRecording,
                          onToggleMinimized:
                              viewModel.didToggleCameraRecordingMinimized,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VectorSaveNoticeListener extends StatefulWidget {
  const _VectorSaveNoticeListener({required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<_VectorSaveNoticeListener> createState() =>
      _VectorSaveNoticeListenerState();
}

class _VectorSaveNoticeListenerState extends State<_VectorSaveNoticeListener> {
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void didUpdateWidget(_VectorSaveNoticeListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) {
      return;
    }
    oldWidget.viewModel.removeListener(_onViewModelChanged);
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final trackCount = widget.viewModel.vectorSaveNoticeTrackCount;
    if (trackCount == null || _isOpen) {
      return;
    }
    _isOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      await showVectorDbSavedDialog(context, changedTrackCount: trackCount);
      if (!mounted) {
        return;
      }
      widget.viewModel.didDismissVectorSaveNotice();
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
