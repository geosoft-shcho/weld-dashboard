// This is a generated file - do not edit.
//
// Generated from dashboard_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dashboard_service.pb.dart' as $0;
import 'dashboard_service.pbjson.dart';

export 'dashboard_service.pb.dart';

abstract class DashboardServiceBase extends $pb.GeneratedService {
  $async.Future<$0.ListEquipmentResponse> listEquipment(
      $pb.ServerContext ctx, $0.ListEquipmentRequest request);
  $async.Future<$0.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $0.ListProjectsRequest request);
  $async.Future<$0.ListCollectionAssignmentsResponse> listCollectionAssignments(
      $pb.ServerContext ctx, $0.ListCollectionAssignmentsRequest request);
  $async.Future<$0.ListCollectionEventsResponse> listCollectionEvents(
      $pb.ServerContext ctx, $0.ListCollectionEventsRequest request);
  $async.Future<$0.ListEquipmentStatusResponse> listEquipmentStatus(
      $pb.ServerContext ctx, $0.ListEquipmentStatusRequest request);
  $async.Future<$0.ListWorkOrdersResponse> listWorkOrders(
      $pb.ServerContext ctx, $0.ListWorkOrdersRequest request);
  $async.Future<$0.ListJointsResponse> listJoints(
      $pb.ServerContext ctx, $0.ListJointsRequest request);
  $async.Future<$0.ListWorkersResponse> listWorkers(
      $pb.ServerContext ctx, $0.ListWorkersRequest request);
  $async.Future<$0.ListWorkHistoryResponse> listWorkHistory(
      $pb.ServerContext ctx, $0.ListWorkHistoryRequest request);
  $async.Future<$0.ListWorkAttachmentsResponse> listWorkAttachments(
      $pb.ServerContext ctx, $0.ListWorkAttachmentsRequest request);
  $async.Future<$0.ListPassesResponse> listPasses(
      $pb.ServerContext ctx, $0.ListPassesRequest request);
  $async.Future<$0.ListWaveformSeriesResponse> listWaveformSeries(
      $pb.ServerContext ctx, $0.ListWaveformSeriesRequest request);
  $async.Future<$0.GetPassWaveformResponse> getPassWaveform(
      $pb.ServerContext ctx, $0.GetPassWaveformRequest request);
  $async.Future<$0.ListQualityResultsResponse> listQualityResults(
      $pb.ServerContext ctx, $0.ListQualityResultsRequest request);
  $async.Future<$0.ListQualityLinksResponse> listQualityLinks(
      $pb.ServerContext ctx, $0.ListQualityLinksRequest request);
  $async.Future<$0.GetContextResponse> getContext(
      $pb.ServerContext ctx, $0.GetContextRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListEquipment':
        return $0.ListEquipmentRequest();
      case 'ListProjects':
        return $0.ListProjectsRequest();
      case 'ListCollectionAssignments':
        return $0.ListCollectionAssignmentsRequest();
      case 'ListCollectionEvents':
        return $0.ListCollectionEventsRequest();
      case 'ListEquipmentStatus':
        return $0.ListEquipmentStatusRequest();
      case 'ListWorkOrders':
        return $0.ListWorkOrdersRequest();
      case 'ListJoints':
        return $0.ListJointsRequest();
      case 'ListWorkers':
        return $0.ListWorkersRequest();
      case 'ListWorkHistory':
        return $0.ListWorkHistoryRequest();
      case 'ListWorkAttachments':
        return $0.ListWorkAttachmentsRequest();
      case 'ListPasses':
        return $0.ListPassesRequest();
      case 'ListWaveformSeries':
        return $0.ListWaveformSeriesRequest();
      case 'GetPassWaveform':
        return $0.GetPassWaveformRequest();
      case 'ListQualityResults':
        return $0.ListQualityResultsRequest();
      case 'ListQualityLinks':
        return $0.ListQualityLinksRequest();
      case 'GetContext':
        return $0.GetContextRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListEquipment':
        return listEquipment(ctx, request as $0.ListEquipmentRequest);
      case 'ListProjects':
        return listProjects(ctx, request as $0.ListProjectsRequest);
      case 'ListCollectionAssignments':
        return listCollectionAssignments(
            ctx, request as $0.ListCollectionAssignmentsRequest);
      case 'ListCollectionEvents':
        return listCollectionEvents(
            ctx, request as $0.ListCollectionEventsRequest);
      case 'ListEquipmentStatus':
        return listEquipmentStatus(
            ctx, request as $0.ListEquipmentStatusRequest);
      case 'ListWorkOrders':
        return listWorkOrders(ctx, request as $0.ListWorkOrdersRequest);
      case 'ListJoints':
        return listJoints(ctx, request as $0.ListJointsRequest);
      case 'ListWorkers':
        return listWorkers(ctx, request as $0.ListWorkersRequest);
      case 'ListWorkHistory':
        return listWorkHistory(ctx, request as $0.ListWorkHistoryRequest);
      case 'ListWorkAttachments':
        return listWorkAttachments(
            ctx, request as $0.ListWorkAttachmentsRequest);
      case 'ListPasses':
        return listPasses(ctx, request as $0.ListPassesRequest);
      case 'ListWaveformSeries':
        return listWaveformSeries(ctx, request as $0.ListWaveformSeriesRequest);
      case 'GetPassWaveform':
        return getPassWaveform(ctx, request as $0.GetPassWaveformRequest);
      case 'ListQualityResults':
        return listQualityResults(ctx, request as $0.ListQualityResultsRequest);
      case 'ListQualityLinks':
        return listQualityLinks(ctx, request as $0.ListQualityLinksRequest);
      case 'GetContext':
        return getContext(ctx, request as $0.GetContextRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DashboardServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DashboardServiceBase$messageJson;
}
