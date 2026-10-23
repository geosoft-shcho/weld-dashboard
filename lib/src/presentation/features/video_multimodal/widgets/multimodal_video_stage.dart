import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../video_caption.dart';
import '../video_multimodal_view_model.dart';
import '../video_overlay_frame.dart';
import 'multimodal_video_player.dart';

class MultimodalVideoStage extends StatelessWidget {
  const MultimodalVideoStage({super.key, required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    if (viewModel.isLoading) {
      return const ColoredBox(
        color: AppTheme.SURFACE,
        child: Center(child: ProgressRing()),
      );
    }
    final monitoredTrackIds = viewModel.monitoredTrackIds;
    if (monitoredTrackIds.isEmpty) {
      return _singleLegacy(theme);
    }
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: _grid(monitoredTrackIds),
    );
  }

  /// 모니터 미선택 시: 기존과 같이 활성 트랙 영상 1칸.
  Widget _singleLegacy(FluentThemeData theme) {
    final video = viewModel.activeVideoBar;
    if (video == null) {
      return ColoredBox(
        color: AppTheme.SURFACE,
        child: Center(
          child: Text(
            '고른 트랙에서 이 시각을 덮는 영상이 없습니다. ${viewModel.playheadLabel}',
            style: theme.typography.caption,
          ),
        ),
      );
    }
    return _player(
      trackId: '',
      mediaUrl: video.mediaUrl,
      seekToMs: viewModel.fileSeekMilliseconds(video),
      playbackRate: viewModel.playbackRateFor(video),
      captions: viewModel.activeVideoCaptions,
      frames: viewModel.activeVideoOverlayFrames,
    );
  }

  Widget _grid(List<String> trackIds) {
    final count = trackIds.length;
    if (count == 1) {
      return _slot(trackIds[0]);
    }
    if (count == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _slot(trackIds[0])),
          Expanded(child: _slot(trackIds[1])),
        ],
      );
    }
    if (count == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _slot(trackIds[0])),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _slot(trackIds[1])),
                Expanded(child: _slot(trackIds[2])),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _slot(trackIds[0])),
              Expanded(child: _slot(trackIds[1])),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _slot(trackIds[2])),
              Expanded(child: _slot(trackIds[3])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _slot(String trackId) {
    final focused = viewModel.isMonitorSlotFocused(trackId);
    final video = viewModel.videoBarForTrack(trackId);
    return GestureDetector(
      onTap: () => viewModel.didTapFocusMonitorSlot(trackId),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: focused ? AppTheme.ACCENT_STEEL : const Color(0xFF3E424A),
            width: focused ? 2 : 1,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (video == null)
              ColoredBox(
                color: AppTheme.SURFACE,
                child: Center(
                  child: Text(
                    '이 시각에 영상 없음 · ${viewModel.playheadLabel}',
                    style: const TextStyle(color: AppTheme.INK, fontSize: 12),
                  ),
                ),
              )
            else
              _player(
                trackId: trackId,
                mediaUrl: video.mediaUrl,
                seekToMs: viewModel.fileSeekMilliseconds(video),
                playbackRate: viewModel.playbackRateFor(video),
                captions: viewModel.captionsForTrack(trackId),
                frames: viewModel.overlayFramesForTrack(trackId),
              ),
            Positioned(
              left: 6,
              top: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.SURFACE.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    viewModel.monitorTrackLabel(trackId),
                    style: const TextStyle(
                      color: AppTheme.INK,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _player({
    required String trackId,
    required String mediaUrl,
    required int seekToMs,
    required double playbackRate,
    required List<VideoCaption> captions,
    required List<VideoOverlayFrame> frames,
  }) {
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: MultimodalVideoPlayer(
        key: ValueKey('$trackId|$mediaUrl'),
        mediaUrl: mediaUrl,
        seekToMs: seekToMs,
        playbackRate: playbackRate,
        seekToken: viewModel.seekToken,
        playbackToken: viewModel.playbackToken,
        wantsPlayback: viewModel.wantsPlayback,
        captions: captions,
        frames: frames,
        onClock: (clock) {
          viewModel.didReceiveVideoClock(
            mediaUrl: mediaUrl,
            localSeconds: clock.position.inMilliseconds / 1000,
            isPlaying: clock.isPlaying,
          );
        },
      ),
    );
  }
}
