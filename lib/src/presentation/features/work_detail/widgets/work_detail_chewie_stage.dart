import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/themes/app_theme.dart';
import 'work_detail_material_scope.dart';

class WorkDetailChewieStage extends StatefulWidget {
  const WorkDetailChewieStage({
    super.key,
    required this.assetPath,
    this.seekToMs,
    this.seekToken = 0,
  });

  final String assetPath;
  final int? seekToMs;
  /// 같은 ms를 연속 탭해도 seek가 다시 적용되도록 증가.
  final int seekToken;

  @override
  State<WorkDetailChewieStage> createState() => _WorkDetailChewieStageState();
}

class _WorkDetailChewieStageState extends State<WorkDetailChewieStage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String _errorMessage = '';
  int? _pendingSeekToMs;

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
    if (oldWidget.seekToken != widget.seekToken ||
        oldWidget.seekToMs != widget.seekToMs) {
      _applySeek(widget.seekToMs);
    }
  }

  @override
  void dispose() {
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

  void _disposePlayers() {
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
