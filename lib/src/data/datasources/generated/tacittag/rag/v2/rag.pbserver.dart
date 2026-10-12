// This is a generated file - do not edit.
//
// Generated from tacittag/rag/v2/rag.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'rag.pb.dart' as $0;
import 'rag.pbjson.dart';

export 'rag.pb.dart';

abstract class RagServiceBase extends $pb.GeneratedService {
  $async.Future<$0.AskQuestionResponse> askQuestion(
      $pb.ServerContext ctx, $0.AskQuestionRequest request);
  $async.Future<$0.GetSessionHistoryResponse> getSessionHistory(
      $pb.ServerContext ctx, $0.GetSessionHistoryRequest request);
  $async.Future<$0.IndexProjectResponse> indexProject(
      $pb.ServerContext ctx, $0.IndexProjectRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'AskQuestion':
        return $0.AskQuestionRequest();
      case 'GetSessionHistory':
        return $0.GetSessionHistoryRequest();
      case 'IndexProject':
        return $0.IndexProjectRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'AskQuestion':
        return askQuestion(ctx, request as $0.AskQuestionRequest);
      case 'GetSessionHistory':
        return getSessionHistory(ctx, request as $0.GetSessionHistoryRequest);
      case 'IndexProject':
        return indexProject(ctx, request as $0.IndexProjectRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RagServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RagServiceBase$messageJson;
}
