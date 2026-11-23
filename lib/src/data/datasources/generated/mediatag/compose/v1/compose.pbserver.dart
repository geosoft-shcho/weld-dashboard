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

import 'compose.pb.dart' as $6;
import 'compose.pbjson.dart';

export 'compose.pb.dart';

abstract class MediaComposeServiceBase extends $pb.GeneratedService {
  $async.Future<$6.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $6.GetTimelineRequest request);
  $async.Future<$6.ListTimelinesResponse> listTimelines(
      $pb.ServerContext ctx, $6.ListTimelinesRequest request);
  $async.Future<$6.UpdateTimelineResponse> updateTimeline(
      $pb.ServerContext ctx, $6.UpdateTimelineRequest request);
  $async.Future<$6.DeleteTimelineResponse> deleteTimeline(
      $pb.ServerContext ctx, $6.DeleteTimelineRequest request);
  $async.Future<$6.CreateTrackResponse> createTrack(
      $pb.ServerContext ctx, $6.CreateTrackRequest request);
  $async.Future<$6.UpdateTrackResponse> updateTrack(
      $pb.ServerContext ctx, $6.UpdateTrackRequest request);
  $async.Future<$6.DeleteTrackResponse> deleteTrack(
      $pb.ServerContext ctx, $6.DeleteTrackRequest request);
  $async.Future<$6.CreateClipResponse> createClip(
      $pb.ServerContext ctx, $6.CreateClipRequest request);
  $async.Future<$6.GetClipResponse> getClip(
      $pb.ServerContext ctx, $6.GetClipRequest request);
  $async.Future<$6.UpdateClipResponse> updateClip(
      $pb.ServerContext ctx, $6.UpdateClipRequest request);
  $async.Future<$6.DeleteClipResponse> deleteClip(
      $pb.ServerContext ctx, $6.DeleteClipRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetTimeline':
        return $6.GetTimelineRequest();
      case 'ListTimelines':
        return $6.ListTimelinesRequest();
      case 'UpdateTimeline':
        return $6.UpdateTimelineRequest();
      case 'DeleteTimeline':
        return $6.DeleteTimelineRequest();
      case 'CreateTrack':
        return $6.CreateTrackRequest();
      case 'UpdateTrack':
        return $6.UpdateTrackRequest();
      case 'DeleteTrack':
        return $6.DeleteTrackRequest();
      case 'CreateClip':
        return $6.CreateClipRequest();
      case 'GetClip':
        return $6.GetClipRequest();
      case 'UpdateClip':
        return $6.UpdateClipRequest();
      case 'DeleteClip':
        return $6.DeleteClipRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetTimeline':
        return getTimeline(ctx, request as $6.GetTimelineRequest);
      case 'ListTimelines':
        return listTimelines(ctx, request as $6.ListTimelinesRequest);
      case 'UpdateTimeline':
        return updateTimeline(ctx, request as $6.UpdateTimelineRequest);
      case 'DeleteTimeline':
        return deleteTimeline(ctx, request as $6.DeleteTimelineRequest);
      case 'CreateTrack':
        return createTrack(ctx, request as $6.CreateTrackRequest);
      case 'UpdateTrack':
        return updateTrack(ctx, request as $6.UpdateTrackRequest);
      case 'DeleteTrack':
        return deleteTrack(ctx, request as $6.DeleteTrackRequest);
      case 'CreateClip':
        return createClip(ctx, request as $6.CreateClipRequest);
      case 'GetClip':
        return getClip(ctx, request as $6.GetClipRequest);
      case 'UpdateClip':
        return updateClip(ctx, request as $6.UpdateClipRequest);
      case 'DeleteClip':
        return deleteClip(ctx, request as $6.DeleteClipRequest);
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
  $async.Future<$6.ListLabelsResponse> listLabels(
      $pb.ServerContext ctx, $6.ListLabelsRequest request);
  $async.Future<$6.CreateLabelValueResponse> createLabelValue(
      $pb.ServerContext ctx, $6.CreateLabelValueRequest request);
  $async.Future<$6.UpdateLabelValueResponse> updateLabelValue(
      $pb.ServerContext ctx, $6.UpdateLabelValueRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListLabels':
        return $6.ListLabelsRequest();
      case 'CreateLabelValue':
        return $6.CreateLabelValueRequest();
      case 'UpdateLabelValue':
        return $6.UpdateLabelValueRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListLabels':
        return listLabels(ctx, request as $6.ListLabelsRequest);
      case 'CreateLabelValue':
        return createLabelValue(ctx, request as $6.CreateLabelValueRequest);
      case 'UpdateLabelValue':
        return updateLabelValue(ctx, request as $6.UpdateLabelValueRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LabelServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => LabelServiceBase$messageJson;
}
