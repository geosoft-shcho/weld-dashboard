import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/timeline_time.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/timeline_clip_helpers.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/timeline_playhead_clock.dart';

void main() {
  test('GetTimeline audio endNs formats as 0:00:44 span label', () {
    final seconds = secondsFromNanoseconds('44280000000');
    expect(seconds, closeTo(44.28, 0.0001));
    expect(formatPlayheadClock(seconds), '0:00:44');
  });

  test('formatPlayheadClock does not clamp long spans to 24:00:00', () {
    expect(formatPlayheadClock(86400), '24:00:00');
    expect(formatPlayheadClock(86401), '24:00:01');
    expect(formatPlayheadClock(90000), '25:00:00');
  });

  test('formatPlayheadClock guards invalid seconds', () {
    expect(formatPlayheadClock(double.nan), '0:00:00');
    expect(formatPlayheadClock(double.infinity), '0:00:00');
    expect(formatPlayheadClock(-1), '0:00:00');
    expect(formatPlayheadClock(0), '0:00:00');
  });

  test('clampToSpan drops stale playhead past short timeline', () {
    final clock = TimelinePlayheadClock();
    clock.seekTo(925128, spanSeconds: 925128, resumeIfWasPlaying: false);
    expect(formatPlayheadClock(clock.playheadSeconds), '256:58:48');
    clock.clampToSpan(44.28);
    expect(clock.playheadSeconds, closeTo(44.28, 0.0001));
    expect(formatPlayheadClock(clock.playheadSeconds), '0:00:44');
  });

  test('orphan subtitle beyond media end does not inflate span', () {
    final span = timelineSpanSecondsFromClips([
      _clip(
        clipId: '18690',
        kind: TimelineClipKind.video,
        startNs: '0',
        endNs: '43926898000',
        assetDurationNs: '43926898000',
      ),
      _clip(
        clipId: '18691',
        kind: TimelineClipKind.audio,
        startNs: '0',
        endNs: '44280000000',
        assetDurationNs: '44280000000',
      ),
      _clip(
        clipId: '18695',
        kind: TimelineClipKind.subtitle,
        startNs: '0',
        endNs: '22000000000',
      ),
      _clip(
        clipId: '18694',
        kind: TimelineClipKind.subtitle,
        startNs: '925117941999999',
        endNs: '925128212000000',
      ),
    ]);
    expect(span, closeTo(44.28, 0.0001));
    expect(formatPlayheadClock(span), '0:00:44');
  });
}

TimelineClip _clip({
  required String clipId,
  required TimelineClipKind kind,
  required String startNs,
  required String endNs,
  String assetDurationNs = '',
}) {
  return TimelineClip(
    clipId: clipId,
    trackId: 't1',
    kind: kind,
    startNs: startNs,
    endNs: endNs,
    assetId: '',
    fileName: '',
    playbackUrl: '',
    description: '',
    showsToolBadge: false,
    assetDurationNs: assetDurationNs,
  );
}
