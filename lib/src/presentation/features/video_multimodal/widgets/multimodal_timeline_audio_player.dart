import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../domain/timeline_clip_playback.dart';
import '../video_playback_rate.dart';

/// 타임라인 `T`를 덮는 음성 클립 소리. UI 없음.
class MultimodalTimelineAudioPlayer extends StatefulWidget {
  const MultimodalTimelineAudioPlayer({
    super.key,
    required this.mediaUrl,
    required this.seekToMs,
    required this.playbackRate,
    required this.seekToken,
    required this.playbackToken,
    required this.wantsPlayback,
  });

  final String mediaUrl;
  final int seekToMs;
  final double playbackRate;
  final int seekToken;
  final int playbackToken;
  final bool wantsPlayback;

  @override
  State<MultimodalTimelineAudioPlayer> createState() =>
      _MultimodalTimelineAudioPlayerState();
}

class _MultimodalTimelineAudioPlayerState
    extends State<MultimodalTimelineAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  String _loadedUrl = '';
  bool _openInFlight = false;

  @override
  void initState() {
    super.initState();
    unawaited(_sync());
  }

  @override
  void didUpdateWidget(covariant MultimodalTimelineAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final urlChanged = oldWidget.mediaUrl != widget.mediaUrl;
    final seekChanged = oldWidget.seekToken != widget.seekToken;
    final playChanged = oldWidget.wantsPlayback != widget.wantsPlayback ||
        oldWidget.playbackToken != widget.playbackToken ||
        oldWidget.playbackRate != widget.playbackRate;
    if (urlChanged || seekChanged || playChanged) {
      unawaited(_sync(forceSeek: urlChanged || seekChanged));
      return;
    }
    if (widget.wantsPlayback && widget.mediaUrl.isNotEmpty) {
      unawaited(_seekIfDrifted());
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _sync({bool forceSeek = false}) async {
    final url = widget.mediaUrl;
    if (url.isEmpty) {
      _loadedUrl = '';
      try {
        await _player.stop();
      } catch (_) {}
      return;
    }
    if (_loadedUrl != url) {
      if (_openInFlight) {
        return;
      }
      _openInFlight = true;
      try {
        if (url.startsWith('http://') || url.startsWith('https://')) {
          await _player.setUrl(url);
        } else {
          await _player.setAsset(url);
        }
        _loadedUrl = url;
      } catch (error) {
        debugPrint('[AUDIO] open failed: $error');
        _loadedUrl = '';
        _openInFlight = false;
        return;
      }
      _openInFlight = false;
      forceSeek = true;
    }
    if (!mounted || widget.mediaUrl != url) {
      return;
    }
    final rate = browserPlaybackRate(widget.playbackRate) ?? 1.0;
    try {
      if ((_player.speed - rate).abs() >= 0.01) {
        await _player.setSpeed(rate);
      }
    } catch (error) {
      debugPrint('[AUDIO] setSpeed failed: $error');
      try {
        await _player.setSpeed(1);
      } catch (_) {}
    }
    if (!mounted || widget.mediaUrl != url) {
      return;
    }
    if (forceSeek || doesRequireStepSeek(widget.playbackRate)) {
      await _seekTo(widget.seekToMs);
    } else {
      await _seekIfDrifted();
    }
    if (!mounted || widget.mediaUrl != url) {
      return;
    }
    if (!widget.wantsPlayback) {
      await _player.pause();
      return;
    }
    if (!_player.playing) {
      try {
        await _player.play();
      } catch (error) {
        debugPrint('[AUDIO] play failed: $error');
      }
    }
  }

  Future<void> _seekIfDrifted() async {
    if (_loadedUrl.isEmpty || _loadedUrl != widget.mediaUrl) {
      return;
    }
    final currentSeconds = _player.position.inMilliseconds / 1000.0;
    final expectedSeconds = widget.seekToMs / 1000.0;
    if (!doesFileDriftBeyond(
      fileSeconds: currentSeconds,
      expectedFileSeconds: expectedSeconds,
    )) {
      return;
    }
    await _seekTo(widget.seekToMs);
  }

  Future<void> _seekTo(int milliseconds) async {
    final ms = milliseconds < 0 ? 0 : milliseconds;
    try {
      await _player.seek(Duration(milliseconds: ms));
    } catch (error) {
      debugPrint('[AUDIO] seek failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
