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
        jobId: Int64(1),
        name: '용접',
        status: compose_pb.TimelineStatus.TIMELINE_STATUS_DRAFT,
      ),
      tracks: [
        compose_pb.Track(
          trackId: Int64(2),
          name: '숨김',
          order: 2,
          visible: false,
        ),
        compose_pb.Track(trackId: Int64(1), name: '영상', order: 1),
      ],
      clips: [
        compose_pb.Clip(
          clipId: Int64(10),
          trackId: Int64(1),
          kind: compose_pb.ClipKind.CLIP_KIND_VIDEO,
          timelineStartNs: Int64.ZERO,
          timelineEndNs: Int64(2000000000),
          source: compose_pb.ClipSource(assetId: Int64(20)),
          provenance: compose_pb.ClipProvenance(toolId: Int64(7)),
        ),
        compose_pb.Clip(
          clipId: Int64(11),
          trackId: Int64(1),
          kind: compose_pb.ClipKind.CLIP_KIND_AUDIO,
          timelineStartNs: Int64.ZERO,
        ),
      ],
      assets: [
        asset_pb.Asset(
          assetId: Int64(20),
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
    expect(timeline.overlays, isEmpty);
  });

  test('keeps subtitle and pose overlays on visible tracks', () {
    final response = compose_pb.GetTimelineResponse(
      tracks: [
        compose_pb.Track(trackId: Int64(1), name: '영상', order: 1),
        compose_pb.Track(
          trackId: Int64(2),
          name: '숨김 포즈',
          order: 2,
          visible: false,
        ),
      ],
      clips: [
        compose_pb.Clip(
          clipId: Int64(10),
          trackId: Int64(1),
          kind: compose_pb.ClipKind.CLIP_KIND_VIDEO,
          timelineStartNs: Int64.ZERO,
          timelineEndNs: Int64(30000000000),
          source: compose_pb.ClipSource(assetId: Int64(20)),
        ),
        compose_pb.Clip(
          clipId: Int64(11),
          trackId: Int64(1),
          kind: compose_pb.ClipKind.CLIP_KIND_POSE,
          timelineStartNs: Int64(10000000000),
          timelineEndNs: Int64(20000000000),
          source: compose_pb.ClipSource(
            assetId: Int64(30),
            startNs: Int64(2000000000),
            endNs: Int64(8000000000),
          ),
        ),
        compose_pb.Clip(
          clipId: Int64(12),
          trackId: Int64(1),
          kind: compose_pb.ClipKind.CLIP_KIND_SUBTITLE,
          timelineStartNs: Int64.ZERO,
          timelineEndNs: Int64(5000000000),
          source: compose_pb.ClipSource(assetId: Int64(40)),
        ),
        compose_pb.Clip(
          clipId: Int64(13),
          trackId: Int64(2),
          kind: compose_pb.ClipKind.CLIP_KIND_POSE,
          timelineStartNs: Int64.ZERO,
          timelineEndNs: Int64(1000000000),
          source: compose_pb.ClipSource(assetId: Int64(30)),
        ),
        compose_pb.Clip(
          clipId: Int64(14),
          trackId: Int64(1),
          kind: compose_pb.ClipKind.CLIP_KIND_POSE,
          timelineStartNs: Int64.ZERO,
          timelineEndNs: Int64(1000000000),
          source: compose_pb.ClipSource(assetId: Int64(20)),
        ),
      ],
      assets: [
        asset_pb.Asset(
          assetId: Int64(20),
          kind: asset_pb.AssetKind.ASSET_KIND_VIDEO,
          contentUrl: '/files/cam.mp4',
        ),
        asset_pb.Asset(
          assetId: Int64(30),
          kind: asset_pb.AssetKind.ASSET_KIND_POSE,
          contentUrl: '/files/pose.json',
        ),
        asset_pb.Asset(
          assetId: Int64(40),
          kind: asset_pb.AssetKind.ASSET_KIND_SUBTITLE,
          contentUrl: '/files/caption.vtt',
        ),
      ],
    );

    final timeline = jobTimelineFromResponse(
      response,
      resolveContentUrl: (contentUrl) => 'http://host$contentUrl',
    );

    expect(timeline.overlays, hasLength(2));
    final pose = timeline.overlays.first;
    expect(pose.kind, TimelineOverlayKind.pose);
    expect(pose.assetId, '30');
    expect(pose.contentUrl, 'http://host/files/pose.json');
    expect(pose.timelineStartNs, '10000000000');
    expect(pose.sourceStartNs, '2000000000');
    expect(pose.sourceEndNs, '8000000000');
    expect(timeline.overlays.last.kind, TimelineOverlayKind.subtitle);
    expect(timeline.overlays.last.contentUrl, 'http://host/files/caption.vtt');
  });
}
