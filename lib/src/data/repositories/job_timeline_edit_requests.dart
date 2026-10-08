import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';

import '../../domain/entities/job_timeline.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import '../datasources/generated/mediatag/compose/v1/compose.pbenum.dart';
import 'proto_id.dart';

compose_pb.CreateTrackRequest buildCreateTrackRequest({
  required String jobId,
  required String name,
  int? order,
  bool? isVisible,
}) {
  final track = compose_pb.Track(jobId: protoId(jobId), name: name);
  if (order != null) {
    track.order = order;
  }
  if (isVisible != null) {
    track.visible = isVisible;
  }
  return compose_pb.CreateTrackRequest(track: track);
}

compose_pb.UpdateTrackRequest buildUpdateTrackRequest({
  required String trackId,
  String? name,
  int? order,
  bool? isVisible,
}) {
  final track = compose_pb.Track(trackId: protoId(trackId));
  final paths = <String>[];
  if (name != null) {
    track.name = name;
    paths.add('name');
  }
  if (order != null) {
    track.order = order;
    paths.add('order');
  }
  if (isVisible != null) {
    track.visible = isVisible;
    paths.add('visible');
  }
  return compose_pb.UpdateTrackRequest(
    track: track,
    updateMask: FieldMask(paths: paths),
  );
}

compose_pb.DeleteTrackRequest buildDeleteTrackRequest({
  required String trackId,
}) {
  return compose_pb.DeleteTrackRequest(trackId: protoId(trackId));
}

compose_pb.CreateClipRequest buildCreateClipRequest({
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
  final clip = compose_pb.Clip(
    trackId: protoId(trackId),
    timelineStartNs: Int64.parseInt(startNs),
    timelineEndNs: Int64.parseInt(endNs),
  );
  if (!omitsKind) {
    clip.kind = protoClipKindFrom(kind);
  }
  final sourceAssetId = protoIdOrNull(assetId);
  if (sourceAssetId != null) {
    clip.source = compose_pb.ClipSource(assetId: sourceAssetId);
  }
  final labelId = protoIdOrNull(labelValueId);
  if (labelId != null) {
    clip.labelValueId = labelId;
  }
  if (description.isNotEmpty) {
    clip.description = description;
  }
  return compose_pb.CreateClipRequest(clip: clip);
}

compose_pb.UpdateClipRequest buildUpdateClipRequest({
  required String clipId,
  String? trackId,
  String? startNs,
  String? endNs,
  String? assetId,
  String? labelValueId,
  String? description,
  bool? isReviewed,
}) {
  final clip = compose_pb.Clip(clipId: protoId(clipId));
  final paths = <String>[];
  if (trackId != null) {
    clip.trackId = protoId(trackId);
    paths.add('track_id');
  }
  if (startNs != null) {
    clip.timelineStartNs = Int64.parseInt(startNs);
    paths.add('timeline_start_ns');
  }
  if (endNs != null) {
    clip.timelineEndNs = Int64.parseInt(endNs);
    paths.add('timeline_end_ns');
  }
  if (assetId != null) {
    clip.source = compose_pb.ClipSource(assetId: protoId(assetId));
    paths.add('source');
  }
  if (labelValueId != null) {
    clip.labelValueId = protoId(labelValueId);
    paths.add('label_value_id');
  }
  if (description != null) {
    clip.description = description;
    paths.add('description');
  }
  if (isReviewed != null) {
    clip.provenance = compose_pb.ClipProvenance(reviewed: isReviewed);
    paths.add('provenance.reviewed');
  }
  return compose_pb.UpdateClipRequest(
    clip: clip,
    updateMask: FieldMask(paths: paths),
  );
}

compose_pb.DeleteClipRequest buildDeleteClipRequest({required String clipId}) {
  return compose_pb.DeleteClipRequest(clipId: protoId(clipId));
}

compose_pb.ChangeTimelineStatusRequest buildChangeTimelineStatusRequest({
  required String jobId,
  required JobTimelineStatus fromStatus,
  required JobTimelineStatus toStatus,
}) {
  return compose_pb.ChangeTimelineStatusRequest(
    jobId: protoId(jobId),
    fromStatus: protoTimelineStatusFrom(fromStatus),
    toStatus: protoTimelineStatusFrom(toStatus),
  );
}

JobTimelineStatus jobTimelineStatusFromProto(TimelineStatus status) {
  switch (status) {
    case TimelineStatus.TIMELINE_STATUS_DRAFT:
      return JobTimelineStatus.draft;
    case TimelineStatus.TIMELINE_STATUS_SUGGESTED:
      return JobTimelineStatus.suggested;
    case TimelineStatus.TIMELINE_STATUS_CONFIRMED:
      return JobTimelineStatus.confirmed;
    case TimelineStatus.TIMELINE_STATUS_REJECTED:
      return JobTimelineStatus.rejected;
    case TimelineStatus.TIMELINE_STATUS_UNSPECIFIED:
      return JobTimelineStatus.unspecified;
  }
  return JobTimelineStatus.unspecified;
}

TimelineStatus protoTimelineStatusFrom(JobTimelineStatus status) {
  switch (status) {
    case JobTimelineStatus.draft:
      return TimelineStatus.TIMELINE_STATUS_DRAFT;
    case JobTimelineStatus.suggested:
      return TimelineStatus.TIMELINE_STATUS_SUGGESTED;
    case JobTimelineStatus.confirmed:
      return TimelineStatus.TIMELINE_STATUS_CONFIRMED;
    case JobTimelineStatus.rejected:
      return TimelineStatus.TIMELINE_STATUS_REJECTED;
    case JobTimelineStatus.unspecified:
      return TimelineStatus.TIMELINE_STATUS_UNSPECIFIED;
  }
}

ClipKind protoClipKindFrom(TimelineClipKind kind) {
  switch (kind) {
    case TimelineClipKind.video:
      return ClipKind.CLIP_KIND_VIDEO;
    case TimelineClipKind.audio:
      return ClipKind.CLIP_KIND_AUDIO;
    case TimelineClipKind.image:
      return ClipKind.CLIP_KIND_IMAGE;
    case TimelineClipKind.pdf:
      return ClipKind.CLIP_KIND_PDF;
    case TimelineClipKind.subtitle:
      return ClipKind.CLIP_KIND_SUBTITLE;
    case TimelineClipKind.pose:
      return ClipKind.CLIP_KIND_POSE;
    case TimelineClipKind.timeseries:
      return ClipKind.CLIP_KIND_TIMESERIES;
    case TimelineClipKind.pointCloud:
      return ClipKind.CLIP_KIND_POINTCLOUD;
    case TimelineClipKind.file:
      return ClipKind.CLIP_KIND_FILE;
    case TimelineClipKind.tag:
      return ClipKind.CLIP_KIND_TAG;
    case TimelineClipKind.region:
      return ClipKind.CLIP_KIND_REGION;
    case TimelineClipKind.unspecified:
      return ClipKind.CLIP_KIND_UNSPECIFIED;
  }
}

JobTimelineException timelineExceptionFromConnect(
  ConnectException error, {
  required String emptyMessage,
}) {
  final message = error.message.trim();
  return JobTimelineException(
    message.isEmpty ? emptyMessage : message,
    failure: _failureFrom(error.code),
  );
}

JobTimelineFailure _failureFrom(Code code) {
  switch (code) {
    case Code.invalidArgument:
      return JobTimelineFailure.invalidArgument;
    case Code.notFound:
      return JobTimelineFailure.notFound;
    case Code.failedPrecondition:
      return JobTimelineFailure.failedPrecondition;
    case Code.aborted:
      return JobTimelineFailure.aborted;
    default:
      return JobTimelineFailure.unknown;
  }
}
