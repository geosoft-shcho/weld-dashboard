// This is a generated file - do not edit.
//
// Generated from mediatag/compose/v1/compose.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'compose.pb.dart' as $4;
import 'compose.pbjson.dart';

export 'compose.pb.dart';

abstract class MediaComposeServiceBase extends $pb.GeneratedService {
  $async.Future<$4.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $4.GetTimelineRequest request);
  $async.Future<$4.ListTimelinesResponse> listTimelines(
      $pb.ServerContext ctx, $4.ListTimelinesRequest request);
  $async.Future<$4.UpdateTimelineResponse> updateTimeline(
      $pb.ServerContext ctx, $4.UpdateTimelineRequest request);
  $async.Future<$4.ChangeTimelineStatusResponse> changeTimelineStatus(
      $pb.ServerContext ctx, $4.ChangeTimelineStatusRequest request);
  $async.Future<$4.DeleteTimelineResponse> deleteTimeline(
      $pb.ServerContext ctx, $4.DeleteTimelineRequest request);
  $async.Future<$4.CreateTrackResponse> createTrack(
      $pb.ServerContext ctx, $4.CreateTrackRequest request);
  $async.Future<$4.UpdateTrackResponse> updateTrack(
      $pb.ServerContext ctx, $4.UpdateTrackRequest request);
  $async.Future<$4.DeleteTrackResponse> deleteTrack(
      $pb.ServerContext ctx, $4.DeleteTrackRequest request);
  $async.Future<$4.CreateClipResponse> createClip(
      $pb.ServerContext ctx, $4.CreateClipRequest request);
  $async.Future<$4.UpdateClipResponse> updateClip(
      $pb.ServerContext ctx, $4.UpdateClipRequest request);
  $async.Future<$4.DeleteClipResponse> deleteClip(
      $pb.ServerContext ctx, $4.DeleteClipRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetTimeline':
        return $4.GetTimelineRequest();
      case 'ListTimelines':
        return $4.ListTimelinesRequest();
      case 'UpdateTimeline':
        return $4.UpdateTimelineRequest();
      case 'ChangeTimelineStatus':
        return $4.ChangeTimelineStatusRequest();
      case 'DeleteTimeline':
        return $4.DeleteTimelineRequest();
      case 'CreateTrack':
        return $4.CreateTrackRequest();
      case 'UpdateTrack':
        return $4.UpdateTrackRequest();
      case 'DeleteTrack':
        return $4.DeleteTrackRequest();
      case 'CreateClip':
        return $4.CreateClipRequest();
      case 'UpdateClip':
        return $4.UpdateClipRequest();
      case 'DeleteClip':
        return $4.DeleteClipRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetTimeline':
        return getTimeline(ctx, request as $4.GetTimelineRequest);
      case 'ListTimelines':
        return listTimelines(ctx, request as $4.ListTimelinesRequest);
      case 'UpdateTimeline':
        return updateTimeline(ctx, request as $4.UpdateTimelineRequest);
      case 'ChangeTimelineStatus':
        return changeTimelineStatus(
            ctx, request as $4.ChangeTimelineStatusRequest);
      case 'DeleteTimeline':
        return deleteTimeline(ctx, request as $4.DeleteTimelineRequest);
      case 'CreateTrack':
        return createTrack(ctx, request as $4.CreateTrackRequest);
      case 'UpdateTrack':
        return updateTrack(ctx, request as $4.UpdateTrackRequest);
      case 'DeleteTrack':
        return deleteTrack(ctx, request as $4.DeleteTrackRequest);
      case 'CreateClip':
        return createClip(ctx, request as $4.CreateClipRequest);
      case 'UpdateClip':
        return updateClip(ctx, request as $4.UpdateClipRequest);
      case 'DeleteClip':
        return deleteClip(ctx, request as $4.DeleteClipRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      MediaComposeServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MediaComposeServiceBase$messageJson;
}

abstract class LabelServiceBase extends $pb.GeneratedService {
  $async.Future<$4.ListLabelsResponse> listLabels(
      $pb.ServerContext ctx, $4.ListLabelsRequest request);
  $async.Future<$4.CreateLabelValueResponse> createLabelValue(
      $pb.ServerContext ctx, $4.CreateLabelValueRequest request);
  $async.Future<$4.UpdateLabelValueResponse> updateLabelValue(
      $pb.ServerContext ctx, $4.UpdateLabelValueRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListLabels':
        return $4.ListLabelsRequest();
      case 'CreateLabelValue':
        return $4.CreateLabelValueRequest();
      case 'UpdateLabelValue':
        return $4.UpdateLabelValueRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListLabels':
        return listLabels(ctx, request as $4.ListLabelsRequest);
      case 'CreateLabelValue':
        return createLabelValue(ctx, request as $4.CreateLabelValueRequest);
      case 'UpdateLabelValue':
        return updateLabelValue(ctx, request as $4.UpdateLabelValueRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LabelServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => LabelServiceBase$messageJson;
}
