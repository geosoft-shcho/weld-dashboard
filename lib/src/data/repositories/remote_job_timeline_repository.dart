import 'package:connectrpc/connect.dart';

import '../../domain/entities/job_timeline.dart';
import '../../domain/repositories/job_timeline_repository.dart';
import '../../domain/timeline_time.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import '../datasources/generated/mediatag/compose/v1/compose.pbenum.dart';
import '../datasources/remote/media_tag_data_source.dart';
import 'job_timeline_edit_requests.dart';
import 'proto_id.dart';

class RemoteJobTimelineRepository implements JobTimelineRepository {
  RemoteJobTimelineRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    if (jobId.isEmpty) {
      return JobTimeline.empty;
    }
    try {
      final response = await _mediaTag.composeService.getTimeline(
        compose_pb.GetTimelineRequest(
          jobId: protoId(jobId),
          includeAssets: true,
        ),
      );
      return jobTimelineFromResponse(
        response,
        resolveContentUrl: _mediaTag.resolveContentUrl,
      );
    } on ConnectException catch (error) {
      throw timelineExceptionFromConnect(
        error,
        emptyMessage: '타임라인을 불러오지 못했습니다.',
      );
    }
  }

  @override
  Future<String> readContent({required String url}) async {
    if (url.isEmpty) {
      return '';
    }
    try {
      return await _mediaTag.readContent(url);
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) {
    return _write(
      emptyMessage: '트랙을 만들지 못했습니다.',
      call: () => _mediaTag.composeService.createTrack(
        buildCreateTrackRequest(
          jobId: jobId,
          name: name,
          order: order,
          isVisible: isVisible,
        ),
      ),
    );
  }

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) {
    return _write(
      emptyMessage: '트랙을 저장하지 못했습니다.',
      call: () => _mediaTag.composeService.updateTrack(
        buildUpdateTrackRequest(
          trackId: trackId,
          name: name,
          order: order,
          isVisible: isVisible,
        ),
      ),
    );
  }

  @override
  Future<void> deleteTrack({required String trackId}) {
    return _write(
      emptyMessage: '트랙을 지우지 못했습니다.',
      call: () => _mediaTag.composeService.deleteTrack(
        buildDeleteTrackRequest(trackId: trackId),
      ),
    );
  }

  @override
  Future<void> createClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    bool omitsKind = false,
    List<String> inputClipIds = const [],
  }) {
    return _write(
      emptyMessage: '클립을 만들지 못했습니다.',
      call: () => _mediaTag.composeService.createClip(
        buildCreateClipRequest(
          trackId: trackId,
          kind: kind,
          startNs: startNs,
          endNs: endNs,
          assetId: assetId,
          labelValueId: labelValueId,
          description: description,
          omitsKind: omitsKind,
          inputClipIds: inputClipIds,
        ),
      ),
    );
  }

  @override
  Future<void> updateClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) {
    return _write(
      emptyMessage: '클립을 저장하지 못했습니다.',
      call: () => _mediaTag.composeService.updateClip(
        buildUpdateClipRequest(
          clipId: clipId,
          trackId: trackId,
          startNs: startNs,
          endNs: endNs,
          assetId: assetId,
          labelValueId: labelValueId,
          description: description,
          isReviewed: isReviewed,
        ),
      ),
    );
  }

  @override
  Future<void> deleteClip({required String clipId}) {
    return _write(
      emptyMessage: '클립을 지우지 못했습니다.',
      call: () => _mediaTag.composeService.deleteClip(
        buildDeleteClipRequest(clipId: clipId),
      ),
    );
  }

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) {
    return _write(
      emptyMessage: '타임라인 상태를 바꾸지 못했습니다.',
      call: () => _mediaTag.composeService.changeTimelineStatus(
        buildChangeTimelineStatusRequest(
          jobId: jobId,
          fromStatus: fromStatus,
          toStatus: toStatus,
        ),
      ),
    );
  }

  Future<void> _write({
    required String emptyMessage,
    required Future<Object?> Function() call,
  }) async {
    try {
      await call();
    } on ConnectException catch (error) {
      throw timelineExceptionFromConnect(error, emptyMessage: emptyMessage);
    }
  }
}

JobTimeline jobTimelineFromResponse(
  compose_pb.GetTimelineResponse response, {
  required String Function(String contentUrl) resolveContentUrl,
}) {
  final assetsById = <String, asset_pb.Asset>{
    for (final asset in response.assets)
      if (idText(asset.assetId).isNotEmpty) idText(asset.assetId): asset,
  };
  final visibleTrackIds = <String>{
    for (final track in response.tracks)
      if ((track.hasVisible() ? track.visible : true) &&
          idText(track.trackId).isNotEmpty)
        idText(track.trackId),
  };
  final overlays = <TimelineOverlay>[];
  final clipsByTrackId = <String, List<TimelineClip>>{};
  for (final clip in response.clips) {
    final mapped = _clipFrom(clip, assetsById, resolveContentUrl);
    if (mapped == null) {
      continue;
    }
    final overlay = _overlayFrom(
      clip,
      assetsById,
      resolveContentUrl,
      visibleTrackIds,
    );
    if (overlay != null) {
      overlays.add(overlay);
    }
    clipsByTrackId.putIfAbsent(mapped.trackId, () => []).add(mapped);
  }
  for (final clips in clipsByTrackId.values) {
    clips.sort((left, right) {
      final byStart = BigInt.parse(
        left.startNs,
      ).compareTo(BigInt.parse(right.startNs));
      if (byStart != 0) {
        return byStart;
      }
      return left.clipId.compareTo(right.clipId);
    });
  }
  final ordered = response.tracks.asMap().entries.toList()
    ..sort((left, right) {
      final byOrder = left.value.order.compareTo(right.value.order);
      if (byOrder != 0) {
        return byOrder;
      }
      return left.key.compareTo(right.key);
    });
  final tracks = <TimelineTrack>[];
  for (final entry in ordered) {
    final track = entry.value;
    final isVisible = track.hasVisible() ? track.visible : true;
    final trackId = idText(track.trackId);
    if (!isVisible || trackId.isEmpty) {
      continue;
    }
    tracks.add(
      TimelineTrack(
        trackId: trackId,
        name: track.name,
        order: track.order,
        isVisible: true,
        clips: clipsByTrackId[trackId] ?? const [],
      ),
    );
  }
  return JobTimeline(
    jobId: idText(response.timeline.jobId),
    name: response.timeline.name,
    status: jobTimelineStatusFromProto(response.timeline.status),
    tracks: tracks,
    overlays: overlays,
  );
}

TimelineOverlay? _overlayFrom(
  compose_pb.Clip clip,
  Map<String, asset_pb.Asset> assetsById,
  String Function(String contentUrl) resolveContentUrl,
  Set<String> visibleTrackIds,
) {
  final trackId = idText(clip.trackId);
  if (!visibleTrackIds.contains(trackId) ||
      !clip.hasTimelineStartNs() ||
      !clip.hasTimelineEndNs() ||
      !clip.hasSource()) {
    return null;
  }
  final assetId = idText(clip.source.assetId);
  final asset = assetsById[assetId];
  if (asset == null || asset.contentUrl.isEmpty) {
    return null;
  }
  final kind = _overlayKind(clip.kind, asset.kind);
  if (kind == null) {
    return null;
  }
  final start = clip.timelineStartNs.toString();
  final end = clip.timelineEndNs.toString();
  if (!isOpenNanosecondInterval(start, end)) {
    return null;
  }
  return TimelineOverlay(
    assetId: assetId,
    kind: kind,
    contentUrl: resolveContentUrl(asset.contentUrl),
    timelineStartNs: start,
    timelineEndNs: end,
    sourceStartNs: clip.source.hasStartNs()
        ? clip.source.startNs.toString()
        : '',
    sourceEndNs: clip.source.hasEndNs() ? clip.source.endNs.toString() : '',
  );
}

TimelineOverlayKind? _overlayKind(
  ClipKind clipKind,
  asset_pb.AssetKind assetKind,
) {
  if (clipKind == ClipKind.CLIP_KIND_SUBTITLE &&
      assetKind == asset_pb.AssetKind.ASSET_KIND_SUBTITLE) {
    return TimelineOverlayKind.subtitle;
  }
  if (clipKind == ClipKind.CLIP_KIND_POSE &&
      assetKind == asset_pb.AssetKind.ASSET_KIND_POSE) {
    return TimelineOverlayKind.pose;
  }
  return null;
}

TimelineClip? _clipFrom(
  compose_pb.Clip clip,
  Map<String, asset_pb.Asset> assetsById,
  String Function(String contentUrl) resolveContentUrl,
) {
  final clipId = idText(clip.clipId);
  final trackId = idText(clip.trackId);
  if (clipId.isEmpty ||
      trackId.isEmpty ||
      !clip.hasTimelineStartNs() ||
      !clip.hasTimelineEndNs()) {
    return null;
  }
  final start = clip.timelineStartNs.toString();
  final end = clip.timelineEndNs.toString();
  if (!isOpenNanosecondInterval(start, end)) {
    return null;
  }
  final assetId = clip.hasSource() ? idText(clip.source.assetId) : '';
  final asset = assetsById[assetId];
  final contentUrl = asset == null ? '' : asset.contentUrl;
  final provenance = clip.hasProvenance() ? clip.provenance : null;
  return TimelineClip(
    clipId: clipId,
    trackId: trackId,
    kind: _kindFrom(clip.kind),
    startNs: start,
    endNs: end,
    assetId: assetId,
    fileName: asset == null ? '' : asset.fileName,
    playbackUrl: contentUrl.isEmpty ? '' : resolveContentUrl(contentUrl),
    description: clip.description,
    labelValueId: idText(clip.labelValueId),
    showsToolBadge:
        provenance != null &&
        (idText(provenance.runId).isNotEmpty ||
            idText(provenance.toolId).isNotEmpty),
  );
}

TimelineClipKind _kindFrom(ClipKind kind) {
  switch (kind) {
    case ClipKind.CLIP_KIND_VIDEO:
      return TimelineClipKind.video;
    case ClipKind.CLIP_KIND_AUDIO:
      return TimelineClipKind.audio;
    case ClipKind.CLIP_KIND_IMAGE:
      return TimelineClipKind.image;
    case ClipKind.CLIP_KIND_PDF:
      return TimelineClipKind.pdf;
    case ClipKind.CLIP_KIND_SUBTITLE:
      return TimelineClipKind.subtitle;
    case ClipKind.CLIP_KIND_POSE:
      return TimelineClipKind.pose;
    case ClipKind.CLIP_KIND_TIMESERIES:
      return TimelineClipKind.timeseries;
    case ClipKind.CLIP_KIND_POINTCLOUD:
      return TimelineClipKind.pointCloud;
    case ClipKind.CLIP_KIND_FILE:
      return TimelineClipKind.file;
    case ClipKind.CLIP_KIND_TAG:
      return TimelineClipKind.tag;
    case ClipKind.CLIP_KIND_REGION:
      return TimelineClipKind.region;
    case ClipKind.CLIP_KIND_UNSPECIFIED:
      return TimelineClipKind.unspecified;
  }
  return TimelineClipKind.unspecified;
}
