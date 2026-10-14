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
    final video = viewModel.activeVideoBar;
    if (viewModel.isLoading) {
      return const ColoredBox(
        color: AppTheme.SURFACE,
        child: Center(child: ProgressRing()),
      );
    }
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
      mediaUrl: video.mediaUrl,
      seekToMs: viewModel.fileSeekMilliseconds(video),
      playbackRate: viewModel.playbackRateFor(video),
      captions: viewModel.activeVideoCaptions,
      frames: viewModel.activeVideoOverlayFrames,
    );
  }

  Widget _player({
    required String mediaUrl,
    required int seekToMs,
    required double playbackRate,
    required List<VideoCaption> captions,
    required List<VideoOverlayFrame> frames,
  }) {
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: MultimodalVideoPlayer(
        key: ValueKey(mediaUrl),
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
