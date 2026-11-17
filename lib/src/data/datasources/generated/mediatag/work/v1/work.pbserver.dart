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

import 'work.pb.dart' as $5;
import 'work.pbjson.dart';

export 'work.pb.dart';

abstract class WorkServiceBase extends $pb.GeneratedService {
  $async.Future<$5.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $5.ListProjectsRequest request);
  $async.Future<$5.GetProjectResponse> getProject(
      $pb.ServerContext ctx, $5.GetProjectRequest request);
  $async.Future<$5.CreateProjectResponse> createProject(
      $pb.ServerContext ctx, $5.CreateProjectRequest request);
  $async.Future<$5.ListWorkersResponse> listWorkers(
      $pb.ServerContext ctx, $5.ListWorkersRequest request);
  $async.Future<$5.GetWorkerResponse> getWorker(
      $pb.ServerContext ctx, $5.GetWorkerRequest request);
  $async.Future<$5.CreateWorkerResponse> createWorker(
      $pb.ServerContext ctx, $5.CreateWorkerRequest request);
  $async.Future<$5.UpdateWorkerResponse> updateWorker(
      $pb.ServerContext ctx, $5.UpdateWorkerRequest request);
  $async.Future<$5.DeleteWorkerResponse> deleteWorker(
      $pb.ServerContext ctx, $5.DeleteWorkerRequest request);
  $async.Future<$5.ListEquipmentResponse> listEquipment(
      $pb.ServerContext ctx, $5.ListEquipmentRequest request);
  $async.Future<$5.GetEquipmentResponse> getEquipment(
      $pb.ServerContext ctx, $5.GetEquipmentRequest request);
  $async.Future<$5.CreateEquipmentResponse> createEquipment(
      $pb.ServerContext ctx, $5.CreateEquipmentRequest request);
  $async.Future<$5.UpdateEquipmentResponse> updateEquipment(
      $pb.ServerContext ctx, $5.UpdateEquipmentRequest request);
  $async.Future<$5.DeleteEquipmentResponse> deleteEquipment(
      $pb.ServerContext ctx, $5.DeleteEquipmentRequest request);
  $async.Future<$5.CreateProjectItemsResponse> createProjectItems(
      $pb.ServerContext ctx, $5.CreateProjectItemsRequest request);
  $async.Future<$5.UpdateProjectItemResponse> updateProjectItem(
      $pb.ServerContext ctx, $5.UpdateProjectItemRequest request);
  $async.Future<$5.DeleteProjectItemResponse> deleteProjectItem(
      $pb.ServerContext ctx, $5.DeleteProjectItemRequest request);
  $async.Future<$5.ListItemsResponse> listItems(
      $pb.ServerContext ctx, $5.ListItemsRequest request);
  $async.Future<$5.ListJobFiltersResponse> listJobFilters(
      $pb.ServerContext ctx, $5.ListJobFiltersRequest request);
  $async.Future<$5.ListJobsResponse> listJobs(
      $pb.ServerContext ctx, $5.ListJobsRequest request);
  $async.Future<$5.UpdateProjectResponse> updateProject(
      $pb.ServerContext ctx, $5.UpdateProjectRequest request);
  $async.Future<$5.DeleteProjectResponse> deleteProject(
      $pb.ServerContext ctx, $5.DeleteProjectRequest request);
  $async.Future<$5.CreateJobResponse> createJob(
      $pb.ServerContext ctx, $5.CreateJobRequest request);
  $async.Future<$5.UpdateJobResponse> updateJob(
      $pb.ServerContext ctx, $5.UpdateJobRequest request);
  $async.Future<$5.DeleteJobResponse> deleteJob(
      $pb.ServerContext ctx, $5.DeleteJobRequest request);
  $async.Future<$5.CreatePassResponse> createPass(
      $pb.ServerContext ctx, $5.CreatePassRequest request);
  $async.Future<$5.UpdatePassResponse> updatePass(
      $pb.ServerContext ctx, $5.UpdatePassRequest request);
  $async.Future<$5.DeletePassResponse> deletePass(
      $pb.ServerContext ctx, $5.DeletePassRequest request);
  $async.Future<$5.GetJobResponse> getJob(
      $pb.ServerContext ctx, $5.GetJobRequest request);
  $async.Future<$5.ListCollectionNodesResponse> listCollectionNodes(
      $pb.ServerContext ctx, $5.ListCollectionNodesRequest request);
  $async.Future<$5.GetPassWaveformResponse> getPassWaveform(
      $pb.ServerContext ctx, $5.GetPassWaveformRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListProjects':
        return $5.ListProjectsRequest();
      case 'GetProject':
        return $5.GetProjectRequest();
      case 'CreateProject':
        return $5.CreateProjectRequest();
      case 'ListWorkers':
        return $5.ListWorkersRequest();
      case 'GetWorker':
        return $5.GetWorkerRequest();
      case 'CreateWorker':
        return $5.CreateWorkerRequest();
      case 'UpdateWorker':
        return $5.UpdateWorkerRequest();
      case 'DeleteWorker':
        return $5.DeleteWorkerRequest();
      case 'ListEquipment':
        return $5.ListEquipmentRequest();
      case 'GetEquipment':
        return $5.GetEquipmentRequest();
      case 'CreateEquipment':
        return $5.CreateEquipmentRequest();
      case 'UpdateEquipment':
        return $5.UpdateEquipmentRequest();
      case 'DeleteEquipment':
        return $5.DeleteEquipmentRequest();
      case 'CreateProjectItems':
        return $5.CreateProjectItemsRequest();
      case 'UpdateProjectItem':
        return $5.UpdateProjectItemRequest();
      case 'DeleteProjectItem':
        return $5.DeleteProjectItemRequest();
      case 'ListItems':
        return $5.ListItemsRequest();
      case 'ListJobFilters':
        return $5.ListJobFiltersRequest();
      case 'ListJobs':
        return $5.ListJobsRequest();
      case 'UpdateProject':
        return $5.UpdateProjectRequest();
      case 'DeleteProject':
        return $5.DeleteProjectRequest();
      case 'CreateJob':
        return $5.CreateJobRequest();
      case 'UpdateJob':
        return $5.UpdateJobRequest();
      case 'DeleteJob':
        return $5.DeleteJobRequest();
      case 'CreatePass':
        return $5.CreatePassRequest();
      case 'UpdatePass':
        return $5.UpdatePassRequest();
      case 'DeletePass':
        return $5.DeletePassRequest();
      case 'GetJob':
        return $5.GetJobRequest();
      case 'ListCollectionNodes':
        return $5.ListCollectionNodesRequest();
      case 'GetPassWaveform':
        return $5.GetPassWaveformRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListProjects':
        return listProjects(ctx, request as $5.ListProjectsRequest);
      case 'GetProject':
        return getProject(ctx, request as $5.GetProjectRequest);
      case 'CreateProject':
        return createProject(ctx, request as $5.CreateProjectRequest);
      case 'ListWorkers':
        return listWorkers(ctx, request as $5.ListWorkersRequest);
      case 'GetWorker':
        return getWorker(ctx, request as $5.GetWorkerRequest);
      case 'CreateWorker':
        return createWorker(ctx, request as $5.CreateWorkerRequest);
      case 'UpdateWorker':
        return updateWorker(ctx, request as $5.UpdateWorkerRequest);
      case 'DeleteWorker':
        return deleteWorker(ctx, request as $5.DeleteWorkerRequest);
      case 'ListEquipment':
        return listEquipment(ctx, request as $5.ListEquipmentRequest);
      case 'GetEquipment':
        return getEquipment(ctx, request as $5.GetEquipmentRequest);
      case 'CreateEquipment':
        return createEquipment(ctx, request as $5.CreateEquipmentRequest);
      case 'UpdateEquipment':
        return updateEquipment(ctx, request as $5.UpdateEquipmentRequest);
      case 'DeleteEquipment':
        return deleteEquipment(ctx, request as $5.DeleteEquipmentRequest);
      case 'CreateProjectItems':
        return createProjectItems(ctx, request as $5.CreateProjectItemsRequest);
      case 'UpdateProjectItem':
        return updateProjectItem(ctx, request as $5.UpdateProjectItemRequest);
      case 'DeleteProjectItem':
        return deleteProjectItem(ctx, request as $5.DeleteProjectItemRequest);
      case 'ListItems':
        return listItems(ctx, request as $5.ListItemsRequest);
      case 'ListJobFilters':
        return listJobFilters(ctx, request as $5.ListJobFiltersRequest);
      case 'ListJobs':
        return listJobs(ctx, request as $5.ListJobsRequest);
      case 'UpdateProject':
        return updateProject(ctx, request as $5.UpdateProjectRequest);
      case 'DeleteProject':
        return deleteProject(ctx, request as $5.DeleteProjectRequest);
      case 'CreateJob':
        return createJob(ctx, request as $5.CreateJobRequest);
      case 'UpdateJob':
        return updateJob(ctx, request as $5.UpdateJobRequest);
      case 'DeleteJob':
        return deleteJob(ctx, request as $5.DeleteJobRequest);
      case 'CreatePass':
        return createPass(ctx, request as $5.CreatePassRequest);
      case 'UpdatePass':
        return updatePass(ctx, request as $5.UpdatePassRequest);
      case 'DeletePass':
        return deletePass(ctx, request as $5.DeletePassRequest);
      case 'GetJob':
        return getJob(ctx, request as $5.GetJobRequest);
      case 'ListCollectionNodes':
        return listCollectionNodes(
            ctx, request as $5.ListCollectionNodesRequest);
      case 'GetPassWaveform':
        return getPassWaveform(ctx, request as $5.GetPassWaveformRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => WorkServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => WorkServiceBase$messageJson;
}
