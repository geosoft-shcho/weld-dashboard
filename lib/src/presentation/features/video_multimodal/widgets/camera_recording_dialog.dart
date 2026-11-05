import 'package:camera/camera.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../core/di/locator.dart';
import '../../../core/widgets/lookup_search_field.dart';
import '../camera_recording_view_model.dart';
import 'vector_db_saved_dialog.dart';

class CameraRecordingOverlay extends StatelessWidget {
  const CameraRecordingOverlay({
    super.key,
    required this.jobId,
    required this.onUploaded,
    required this.onRecordingPlaced,
    this.onUploadCompleted,
    this.passId = '',
    this.capturesScreenComment = false,
    this.onRecordingStarted,
    this.takeScreenCommentContext,
    required this.onClose,
    required this.isMinimized,
    required this.onMove,
    required this.onToggleMinimized,
  });

  static const double PANEL_WIDTH = 340;
  static const double PREVIEW_HEIGHT = 180;

  final String jobId;
  final String passId;
  final Future<void> Function() onUploaded;
  final Future<void> Function({required String assetId, required bool isVideo})
  onRecordingPlaced;
  final Future<void> Function()? onUploadCompleted;
  final bool capturesScreenComment;
  final void Function()? onRecordingStarted;
  final List<Map<String, Object?>> Function()? takeScreenCommentContext;
  final VoidCallback onClose;
  final bool isMinimized;
  final void Function(double dx, double dy) onMove;
  final VoidCallback onToggleMinimized;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CameraRecordingViewModel>(
        param1: CameraRecordingArgs(
          jobId: jobId,
          passId: passId,
          onUploaded: onUploaded,
          onRecordingPlaced: onRecordingPlaced,
          onUploadCompleted: onUploadCompleted,
          capturesScreenComment: capturesScreenComment,
          onRecordingStarted: onRecordingStarted,
          takeScreenCommentContext: takeScreenCommentContext,
        ),
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

class CameraRecordingScope extends StatefulWidget {
  const CameraRecordingScope({
    super.key,
    required this.jobId,
    required this.builder,
    this.passId = '',
    this.capturesScreenComment = false,
    this.commentScreen = '',
  });

  final String jobId;
  final String passId;
  final bool capturesScreenComment;
  final String commentScreen;
  final Widget Function(BuildContext context, Widget recordButton) builder;

  @override
  State<CameraRecordingScope> createState() => _CameraRecordingScopeState();
}

class _CameraRecordingScopeState extends State<CameraRecordingScope> {
  static const double _START_X = 24;
  static const double _START_Y = 24;

  bool _isOpen = false;
  bool _isMinimized = false;
  double _offsetX = _START_X;
  double _offsetY = _START_Y;
  String _openedPassId = '';

  void _open() {
    setState(() {
      _isOpen = true;
      _isMinimized = false;
      _openedPassId = widget.passId;
    });
  }

  List<Map<String, Object?>> _takeScreenCommentContext() {
    final row = <String, Object?>{'t_ms': 0, 'screen': widget.commentScreen};
    final jobId = int.tryParse(widget.jobId);
    if (jobId != null) {
      row['job_id'] = jobId;
    }
    final passId = int.tryParse(_openedPassId);
    if (passId != null && passId != 0) {
      row['pass_id'] = passId;
    }
    return [row];
  }

  Future<void> _showVectorSaved() async {
    if (!mounted) {
      return;
    }
    await showVectorDbSavedDialog(context, changedTrackCount: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(
          context,
          Button(
            onPressed: _isOpen ? null : _open,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.video, size: 16),
                SizedBox(width: 8),
                Text('녹화'),
              ],
            ),
          ),
        ),
        if (_isOpen)
          Positioned(
            left: _offsetX,
            top: _offsetY,
            child: CameraRecordingOverlay(
              jobId: widget.jobId,
              passId: int.tryParse(_openedPassId) == null ? '' : _openedPassId,
              capturesScreenComment: widget.capturesScreenComment,
              takeScreenCommentContext: widget.capturesScreenComment
                  ? _takeScreenCommentContext
                  : null,
              onUploaded: () async {},
              onRecordingPlaced:
                  ({required String assetId, required bool isVideo}) async {},
              onUploadCompleted: _showVectorSaved,
              onClose: () => setState(() => _isOpen = false),
              isMinimized: _isMinimized,
              onMove: (dx, dy) {
                setState(() {
                  _offsetX = (_offsetX + dx).clamp(0, 1200);
                  _offsetY = (_offsetY + dy).clamp(0, 800);
                });
              },
              onToggleMinimized: () =>
                  setState(() => _isMinimized = !_isMinimized),
            ),
          ),
      ],
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
                        if (viewModel.capturesScreenComment) ...[
                          LookupSearchField(
                            value: viewModel.commentBody,
                            hintText: '녹화에 덧붙일 글 (없어도 됩니다)',
                            onChanged: viewModel.didChangeCommentBody,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (viewModel.isUploading) ...[
                          const ProgressBar(),
                          if (viewModel.noticeText.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              viewModel.noticeText,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.resources.textFillColorSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                        ],
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
