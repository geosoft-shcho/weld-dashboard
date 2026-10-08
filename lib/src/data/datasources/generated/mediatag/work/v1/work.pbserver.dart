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

import 'work.pb.dart' as $4;
import 'work.pbjson.dart';

export 'work.pb.dart';

abstract class WorkServiceBase extends $pb.GeneratedService {
  $async.Future<$4.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $4.ListProjectsRequest request);
  $async.Future<$4.CreateProjectResponse> createProject(
      $pb.ServerContext ctx, $4.CreateProjectRequest request);
  $async.Future<$4.ListWorkersResponse> listWorkers(
      $pb.ServerContext ctx, $4.ListWorkersRequest request);
  $async.Future<$4.CreateWorkerResponse> createWorker(
      $pb.ServerContext ctx, $4.CreateWorkerRequest request);
  $async.Future<$4.UpdateWorkerResponse> updateWorker(
      $pb.ServerContext ctx, $4.UpdateWorkerRequest request);
  $async.Future<$4.DeleteWorkerResponse> deleteWorker(
      $pb.ServerContext ctx, $4.DeleteWorkerRequest request);
  $async.Future<$4.ListEquipmentResponse> listEquipment(
      $pb.ServerContext ctx, $4.ListEquipmentRequest request);
  $async.Future<$4.CreateEquipmentResponse> createEquipment(
      $pb.ServerContext ctx, $4.CreateEquipmentRequest request);
  $async.Future<$4.UpdateEquipmentResponse> updateEquipment(
      $pb.ServerContext ctx, $4.UpdateEquipmentRequest request);
  $async.Future<$4.DeleteEquipmentResponse> deleteEquipment(
      $pb.ServerContext ctx, $4.DeleteEquipmentRequest request);
  $async.Future<$4.CreateProjectItemsResponse> createProjectItems(
      $pb.ServerContext ctx, $4.CreateProjectItemsRequest request);
  $async.Future<$4.UpdateProjectItemResponse> updateProjectItem(
      $pb.ServerContext ctx, $4.UpdateProjectItemRequest request);
  $async.Future<$4.ListItemsResponse> listItems(
      $pb.ServerContext ctx, $4.ListItemsRequest request);
  $async.Future<$4.ListJobFiltersResponse> listJobFilters(
      $pb.ServerContext ctx, $4.ListJobFiltersRequest request);
  $async.Future<$4.ListJobsResponse> listJobs(
      $pb.ServerContext ctx, $4.ListJobsRequest request);
  $async.Future<$4.UpdateProjectResponse> updateProject(
      $pb.ServerContext ctx, $4.UpdateProjectRequest request);
  $async.Future<$4.DeleteProjectResponse> deleteProject(
      $pb.ServerContext ctx, $4.DeleteProjectRequest request);
  $async.Future<$4.CreateJobResponse> createJob(
      $pb.ServerContext ctx, $4.CreateJobRequest request);
  $async.Future<$4.UpdateJobResponse> updateJob(
      $pb.ServerContext ctx, $4.UpdateJobRequest request);
  $async.Future<$4.DeleteJobResponse> deleteJob(
      $pb.ServerContext ctx, $4.DeleteJobRequest request);
  $async.Future<$4.CreatePassResponse> createPass(
      $pb.ServerContext ctx, $4.CreatePassRequest request);
  $async.Future<$4.UpdatePassResponse> updatePass(
      $pb.ServerContext ctx, $4.UpdatePassRequest request);
  $async.Future<$4.DeletePassResponse> deletePass(
      $pb.ServerContext ctx, $4.DeletePassRequest request);
  $async.Future<$4.GetJobResponse> getJob(
      $pb.ServerContext ctx, $4.GetJobRequest request);
  $async.Future<$4.ListCollectionNodesResponse> listCollectionNodes(
      $pb.ServerContext ctx, $4.ListCollectionNodesRequest request);
  $async.Future<$4.GetPassWaveformResponse> getPassWaveform(
      $pb.ServerContext ctx, $4.GetPassWaveformRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListProjects':
        return $4.ListProjectsRequest();
      case 'CreateProject':
        return $4.CreateProjectRequest();
      case 'ListWorkers':
        return $4.ListWorkersRequest();
      case 'CreateWorker':
        return $4.CreateWorkerRequest();
      case 'UpdateWorker':
        return $4.UpdateWorkerRequest();
      case 'DeleteWorker':
        return $4.DeleteWorkerRequest();
      case 'ListEquipment':
        return $4.ListEquipmentRequest();
      case 'CreateEquipment':
        return $4.CreateEquipmentRequest();
      case 'UpdateEquipment':
        return $4.UpdateEquipmentRequest();
      case 'DeleteEquipment':
        return $4.DeleteEquipmentRequest();
      case 'CreateProjectItems':
        return $4.CreateProjectItemsRequest();
      case 'UpdateProjectItem':
        return $4.UpdateProjectItemRequest();
      case 'ListItems':
        return $4.ListItemsRequest();
      case 'ListJobFilters':
        return $4.ListJobFiltersRequest();
      case 'ListJobs':
        return $4.ListJobsRequest();
      case 'UpdateProject':
        return $4.UpdateProjectRequest();
      case 'DeleteProject':
        return $4.DeleteProjectRequest();
      case 'CreateJob':
        return $4.CreateJobRequest();
      case 'UpdateJob':
        return $4.UpdateJobRequest();
      case 'DeleteJob':
        return $4.DeleteJobRequest();
      case 'CreatePass':
        return $4.CreatePassRequest();
      case 'UpdatePass':
        return $4.UpdatePassRequest();
      case 'DeletePass':
        return $4.DeletePassRequest();
      case 'GetJob':
        return $4.GetJobRequest();
      case 'ListCollectionNodes':
        return $4.ListCollectionNodesRequest();
      case 'GetPassWaveform':
        return $4.GetPassWaveformRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListProjects':
        return listProjects(ctx, request as $4.ListProjectsRequest);
      case 'CreateProject':
        return createProject(ctx, request as $4.CreateProjectRequest);
      case 'ListWorkers':
        return listWorkers(ctx, request as $4.ListWorkersRequest);
      case 'CreateWorker':
        return createWorker(ctx, request as $4.CreateWorkerRequest);
      case 'UpdateWorker':
        return updateWorker(ctx, request as $4.UpdateWorkerRequest);
      case 'DeleteWorker':
        return deleteWorker(ctx, request as $4.DeleteWorkerRequest);
      case 'ListEquipment':
        return listEquipment(ctx, request as $4.ListEquipmentRequest);
      case 'CreateEquipment':
        return createEquipment(ctx, request as $4.CreateEquipmentRequest);
      case 'UpdateEquipment':
        return updateEquipment(ctx, request as $4.UpdateEquipmentRequest);
      case 'DeleteEquipment':
        return deleteEquipment(ctx, request as $4.DeleteEquipmentRequest);
      case 'CreateProjectItems':
        return createProjectItems(ctx, request as $4.CreateProjectItemsRequest);
      case 'UpdateProjectItem':
        return updateProjectItem(ctx, request as $4.UpdateProjectItemRequest);
      case 'ListItems':
        return listItems(ctx, request as $4.ListItemsRequest);
      case 'ListJobFilters':
        return listJobFilters(ctx, request as $4.ListJobFiltersRequest);
      case 'ListJobs':
        return listJobs(ctx, request as $4.ListJobsRequest);
      case 'UpdateProject':
        return updateProject(ctx, request as $4.UpdateProjectRequest);
      case 'DeleteProject':
        return deleteProject(ctx, request as $4.DeleteProjectRequest);
      case 'CreateJob':
        return createJob(ctx, request as $4.CreateJobRequest);
      case 'UpdateJob':
        return updateJob(ctx, request as $4.UpdateJobRequest);
      case 'DeleteJob':
        return deleteJob(ctx, request as $4.DeleteJobRequest);
      case 'CreatePass':
        return createPass(ctx, request as $4.CreatePassRequest);
      case 'UpdatePass':
        return updatePass(ctx, request as $4.UpdatePassRequest);
      case 'DeletePass':
        return deletePass(ctx, request as $4.DeletePassRequest);
      case 'GetJob':
        return getJob(ctx, request as $4.GetJobRequest);
      case 'ListCollectionNodes':
        return listCollectionNodes(
            ctx, request as $4.ListCollectionNodesRequest);
      case 'GetPassWaveform':
        return getPassWaveform(ctx, request as $4.GetPassWaveformRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => WorkServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => WorkServiceBase$messageJson;
}
