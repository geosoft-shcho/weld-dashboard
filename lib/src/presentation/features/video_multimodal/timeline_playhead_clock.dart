import 'dart:async';

import 'video_playback_rate.dart';

/// 가이드 §6: 타임라인 시각 `T`. wall × 타임라인 배속으로만 민다.
/// 파일 `timeupdate`로 덮지 않는다. covering·seekToken은 ViewModel 몫이다.
class TimelinePlayheadClock {
  double _playheadSeconds = 0;
  double _timelinePlaybackRate = 1;
  bool _wantsPlayback = false;
  Timer? _timer;
  DateTime? _lastTickAt;
  double Function()? _spanSeconds;
  void Function()? _onTick;
  void Function()? _onEndedAtSpan;

  double get playheadSeconds => _playheadSeconds;
  double get timelinePlaybackRate => _timelinePlaybackRate;
  String get timelinePlaybackRateLabel =>
      formatTimelinePlaybackRateLabel(_timelinePlaybackRate);

  /// 재생 의도. 갭에서도 `T`가 가면 true — UI ▶/❚❚ 와 동일.
  bool get wantsPlayback => _wantsPlayback;
  bool get isPlaying => _wantsPlayback;

  void seekTo(
    double seconds, {
    required double spanSeconds,
    required bool resumeIfWasPlaying,
  }) {
    _playheadSeconds = seconds.clamp(0.0, spanSeconds);
    _wantsPlayback = resumeIfWasPlaying;
  }

  void play({required double spanSeconds}) {
    if (_playheadSeconds >= spanSeconds) {
      _playheadSeconds = 0;
    }
    _wantsPlayback = true;
  }

  void pause() {
    _wantsPlayback = false;
    _stopTimer();
  }

  void cycleTimelinePlaybackRate() {
    _timelinePlaybackRate = nextTimelinePlaybackRate(_timelinePlaybackRate);
  }

  void clampToSpan(double spanSeconds) {
    _playheadSeconds = _playheadSeconds.clamp(0.0, spanSeconds);
  }

  /// [wantsPlayback]이면 틱 시작. [onTick]에서 covering seek·notify.
  void syncTimer({
    required double Function() spanSeconds,
    required void Function() onTick,
    required void Function() onEndedAtSpan,
  }) {
    _spanSeconds = spanSeconds;
    _onTick = onTick;
    _onEndedAtSpan = onEndedAtSpan;
    if (!_wantsPlayback) {
      _stopTimer();
      return;
    }
    if (_timer != null) {
      return;
    }
    _lastTickAt = DateTime.now();
    _timer = Timer.periodic(playheadTickInterval, (_) => _tick());
  }

  void dispose() {
    _stopTimer();
    _spanSeconds = null;
    _onTick = null;
    _onEndedAtSpan = null;
  }

  void _tick() {
    if (!_wantsPlayback) {
      _stopTimer();
      return;
    }
    final span = _spanSeconds?.call() ?? 0.0;
    final now = DateTime.now();
    final lastAt = _lastTickAt ?? now;
    _lastTickAt = now;
    final deltaSeconds =
        now.difference(lastAt).inMicroseconds / 1e6 * _timelinePlaybackRate;
    if (deltaSeconds <= 0) {
      return;
    }
    final next = (_playheadSeconds + deltaSeconds).clamp(0.0, span);
    _playheadSeconds = next;
    if (next >= span) {
      _playheadSeconds = span;
      pause();
      _onEndedAtSpan?.call();
      return;
    }
    _onTick?.call();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _lastTickAt = null;
  }
}
