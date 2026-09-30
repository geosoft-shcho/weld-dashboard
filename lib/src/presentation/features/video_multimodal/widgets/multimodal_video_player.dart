import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

import '../../work_detail/widgets/work_detail_chewie_stage.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_caption.dart';
import '../video_frame_mark.dart';
import 'multimodal_studio_palette.dart';
import 'video_frame_mark_layer.dart';

class MultimodalVideoPlayer extends StatefulWidget {
  const MultimodalVideoPlayer({
    super.key,
    required this.mediaUrl,
    required this.seekToMs,
    required this.seekToken,
    required this.playbackToken,
    required this.wantsPlayback,
    required this.captions,
    required this.marks,
    required this.onUpdateBox,
    required this.onUpdateSkeleton,
    required this.onClock,
  });

  final String mediaUrl;
  final int seekToMs;
  final int seekToken;
  final int playbackToken;
  final bool wantsPlayback;
  final List<VideoCaption> captions;
  final List<VideoFrameMark> marks;
  final void Function(
    int markIndex,
    double left,
    double top,
    double width,
    double height,
  )
  onUpdateBox;
  final void Function(int markIndex, List<VideoFramePoint> points)
  onUpdateSkeleton;
  final ValueChanged<VideoPlaybackClock> onClock;

  @override
  State<MultimodalVideoPlayer> createState() => _MultimodalVideoPlayerState();
}

class _MultimodalVideoPlayerState extends State<MultimodalVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int _captionGeneration = 0;
  VideoMarkSelection? _selection;
  bool _didHitMark = false;
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
      _selection = null;
      _open();
      return;
    }
    if (oldWidget.seekToken != widget.seekToken) {
      _seekTo(widget.seekToMs);
    }
    if (oldWidget.playbackToken != widget.playbackToken) {
      final playbackToken = widget.playbackToken;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.playbackToken != playbackToken) {
          return;
        }
        _applyPlayback();
      });
    }
    if (!_sameCaptions(oldWidget.captions, widget.captions)) {
      _syncCaptions();
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
      final chewieController = _createChewie(videoController, widget.captions);
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

  ChewieController _createChewie(
    VideoPlayerController videoController,
    List<VideoCaption> captions,
  ) {
    final ratio = videoController.value.aspectRatio == 0
        ? 16 / 9
        : videoController.value.aspectRatio;
    final cues = _chewieCues(captions);
    return ChewieController(
      videoPlayerController: videoController,
      aspectRatio: ratio,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      draggableProgressBar: true,
      showSubtitles: cues.isNotEmpty,
      subtitle: cues.isEmpty ? null : Subtitles(cues),
      customControls: const MaterialDesktopControls(),
      overlay: const _AnnotationOverlay(),
      materialProgressColors: ChewieProgressColors(
        playedColor: MultimodalStudioPalette.GRAPE_500,
        handleColor: MultimodalStudioPalette.GRAPE_500,
        bufferedColor: MultimodalStudioPalette.SAND_600,
        backgroundColor: MultimodalStudioPalette.SAND_300,
      ),
    );
  }

  List<Subtitle> _chewieCues(List<VideoCaption> captions) {
    return [
      for (var index = 0; index < captions.length; index++)
        Subtitle(
          index: index,
          start: captions[index].start,
          end: captions[index].end,
          text: captions[index].text,
        ),
    ];
  }

  bool _sameCaptions(List<VideoCaption> left, List<VideoCaption> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }
    return true;
  }

  void _syncCaptions() {
    final videoController = _videoController;
    if (videoController == null || !videoController.value.isInitialized) {
      return;
    }
    final previous = _chewieController;
    final next = _createChewie(videoController, widget.captions);
    setState(() {
      _chewieController = next;
      _captionGeneration += 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      previous?.dispose();
    });
  }

  void _watch(VideoPlayerController controller) {
    void emit() {
      if (!mounted || !controller.value.isInitialized) {
        return;
      }
      final value = controller.value;
      final clock = VideoPlaybackClock(
        position: value.position,
        duration: value.duration,
        isPlaying: value.isPlaying,
      );
      final phase = WidgetsBinding.instance.schedulerPhase;
      if (phase == SchedulerPhase.persistentCallbacks ||
          phase == SchedulerPhase.midFrameMicrotasks) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          widget.onClock(clock);
        });
        return;
      }
      widget.onClock(clock);
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

  void _handleSelect(VideoMarkSelection selection) {
    _didHitMark = true;
    if (_selection == selection) {
      return;
    }
    setState(() => _selection = selection);
  }

  void _handleStagePointerDown(PointerDownEvent _) {
    if (_didHitMark) {
      _didHitMark = false;
      return;
    }
    if (_selection == null) {
      return;
    }
    setState(() => _selection = null);
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
                  child: Listener(
                    behavior: HitTestBehavior.deferToChild,
                    onPointerDown: _handleStagePointerDown,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Chewie(
                          key: ValueKey(_captionGeneration),
                          controller: chewieController,
                        ),
                        VideoFrameMarkLayer(
                          controller: videoController,
                          marks: widget.marks,
                          selection: _selection,
                          onSelect: _handleSelect,
                          onCommitBox: widget.onUpdateBox,
                          onCommitSkeleton: widget.onUpdateSkeleton,
                        ),
                      ],
                    ),
                  ),
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
