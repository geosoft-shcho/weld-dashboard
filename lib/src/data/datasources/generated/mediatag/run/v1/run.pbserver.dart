// This is a generated file - do not edit.
//
// Generated from mediatag/run/v1/run.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'run.pb.dart' as $1;
import 'run.pbjson.dart';

export 'run.pb.dart';

abstract class RunServiceBase extends $pb.GeneratedService {
  $async.Future<$1.StartRunResponse> startRun(
      $pb.ServerContext ctx, $1.StartRunRequest request);
  $async.Future<$1.GetRunResponse> getRun(
      $pb.ServerContext ctx, $1.GetRunRequest request);
  $async.Future<$1.ListRunsResponse> listRuns(
      $pb.ServerContext ctx, $1.ListRunsRequest request);
  $async.Future<$1.CancelRunResponse> cancelRun(
      $pb.ServerContext ctx, $1.CancelRunRequest request);
  $async.Future<$1.GetQueueResponse> getQueue(
      $pb.ServerContext ctx, $1.GetQueueRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'StartRun':
        return $1.StartRunRequest();
      case 'GetRun':
        return $1.GetRunRequest();
      case 'ListRuns':
        return $1.ListRunsRequest();
      case 'CancelRun':
        return $1.CancelRunRequest();
      case 'GetQueue':
        return $1.GetQueueRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'StartRun':
        return startRun(ctx, request as $1.StartRunRequest);
      case 'GetRun':
        return getRun(ctx, request as $1.GetRunRequest);
      case 'ListRuns':
        return listRuns(ctx, request as $1.ListRunsRequest);
      case 'CancelRun':
        return cancelRun(ctx, request as $1.CancelRunRequest);
      case 'GetQueue':
        return getQueue(ctx, request as $1.GetQueueRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RunServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RunServiceBase$messageJson;
}
