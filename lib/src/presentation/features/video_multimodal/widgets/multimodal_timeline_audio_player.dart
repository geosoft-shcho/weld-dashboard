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
  static const Duration _urlDebounce = Duration(milliseconds: 200);

  final AudioPlayer _player = AudioPlayer();
  String _loadedUrl = '';
  String _desiredUrl = '';
  bool _openInFlight = false;
  Timer? _urlDebounceTimer;
  bool _forceSeekAfterOpen = false;

  @override
  void initState() {
    super.initState();
    _desiredUrl = widget.mediaUrl;
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
    if (urlChanged) {
      _desiredUrl = widget.mediaUrl;
      _forceSeekAfterOpen = true;
      _scheduleUrlSync();
      return;
    }
    if (seekChanged || playChanged) {
      unawaited(_sync(forceSeek: seekChanged));
      return;
    }
    if (widget.wantsPlayback &&
        widget.mediaUrl.isNotEmpty &&
        _loadedUrl == widget.mediaUrl) {
      unawaited(_seekIfDrifted());
    }
  }

  @override
  void dispose() {
    _urlDebounceTimer?.cancel();
    unawaited(_player.dispose());
    super.dispose();
  }

  void _scheduleUrlSync() {
    final url = _desiredUrl;
    if (url.isEmpty) {
      _urlDebounceTimer?.cancel();
      unawaited(_sync(forceSeek: false));
      return;
    }
    if (url == _loadedUrl) {
      _urlDebounceTimer?.cancel();
      unawaited(_sync(forceSeek: _forceSeekAfterOpen));
      return;
    }
    _urlDebounceTimer?.cancel();
    _urlDebounceTimer = Timer(_urlDebounce, () {
      if (!mounted) {
        return;
      }
      unawaited(_sync(forceSeek: true));
    });
  }

  Future<void> _sync({bool forceSeek = false}) async {
    final url = _desiredUrl;
    if (url.isEmpty) {
      try {
        await _player.pause();
      } catch (_) {}
      return;
    }
    if (_loadedUrl != url) {
      if (_openInFlight) {
        return;
      }
      _openInFlight = true;
      final openUrl = url;
      try {
        if (openUrl.startsWith('http://') || openUrl.startsWith('https://')) {
          await _player.setUrl(openUrl);
        } else {
          await _player.setAsset(openUrl);
        }
        _loadedUrl = openUrl;
      } catch (_) {
        _loadedUrl = '';
        _openInFlight = false;
        if (mounted && _desiredUrl.isNotEmpty && _desiredUrl != openUrl) {
          unawaited(_sync(forceSeek: true));
        }
        return;
      }
      _openInFlight = false;
      forceSeek = true;
      if (!mounted) {
        return;
      }
      if (_desiredUrl != openUrl) {
        if (_desiredUrl.isEmpty) {
          try {
            await _player.pause();
          } catch (_) {}
          return;
        }
        if (_desiredUrl != _loadedUrl) {
          unawaited(_sync(forceSeek: true));
          return;
        }
      }
    }
    if (!mounted || _desiredUrl != url) {
      return;
    }
    final shouldForceSeek = forceSeek || _forceSeekAfterOpen;
    _forceSeekAfterOpen = false;
    final rate = browserPlaybackRate(widget.playbackRate) ?? 1.0;
    try {
      if ((_player.speed - rate).abs() >= 0.01) {
        await _player.setSpeed(rate);
      }
    } catch (_) {
      try {
        await _player.setSpeed(1);
      } catch (_) {}
    }
    if (!mounted || _desiredUrl != url) {
      return;
    }
    if (shouldForceSeek || doesRequireStepSeek(widget.playbackRate)) {
      await _seekTo(widget.seekToMs);
    } else {
      await _seekIfDrifted();
    }
    if (!mounted || _desiredUrl != url) {
      return;
    }
    if (!widget.wantsPlayback || widget.mediaUrl.isEmpty) {
      await _player.pause();
      return;
    }
    if (!_player.playing) {
      try {
        await _player.play();
      } catch (_) {}
    }
  }

  Future<void> _seekIfDrifted() async {
    if (_loadedUrl.isEmpty || _loadedUrl != _desiredUrl) {
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
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
