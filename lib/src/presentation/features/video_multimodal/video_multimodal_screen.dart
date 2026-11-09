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
          locator<VideoMultimodalViewModel>(param1: jobId)..openTimeline(),
      child: const _VideoMultimodalBody(),
    );
  }
}

class _VideoMultimodalBody extends StatelessWidget {
  const _VideoMultimodalBody();

  @override
  Widget build(BuildContext context) {
    final coordinator = context.read<AppCoordinator>();
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _VectorSaveNoticeHost(),
              _ToolbarHost(
                onBack: () =>
                    coordinator.didTapBackFromVideoMultimodal(context),
              ),
              const _ErrorHost(),
              const _NoticeHost(),
              const Expanded(child: _WorkspaceHost()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarHost extends StatelessWidget {
  const _ToolbarHost({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    context.select<VideoMultimodalViewModel, String>(_toolbarKey);
    final viewModel = context.read<VideoMultimodalViewModel>();
    return MultimodalPageToolbar(
      viewModel: viewModel,
      title: viewModel.pageTitle,
      onBack: onBack,
    );
  }
}

class _ErrorHost extends StatelessWidget {
  const _ErrorHost();

  @override
  Widget build(BuildContext context) {
    final hasError = context.select<VideoMultimodalViewModel, bool>(
      (viewModel) => viewModel.hasError,
    );
    if (!hasError) {
      return const SizedBox.shrink();
    }
    final viewModel = context.read<VideoMultimodalViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: InfoBar(
        title: const Text('타임라인 조회 실패'),
        content: Text(viewModel.errorMessage),
        severity: InfoBarSeverity.error,
        action: Button(
          onPressed: viewModel.openTimeline,
          child: const Text('다시 시도'),
        ),
      ),
    );
  }
}

class _NoticeHost extends StatelessWidget {
  const _NoticeHost();

  @override
  Widget build(BuildContext context) {
    final hasNotice = context.select<VideoMultimodalViewModel, bool>(
      (viewModel) => viewModel.hasNotice,
    );
    if (!hasNotice) {
      return const SizedBox.shrink();
    }
    final viewModel = context.read<VideoMultimodalViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: InfoBar(
        title: const Text('안내'),
        content: Text(viewModel.noticeText),
        severity: InfoBarSeverity.warning,
        onClose: viewModel.didDismissNotice,
      ),
    );
  }
}

class _WorkspaceHost extends StatelessWidget {
  const _WorkspaceHost();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _StageBoardHost()),
            _SidePanelHost(),
          ],
        ),
        _InferenceHost(),
        _CameraRecordingHost(),
      ],
    );
  }
}

class _StageBoardHost extends StatelessWidget {
  const _StageBoardHost();

  @override
  Widget build(BuildContext context) {
    context.select<VideoMultimodalViewModel, String>(_stageBoardKey);
    final viewModel = context.read<VideoMultimodalViewModel>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBoardHeight = (constraints.maxHeight - 100).clamp(
          VideoMultimodalViewModel.MIN_TIMELINE_HEIGHT,
          VideoMultimodalViewModel.MAX_TIMELINE_HEIGHT,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: MultimodalVideoStage(viewModel: viewModel)),
            MultimodalTimelineBoard(
              viewModel: viewModel,
              maxHeight: maxBoardHeight,
            ),
          ],
        );
      },
    );
  }
}

class _SidePanelHost extends StatelessWidget {
  const _SidePanelHost();

  @override
  Widget build(BuildContext context) {
    final side = context.select<VideoMultimodalViewModel, VideoMultimodalSide>(
      (viewModel) => viewModel.side,
    );
    if (side == VideoMultimodalSide.none) {
      return const SizedBox.shrink();
    }
    context.select<VideoMultimodalViewModel, String>(_sidePanelKey);
    final viewModel = context.read<VideoMultimodalViewModel>();
    return MultimodalSidePanel(
      viewModel: viewModel,
      onClose: viewModel.didTapCloseSide,
    );
  }
}

class _InferenceHost extends StatelessWidget {
  const _InferenceHost();

  @override
  Widget build(BuildContext context) {
    context.select<VideoMultimodalViewModel, String>(_inferenceKey);
    final viewModel = context.read<VideoMultimodalViewModel>();
    return MultimodalInferencePanel(viewModel: viewModel);
  }
}

class _CameraRecordingHost extends StatelessWidget {
  const _CameraRecordingHost();

  @override
  Widget build(BuildContext context) {
    final isOpen = context.select<VideoMultimodalViewModel, bool>(
      (viewModel) => viewModel.isCameraRecordingOpen,
    );
    if (!isOpen) {
      return const SizedBox.shrink();
    }
    context.select<VideoMultimodalViewModel, String>(_cameraKey);
    final viewModel = context.read<VideoMultimodalViewModel>();
    return Positioned(
      left: viewModel.cameraRecordingOffsetX,
      top: viewModel.cameraRecordingOffsetY,
      child: CameraRecordingOverlay(
        jobId: viewModel.jobId,
        onUploaded: viewModel.refreshAfterRecordingUpload,
        onRecordingPlaced: viewModel.didPlaceUploadedRecording,
        capturesScreenComment: true,
        onRecordingStarted: viewModel.didBeginScreenCommentCapture,
        takeScreenCommentContext: viewModel.takeScreenCommentContext,
        onClose: viewModel.didCloseCameraRecording,
        isMinimized: viewModel.isCameraRecordingMinimized,
        onMove: viewModel.didMoveCameraRecording,
        onToggleMinimized: viewModel.didToggleCameraRecordingMinimized,
      ),
    );
  }
}

class _VectorSaveNoticeHost extends StatefulWidget {
  const _VectorSaveNoticeHost();

  @override
  State<_VectorSaveNoticeHost> createState() => _VectorSaveNoticeHostState();
}

class _VectorSaveNoticeHostState extends State<_VectorSaveNoticeHost> {
  VideoMultimodalViewModel? _viewModel;
  bool _isOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = context.read<VideoMultimodalViewModel>();
    if (identical(_viewModel, viewModel)) {
      return;
    }
    _viewModel?.removeListener(_onViewModelChanged);
    _viewModel = viewModel;
    _viewModel?.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final viewModel = _viewModel;
    if (viewModel == null) {
      return;
    }
    final trackCount = viewModel.vectorSaveNoticeTrackCount;
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
      viewModel.didDismissVectorSaveNotice();
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

String _toolbarKey(VideoMultimodalViewModel viewModel) {
  return [
    viewModel.isLoading,
    viewModel.side,
    viewModel.pageTitle,
    viewModel.isCameraRecordingOpen,
  ].join('|');
}

String _stageBoardKey(VideoMultimodalViewModel viewModel) {
  return [
    viewModel.playheadSeconds,
    viewModel.seekToken,
    viewModel.playbackToken,
    viewModel.wantsPlayback,
    viewModel.selectedClipId,
    viewModel.timelineBoardHeight,
    viewModel.isLoading,
    viewModel.spanSeconds,
    viewModel.monitoredTrackIds.join(','),
    viewModel.focusedMonitorTrackId,
    viewModel.coveringAudioMediaUrl,
    viewModel.coveringAudioSeekMilliseconds,
    viewModel.chartExpandedClipId,
    viewModel.expandedChartKind,
    viewModel.isTimeseriesChartLoading,
    viewModel.isAudioChartLoading,
    viewModel.timeseriesSeries.doesHaveAnySeries,
    viewModel.audioAmplitudes.length,
    viewModel.isClipDetailLoading,
    viewModel.clipDetailFields.length,
    viewModel.showsMissingTargetVideoBanner,
    viewModel.timelineTracks.length,
    viewModel.timelineClips.length,
  ].join('|');
}

String _sidePanelKey(VideoMultimodalViewModel viewModel) {
  return [
    viewModel.side,
    viewModel.selectedClipId,
    viewModel.isClipDetailLoading,
    viewModel.clipDetailFields.length,
    viewModel.clipDetailMessage,
    viewModel.commentListReloadCount,
    viewModel.assetsSearchQuery,
    viewModel.isLoadingAssetsPage,
    viewModel.assetsPageIndex,
    viewModel.assetsPageRows.length,
    viewModel.isLoadingLabels,
    viewModel.isLoadingAskHistory,
    viewModel.isAsking,
    viewModel.askTurns.length,
    viewModel.labelRoots.length,
  ].join('|');
}

String _inferenceKey(VideoMultimodalViewModel viewModel) {
  return [
    viewModel.isInferenceVisible,
    viewModel.inferencePhase,
    viewModel.inferenceOffsetX,
    viewModel.inferenceOffsetY,
    viewModel.isInferenceMinimized,
    viewModel.inferenceMessage,
    viewModel.inferenceProgressValue,
    viewModel.inferenceModelName,
  ].join('|');
}

String _cameraKey(VideoMultimodalViewModel viewModel) {
  return [
    viewModel.isCameraRecordingOpen,
    viewModel.isCameraRecordingMinimized,
    viewModel.cameraRecordingOffsetX,
    viewModel.cameraRecordingOffsetY,
  ].join('|');
}
