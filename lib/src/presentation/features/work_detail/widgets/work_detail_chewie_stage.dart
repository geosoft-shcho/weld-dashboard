import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/themes/app_theme.dart';
import 'work_detail_material_scope.dart';

class VideoPlaybackClock {
  const VideoPlaybackClock({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  final Duration position;
  final Duration duration;
  final bool isPlaying;
}

class WorkDetailChewieStage extends StatefulWidget {
  const WorkDetailChewieStage({
    super.key,
    required this.assetPath,
    this.seekToMs,
    this.seekToken = 0,
    this.applySeekOnTokenOnly = false,
    this.playbackToken = 0,
    this.wantsPlayback = false,
    this.onClock,
  });

  final String assetPath;
  final int? seekToMs;
  /// 같은 ms를 연속 탭해도 seek가 다시 적용되도록 증가.
  final int seekToken;
  /// 재생 위치 콜백이 seekToMs를 다시 바꿀 때 탐색이 반복되지 않게 한다.
  final bool applySeekOnTokenOnly;
  final int playbackToken;
  final bool wantsPlayback;
  final ValueChanged<VideoPlaybackClock>? onClock;

  @override
  State<WorkDetailChewieStage> createState() => _WorkDetailChewieStageState();
}

class _WorkDetailChewieStageState extends State<WorkDetailChewieStage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String _errorMessage = '';
  int? _pendingSeekToMs;
  Timer? _clockTimer;
  VoidCallback? _clockListener;

  @override
  void initState() {
    super.initState();
    _pendingSeekToMs = widget.seekToMs;
    _load();
  }

  @override
  void didUpdateWidget(covariant WorkDetailChewieStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _pendingSeekToMs = widget.seekToMs;
      _load();
      return;
    }
    final tokenChanged = oldWidget.seekToken != widget.seekToken;
    final positionChanged = oldWidget.seekToMs != widget.seekToMs;
    if (widget.applySeekOnTokenOnly) {
      if (tokenChanged) {
        _applySeek(widget.seekToMs);
      }
    } else if (tokenChanged || positionChanged) {
      _applySeek(widget.seekToMs);
    }
    if (oldWidget.playbackToken != widget.playbackToken) {
      final controller = _videoController;
      if (controller != null && controller.value.isInitialized) {
        if (widget.wantsPlayback) {
          controller.play();
        } else {
          controller.pause();
        }
      }
    }
  }

  @override
  void dispose() {
    _unbindClock();
    _disposePlayers();
    super.dispose();
  }

  Future<void> _load() async {
    _disposePlayers();
    setState(() {
      _errorMessage = '';
    });
    final source = widget.assetPath;
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
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppTheme.ACCENT_STEEL,
          handleColor: AppTheme.ACCENT_STEEL,
          bufferedColor: const Color(0xFF5A616C),
          backgroundColor: const Color(0xFF121416),
        ),
      );
      setState(() {
        _videoController = videoController;
        _chewieController = chewieController;
      });
      _bindClock();
      await _applySeek(_pendingSeekToMs ?? widget.seekToMs);
    } catch (error) {
      await videoController.dispose();
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _applySeek(int? seekToMs) async {
    if (seekToMs == null) {
      return;
    }
    final videoController = _videoController;
    if (videoController == null || !videoController.value.isInitialized) {
      _pendingSeekToMs = seekToMs;
      return;
    }
    _pendingSeekToMs = null;
    final durationMs = videoController.value.duration.inMilliseconds;
    final clamped = durationMs <= 0
        ? 0
        : seekToMs.clamp(0, durationMs);
    await videoController.seekTo(Duration(milliseconds: clamped));
  }

  void _bindClock() {
    _unbindClock();
    final controller = _videoController;
    if (controller == null || widget.onClock == null) {
      return;
    }
    void emit() {
      if (!mounted || !controller.value.isInitialized) {
        return;
      }
      widget.onClock!(
        VideoPlaybackClock(
          position: controller.value.position,
          duration: controller.value.duration,
          isPlaying: controller.value.isPlaying,
        ),
      );
    }

    _clockListener = emit;
    controller.addListener(emit);
    _clockTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!controller.value.isInitialized || !controller.value.isPlaying) {
        return;
      }
      emit();
    });
    emit();
  }

  void _unbindClock() {
    _clockTimer?.cancel();
    _clockTimer = null;
    final controller = _videoController;
    final listener = _clockListener;
    if (controller != null && listener != null) {
      controller.removeListener(listener);
    }
    _clockListener = null;
  }

  void _disposePlayers() {
    _unbindClock();
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          '비디오를 열 수 없습니다.\n$_errorMessage',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF8E949E)),
        ),
      );
    }
    final chewieController = _chewieController;
    final videoController = _videoController;
    if (chewieController == null ||
        videoController == null ||
        !videoController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return WorkDetailMaterialScope(
      child: ColoredBox(
        color: const Color(0xFF121416),
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(controller: chewieController),
          ),
        ),
      ),
    );
  }
}
