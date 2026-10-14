import 'package:camera/camera.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../core/di/locator.dart';
import '../camera_recording_view_model.dart';

class CameraRecordingOverlay extends StatelessWidget {
  const CameraRecordingOverlay({
    super.key,
    required this.jobId,
    required this.onUploaded,
    required this.onClose,
    required this.isMinimized,
    required this.onMove,
    required this.onToggleMinimized,
  });

  static const double PANEL_WIDTH = 340;
  static const double PREVIEW_HEIGHT = 180;

  final String jobId;
  final Future<void> Function() onUploaded;
  final VoidCallback onClose;
  final bool isMinimized;
  final void Function(double dx, double dy) onMove;
  final VoidCallback onToggleMinimized;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CameraRecordingViewModel>(
        param1: CameraRecordingArgs(jobId: jobId, onUploaded: onUploaded),
      )..prepare(),
      child: _CameraRecordingCard(
        onClose: onClose,
        isMinimized: isMinimized,
        onMove: onMove,
        onToggleMinimized: onToggleMinimized,
      ),
    );
  }
}

class _CameraRecordingCard extends StatelessWidget {
  const _CameraRecordingCard({
    required this.onClose,
    required this.isMinimized,
    required this.onMove,
    required this.onToggleMinimized,
  });

  final VoidCallback onClose;
  final bool isMinimized;
  final void Function(double dx, double dy) onMove;
  final VoidCallback onToggleMinimized;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraRecordingViewModel>();
    final controller = viewModel.cameraController;
    final theme = FluentTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: theme.resources.solidBackgroundFillColorBase,
          child: SizedBox(
            width: CameraRecordingOverlay.PANEL_WIDTH,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onPanUpdate: (details) =>
                      onMove(details.delta.dx, details.delta.dy),
                  child: ColoredBox(
                    color: theme.resources.cardBackgroundFillColorSecondary,
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Icon(
                            FluentIcons.gripper_dots_vertical,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Expanded(child: Text('카메라 녹화')),
                          IconButton(
                            icon: Icon(
                              isMinimized
                                  ? FluentIcons.chevron_down
                                  : FluentIcons.chevron_up,
                              size: 12,
                            ),
                            onPressed: onToggleMinimized,
                          ),
                          IconButton(
                            icon: const Icon(
                              FluentIcons.chrome_close,
                              size: 12,
                            ),
                            onPressed: onClose,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isMinimized)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (viewModel.noticeText.isNotEmpty)
                          InfoBar(
                            title: Text(
                              viewModel.isNoticeError ? '녹화 실패' : '안내',
                            ),
                            content: Text(viewModel.noticeText),
                            severity: viewModel.isNoticeError
                                ? InfoBarSeverity.error
                                : InfoBarSeverity.info,
                          ),
                        if (viewModel.noticeText.isNotEmpty)
                          const SizedBox(height: 12),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SizedBox(
                            height: CameraRecordingOverlay.PREVIEW_HEIGHT,
                            child: controller == null
                                ? const Center(child: ProgressRing())
                                : CameraPreview(controller),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (viewModel.isUploading) const ProgressBar(),
                        if (viewModel.isUploading) const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton(
                              onPressed: viewModel.canStart
                                  ? viewModel.didTapStart
                                  : null,
                              child: const Text('시작'),
                            ),
                            Button(
                              onPressed: viewModel.canStop
                                  ? viewModel.didTapStop
                                  : null,
                              child: const Text('정지'),
                            ),
                            Button(
                              onPressed: viewModel.canSaveVideo
                                  ? viewModel.didTapSaveVideo
                                  : null,
                              child: const Text('영상 저장'),
                            ),
                            Button(
                              onPressed: viewModel.canSaveAudio
                                  ? viewModel.didTapSaveAudio
                                  : null,
                              child: const Text('음성 저장'),
                            ),
                            FilledButton(
                              onPressed: viewModel.canUpload
                                  ? viewModel.didTapUpload
                                  : null,
                              child: Text(
                                viewModel.videoUploaded &&
                                        viewModel.audioUploaded
                                    ? '업로드 완료'
                                    : '녹화 파일 업로드',
                              ),
                            ),
                            if (viewModel.canRetry)
                              Button(
                                onPressed: viewModel.didTapRetry,
                                child: const Text('다시 시도'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
