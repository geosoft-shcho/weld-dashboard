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

import 'report.pb.dart' as $3;
import 'report.pbjson.dart';

export 'report.pb.dart';

abstract class ReportServiceBase extends $pb.GeneratedService {
  $async.Future<$3.ListReportSetsResponse> listReportSets(
      $pb.ServerContext ctx, $3.ListReportSetsRequest request);
  $async.Future<$3.GetReportSetResponse> getReportSet(
      $pb.ServerContext ctx, $3.GetReportSetRequest request);
  $async.Future<$3.ResolveReviewResponse> resolveReview(
      $pb.ServerContext ctx, $3.ResolveReviewRequest request);
  $async.Future<$3.UpdateReportFieldResponse> updateReportField(
      $pb.ServerContext ctx, $3.UpdateReportFieldRequest request);
  $async.Future<$3.ListQualityResultsResponse> listQualityResults(
      $pb.ServerContext ctx, $3.ListQualityResultsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListReportSets':
        return $3.ListReportSetsRequest();
      case 'GetReportSet':
        return $3.GetReportSetRequest();
      case 'ResolveReview':
        return $3.ResolveReviewRequest();
      case 'UpdateReportField':
        return $3.UpdateReportFieldRequest();
      case 'ListQualityResults':
        return $3.ListQualityResultsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListReportSets':
        return listReportSets(ctx, request as $3.ListReportSetsRequest);
      case 'GetReportSet':
        return getReportSet(ctx, request as $3.GetReportSetRequest);
      case 'ResolveReview':
        return resolveReview(ctx, request as $3.ResolveReviewRequest);
      case 'UpdateReportField':
        return updateReportField(ctx, request as $3.UpdateReportFieldRequest);
      case 'ListQualityResults':
        return listQualityResults(ctx, request as $3.ListQualityResultsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ReportServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ReportServiceBase$messageJson;
}
