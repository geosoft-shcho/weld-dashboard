import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Chewie 데스크톱 기본 바와 같되, 재생바·버튼 줄 가로 여백을 동일하게 둔다.
/// 재생/정지는 [togglePlaybackHandler]로 ViewModel과 맞춘다.
class MultimodalDesktopControls extends StatefulWidget {
  const MultimodalDesktopControls({
    super.key,
    required this.togglePlaybackHandler,
  });

  static const double horizontalPadding = 20;

  final VoidCallback togglePlaybackHandler;

  @override
  State<MultimodalDesktopControls> createState() =>
      _MultimodalDesktopControlsState();
}

class _MultimodalDesktopControlsState extends State<MultimodalDesktopControls> {
  static const Duration _hideDelay = Duration(seconds: 2);

  ChewieController? _chewie;
  VideoPlayerController? _video;
  Timer? _hideTimer;
  bool _hidden = false;
  bool _pointerInside = false;
  double? _volumeBeforeMute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final chewie = ChewieController.of(context);
    final video = chewie.videoPlayerController;
    _chewie = chewie;
    if (_video != video) {
      _video?.removeListener(_onVideoTick);
      _video = video;
      _video?.addListener(_onVideoTick);
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _video?.removeListener(_onVideoTick);
    super.dispose();
  }

  void _onVideoTick() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _showControls() {
    _hideTimer?.cancel();
    if (_hidden) {
      setState(() => _hidden = false);
    }
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_pointerInside) {
      return;
    }
    final video = _video;
    if (video == null || !video.value.isPlaying) {
      return;
    }
    _hideTimer = Timer(_hideDelay, () {
      if (!mounted || _pointerInside) {
        return;
      }
      setState(() => _hidden = true);
    });
  }

  void _onPointerEnter() {
    _pointerInside = true;
    _showControls();
  }

  void _onPointerExit() {
    _pointerInside = false;
    _scheduleHide();
  }

  void _togglePlay() {
    _showControls();
    widget.togglePlaybackHandler();
  }

  Future<void> _toggleMute() async {
    final video = _video;
    if (video == null) {
      return;
    }
    _showControls();
    if (video.value.volume > 0) {
      _volumeBeforeMute = video.value.volume;
      await video.setVolume(0);
    } else {
      await video.setVolume(_volumeBeforeMute ?? 0.5);
    }
  }

  void _toggleFullscreen() {
    final chewie = _chewie;
    if (chewie == null) {
      return;
    }
    _showControls();
    chewie.toggleFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    final chewie = _chewie;
    final video = _video;
    if (chewie == null || video == null) {
      return const SizedBox.expand();
    }
    final value = video.value;
    final colors =
        chewie.materialProgressColors ??
        ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.secondary,
          handleColor: Theme.of(context).colorScheme.secondary,
          bufferedColor: Theme.of(
            context,
          ).colorScheme.surface.withValues(alpha: 0.5),
          backgroundColor: Theme.of(
            context,
          ).disabledColor.withValues(alpha: 0.5),
        );

    return MouseRegion(
      cursor: _hidden ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => _onPointerEnter(),
      onHover: (_) => _onPointerEnter(),
      onExit: (_) => _onPointerExit(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _togglePlay,
        child: AbsorbPointer(
          absorbing: _hidden,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: _hidden ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ColoredBox(
                    color: const Color(0x66000000),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  MultimodalDesktopControls.horizontalPadding,
                            ),
                            child: SizedBox(
                              height: 28,
                              child: MaterialVideoProgressBar(
                                video,
                                colors: colors,
                                height: 28,
                                draggableProgressBar:
                                    chewie.draggableProgressBar,
                                onDragStart: _showControls,
                                onDragUpdate: _showControls,
                                onDragEnd: _showControls,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              MultimodalDesktopControls.horizontalPadding,
                              0,
                              MultimodalDesktopControls.horizontalPadding,
                              8,
                            ),
                            child: Row(
                              children: [
                                _iconButton(
                                  value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  _togglePlay,
                                ),
                                if (chewie.allowMuting)
                                  _iconButton(
                                    value.volume > 0
                                        ? Icons.volume_up
                                        : Icons.volume_off,
                                    _toggleMute,
                                  ),
                                Text(
                                  '${_clock(value.position)} / ${_clock(value.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                if (chewie.allowFullScreen)
                                  _iconButton(
                                    chewie.isFullScreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    _toggleFullscreen,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }

  String _clock(Duration duration) {
    final total = duration.inSeconds.clamp(0, 86400);
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
