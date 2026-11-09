import 'package:flutter/foundation.dart';

import '../../../domain/entities/job_timeline.dart';
import '../../../domain/timeline_time.dart';
import 'timeline_clip_helpers.dart';
import 'timeline_playhead_clock.dart';

/// GetTimeline 클립 `timelineEndNs` → span 라벨 디버그.
class TimelineSpanDebugLog {
  TimelineSpanDebugLog._();

  static void log({
    required String source,
    required String jobId,
    required List<TimelineClip> clips,
    required double spanSeconds,
    required String spanLabel,
    required String playheadLabel,
  }) {
    if (!kDebugMode) {
      return;
    }
    var mediaEnd = 0.0;
    for (final clip in clips) {
      final assetDur = secondsFromNanoseconds(clip.assetDurationNs);
      final isAnchor =
          assetDur > 0 ||
          clip.kind == TimelineClipKind.video ||
          clip.kind == TimelineClipKind.audio;
      if (!isAnchor) {
        continue;
      }
      final endSeconds = secondsFromNanoseconds(clip.endNanoseconds);
      if (endSeconds > mediaEnd) {
        mediaEnd = endSeconds;
      }
    }
    var maxCountedEndNs = BigInt.from(-1);
    var maxCountedClipId = '';
    var maxCountedEndSeconds = 0.0;
    // ignore: avoid_print
    print(
      '[MM-SPAN] begin source=$source jobId=$jobId clips=${clips.length} '
      'mediaEndSec=$mediaEnd',
    );
    for (final clip in clips) {
      final endNsText = clip.endNanoseconds;
      final startSeconds = secondsFromNanoseconds(clip.startNanoseconds);
      final endSeconds = secondsFromNanoseconds(endNsText);
      final assetDur = secondsFromNanoseconds(clip.assetDurationNs);
      var usedSeconds = endSeconds;
      var repaired = false;
      if (assetDur > 0 && endSeconds - startSeconds > assetDur * 2 + 60) {
        usedSeconds = startSeconds + assetDur;
        repaired = true;
      }
      final counted = doesClipCountTowardTimelineSpan(
        clip,
        mediaEndSeconds: mediaEnd,
      );
      if (counted) {
        final endNs = BigInt.tryParse(endNsText) ?? BigInt.zero;
        if (endNs > maxCountedEndNs) {
          maxCountedEndNs = endNs;
          maxCountedClipId = clip.clipId;
          maxCountedEndSeconds = usedSeconds;
        }
      }
      // ignore: avoid_print
      print(
        '[MM-SPAN] clip id=${clip.clipId} kind=${clip.kind.name} '
        'startNs=${clip.startNanoseconds} endNs=$endNsText '
        'endSec=$endSeconds usedSec=$usedSeconds '
        'assetDurSec=$assetDur repaired=$repaired counted=$counted '
        'clock=${formatPlayheadClock(usedSeconds)}',
      );
    }
    // ignore: avoid_print
    print(
      '[MM-SPAN] maxCountedEndNs=$maxCountedEndNs '
      'maxClip=$maxCountedClipId maxEndSec=$maxCountedEndSeconds '
      'maxClock=${formatPlayheadClock(maxCountedEndSeconds)} '
      'spanSeconds=$spanSeconds spanLabel=$spanLabel '
      'playheadLabel=$playheadLabel',
    );
  }
}
