import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../work_detail/widgets/work_detail_chewie_stage.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import 'multimodal_studio_palette.dart';

class MultimodalVideoPlayer extends StatefulWidget {
  const MultimodalVideoPlayer({
    super.key,
    required this.mediaUrl,
    required this.seekToMs,
    required this.seekToken,
    required this.playbackToken,
    required this.wantsPlayback,
    required this.onClock,
  });

  final String mediaUrl;
  final int seekToMs;
  final int seekToken;
  final int playbackToken;
  final bool wantsPlayback;
  final ValueChanged<VideoPlaybackClock> onClock;

  @override
  State<MultimodalVideoPlayer> createState() => _MultimodalVideoPlayerState();
}

class _MultimodalVideoPlayerState extends State<MultimodalVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Timer? _clockTimer;
  VoidCallback? _clockListener;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void didUpdateWidget(covariant MultimodalVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaUrl != widget.mediaUrl) {
      _open();
      return;
    }
    if (oldWidget.seekToken != widget.seekToken) {
      _seekTo(widget.seekToMs);
    }
    if (oldWidget.playbackToken != widget.playbackToken) {
      _applyPlayback();
    }
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  Future<void> _open() async {
    _release();
    setState(() => _errorText = '');
    final source = widget.mediaUrl;
    final videoController =
        source.startsWith('http://') || source.startsWith('https://')
        ? VideoPlayerController.networkUrl(Uri.parse(source))
        : VideoPlayerController.asset(source);
    try {
      await videoController.initialize();
      if (!mounted) {
        await videoController.dispose();
        return;
      }
      final ratio = videoController.value.aspectRatio == 0
          ? 16 / 9
          : videoController.value.aspectRatio;
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        aspectRatio: ratio,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        draggableProgressBar: true,
        customControls: const MaterialDesktopControls(),
        overlay: const _AnnotationOverlay(),
        materialProgressColors: ChewieProgressColors(
          playedColor: MultimodalStudioPalette.GRAPE_500,
          handleColor: MultimodalStudioPalette.GRAPE_500,
          bufferedColor: MultimodalStudioPalette.SAND_600,
          backgroundColor: MultimodalStudioPalette.SAND_300,
        ),
      );
      setState(() {
        _videoController = videoController;
        _chewieController = chewieController;
      });
      _watch(videoController);
      await _seekTo(widget.seekToMs);
      if (widget.wantsPlayback) {
        await videoController.play();
      }
    } catch (error) {
      await videoController.dispose();
      if (!mounted) {
        return;
      }
      setState(() => _errorText = error.toString());
    }
  }

  void _watch(VideoPlayerController controller) {
    void emit() {
      if (!mounted || !controller.value.isInitialized) {
        return;
      }
      final value = controller.value;
      widget.onClock(
        VideoPlaybackClock(
          position: value.position,
          duration: value.duration,
          isPlaying: value.isPlaying,
        ),
      );
    }

    _clockListener = emit;
    controller.addListener(emit);
    _clockTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!controller.value.isPlaying) {
        return;
      }
      emit();
    });
    emit();
  }

  Future<void> _seekTo(int milliseconds) async {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final durationMs = controller.value.duration.inMilliseconds;
    final clamped = durationMs <= 0 ? 0 : milliseconds.clamp(0, durationMs);
    await controller.seekTo(Duration(milliseconds: clamped));
  }

  void _applyPlayback() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (widget.wantsPlayback) {
      controller.play();
    } else {
      controller.pause();
    }
  }

  void _release() {
    _clockTimer?.cancel();
    _clockTimer = null;
    final controller = _videoController;
    final listener = _clockListener;
    if (controller != null && listener != null) {
      controller.removeListener(listener);
    }
    _clockListener = null;
    _chewieController?.dispose();
    _chewieController = null;
    controller?.dispose();
    _videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = _chewieController;
    final videoController = _videoController;
    return WorkDetailMaterialScope(
      child: ColoredBox(
        color: const Color(0xFF121416),
        child: _errorText.isNotEmpty
            ? Center(child: Text('비디오를 열 수 없습니다.\n$_errorText'))
            : chewieController == null ||
                  videoController == null ||
                  !videoController.value.isInitialized
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: AspectRatio(
                  aspectRatio: chewieController.aspectRatio ?? 16 / 9,
                  child: Chewie(controller: chewieController),
                ),
              ),
      ),
    );
  }
}

class _AnnotationOverlay extends StatelessWidget {
  const _AnnotationOverlay();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(child: SizedBox.expand());
  }
}
