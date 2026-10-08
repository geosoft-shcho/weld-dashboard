// This is a generated file - do not edit.
//
// Generated from mediatag/tool/v1/tool.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'tool.pb.dart' as $3;
import 'tool.pbjson.dart';

export 'tool.pb.dart';

abstract class ToolServiceBase extends $pb.GeneratedService {
  $async.Future<$3.ListToolsResponse> listTools(
      $pb.ServerContext ctx, $3.ListToolsRequest request);
  $async.Future<$3.CreateToolResponse> createTool(
      $pb.ServerContext ctx, $3.CreateToolRequest request);
  $async.Future<$3.UpdateToolResponse> updateTool(
      $pb.ServerContext ctx, $3.UpdateToolRequest request);
  $async.Future<$3.DeleteToolResponse> deleteTool(
      $pb.ServerContext ctx, $3.DeleteToolRequest request);
  $async.Future<$3.StartRunResponse> startRun(
      $pb.ServerContext ctx, $3.StartRunRequest request);
  $async.Future<$3.GetRunResponse> getRun(
      $pb.ServerContext ctx, $3.GetRunRequest request);
  $async.Future<$3.ListRunsResponse> listRuns(
      $pb.ServerContext ctx, $3.ListRunsRequest request);
  $async.Future<$3.CancelRunResponse> cancelRun(
      $pb.ServerContext ctx, $3.CancelRunRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListTools':
        return $3.ListToolsRequest();
      case 'CreateTool':
        return $3.CreateToolRequest();
      case 'UpdateTool':
        return $3.UpdateToolRequest();
      case 'DeleteTool':
        return $3.DeleteToolRequest();
      case 'StartRun':
        return $3.StartRunRequest();
      case 'GetRun':
        return $3.GetRunRequest();
      case 'ListRuns':
        return $3.ListRunsRequest();
      case 'CancelRun':
        return $3.CancelRunRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListTools':
        return listTools(ctx, request as $3.ListToolsRequest);
      case 'CreateTool':
        return createTool(ctx, request as $3.CreateToolRequest);
      case 'UpdateTool':
        return updateTool(ctx, request as $3.UpdateToolRequest);
      case 'DeleteTool':
        return deleteTool(ctx, request as $3.DeleteToolRequest);
      case 'StartRun':
        return startRun(ctx, request as $3.StartRunRequest);
      case 'GetRun':
        return getRun(ctx, request as $3.GetRunRequest);
      case 'ListRuns':
        return listRuns(ctx, request as $3.ListRunsRequest);
      case 'CancelRun':
        return cancelRun(ctx, request as $3.CancelRunRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ToolServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ToolServiceBase$messageJson;
}
