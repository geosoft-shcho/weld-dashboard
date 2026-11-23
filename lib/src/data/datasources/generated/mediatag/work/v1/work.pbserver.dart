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

import 'work.pb.dart' as $6;
import 'work.pbjson.dart';

export 'work.pb.dart';

abstract class WorkServiceBase extends $pb.GeneratedService {
  $async.Future<$6.ListProjectsResponse> listProjects(
      $pb.ServerContext ctx, $6.ListProjectsRequest request);
  $async.Future<$6.GetProjectResponse> getProject(
      $pb.ServerContext ctx, $6.GetProjectRequest request);
  $async.Future<$6.CreateProjectResponse> createProject(
      $pb.ServerContext ctx, $6.CreateProjectRequest request);
  $async.Future<$6.ListWorkersResponse> listWorkers(
      $pb.ServerContext ctx, $6.ListWorkersRequest request);
  $async.Future<$6.GetWorkerResponse> getWorker(
      $pb.ServerContext ctx, $6.GetWorkerRequest request);
  $async.Future<$6.CreateWorkerResponse> createWorker(
      $pb.ServerContext ctx, $6.CreateWorkerRequest request);
  $async.Future<$6.UpdateWorkerResponse> updateWorker(
      $pb.ServerContext ctx, $6.UpdateWorkerRequest request);
  $async.Future<$6.DeleteWorkerResponse> deleteWorker(
      $pb.ServerContext ctx, $6.DeleteWorkerRequest request);
  $async.Future<$6.ListEquipmentResponse> listEquipment(
      $pb.ServerContext ctx, $6.ListEquipmentRequest request);
  $async.Future<$6.GetEquipmentResponse> getEquipment(
      $pb.ServerContext ctx, $6.GetEquipmentRequest request);
  $async.Future<$6.CreateEquipmentResponse> createEquipment(
      $pb.ServerContext ctx, $6.CreateEquipmentRequest request);
  $async.Future<$6.UpdateEquipmentResponse> updateEquipment(
      $pb.ServerContext ctx, $6.UpdateEquipmentRequest request);
  $async.Future<$6.DeleteEquipmentResponse> deleteEquipment(
      $pb.ServerContext ctx, $6.DeleteEquipmentRequest request);
  $async.Future<$6.CreateProjectItemsResponse> createProjectItems(
      $pb.ServerContext ctx, $6.CreateProjectItemsRequest request);
  $async.Future<$6.UpdateProjectItemResponse> updateProjectItem(
      $pb.ServerContext ctx, $6.UpdateProjectItemRequest request);
  $async.Future<$6.DeleteProjectItemResponse> deleteProjectItem(
      $pb.ServerContext ctx, $6.DeleteProjectItemRequest request);
  $async.Future<$6.ListItemsResponse> listItems(
      $pb.ServerContext ctx, $6.ListItemsRequest request);
  $async.Future<$6.ListJobFiltersResponse> listJobFilters(
      $pb.ServerContext ctx, $6.ListJobFiltersRequest request);
  $async.Future<$6.ListJobsResponse> listJobs(
      $pb.ServerContext ctx, $6.ListJobsRequest request);
  $async.Future<$6.UpdateProjectResponse> updateProject(
      $pb.ServerContext ctx, $6.UpdateProjectRequest request);
  $async.Future<$6.DeleteProjectResponse> deleteProject(
      $pb.ServerContext ctx, $6.DeleteProjectRequest request);
  $async.Future<$6.CreateJobResponse> createJob(
      $pb.ServerContext ctx, $6.CreateJobRequest request);
  $async.Future<$6.UpdateJobResponse> updateJob(
      $pb.ServerContext ctx, $6.UpdateJobRequest request);
  $async.Future<$6.DeleteJobResponse> deleteJob(
      $pb.ServerContext ctx, $6.DeleteJobRequest request);
  $async.Future<$6.CreatePassResponse> createPass(
      $pb.ServerContext ctx, $6.CreatePassRequest request);
  $async.Future<$6.UpdatePassResponse> updatePass(
      $pb.ServerContext ctx, $6.UpdatePassRequest request);
  $async.Future<$6.DeletePassResponse> deletePass(
      $pb.ServerContext ctx, $6.DeletePassRequest request);
  $async.Future<$6.GetJobResponse> getJob(
      $pb.ServerContext ctx, $6.GetJobRequest request);
  $async.Future<$6.ListCollectionNodesResponse> listCollectionNodes(
      $pb.ServerContext ctx, $6.ListCollectionNodesRequest request);
  $async.Future<$6.GetPassWaveformResponse> getPassWaveform(
      $pb.ServerContext ctx, $6.GetPassWaveformRequest request);
  $async.Future<$6.GetCollectionSummaryResponse> getCollectionSummary(
      $pb.ServerContext ctx, $6.GetCollectionSummaryRequest request);
  $async.Future<$6.ListAssetCountsResponse> listAssetCounts(
      $pb.ServerContext ctx, $6.ListAssetCountsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListProjects':
        return $6.ListProjectsRequest();
      case 'GetProject':
        return $6.GetProjectRequest();
      case 'CreateProject':
        return $6.CreateProjectRequest();
      case 'ListWorkers':
        return $6.ListWorkersRequest();
      case 'GetWorker':
        return $6.GetWorkerRequest();
      case 'CreateWorker':
        return $6.CreateWorkerRequest();
      case 'UpdateWorker':
        return $6.UpdateWorkerRequest();
      case 'DeleteWorker':
        return $6.DeleteWorkerRequest();
      case 'ListEquipment':
        return $6.ListEquipmentRequest();
      case 'GetEquipment':
        return $6.GetEquipmentRequest();
      case 'CreateEquipment':
        return $6.CreateEquipmentRequest();
      case 'UpdateEquipment':
        return $6.UpdateEquipmentRequest();
      case 'DeleteEquipment':
        return $6.DeleteEquipmentRequest();
      case 'CreateProjectItems':
        return $6.CreateProjectItemsRequest();
      case 'UpdateProjectItem':
        return $6.UpdateProjectItemRequest();
      case 'DeleteProjectItem':
        return $6.DeleteProjectItemRequest();
      case 'ListItems':
        return $6.ListItemsRequest();
      case 'ListJobFilters':
        return $6.ListJobFiltersRequest();
      case 'ListJobs':
        return $6.ListJobsRequest();
      case 'UpdateProject':
        return $6.UpdateProjectRequest();
      case 'DeleteProject':
        return $6.DeleteProjectRequest();
      case 'CreateJob':
        return $6.CreateJobRequest();
      case 'UpdateJob':
        return $6.UpdateJobRequest();
      case 'DeleteJob':
        return $6.DeleteJobRequest();
      case 'CreatePass':
        return $6.CreatePassRequest();
      case 'UpdatePass':
        return $6.UpdatePassRequest();
      case 'DeletePass':
        return $6.DeletePassRequest();
      case 'GetJob':
        return $6.GetJobRequest();
      case 'ListCollectionNodes':
        return $6.ListCollectionNodesRequest();
      case 'GetPassWaveform':
        return $6.GetPassWaveformRequest();
      case 'GetCollectionSummary':
        return $6.GetCollectionSummaryRequest();
      case 'ListAssetCounts':
        return $6.ListAssetCountsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListProjects':
        return listProjects(ctx, request as $6.ListProjectsRequest);
      case 'GetProject':
        return getProject(ctx, request as $6.GetProjectRequest);
      case 'CreateProject':
        return createProject(ctx, request as $6.CreateProjectRequest);
      case 'ListWorkers':
        return listWorkers(ctx, request as $6.ListWorkersRequest);
      case 'GetWorker':
        return getWorker(ctx, request as $6.GetWorkerRequest);
      case 'CreateWorker':
        return createWorker(ctx, request as $6.CreateWorkerRequest);
      case 'UpdateWorker':
        return updateWorker(ctx, request as $6.UpdateWorkerRequest);
      case 'DeleteWorker':
        return deleteWorker(ctx, request as $6.DeleteWorkerRequest);
      case 'ListEquipment':
        return listEquipment(ctx, request as $6.ListEquipmentRequest);
      case 'GetEquipment':
        return getEquipment(ctx, request as $6.GetEquipmentRequest);
      case 'CreateEquipment':
        return createEquipment(ctx, request as $6.CreateEquipmentRequest);
      case 'UpdateEquipment':
        return updateEquipment(ctx, request as $6.UpdateEquipmentRequest);
      case 'DeleteEquipment':
        return deleteEquipment(ctx, request as $6.DeleteEquipmentRequest);
      case 'CreateProjectItems':
        return createProjectItems(ctx, request as $6.CreateProjectItemsRequest);
      case 'UpdateProjectItem':
        return updateProjectItem(ctx, request as $6.UpdateProjectItemRequest);
      case 'DeleteProjectItem':
        return deleteProjectItem(ctx, request as $6.DeleteProjectItemRequest);
      case 'ListItems':
        return listItems(ctx, request as $6.ListItemsRequest);
      case 'ListJobFilters':
        return listJobFilters(ctx, request as $6.ListJobFiltersRequest);
      case 'ListJobs':
        return listJobs(ctx, request as $6.ListJobsRequest);
      case 'UpdateProject':
        return updateProject(ctx, request as $6.UpdateProjectRequest);
      case 'DeleteProject':
        return deleteProject(ctx, request as $6.DeleteProjectRequest);
      case 'CreateJob':
        return createJob(ctx, request as $6.CreateJobRequest);
      case 'UpdateJob':
        return updateJob(ctx, request as $6.UpdateJobRequest);
      case 'DeleteJob':
        return deleteJob(ctx, request as $6.DeleteJobRequest);
      case 'CreatePass':
        return createPass(ctx, request as $6.CreatePassRequest);
      case 'UpdatePass':
        return updatePass(ctx, request as $6.UpdatePassRequest);
      case 'DeletePass':
        return deletePass(ctx, request as $6.DeletePassRequest);
      case 'GetJob':
        return getJob(ctx, request as $6.GetJobRequest);
      case 'ListCollectionNodes':
        return listCollectionNodes(
            ctx, request as $6.ListCollectionNodesRequest);
      case 'GetPassWaveform':
        return getPassWaveform(ctx, request as $6.GetPassWaveformRequest);
      case 'GetCollectionSummary':
        return getCollectionSummary(
            ctx, request as $6.GetCollectionSummaryRequest);
      case 'ListAssetCounts':
        return listAssetCounts(ctx, request as $6.ListAssetCountsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => WorkServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => WorkServiceBase$messageJson;
}
