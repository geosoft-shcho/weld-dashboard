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

import 'tool.pb.dart' as $2;
import 'tool.pbjson.dart';

export 'tool.pb.dart';

abstract class ToolServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ListToolsResponse> listTools(
      $pb.ServerContext ctx, $2.ListToolsRequest request);
  $async.Future<$2.CreateToolResponse> createTool(
      $pb.ServerContext ctx, $2.CreateToolRequest request);
  $async.Future<$2.UpdateToolResponse> updateTool(
      $pb.ServerContext ctx, $2.UpdateToolRequest request);
  $async.Future<$2.DeleteToolResponse> deleteTool(
      $pb.ServerContext ctx, $2.DeleteToolRequest request);
  $async.Future<$2.StartRunResponse> startRun(
      $pb.ServerContext ctx, $2.StartRunRequest request);
  $async.Future<$2.GetRunResponse> getRun(
      $pb.ServerContext ctx, $2.GetRunRequest request);
  $async.Future<$2.ListRunsResponse> listRuns(
      $pb.ServerContext ctx, $2.ListRunsRequest request);
  $async.Future<$2.CancelRunResponse> cancelRun(
      $pb.ServerContext ctx, $2.CancelRunRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListTools':
        return $2.ListToolsRequest();
      case 'CreateTool':
        return $2.CreateToolRequest();
      case 'UpdateTool':
        return $2.UpdateToolRequest();
      case 'DeleteTool':
        return $2.DeleteToolRequest();
      case 'StartRun':
        return $2.StartRunRequest();
      case 'GetRun':
        return $2.GetRunRequest();
      case 'ListRuns':
        return $2.ListRunsRequest();
      case 'CancelRun':
        return $2.CancelRunRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListTools':
        return listTools(ctx, request as $2.ListToolsRequest);
      case 'CreateTool':
        return createTool(ctx, request as $2.CreateToolRequest);
      case 'UpdateTool':
        return updateTool(ctx, request as $2.UpdateToolRequest);
      case 'DeleteTool':
        return deleteTool(ctx, request as $2.DeleteToolRequest);
      case 'StartRun':
        return startRun(ctx, request as $2.StartRunRequest);
      case 'GetRun':
        return getRun(ctx, request as $2.GetRunRequest);
      case 'ListRuns':
        return listRuns(ctx, request as $2.ListRunsRequest);
      case 'CancelRun':
        return cancelRun(ctx, request as $2.CancelRunRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ToolServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ToolServiceBase$messageJson;
}
