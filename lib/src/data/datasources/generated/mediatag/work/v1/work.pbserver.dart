// This is a generated file - do not edit.
//
// Generated from mediatag/work/v1/work.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'work.pb.dart' as $3;
import 'work.pbjson.dart';

export 'work.pb.dart';

abstract class WorkServiceBase extends $pb.GeneratedService {
  $async.Future<$3.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $3.ListProjectsRequest request);
  $async.Future<$3.ListWorkersResponse> listWorkers(
      $pb.ServerContext ctx, $3.ListWorkersRequest request);
  $async.Future<$3.ListEquipmentResponse> listEquipment(
      $pb.ServerContext ctx, $3.ListEquipmentRequest request);
  $async.Future<$3.ListJobsResponse> listJobs(
      $pb.ServerContext ctx, $3.ListJobsRequest request);
  $async.Future<$3.GetJobResponse> getJob(
      $pb.ServerContext ctx, $3.GetJobRequest request);
  $async.Future<$3.ListCollectionNodesResponse> listCollectionNodes(
      $pb.ServerContext ctx, $3.ListCollectionNodesRequest request);
  $async.Future<$3.GetPassWaveformResponse> getPassWaveform(
      $pb.ServerContext ctx, $3.GetPassWaveformRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListProjects':
        return $3.ListProjectsRequest();
      case 'ListWorkers':
        return $3.ListWorkersRequest();
      case 'ListEquipment':
        return $3.ListEquipmentRequest();
      case 'ListJobs':
        return $3.ListJobsRequest();
      case 'GetJob':
        return $3.GetJobRequest();
      case 'ListCollectionNodes':
        return $3.ListCollectionNodesRequest();
      case 'GetPassWaveform':
        return $3.GetPassWaveformRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListProjects':
        return listProjects(ctx, request as $3.ListProjectsRequest);
      case 'ListWorkers':
        return listWorkers(ctx, request as $3.ListWorkersRequest);
      case 'ListEquipment':
        return listEquipment(ctx, request as $3.ListEquipmentRequest);
      case 'ListJobs':
        return listJobs(ctx, request as $3.ListJobsRequest);
      case 'GetJob':
        return getJob(ctx, request as $3.GetJobRequest);
      case 'ListCollectionNodes':
        return listCollectionNodes(
            ctx, request as $3.ListCollectionNodesRequest);
      case 'GetPassWaveform':
        return getPassWaveform(ctx, request as $3.GetPassWaveformRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => WorkServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => WorkServiceBase$messageJson;
}
