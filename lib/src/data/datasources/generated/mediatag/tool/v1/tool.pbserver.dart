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
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ToolServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ToolServiceBase$messageJson;
}
