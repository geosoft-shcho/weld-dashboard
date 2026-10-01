// This is a generated file - do not edit.
//
// Generated from mediatag/report/v1/report.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'report.pb.dart' as $2;
import 'report.pbjson.dart';

export 'report.pb.dart';

abstract class ReportServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ListReportSetsResponse> listReportSets(
      $pb.ServerContext ctx, $2.ListReportSetsRequest request);
  $async.Future<$2.GetReportSetResponse> getReportSet(
      $pb.ServerContext ctx, $2.GetReportSetRequest request);
  $async.Future<$2.ResolveReviewResponse> resolveReview(
      $pb.ServerContext ctx, $2.ResolveReviewRequest request);
  $async.Future<$2.MatchReportSetResponse> matchReportSet(
      $pb.ServerContext ctx, $2.MatchReportSetRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListReportSets':
        return $2.ListReportSetsRequest();
      case 'GetReportSet':
        return $2.GetReportSetRequest();
      case 'ResolveReview':
        return $2.ResolveReviewRequest();
      case 'MatchReportSet':
        return $2.MatchReportSetRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListReportSets':
        return listReportSets(ctx, request as $2.ListReportSetsRequest);
      case 'GetReportSet':
        return getReportSet(ctx, request as $2.GetReportSetRequest);
      case 'ResolveReview':
        return resolveReview(ctx, request as $2.ResolveReviewRequest);
      case 'MatchReportSet':
        return matchReportSet(ctx, request as $2.MatchReportSetRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ReportServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ReportServiceBase$messageJson;
}
