import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/asset/v1/asset.pb.dart'
    as asset_pb;
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import 'package:weld_dashboard/src/data/repositories/remote_job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';

void main() {
  test('groups clips by track and keeps content url only', () {
    final response = compose_pb.GetTimelineResponse(
      timeline: compose_pb.Timeline(
        jobId: 'job-1',
        name: '용접',
        status: compose_pb.TimelineStatus.TIMELINE_STATUS_DRAFT,
      ),
      tracks: [
        compose_pb.Track(
          trackId: 'hidden',
          name: '숨김',
          order: 2,
          visible: false,
        ),
        compose_pb.Track(trackId: 'video', name: '영상', order: 1),
      ],
      clips: [
        compose_pb.Clip(
          clipId: 'clip-1',
          trackId: 'video',
          kind: compose_pb.ClipKind.CLIP_KIND_VIDEO,
          timelineStartNs: Int64.ZERO,
          timelineEndNs: Int64(2000000000),
          source: compose_pb.ClipSource(assetId: 'asset-1'),
          provenance: compose_pb.ClipProvenance(toolId: 'pose'),
        ),
        compose_pb.Clip(
          clipId: 'missing-end',
          trackId: 'video',
          kind: compose_pb.ClipKind.CLIP_KIND_AUDIO,
          timelineStartNs: Int64.ZERO,
        ),
      ],
      assets: [
        asset_pb.Asset(
          assetId: 'asset-1',
          fileName: 'cam.mp4',
          contentUrl: '/assets/asset-1/content',
          sourcePath: '/secret/cam.mp4',
        ),
      ],
    );

    final timeline = jobTimelineFromResponse(
      response,
      resolveContentUrl: (contentUrl) => 'http://host$contentUrl',
    );

    expect(timeline.name, '용접');
    expect(timeline.status, JobTimelineStatus.draft);
    expect(timeline.tracks, hasLength(1));
    expect(timeline.tracks.single.name, '영상');
    final clip = timeline.tracks.single.clips.single;
    expect(clip.kind, TimelineClipKind.video);
    expect(clip.startNanoseconds, '0');
    expect(clip.endNanoseconds, '2000000000');
    expect(clip.playbackUrl, 'http://host/assets/asset-1/content');
    expect(clip.playbackUrl.contains('/secret/'), isFalse);
    expect(clip.fileName, 'cam.mp4');
    expect(clip.showsToolMark, isTrue);
  });
}
