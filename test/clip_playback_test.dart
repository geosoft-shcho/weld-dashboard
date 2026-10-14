import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/clip_file_position.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/timeline_board_helpers.dart';

void main() {
  test('file position adds the file start after the asset axis', () {
    const clip = ClipPlaybackInput(
      timelineStartNs: '0',
      timelineEndNs: '40000000000',
      sourceStartNs: '0',
      sourceEndNs: '40000000000',
      assetDurationNs: '40000000000',
      assetStartTimeNs: '428559000000',
    );

    final position = clipFilePositionAt(clip: clip, playheadSeconds: 28);

    expect(position?.rate, closeTo(1, 0.000001));
    expect(position?.fileSeconds, closeTo(456.559, 0.000001));
    expect(position?.rateLabel, isEmpty);
    expect(
      playheadSecondsFromFilePosition(clip: clip, fileSeconds: 456.559),
      closeTo(28, 0.000001),
    );
  });

  test('a shorter clip plays its whole source faster', () {
    const clip = ClipPlaybackInput(
      timelineStartNs: '5000000000',
      timelineEndNs: '15000000000',
      sourceStartNs: '10000000000',
      sourceEndNs: '30000000000',
      assetDurationNs: '40000000000',
      assetStartTimeNs: '7000000000',
    );

    final start = clipFilePositionAt(clip: clip, playheadSeconds: 5);
    final end = clipFilePositionAt(clip: clip, playheadSeconds: 15);

    expect(start?.rate, closeTo(2, 0.000001));
    expect(start?.fileSeconds, closeTo(17, 0.000001));
    expect(start?.rateLabel, 'x2');
    expect(end?.fileSeconds, closeTo(37, 0.000001));
    expect(
      playheadSecondsFromFilePosition(clip: clip, fileSeconds: 27),
      closeTo(10, 0.000001),
    );
  });

  test('a source past the asset length does not fit', () {
    expect(
      sourceIntervalFitsAsset(
        sourceStartNs: '0',
        sourceEndNs: '2000000000',
        assetDurationNs: '1000000000',
      ),
      isFalse,
    );
    expect(
      sourceIntervalFitsAsset(
        sourceStartNs: '0',
        sourceEndNs: '1000000000',
        assetDurationNs: '1000000000',
      ),
      isTrue,
    );
  });

  test('overlapping clips stack and touching clips share a lane', () {
    final lanes = assignClipLanes([
      _clip(clipId: '102', startNs: '10000000000', endNs: '30000000000'),
      _clip(clipId: '104', startNs: '45000000000', endNs: '55000000000'),
      _clip(clipId: '103', startNs: '25000000000', endNs: '35000000000'),
      _clip(clipId: '105', startNs: '30000000000', endNs: '32000000000'),
    ]);

    expect(lanes['102'], 0);
    expect(lanes['103'], 1);
    expect(lanes['104'], 0);
    expect(lanes['105'], 0);
  });
}

TimelineClip _clip({
  required String clipId,
  required String startNs,
  required String endNs,
}) {
  return TimelineClip(
    clipId: clipId,
    trackId: 'track',
    kind: TimelineClipKind.video,
    startNs: startNs,
    endNs: endNs,
    assetId: '',
    fileName: '',
    playbackUrl: '',
    description: '',
    showsToolBadge: false,
  );
}
