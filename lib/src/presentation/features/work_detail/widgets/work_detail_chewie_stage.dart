import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/themes/app_theme.dart';
import 'work_detail_material_scope.dart';

class WorkDetailChewieStage extends StatefulWidget {
  const WorkDetailChewieStage({super.key, required this.assetPath});

  final String assetPath;

  @override
  State<WorkDetailChewieStage> createState() => _WorkDetailChewieStageState();
}

class _WorkDetailChewieStageState extends State<WorkDetailChewieStage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant WorkDetailChewieStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _load();
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
    final videoController = VideoPlayerController.asset(widget.assetPath);
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
