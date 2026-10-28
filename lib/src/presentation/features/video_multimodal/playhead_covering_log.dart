import '../../../domain/entities/job_timeline.dart';
import '../../../domain/timeline_time.dart';

/// `[PLAYHEAD]` — `T` 기준 covering 영상 클립 디버그 로그.
/// `print` 사용(debugPrint 쓰로틀에 가리지 않음).
class PlayheadCoveringLog {
  DateTime _lastThrottledAt = DateTime.fromMillisecondsSinceEpoch(0);

  static const Duration throttleInterval = Duration(seconds: 1);

  void log({
    required String reason,
    required double playheadSeconds,
    required double spanSeconds,
    required bool wantsPlayback,
    required String modeLabel,
    TimelineClip? clip,
    int seekMs = -1,
    double rate = 0,
    bool step = false,
    bool throttle = false,
  }) {
    try {
      if (throttle) {
        final now = DateTime.now();
        if (now.difference(_lastThrottledAt) < throttleInterval) {
          return;
        }
        _lastThrottledAt = now;
      }
      final t = playheadSeconds.toStringAsFixed(3);
      final span = spanSeconds.toStringAsFixed(3);
      if (clip == null) {
        // ignore: avoid_print
        print(
          '[PLAYHEAD] $reason T=$t span=$span covering=none '
          '($modeLabel) wants=$wantsPlayback',
        );
        return;
      }
      final start = secondsFromNanoseconds(clip.startNanoseconds);
      final end = secondsFromNanoseconds(clip.endNanoseconds);
      // ignore: avoid_print
      print(
        '[PLAYHEAD] $reason T=$t span=$span '
        'clipId=${clip.clipId} trackId=${clip.trackId} '
        'file=${clip.fileName} '
        'timeline=${start.toStringAsFixed(3)}..${end.toStringAsFixed(3)} '
        'seekMs=$seekMs rate=${rate.toStringAsFixed(3)} step=$step '
        '($modeLabel) wants=$wantsPlayback',
      );
    } catch (error, stack) {
      // ignore: avoid_print
      print('[PLAYHEAD] $reason log failed: $error');
      // ignore: avoid_print
      print(stack);
    }
  }
}
