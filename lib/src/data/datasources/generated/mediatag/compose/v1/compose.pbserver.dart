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

import 'compose.pb.dart' as $5;
import 'compose.pbjson.dart';

export 'compose.pb.dart';

abstract class MediaComposeServiceBase extends $pb.GeneratedService {
  $async.Future<$5.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $5.GetTimelineRequest request);
  $async.Future<$5.ListTimelinesResponse> listTimelines(
      $pb.ServerContext ctx, $5.ListTimelinesRequest request);
  $async.Future<$5.UpdateTimelineResponse> updateTimeline(
      $pb.ServerContext ctx, $5.UpdateTimelineRequest request);
  $async.Future<$5.DeleteTimelineResponse> deleteTimeline(
      $pb.ServerContext ctx, $5.DeleteTimelineRequest request);
  $async.Future<$5.CreateTrackResponse> createTrack(
      $pb.ServerContext ctx, $5.CreateTrackRequest request);
  $async.Future<$5.UpdateTrackResponse> updateTrack(
      $pb.ServerContext ctx, $5.UpdateTrackRequest request);
  $async.Future<$5.DeleteTrackResponse> deleteTrack(
      $pb.ServerContext ctx, $5.DeleteTrackRequest request);
  $async.Future<$5.CreateClipResponse> createClip(
      $pb.ServerContext ctx, $5.CreateClipRequest request);
  $async.Future<$5.GetClipResponse> getClip(
      $pb.ServerContext ctx, $5.GetClipRequest request);
  $async.Future<$5.UpdateClipResponse> updateClip(
      $pb.ServerContext ctx, $5.UpdateClipRequest request);
  $async.Future<$5.DeleteClipResponse> deleteClip(
      $pb.ServerContext ctx, $5.DeleteClipRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetTimeline':
        return $5.GetTimelineRequest();
      case 'ListTimelines':
        return $5.ListTimelinesRequest();
      case 'UpdateTimeline':
        return $5.UpdateTimelineRequest();
      case 'DeleteTimeline':
        return $5.DeleteTimelineRequest();
      case 'CreateTrack':
        return $5.CreateTrackRequest();
      case 'UpdateTrack':
        return $5.UpdateTrackRequest();
      case 'DeleteTrack':
        return $5.DeleteTrackRequest();
      case 'CreateClip':
        return $5.CreateClipRequest();
      case 'GetClip':
        return $5.GetClipRequest();
      case 'UpdateClip':
        return $5.UpdateClipRequest();
      case 'DeleteClip':
        return $5.DeleteClipRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetTimeline':
        return getTimeline(ctx, request as $5.GetTimelineRequest);
      case 'ListTimelines':
        return listTimelines(ctx, request as $5.ListTimelinesRequest);
      case 'UpdateTimeline':
        return updateTimeline(ctx, request as $5.UpdateTimelineRequest);
      case 'DeleteTimeline':
        return deleteTimeline(ctx, request as $5.DeleteTimelineRequest);
      case 'CreateTrack':
        return createTrack(ctx, request as $5.CreateTrackRequest);
      case 'UpdateTrack':
        return updateTrack(ctx, request as $5.UpdateTrackRequest);
      case 'DeleteTrack':
        return deleteTrack(ctx, request as $5.DeleteTrackRequest);
      case 'CreateClip':
        return createClip(ctx, request as $5.CreateClipRequest);
      case 'GetClip':
        return getClip(ctx, request as $5.GetClipRequest);
      case 'UpdateClip':
        return updateClip(ctx, request as $5.UpdateClipRequest);
      case 'DeleteClip':
        return deleteClip(ctx, request as $5.DeleteClipRequest);
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
  $async.Future<$5.ListLabelsResponse> listLabels(
      $pb.ServerContext ctx, $5.ListLabelsRequest request);
  $async.Future<$5.CreateLabelValueResponse> createLabelValue(
      $pb.ServerContext ctx, $5.CreateLabelValueRequest request);
  $async.Future<$5.UpdateLabelValueResponse> updateLabelValue(
      $pb.ServerContext ctx, $5.UpdateLabelValueRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListLabels':
        return $5.ListLabelsRequest();
      case 'CreateLabelValue':
        return $5.CreateLabelValueRequest();
      case 'UpdateLabelValue':
        return $5.UpdateLabelValueRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListLabels':
        return listLabels(ctx, request as $5.ListLabelsRequest);
      case 'CreateLabelValue':
        return createLabelValue(ctx, request as $5.CreateLabelValueRequest);
      case 'UpdateLabelValue':
        return updateLabelValue(ctx, request as $5.UpdateLabelValueRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LabelServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => LabelServiceBase$messageJson;
}
