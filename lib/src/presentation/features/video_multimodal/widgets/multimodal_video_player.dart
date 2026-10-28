import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

import '../../work_detail/widgets/work_detail_chewie_stage.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_caption.dart';
import '../video_overlay_frame.dart';
import '../video_playback_rate.dart';
import 'multimodal_desktop_controls.dart';
import 'multimodal_studio_palette.dart';
import 'video_frame_mark_layer.dart';

class MultimodalVideoPlayer extends StatefulWidget {
  const MultimodalVideoPlayer({
    super.key,
    required this.mediaUrl,
    required this.seekToMs,
    required this.playbackRate,
    required this.seekToken,
    required this.playbackToken,
    required this.wantsPlayback,
    required this.captions,
    required this.frames,
    required this.onClock,
    required this.togglePlaybackHandler,
    this.contentEndMs,
    this.usesStepSeek = false,
  });

  final String mediaUrl;
  final int seekToMs;
  final double playbackRate;
  final int seekToken;
  final int playbackToken;
  final bool wantsPlayback;
  final List<VideoCaption> captions;
  final List<VideoOverlayFrame> frames;
  final ValueChanged<VideoPlaybackClock> onClock;
  /// Stage·보드와 같은 ViewModel 재생 토글.
  final VoidCallback togglePlaybackHandler;
  /// 파일 축 내용 끝(ms). `asset_start + duration` 기준. null이면 video.duration.
  final int? contentEndMs;
  /// 가이드 §6: 배속 0·범위 밖이면 재생 대신 시크만(소리 off).
  final bool usesStepSeek;

  @override
  State<MultimodalVideoPlayer> createState() => _MultimodalVideoPlayerState();
}

class _MultimodalVideoPlayerState extends State<MultimodalVideoPlayer> {
  static const Duration _seekTimeout = Duration(milliseconds: 1500);
  static const Duration _pauseTimeout = Duration(milliseconds: 800);

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int _captionGeneration = 0;
  Timer? _clockTimer;
  VoidCallback? _clockListener;
  String _errorText = '';
  bool _leftTarget = false;
  bool _pullingFromEnd = false;
  int _openGeneration = 0;
  int _seekGeneration = 0;
  bool _seekInFlight = false;
  int? _queuedSeekToken;

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

    final didPause = oldWidget.wantsPlayback && !widget.wantsPlayback;
    if (didPause) {
      _cancelSeek();
      unawaited(_pauseNow());
    }

    if (oldWidget.seekToken != widget.seekToken) {
      _leftTarget = false;
      if (!didPause) {
        unawaited(_seekAndApply(widget.seekToken));
      }
    } else if (!didPause &&
        (oldWidget.playbackToken != widget.playbackToken ||
            oldWidget.playbackRate != widget.playbackRate ||
            oldWidget.usesStepSeek != widget.usesStepSeek)) {
      final playbackToken = widget.playbackToken;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.playbackToken != playbackToken) {
          return;
        }
        if (!widget.wantsPlayback) {
          unawaited(_pauseNow());
          return;
        }
        final controller = _videoController;
        if (controller != null) {
          unawaited(_applyPlaybackRate(controller));
        }
      });
    }
    if (!_sameCaptions(oldWidget.captions, widget.captions)) {
      _syncCaptions();
    }
  }

  void _cancelSeek() {
    _seekGeneration += 1;
    _queuedSeekToken = null;
  }

  Future<void> _pauseNow() async {
    final controller = _videoController;
    if (controller == null) {
      return;
    }
    try {
      await controller.pause().timeout(_pauseTimeout, onTimeout: () {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _openGeneration += 1;
    _cancelSeek();
    _release();
    super.dispose();
  }

  Future<void> _open() async {
    final generation = ++_openGeneration;
    _cancelSeek();
    _release();
    setState(() => _errorText = '');
    final source = widget.mediaUrl;
    final videoController =
        source.startsWith('http://') || source.startsWith('https://')
        ? VideoPlayerController.networkUrl(Uri.parse(source))
        : VideoPlayerController.asset(source);
    try {
      await videoController.initialize();
    } catch (error) {
      await videoController.dispose();
      if (mounted && generation == _openGeneration) {
        setState(() => _errorText = error.toString());
      }
      return;
    }
    if (!mounted || generation != _openGeneration) {
      await videoController.dispose();
      return;
    }
    final chewieController = _createChewie(videoController, widget.captions);
    setState(() {
      _videoController = videoController;
      _chewieController = chewieController;
    });
    try {
      await _seekTo(widget.seekToMs);
      if (!mounted || _videoController != videoController) {
        return;
      }
      _watch(videoController);
      await _applyPlaybackRate(videoController);
    } catch (error) {
      debugPrint('[VIDEO] playback setup failed: $error');
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
      customControls: MultimodalDesktopControls(
        togglePlaybackHandler: widget.togglePlaybackHandler,
      ),
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
      if (value.position.inMilliseconds > widget.seekToMs + 500) {
        _leftTarget = true;
      }
      if (_sitsAtEnd(value)) {
        _pullToTarget(controller);
        return;
      }
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

  bool _sitsAtEnd(VideoPlayerValue value) {
    if (_leftTarget || _pullingFromEnd) {
      return false;
    }
    // 가이드 §5: 끝은 asset 길이(+첫 시각) 기준. video.duration은 쓰지 않는다.
    final endMs = widget.contentEndMs ?? value.duration.inMilliseconds;
    if (endMs < 1000) {
      return false;
    }
    final atEnd = value.position.inMilliseconds >= endMs - 400;
    final targetBeforeEnd = widget.seekToMs < endMs - 1000;
    return atEnd && targetBeforeEnd;
  }

  Future<void> _pullToTarget(VideoPlayerController controller) async {
    if (_pullingFromEnd) {
      return;
    }
    _pullingFromEnd = true;
    await _seekTo(widget.seekToMs);
    if (!mounted) {
      _pullingFromEnd = false;
      return;
    }
    if (widget.wantsPlayback) {
      await controller.play();
    }
    _pullingFromEnd = false;
  }

  /// 최신 seek만 적용. 진행 중이면 큐에 넣고, pause 시 [_cancelSeek]로 버린다.
  Future<void> _seekAndApply(int token) async {
    _queuedSeekToken = token;
    if (_seekInFlight) {
      return;
    }
    _seekInFlight = true;
    final generation = _seekGeneration;
    try {
      while (mounted && generation == _seekGeneration) {
        final activeToken = _queuedSeekToken;
        if (activeToken == null) {
          break;
        }
        _queuedSeekToken = null;
        final controller = _videoController;
        if (controller == null) {
          break;
        }
        try {
          await _seekTo(widget.seekToMs).timeout(_seekTimeout, onTimeout: () {});
        } catch (_) {}
        if (!mounted || generation != _seekGeneration) {
          break;
        }
        if (_queuedSeekToken != null || widget.seekToken != activeToken) {
          _queuedSeekToken ??= widget.seekToken;
          continue;
        }
        if (_videoController != controller) {
          break;
        }
        if (!widget.wantsPlayback) {
          await controller.pause();
          break;
        }
        await _applyPlaybackRate(controller);
      }
    } finally {
      _seekInFlight = false;
      final queued = _queuedSeekToken;
      if (queued != null &&
          mounted &&
          generation == _seekGeneration &&
          widget.wantsPlayback) {
        unawaited(_seekAndApply(queued));
      }
    }
  }

  Future<void> _seekTo(int milliseconds) async {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final fileDurationMs = controller.value.duration.inMilliseconds;
    final contentEnd = widget.contentEndMs;
    final maxMs = contentEnd == null
        ? fileDurationMs
        : (fileDurationMs <= 0
              ? contentEnd
              : (contentEnd < fileDurationMs ? contentEnd : fileDurationMs));
    final clamped = maxMs <= 0 ? 0 : milliseconds.clamp(0, maxMs);
    await controller.seekTo(Duration(milliseconds: clamped));
  }

  Future<void> _applyPlaybackRate(VideoPlayerController controller) async {
    if (!controller.value.isInitialized || _videoController != controller) {
      return;
    }
    final requestedRate = widget.playbackRate;
    final stepSeek =
        widget.usesStepSeek || doesRequireStepSeek(requestedRate);
    if (stepSeek) {
      debugPrint(
        '[VIDEO] step-seek mode: '
        'url=${widget.mediaUrl} requested=$requestedRate',
      );
      try {
        await controller.setVolume(0);
        if ((controller.value.playbackSpeed - 1).abs() >= 0.01) {
          await controller.setPlaybackSpeed(1);
        }
      } catch (error) {
        debugPrint('[VIDEO] step-seek setup failed: $error');
      }
      if (!mounted || _videoController != controller) {
        return;
      }
      await controller.pause();
      await _seekTo(widget.seekToMs);
      return;
    }
    final rate = browserPlaybackRate(requestedRate) ?? 1;
    try {
      await controller.setVolume(1);
      if ((controller.value.playbackSpeed - rate).abs() >= 0.01) {
        await controller.setPlaybackSpeed(rate);
      }
    } catch (error) {
      debugPrint(
        '[VIDEO] playback rate failed: '
        'url=${widget.mediaUrl} requested=$requestedRate error=$error',
      );
      if ((controller.value.playbackSpeed - 1).abs() >= 0.01) {
        try {
          await controller.setPlaybackSpeed(1);
        } catch (fallbackError) {
          debugPrint('[VIDEO] playback rate fallback failed: $fallbackError');
        }
      }
    }
    if (!mounted || _videoController != controller) {
      return;
    }
    if (!widget.wantsPlayback) {
      await controller.pause();
      return;
    }
    if (!controller.value.isPlaying) {
      await controller.play();
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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Chewie(
                        key: ValueKey(_captionGeneration),
                        controller: chewieController,
                      ),
                      VideoFrameMarkLayer(
                        controller: videoController,
                        frames: widget.frames,
                      ),
                    ],
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
