import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../video_multimodal_view_model.dart';
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
            '재생 머리가 영상 막대 안에 있으면 그 파일을 재생합니다. ${viewModel.playheadLabel}',
            style: theme.typography.caption,
          ),
        ),
      );
    }
    final localMs = ((viewModel.playheadSeconds - video.startSeconds) * 1000)
        .round();
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: MultimodalVideoPlayer(
        key: ValueKey(video.mediaUrl),
        mediaUrl: video.mediaUrl,
        seekToMs: localMs,
        seekToken: viewModel.seekToken,
        playbackToken: viewModel.playbackToken,
        wantsPlayback: viewModel.wantsPlayback,
        captions: viewModel.activeVideoCaptions,
        onClock: (clock) {
          viewModel.didReceiveVideoClock(
            mediaUrl: video.mediaUrl,
            localSeconds: clock.position.inMilliseconds / 1000,
            durationSeconds: clock.duration.inMilliseconds / 1000,
            isPlaying: clock.isPlaying,
          );
        },
      ),
    );
  }
}
