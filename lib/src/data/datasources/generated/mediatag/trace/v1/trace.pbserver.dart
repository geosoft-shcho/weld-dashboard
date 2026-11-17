// This is a generated file - do not edit.
//
// Generated from mediatag/trace/v1/trace.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'trace.pb.dart' as $3;
import 'trace.pbjson.dart';

export 'trace.pb.dart';

abstract class TraceServiceBase extends $pb.GeneratedService {
  $async.Future<$3.ListTracesResponse> listTraces(
      $pb.ServerContext ctx, $3.ListTracesRequest request);
  $async.Future<$3.GetTraceResponse> getTrace(
      $pb.ServerContext ctx, $3.GetTraceRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListTraces':
        return $3.ListTracesRequest();
      case 'GetTrace':
        return $3.GetTraceRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListTraces':
        return listTraces(ctx, request as $3.ListTracesRequest);
      case 'GetTrace':
        return getTrace(ctx, request as $3.GetTraceRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TraceServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => TraceServiceBase$messageJson;
}
