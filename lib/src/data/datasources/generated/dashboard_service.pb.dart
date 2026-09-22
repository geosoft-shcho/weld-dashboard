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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Equipment extends $pb.GeneratedMessage {
  factory Equipment({
    $core.String? equipmentId,
    $core.String? equipmentName,
    $core.String? lineName,
  }) {
    final result = create();
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (lineName != null) result.lineName = lineName;
    return result;
  }

  Equipment._();

  factory Equipment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Equipment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Equipment',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(2, _omitFieldNames ? '' : 'equipmentName')
    ..aOS(3, _omitFieldNames ? '' : 'lineName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Equipment clone() => Equipment()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Equipment copyWith(void Function(Equipment) updates) =>
      super.copyWith((message) => updates(message as Equipment)) as Equipment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Equipment create() => Equipment._();
  @$core.override
  Equipment createEmptyInstance() => create();
  static $pb.PbList<Equipment> createRepeated() => $pb.PbList<Equipment>();
  @$core.pragma('dart2js:noInline')
  static Equipment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Equipment>(create);
  static Equipment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get equipmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set equipmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get equipmentName => $_getSZ(1);
  @$pb.TagNumber(2)
  set equipmentName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipmentName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipmentName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lineName => $_getSZ(2);
  @$pb.TagNumber(3)
  set lineName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLineName() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineName() => $_clearField(3);
}

class ListEquipmentRequest extends $pb.GeneratedMessage {
  factory ListEquipmentRequest() => create();

  ListEquipmentRequest._();

  factory ListEquipmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEquipmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEquipmentRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentRequest clone() =>
      ListEquipmentRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentRequest copyWith(void Function(ListEquipmentRequest) updates) =>
      super.copyWith((message) => updates(message as ListEquipmentRequest))
          as ListEquipmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEquipmentRequest create() => ListEquipmentRequest._();
  @$core.override
  ListEquipmentRequest createEmptyInstance() => create();
  static $pb.PbList<ListEquipmentRequest> createRepeated() =>
      $pb.PbList<ListEquipmentRequest>();
  @$core.pragma('dart2js:noInline')
  static ListEquipmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEquipmentRequest>(create);
  static ListEquipmentRequest? _defaultInstance;
}

class ListEquipmentResponse extends $pb.GeneratedMessage {
  factory ListEquipmentResponse({
    $core.Iterable<Equipment>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListEquipmentResponse._();

  factory ListEquipmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEquipmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEquipmentResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<Equipment>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: Equipment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentResponse clone() =>
      ListEquipmentResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentResponse copyWith(
          void Function(ListEquipmentResponse) updates) =>
      super.copyWith((message) => updates(message as ListEquipmentResponse))
          as ListEquipmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEquipmentResponse create() => ListEquipmentResponse._();
  @$core.override
  ListEquipmentResponse createEmptyInstance() => create();
  static $pb.PbList<ListEquipmentResponse> createRepeated() =>
      $pb.PbList<ListEquipmentResponse>();
  @$core.pragma('dart2js:noInline')
  static ListEquipmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEquipmentResponse>(create);
  static ListEquipmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Equipment> get items => $_getList(0);
}

class Project extends $pb.GeneratedMessage {
  factory Project({
    $core.String? projectId,
    $core.String? projectName,
    $core.String? siteName,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    if (projectName != null) result.projectName = projectName;
    if (siteName != null) result.siteName = siteName;
    return result;
  }

  Project._();

  factory Project.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Project.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Project',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'projectName')
    ..aOS(3, _omitFieldNames ? '' : 'siteName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Project clone() => Project()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Project copyWith(void Function(Project) updates) =>
      super.copyWith((message) => updates(message as Project)) as Project;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Project create() => Project._();
  @$core.override
  Project createEmptyInstance() => create();
  static $pb.PbList<Project> createRepeated() => $pb.PbList<Project>();
  @$core.pragma('dart2js:noInline')
  static Project getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Project>(create);
  static Project? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectName => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectName() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get siteName => $_getSZ(2);
  @$pb.TagNumber(3)
  set siteName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSiteName() => $_has(2);
  @$pb.TagNumber(3)
  void clearSiteName() => $_clearField(3);
}

class ListProjectsRequest extends $pb.GeneratedMessage {
  factory ListProjectsRequest() => create();

  ListProjectsRequest._();

  factory ListProjectsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProjectsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProjectsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsRequest clone() => ListProjectsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsRequest copyWith(void Function(ListProjectsRequest) updates) =>
      super.copyWith((message) => updates(message as ListProjectsRequest))
          as ListProjectsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest create() => ListProjectsRequest._();
  @$core.override
  ListProjectsRequest createEmptyInstance() => create();
  static $pb.PbList<ListProjectsRequest> createRepeated() =>
      $pb.PbList<ListProjectsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProjectsRequest>(create);
  static ListProjectsRequest? _defaultInstance;
}

class ListProjectsResponse extends $pb.GeneratedMessage {
  factory ListProjectsResponse({
    $core.Iterable<Project>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListProjectsResponse._();

  factory ListProjectsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProjectsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProjectsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<Project>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsResponse clone() =>
      ListProjectsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsResponse copyWith(void Function(ListProjectsResponse) updates) =>
      super.copyWith((message) => updates(message as ListProjectsResponse))
          as ListProjectsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse create() => ListProjectsResponse._();
  @$core.override
  ListProjectsResponse createEmptyInstance() => create();
  static $pb.PbList<ListProjectsResponse> createRepeated() =>
      $pb.PbList<ListProjectsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProjectsResponse>(create);
  static ListProjectsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Project> get items => $_getList(0);
}

class CollectionAssignment extends $pb.GeneratedMessage {
  factory CollectionAssignment({
    $core.String? assignmentId,
    $core.String? equipmentId,
    $core.String? projectId,
    $core.String? workOrderId,
    $core.String? workerId,
    $core.String? assignedFrom,
    $core.String? assignedTo,
    $core.String? note,
  }) {
    final result = create();
    if (assignmentId != null) result.assignmentId = assignmentId;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (projectId != null) result.projectId = projectId;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (workerId != null) result.workerId = workerId;
    if (assignedFrom != null) result.assignedFrom = assignedFrom;
    if (assignedTo != null) result.assignedTo = assignedTo;
    if (note != null) result.note = note;
    return result;
  }

  CollectionAssignment._();

  factory CollectionAssignment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectionAssignment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectionAssignment',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assignmentId')
    ..aOS(2, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(3, _omitFieldNames ? '' : 'projectId')
    ..aOS(4, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(5, _omitFieldNames ? '' : 'workerId')
    ..aOS(6, _omitFieldNames ? '' : 'assignedFrom')
    ..aOS(7, _omitFieldNames ? '' : 'assignedTo')
    ..aOS(8, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionAssignment clone() =>
      CollectionAssignment()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionAssignment copyWith(void Function(CollectionAssignment) updates) =>
      super.copyWith((message) => updates(message as CollectionAssignment))
          as CollectionAssignment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionAssignment create() => CollectionAssignment._();
  @$core.override
  CollectionAssignment createEmptyInstance() => create();
  static $pb.PbList<CollectionAssignment> createRepeated() =>
      $pb.PbList<CollectionAssignment>();
  @$core.pragma('dart2js:noInline')
  static CollectionAssignment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectionAssignment>(create);
  static CollectionAssignment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assignmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assignmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get equipmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set equipmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get projectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set projectId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workOrderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set workOrderId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkOrderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkOrderId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get workerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set workerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get assignedFrom => $_getSZ(5);
  @$pb.TagNumber(6)
  set assignedFrom($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssignedFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssignedFrom() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get assignedTo => $_getSZ(6);
  @$pb.TagNumber(7)
  set assignedTo($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAssignedTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssignedTo() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get note => $_getSZ(7);
  @$pb.TagNumber(8)
  set note($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNote() => $_has(7);
  @$pb.TagNumber(8)
  void clearNote() => $_clearField(8);
}

class ListCollectionAssignmentsRequest extends $pb.GeneratedMessage {
  factory ListCollectionAssignmentsRequest() => create();

  ListCollectionAssignmentsRequest._();

  factory ListCollectionAssignmentsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionAssignmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionAssignmentsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionAssignmentsRequest clone() =>
      ListCollectionAssignmentsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionAssignmentsRequest copyWith(
          void Function(ListCollectionAssignmentsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCollectionAssignmentsRequest))
          as ListCollectionAssignmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionAssignmentsRequest create() =>
      ListCollectionAssignmentsRequest._();
  @$core.override
  ListCollectionAssignmentsRequest createEmptyInstance() => create();
  static $pb.PbList<ListCollectionAssignmentsRequest> createRepeated() =>
      $pb.PbList<ListCollectionAssignmentsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCollectionAssignmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionAssignmentsRequest>(
          create);
  static ListCollectionAssignmentsRequest? _defaultInstance;
}

class ListCollectionAssignmentsResponse extends $pb.GeneratedMessage {
  factory ListCollectionAssignmentsResponse({
    $core.Iterable<CollectionAssignment>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListCollectionAssignmentsResponse._();

  factory ListCollectionAssignmentsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionAssignmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionAssignmentsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<CollectionAssignment>(
        1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: CollectionAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionAssignmentsResponse clone() =>
      ListCollectionAssignmentsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionAssignmentsResponse copyWith(
          void Function(ListCollectionAssignmentsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListCollectionAssignmentsResponse))
          as ListCollectionAssignmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionAssignmentsResponse create() =>
      ListCollectionAssignmentsResponse._();
  @$core.override
  ListCollectionAssignmentsResponse createEmptyInstance() => create();
  static $pb.PbList<ListCollectionAssignmentsResponse> createRepeated() =>
      $pb.PbList<ListCollectionAssignmentsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCollectionAssignmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionAssignmentsResponse>(
          create);
  static ListCollectionAssignmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CollectionAssignment> get items => $_getList(0);
}

/// 빈 배열 = "필터 없음"(store.js와 동일한 규약).
class AssignmentFilter extends $pb.GeneratedMessage {
  factory AssignmentFilter({
    $core.Iterable<$core.String>? projectIds,
    $core.Iterable<$core.String>? workerIds,
    $core.bool? unassigned,
  }) {
    final result = create();
    if (projectIds != null) result.projectIds.addAll(projectIds);
    if (workerIds != null) result.workerIds.addAll(workerIds);
    if (unassigned != null) result.unassigned = unassigned;
    return result;
  }

  AssignmentFilter._();

  factory AssignmentFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignmentFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignmentFilter',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'projectIds')
    ..pPS(2, _omitFieldNames ? '' : 'workerIds')
    ..aOB(3, _omitFieldNames ? '' : 'unassigned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignmentFilter clone() => AssignmentFilter()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignmentFilter copyWith(void Function(AssignmentFilter) updates) =>
      super.copyWith((message) => updates(message as AssignmentFilter))
          as AssignmentFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignmentFilter create() => AssignmentFilter._();
  @$core.override
  AssignmentFilter createEmptyInstance() => create();
  static $pb.PbList<AssignmentFilter> createRepeated() =>
      $pb.PbList<AssignmentFilter>();
  @$core.pragma('dart2js:noInline')
  static AssignmentFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignmentFilter>(create);
  static AssignmentFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get projectIds => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get workerIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get unassigned => $_getBF(2);
  @$pb.TagNumber(3)
  set unassigned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnassigned() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnassigned() => $_clearField(3);
}

class CollectionEvent extends $pb.GeneratedMessage {
  factory CollectionEvent({
    $core.String? eventId,
    $core.String? equipmentId,
    $core.String? eventAt,
    $core.int? durationSec,
    $core.String? connectionStatus,
    $core.int? receivedCount,
    $core.String? windowLabel,
    $core.double? lossRatePct,
    $core.String? timeSyncStatus,
    $core.int? clockOffsetMs,
    $core.String? note,
    $core.String? equipmentName,
    $core.String? lineName,
  }) {
    final result = create();
    if (eventId != null) result.eventId = eventId;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (eventAt != null) result.eventAt = eventAt;
    if (durationSec != null) result.durationSec = durationSec;
    if (connectionStatus != null) result.connectionStatus = connectionStatus;
    if (receivedCount != null) result.receivedCount = receivedCount;
    if (windowLabel != null) result.windowLabel = windowLabel;
    if (lossRatePct != null) result.lossRatePct = lossRatePct;
    if (timeSyncStatus != null) result.timeSyncStatus = timeSyncStatus;
    if (clockOffsetMs != null) result.clockOffsetMs = clockOffsetMs;
    if (note != null) result.note = note;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (lineName != null) result.lineName = lineName;
    return result;
  }

  CollectionEvent._();

  factory CollectionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectionEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(3, _omitFieldNames ? '' : 'eventAt')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'durationSec', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'connectionStatus')
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'receivedCount', $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'windowLabel')
    ..a<$core.double>(
        8, _omitFieldNames ? '' : 'lossRatePct', $pb.PbFieldType.OD)
    ..aOS(9, _omitFieldNames ? '' : 'timeSyncStatus')
    ..a<$core.int>(
        10, _omitFieldNames ? '' : 'clockOffsetMs', $pb.PbFieldType.O3)
    ..aOS(11, _omitFieldNames ? '' : 'note')
    ..aOS(12, _omitFieldNames ? '' : 'equipmentName')
    ..aOS(13, _omitFieldNames ? '' : 'lineName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionEvent clone() => CollectionEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionEvent copyWith(void Function(CollectionEvent) updates) =>
      super.copyWith((message) => updates(message as CollectionEvent))
          as CollectionEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionEvent create() => CollectionEvent._();
  @$core.override
  CollectionEvent createEmptyInstance() => create();
  static $pb.PbList<CollectionEvent> createRepeated() =>
      $pb.PbList<CollectionEvent>();
  @$core.pragma('dart2js:noInline')
  static CollectionEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectionEvent>(create);
  static CollectionEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get equipmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set equipmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get eventAt => $_getSZ(2);
  @$pb.TagNumber(3)
  set eventAt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEventAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get durationSec => $_getIZ(3);
  @$pb.TagNumber(4)
  set durationSec($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationSec() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationSec() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get connectionStatus => $_getSZ(4);
  @$pb.TagNumber(5)
  set connectionStatus($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConnectionStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectionStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get receivedCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set receivedCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReceivedCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearReceivedCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get windowLabel => $_getSZ(6);
  @$pb.TagNumber(7)
  set windowLabel($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWindowLabel() => $_has(6);
  @$pb.TagNumber(7)
  void clearWindowLabel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get lossRatePct => $_getN(7);
  @$pb.TagNumber(8)
  set lossRatePct($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLossRatePct() => $_has(7);
  @$pb.TagNumber(8)
  void clearLossRatePct() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get timeSyncStatus => $_getSZ(8);
  @$pb.TagNumber(9)
  set timeSyncStatus($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTimeSyncStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeSyncStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get clockOffsetMs => $_getIZ(9);
  @$pb.TagNumber(10)
  set clockOffsetMs($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClockOffsetMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearClockOffsetMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get note => $_getSZ(10);
  @$pb.TagNumber(11)
  set note($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearNote() => $_clearField(11);

  /// equipment 조인(store.js eventsFiltered) — 화면이 항상 이 두 필드로 표시·검색한다.
  @$pb.TagNumber(12)
  $core.String get equipmentName => $_getSZ(11);
  @$pb.TagNumber(12)
  set equipmentName($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEquipmentName() => $_has(11);
  @$pb.TagNumber(12)
  void clearEquipmentName() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get lineName => $_getSZ(12);
  @$pb.TagNumber(13)
  set lineName($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLineName() => $_has(12);
  @$pb.TagNumber(13)
  void clearLineName() => $_clearField(13);
}

class ListCollectionEventsRequest extends $pb.GeneratedMessage {
  factory ListCollectionEventsRequest({
    $core.String? date,
    $core.Iterable<$core.String>? equipmentIds,
    $core.Iterable<$core.String>? connectionStatuses,
    $core.Iterable<$core.String>? lines,
    AssignmentFilter? assignment,
    $core.String? from,
    $core.String? to,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (equipmentIds != null) result.equipmentIds.addAll(equipmentIds);
    if (connectionStatuses != null)
      result.connectionStatuses.addAll(connectionStatuses);
    if (lines != null) result.lines.addAll(lines);
    if (assignment != null) result.assignment = assignment;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  ListCollectionEventsRequest._();

  factory ListCollectionEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionEventsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..pPS(2, _omitFieldNames ? '' : 'equipmentIds')
    ..pPS(3, _omitFieldNames ? '' : 'connectionStatuses')
    ..pPS(4, _omitFieldNames ? '' : 'lines')
    ..aOM<AssignmentFilter>(5, _omitFieldNames ? '' : 'assignment',
        subBuilder: AssignmentFilter.create)
    ..aOS(6, _omitFieldNames ? '' : 'from')
    ..aOS(7, _omitFieldNames ? '' : 'to')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionEventsRequest clone() =>
      ListCollectionEventsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionEventsRequest copyWith(
          void Function(ListCollectionEventsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCollectionEventsRequest))
          as ListCollectionEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionEventsRequest create() =>
      ListCollectionEventsRequest._();
  @$core.override
  ListCollectionEventsRequest createEmptyInstance() => create();
  static $pb.PbList<ListCollectionEventsRequest> createRepeated() =>
      $pb.PbList<ListCollectionEventsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCollectionEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionEventsRequest>(create);
  static ListCollectionEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get equipmentIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get connectionStatuses => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get lines => $_getList(3);

  @$pb.TagNumber(5)
  AssignmentFilter get assignment => $_getN(4);
  @$pb.TagNumber(5)
  set assignment(AssignmentFilter value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAssignment() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssignment() => $_clearField(5);
  @$pb.TagNumber(5)
  AssignmentFilter ensureAssignment() => $_ensure(4);

  /// 타임라인 확대(s0 t0/t1) — date로 고른 하루 안에서의 시:분 구간. "HH:MM", 비우면
  /// from=00:00/to=24:00과 동일(전체). event_at의 시:분 부분과 문자열 비교.
  @$pb.TagNumber(6)
  $core.String get from => $_getSZ(5);
  @$pb.TagNumber(6)
  set from($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearFrom() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get to => $_getSZ(6);
  @$pb.TagNumber(7)
  set to($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearTo() => $_clearField(7);
}

class ListCollectionEventsResponse extends $pb.GeneratedMessage {
  factory ListCollectionEventsResponse({
    $core.Iterable<CollectionEvent>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListCollectionEventsResponse._();

  factory ListCollectionEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionEventsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<CollectionEvent>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: CollectionEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionEventsResponse clone() =>
      ListCollectionEventsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionEventsResponse copyWith(
          void Function(ListCollectionEventsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCollectionEventsResponse))
          as ListCollectionEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionEventsResponse create() =>
      ListCollectionEventsResponse._();
  @$core.override
  ListCollectionEventsResponse createEmptyInstance() => create();
  static $pb.PbList<ListCollectionEventsResponse> createRepeated() =>
      $pb.PbList<ListCollectionEventsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCollectionEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionEventsResponse>(create);
  static ListCollectionEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CollectionEvent> get items => $_getList(0);
}

class EquipmentStatusRow extends $pb.GeneratedMessage {
  factory EquipmentStatusRow({
    $core.String? equipmentId,
    $core.String? equipmentName,
    $core.String? lineName,
    $core.String? snapshotAt,
    $core.String? connectionStatus,
    $core.int? receivedCount,
    $core.String? windowLabel,
    $core.double? lossRatePct,
    $core.String? timeSyncStatus,
    $core.int? clockOffsetMs,
    $core.String? lastReceivedAt,
  }) {
    final result = create();
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (lineName != null) result.lineName = lineName;
    if (snapshotAt != null) result.snapshotAt = snapshotAt;
    if (connectionStatus != null) result.connectionStatus = connectionStatus;
    if (receivedCount != null) result.receivedCount = receivedCount;
    if (windowLabel != null) result.windowLabel = windowLabel;
    if (lossRatePct != null) result.lossRatePct = lossRatePct;
    if (timeSyncStatus != null) result.timeSyncStatus = timeSyncStatus;
    if (clockOffsetMs != null) result.clockOffsetMs = clockOffsetMs;
    if (lastReceivedAt != null) result.lastReceivedAt = lastReceivedAt;
    return result;
  }

  EquipmentStatusRow._();

  factory EquipmentStatusRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EquipmentStatusRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EquipmentStatusRow',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(2, _omitFieldNames ? '' : 'equipmentName')
    ..aOS(3, _omitFieldNames ? '' : 'lineName')
    ..aOS(4, _omitFieldNames ? '' : 'snapshotAt')
    ..aOS(5, _omitFieldNames ? '' : 'connectionStatus')
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'receivedCount', $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'windowLabel')
    ..a<$core.double>(
        8, _omitFieldNames ? '' : 'lossRatePct', $pb.PbFieldType.OD)
    ..aOS(9, _omitFieldNames ? '' : 'timeSyncStatus')
    ..a<$core.int>(
        10, _omitFieldNames ? '' : 'clockOffsetMs', $pb.PbFieldType.O3)
    ..aOS(11, _omitFieldNames ? '' : 'lastReceivedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquipmentStatusRow clone() => EquipmentStatusRow()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquipmentStatusRow copyWith(void Function(EquipmentStatusRow) updates) =>
      super.copyWith((message) => updates(message as EquipmentStatusRow))
          as EquipmentStatusRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EquipmentStatusRow create() => EquipmentStatusRow._();
  @$core.override
  EquipmentStatusRow createEmptyInstance() => create();
  static $pb.PbList<EquipmentStatusRow> createRepeated() =>
      $pb.PbList<EquipmentStatusRow>();
  @$core.pragma('dart2js:noInline')
  static EquipmentStatusRow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EquipmentStatusRow>(create);
  static EquipmentStatusRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get equipmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set equipmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get equipmentName => $_getSZ(1);
  @$pb.TagNumber(2)
  set equipmentName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipmentName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipmentName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lineName => $_getSZ(2);
  @$pb.TagNumber(3)
  set lineName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLineName() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get snapshotAt => $_getSZ(3);
  @$pb.TagNumber(4)
  set snapshotAt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSnapshotAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearSnapshotAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get connectionStatus => $_getSZ(4);
  @$pb.TagNumber(5)
  set connectionStatus($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConnectionStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectionStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get receivedCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set receivedCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReceivedCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearReceivedCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get windowLabel => $_getSZ(6);
  @$pb.TagNumber(7)
  set windowLabel($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWindowLabel() => $_has(6);
  @$pb.TagNumber(7)
  void clearWindowLabel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get lossRatePct => $_getN(7);
  @$pb.TagNumber(8)
  set lossRatePct($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLossRatePct() => $_has(7);
  @$pb.TagNumber(8)
  void clearLossRatePct() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get timeSyncStatus => $_getSZ(8);
  @$pb.TagNumber(9)
  set timeSyncStatus($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTimeSyncStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeSyncStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get clockOffsetMs => $_getIZ(9);
  @$pb.TagNumber(10)
  set clockOffsetMs($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClockOffsetMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearClockOffsetMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get lastReceivedAt => $_getSZ(10);
  @$pb.TagNumber(11)
  set lastReceivedAt($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLastReceivedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastReceivedAt() => $_clearField(11);
}

class ListEquipmentStatusRequest extends $pb.GeneratedMessage {
  factory ListEquipmentStatusRequest({
    $core.Iterable<$core.String>? equipmentIds,
    $core.Iterable<$core.String>? connectionStatuses,
    $core.Iterable<$core.String>? lines,
    AssignmentFilter? assignment,
    $core.String? date,
  }) {
    final result = create();
    if (equipmentIds != null) result.equipmentIds.addAll(equipmentIds);
    if (connectionStatuses != null)
      result.connectionStatuses.addAll(connectionStatuses);
    if (lines != null) result.lines.addAll(lines);
    if (assignment != null) result.assignment = assignment;
    if (date != null) result.date = date;
    return result;
  }

  ListEquipmentStatusRequest._();

  factory ListEquipmentStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEquipmentStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEquipmentStatusRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'equipmentIds')
    ..pPS(2, _omitFieldNames ? '' : 'connectionStatuses')
    ..pPS(3, _omitFieldNames ? '' : 'lines')
    ..aOM<AssignmentFilter>(4, _omitFieldNames ? '' : 'assignment',
        subBuilder: AssignmentFilter.create)
    ..aOS(5, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentStatusRequest clone() =>
      ListEquipmentStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentStatusRequest copyWith(
          void Function(ListEquipmentStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListEquipmentStatusRequest))
          as ListEquipmentStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEquipmentStatusRequest create() => ListEquipmentStatusRequest._();
  @$core.override
  ListEquipmentStatusRequest createEmptyInstance() => create();
  static $pb.PbList<ListEquipmentStatusRequest> createRepeated() =>
      $pb.PbList<ListEquipmentStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static ListEquipmentStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEquipmentStatusRequest>(create);
  static ListEquipmentStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get equipmentIds => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get connectionStatuses => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get lines => $_getList(2);

  @$pb.TagNumber(4)
  AssignmentFilter get assignment => $_getN(3);
  @$pb.TagNumber(4)
  set assignment(AssignmentFilter value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAssignment() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssignment() => $_clearField(4);
  @$pb.TagNumber(4)
  AssignmentFilter ensureAssignment() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get date => $_getSZ(4);
  @$pb.TagNumber(5)
  set date($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearDate() => $_clearField(5);
}

class ListEquipmentStatusResponse extends $pb.GeneratedMessage {
  factory ListEquipmentStatusResponse({
    $core.Iterable<EquipmentStatusRow>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListEquipmentStatusResponse._();

  factory ListEquipmentStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEquipmentStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEquipmentStatusResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<EquipmentStatusRow>(
        1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: EquipmentStatusRow.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentStatusResponse clone() =>
      ListEquipmentStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEquipmentStatusResponse copyWith(
          void Function(ListEquipmentStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListEquipmentStatusResponse))
          as ListEquipmentStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEquipmentStatusResponse create() =>
      ListEquipmentStatusResponse._();
  @$core.override
  ListEquipmentStatusResponse createEmptyInstance() => create();
  static $pb.PbList<ListEquipmentStatusResponse> createRepeated() =>
      $pb.PbList<ListEquipmentStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static ListEquipmentStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEquipmentStatusResponse>(create);
  static ListEquipmentStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<EquipmentStatusRow> get items => $_getList(0);
}

class WorkOrder extends $pb.GeneratedMessage {
  factory WorkOrder({
    $core.String? workOrderId,
    $core.String? workOrderNo,
    $core.String? projectId,
    $core.String? title,
    $core.String? plannedDate,
    $core.String? status,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (workOrderNo != null) result.workOrderNo = workOrderNo;
    if (projectId != null) result.projectId = projectId;
    if (title != null) result.title = title;
    if (plannedDate != null) result.plannedDate = plannedDate;
    if (status != null) result.status = status;
    return result;
  }

  WorkOrder._();

  factory WorkOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkOrder',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'workOrderNo')
    ..aOS(3, _omitFieldNames ? '' : 'projectId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'plannedDate')
    ..aOS(6, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkOrder clone() => WorkOrder()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkOrder copyWith(void Function(WorkOrder) updates) =>
      super.copyWith((message) => updates(message as WorkOrder)) as WorkOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkOrder create() => WorkOrder._();
  @$core.override
  WorkOrder createEmptyInstance() => create();
  static $pb.PbList<WorkOrder> createRepeated() => $pb.PbList<WorkOrder>();
  @$core.pragma('dart2js:noInline')
  static WorkOrder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkOrder>(create);
  static WorkOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workOrderNo => $_getSZ(1);
  @$pb.TagNumber(2)
  set workOrderNo($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrderNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrderNo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get projectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set projectId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get plannedDate => $_getSZ(4);
  @$pb.TagNumber(5)
  set plannedDate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlannedDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlannedDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get status => $_getSZ(5);
  @$pb.TagNumber(6)
  set status($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);
}

class ListWorkOrdersRequest extends $pb.GeneratedMessage {
  factory ListWorkOrdersRequest() => create();

  ListWorkOrdersRequest._();

  factory ListWorkOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkOrdersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkOrdersRequest clone() =>
      ListWorkOrdersRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkOrdersRequest copyWith(
          void Function(ListWorkOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as ListWorkOrdersRequest))
          as ListWorkOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkOrdersRequest create() => ListWorkOrdersRequest._();
  @$core.override
  ListWorkOrdersRequest createEmptyInstance() => create();
  static $pb.PbList<ListWorkOrdersRequest> createRepeated() =>
      $pb.PbList<ListWorkOrdersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListWorkOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkOrdersRequest>(create);
  static ListWorkOrdersRequest? _defaultInstance;
}

class ListWorkOrdersResponse extends $pb.GeneratedMessage {
  factory ListWorkOrdersResponse({
    $core.Iterable<WorkOrder>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListWorkOrdersResponse._();

  factory ListWorkOrdersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkOrdersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkOrdersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<WorkOrder>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkOrdersResponse clone() =>
      ListWorkOrdersResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkOrdersResponse copyWith(
          void Function(ListWorkOrdersResponse) updates) =>
      super.copyWith((message) => updates(message as ListWorkOrdersResponse))
          as ListWorkOrdersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkOrdersResponse create() => ListWorkOrdersResponse._();
  @$core.override
  ListWorkOrdersResponse createEmptyInstance() => create();
  static $pb.PbList<ListWorkOrdersResponse> createRepeated() =>
      $pb.PbList<ListWorkOrdersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListWorkOrdersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkOrdersResponse>(create);
  static ListWorkOrdersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkOrder> get items => $_getList(0);
}

class Joint extends $pb.GeneratedMessage {
  factory Joint({
    $core.String? jointId,
    $core.String? jointNo,
    $core.String? name,
    $core.String? workOrderId,
    $core.String? location,
  }) {
    final result = create();
    if (jointId != null) result.jointId = jointId;
    if (jointNo != null) result.jointNo = jointNo;
    if (name != null) result.name = name;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (location != null) result.location = location;
    return result;
  }

  Joint._();

  factory Joint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Joint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Joint',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jointId')
    ..aOS(2, _omitFieldNames ? '' : 'jointNo')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(5, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Joint clone() => Joint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Joint copyWith(void Function(Joint) updates) =>
      super.copyWith((message) => updates(message as Joint)) as Joint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Joint create() => Joint._();
  @$core.override
  Joint createEmptyInstance() => create();
  static $pb.PbList<Joint> createRepeated() => $pb.PbList<Joint>();
  @$core.pragma('dart2js:noInline')
  static Joint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Joint>(create);
  static Joint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jointId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jointId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJointId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJointId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jointNo => $_getSZ(1);
  @$pb.TagNumber(2)
  set jointNo($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJointNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearJointNo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workOrderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set workOrderId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkOrderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkOrderId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get location => $_getSZ(4);
  @$pb.TagNumber(5)
  set location($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocation() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocation() => $_clearField(5);
}

class ListJointsRequest extends $pb.GeneratedMessage {
  factory ListJointsRequest() => create();

  ListJointsRequest._();

  factory ListJointsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJointsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJointsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJointsRequest clone() => ListJointsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJointsRequest copyWith(void Function(ListJointsRequest) updates) =>
      super.copyWith((message) => updates(message as ListJointsRequest))
          as ListJointsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJointsRequest create() => ListJointsRequest._();
  @$core.override
  ListJointsRequest createEmptyInstance() => create();
  static $pb.PbList<ListJointsRequest> createRepeated() =>
      $pb.PbList<ListJointsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListJointsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJointsRequest>(create);
  static ListJointsRequest? _defaultInstance;
}

class ListJointsResponse extends $pb.GeneratedMessage {
  factory ListJointsResponse({
    $core.Iterable<Joint>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListJointsResponse._();

  factory ListJointsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJointsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJointsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<Joint>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: Joint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJointsResponse clone() => ListJointsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJointsResponse copyWith(void Function(ListJointsResponse) updates) =>
      super.copyWith((message) => updates(message as ListJointsResponse))
          as ListJointsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJointsResponse create() => ListJointsResponse._();
  @$core.override
  ListJointsResponse createEmptyInstance() => create();
  static $pb.PbList<ListJointsResponse> createRepeated() =>
      $pb.PbList<ListJointsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListJointsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJointsResponse>(create);
  static ListJointsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Joint> get items => $_getList(0);
}

class Worker extends $pb.GeneratedMessage {
  factory Worker({
    $core.String? workerId,
    $core.String? workerName,
    $core.String? team,
    $core.bool? isMaster,
  }) {
    final result = create();
    if (workerId != null) result.workerId = workerId;
    if (workerName != null) result.workerName = workerName;
    if (team != null) result.team = team;
    if (isMaster != null) result.isMaster = isMaster;
    return result;
  }

  Worker._();

  factory Worker.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Worker.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Worker',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workerId')
    ..aOS(2, _omitFieldNames ? '' : 'workerName')
    ..aOS(3, _omitFieldNames ? '' : 'team')
    ..aOB(4, _omitFieldNames ? '' : 'isMaster')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Worker clone() => Worker()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Worker copyWith(void Function(Worker) updates) =>
      super.copyWith((message) => updates(message as Worker)) as Worker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Worker create() => Worker._();
  @$core.override
  Worker createEmptyInstance() => create();
  static $pb.PbList<Worker> createRepeated() => $pb.PbList<Worker>();
  @$core.pragma('dart2js:noInline')
  static Worker getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Worker>(create);
  static Worker? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set workerName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkerName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get team => $_getSZ(2);
  @$pb.TagNumber(3)
  set team($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTeam() => $_has(2);
  @$pb.TagNumber(3)
  void clearTeam() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isMaster => $_getBF(3);
  @$pb.TagNumber(4)
  set isMaster($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsMaster() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsMaster() => $_clearField(4);
}

class ListWorkersRequest extends $pb.GeneratedMessage {
  factory ListWorkersRequest() => create();

  ListWorkersRequest._();

  factory ListWorkersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkersRequest clone() => ListWorkersRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkersRequest copyWith(void Function(ListWorkersRequest) updates) =>
      super.copyWith((message) => updates(message as ListWorkersRequest))
          as ListWorkersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkersRequest create() => ListWorkersRequest._();
  @$core.override
  ListWorkersRequest createEmptyInstance() => create();
  static $pb.PbList<ListWorkersRequest> createRepeated() =>
      $pb.PbList<ListWorkersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListWorkersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkersRequest>(create);
  static ListWorkersRequest? _defaultInstance;
}

class ListWorkersResponse extends $pb.GeneratedMessage {
  factory ListWorkersResponse({
    $core.Iterable<Worker>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListWorkersResponse._();

  factory ListWorkersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<Worker>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: Worker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkersResponse clone() => ListWorkersResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkersResponse copyWith(void Function(ListWorkersResponse) updates) =>
      super.copyWith((message) => updates(message as ListWorkersResponse))
          as ListWorkersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkersResponse create() => ListWorkersResponse._();
  @$core.override
  ListWorkersResponse createEmptyInstance() => create();
  static $pb.PbList<ListWorkersResponse> createRepeated() =>
      $pb.PbList<ListWorkersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListWorkersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkersResponse>(create);
  static ListWorkersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Worker> get items => $_getList(0);
}

class WorkHistory extends $pb.GeneratedMessage {
  factory WorkHistory({
    $core.String? historyId,
    $core.String? commonKey,
    $core.String? workOrderId,
    $core.String? jointId,
    $core.String? workerId,
    $core.String? equipmentId,
    $core.String? workedAt,
    $core.String? workOrderNo,
    $core.String? title,
    $core.String? jointNo,
    $core.String? jointName,
    $core.String? workerName,
    $core.String? equipmentName,
    $core.int? passCount,
    $core.int? attachmentCount,
  }) {
    final result = create();
    if (historyId != null) result.historyId = historyId;
    if (commonKey != null) result.commonKey = commonKey;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (jointId != null) result.jointId = jointId;
    if (workerId != null) result.workerId = workerId;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (workedAt != null) result.workedAt = workedAt;
    if (workOrderNo != null) result.workOrderNo = workOrderNo;
    if (title != null) result.title = title;
    if (jointNo != null) result.jointNo = jointNo;
    if (jointName != null) result.jointName = jointName;
    if (workerName != null) result.workerName = workerName;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (passCount != null) result.passCount = passCount;
    if (attachmentCount != null) result.attachmentCount = attachmentCount;
    return result;
  }

  WorkHistory._();

  factory WorkHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkHistory',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'historyId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aOS(3, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(4, _omitFieldNames ? '' : 'jointId')
    ..aOS(5, _omitFieldNames ? '' : 'workerId')
    ..aOS(6, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(7, _omitFieldNames ? '' : 'workedAt')
    ..aOS(8, _omitFieldNames ? '' : 'workOrderNo')
    ..aOS(9, _omitFieldNames ? '' : 'title')
    ..aOS(10, _omitFieldNames ? '' : 'jointNo')
    ..aOS(11, _omitFieldNames ? '' : 'jointName')
    ..aOS(12, _omitFieldNames ? '' : 'workerName')
    ..aOS(13, _omitFieldNames ? '' : 'equipmentName')
    ..a<$core.int>(14, _omitFieldNames ? '' : 'passCount', $pb.PbFieldType.O3)
    ..a<$core.int>(
        15, _omitFieldNames ? '' : 'attachmentCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkHistory clone() => WorkHistory()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkHistory copyWith(void Function(WorkHistory) updates) =>
      super.copyWith((message) => updates(message as WorkHistory))
          as WorkHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkHistory create() => WorkHistory._();
  @$core.override
  WorkHistory createEmptyInstance() => create();
  static $pb.PbList<WorkHistory> createRepeated() => $pb.PbList<WorkHistory>();
  @$core.pragma('dart2js:noInline')
  static WorkHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkHistory>(create);
  static WorkHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get historyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set historyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHistoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHistoryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workOrderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workOrderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get jointId => $_getSZ(3);
  @$pb.TagNumber(4)
  set jointId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJointId() => $_has(3);
  @$pb.TagNumber(4)
  void clearJointId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get workerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set workerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get equipmentId => $_getSZ(5);
  @$pb.TagNumber(6)
  set equipmentId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEquipmentId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEquipmentId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get workedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set workedAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWorkedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorkedAt() => $_clearField(7);

  /// 아래는 work_orders/joints/workers/equipment 조인 + passes 카운트 (store.js historyFiltered).
  @$pb.TagNumber(8)
  $core.String get workOrderNo => $_getSZ(7);
  @$pb.TagNumber(8)
  set workOrderNo($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWorkOrderNo() => $_has(7);
  @$pb.TagNumber(8)
  void clearWorkOrderNo() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get title => $_getSZ(8);
  @$pb.TagNumber(9)
  set title($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTitle() => $_has(8);
  @$pb.TagNumber(9)
  void clearTitle() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get jointNo => $_getSZ(9);
  @$pb.TagNumber(10)
  set jointNo($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasJointNo() => $_has(9);
  @$pb.TagNumber(10)
  void clearJointNo() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get jointName => $_getSZ(10);
  @$pb.TagNumber(11)
  set jointName($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasJointName() => $_has(10);
  @$pb.TagNumber(11)
  void clearJointName() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get workerName => $_getSZ(11);
  @$pb.TagNumber(12)
  set workerName($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasWorkerName() => $_has(11);
  @$pb.TagNumber(12)
  void clearWorkerName() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get equipmentName => $_getSZ(12);
  @$pb.TagNumber(13)
  set equipmentName($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEquipmentName() => $_has(12);
  @$pb.TagNumber(13)
  void clearEquipmentName() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get passCount => $_getIZ(13);
  @$pb.TagNumber(14)
  set passCount($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPassCount() => $_has(13);
  @$pb.TagNumber(14)
  void clearPassCount() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get attachmentCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set attachmentCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAttachmentCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearAttachmentCount() => $_clearField(15);
}

class ListWorkHistoryRequest extends $pb.GeneratedMessage {
  factory ListWorkHistoryRequest({
    $core.String? commonKey,
    $core.String? workOrderId,
    $core.String? jointId,
    $core.String? workerId,
    $core.String? equipmentId,
    $core.String? from,
    $core.String? to,
    $core.String? historyId,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (commonKey != null) result.commonKey = commonKey;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (jointId != null) result.jointId = jointId;
    if (workerId != null) result.workerId = workerId;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (historyId != null) result.historyId = historyId;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListWorkHistoryRequest._();

  factory ListWorkHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commonKey')
    ..aOS(2, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(3, _omitFieldNames ? '' : 'jointId')
    ..aOS(4, _omitFieldNames ? '' : 'workerId')
    ..aOS(5, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(6, _omitFieldNames ? '' : 'from')
    ..aOS(7, _omitFieldNames ? '' : 'to')
    ..aOS(8, _omitFieldNames ? '' : 'historyId')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkHistoryRequest clone() =>
      ListWorkHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkHistoryRequest copyWith(
          void Function(ListWorkHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as ListWorkHistoryRequest))
          as ListWorkHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkHistoryRequest create() => ListWorkHistoryRequest._();
  @$core.override
  ListWorkHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<ListWorkHistoryRequest> createRepeated() =>
      $pb.PbList<ListWorkHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static ListWorkHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkHistoryRequest>(create);
  static ListWorkHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commonKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set commonKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommonKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommonKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workOrderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workOrderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get jointId => $_getSZ(2);
  @$pb.TagNumber(3)
  set jointId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJointId() => $_has(2);
  @$pb.TagNumber(3)
  void clearJointId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set workerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get equipmentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set equipmentId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEquipmentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearEquipmentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get from => $_getSZ(5);
  @$pb.TagNumber(6)
  set from($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearFrom() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get to => $_getSZ(6);
  @$pb.TagNumber(7)
  set to($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearTo() => $_clearField(7);

  /// 단건 조회(s2d 딥링크)용 — 정확히 일치. 비우면 무시.
  @$pb.TagNumber(8)
  $core.String get historyId => $_getSZ(7);
  @$pb.TagNumber(8)
  set historyId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHistoryId() => $_has(7);
  @$pb.TagNumber(8)
  void clearHistoryId() => $_clearField(8);

  /// s2 목록 인피니트 스크롤용. limit<=0이면 기존과 동일하게 전체를 반환(하위 호환) —
  /// limit>0일 때만 offset과 함께 페이지 단위로 자른다. 정렬은 worked_at DESC, history_id
  /// DESC(동점 시 결정적 순서 보장)라 offset이 페이지 사이에서 안정적으로 이어진다.
  @$pb.TagNumber(9)
  $core.int get limit => $_getIZ(8);
  @$pb.TagNumber(9)
  set limit($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLimit() => $_has(8);
  @$pb.TagNumber(9)
  void clearLimit() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get offset => $_getIZ(9);
  @$pb.TagNumber(10)
  set offset($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOffset() => $_has(9);
  @$pb.TagNumber(10)
  void clearOffset() => $_clearField(10);
}

class ListWorkHistoryResponse extends $pb.GeneratedMessage {
  factory ListWorkHistoryResponse({
    $core.Iterable<WorkHistory>? items,
    $core.int? totalCount,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ListWorkHistoryResponse._();

  factory ListWorkHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkHistoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<WorkHistory>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: WorkHistory.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkHistoryResponse clone() =>
      ListWorkHistoryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkHistoryResponse copyWith(
          void Function(ListWorkHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as ListWorkHistoryResponse))
          as ListWorkHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkHistoryResponse create() => ListWorkHistoryResponse._();
  @$core.override
  ListWorkHistoryResponse createEmptyInstance() => create();
  static $pb.PbList<ListWorkHistoryResponse> createRepeated() =>
      $pb.PbList<ListWorkHistoryResponse>();
  @$core.pragma('dart2js:noInline')
  static ListWorkHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkHistoryResponse>(create);
  static ListWorkHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkHistory> get items => $_getList(0);

  /// 필터 전체 매치 건수(페이지 크기와 무관) — FE가 이 값과 지금까지 받은 개수를 비교해
  /// 인피니트 스크롤을 멈출 시점을 판단한다. limit을 안 쓴 요청(전체 반환)에서도 items와
  /// 같은 값이 채워진다.
  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class WorkAttachment extends $pb.GeneratedMessage {
  factory WorkAttachment({
    $core.String? attachmentId,
    $core.String? historyId,
    $core.String? fileType,
    $core.String? fileName,
    $core.String? note,
    $core.String? content,
    $core.String? fileUrl,
  }) {
    final result = create();
    if (attachmentId != null) result.attachmentId = attachmentId;
    if (historyId != null) result.historyId = historyId;
    if (fileType != null) result.fileType = fileType;
    if (fileName != null) result.fileName = fileName;
    if (note != null) result.note = note;
    if (content != null) result.content = content;
    if (fileUrl != null) result.fileUrl = fileUrl;
    return result;
  }

  WorkAttachment._();

  factory WorkAttachment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkAttachment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkAttachment',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'attachmentId')
    ..aOS(2, _omitFieldNames ? '' : 'historyId')
    ..aOS(3, _omitFieldNames ? '' : 'fileType')
    ..aOS(4, _omitFieldNames ? '' : 'fileName')
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..aOS(7, _omitFieldNames ? '' : 'fileUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkAttachment clone() => WorkAttachment()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkAttachment copyWith(void Function(WorkAttachment) updates) =>
      super.copyWith((message) => updates(message as WorkAttachment))
          as WorkAttachment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkAttachment create() => WorkAttachment._();
  @$core.override
  WorkAttachment createEmptyInstance() => create();
  static $pb.PbList<WorkAttachment> createRepeated() =>
      $pb.PbList<WorkAttachment>();
  @$core.pragma('dart2js:noInline')
  static WorkAttachment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkAttachment>(create);
  static WorkAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get attachmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set attachmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAttachmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttachmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get historyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set historyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHistoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearHistoryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileType => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileType() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fileName => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFileName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);

  /// text 타입은 본문 텍스트 그대로(기존 와이어프레임 CSV 규약). 그 외 타입은 실제 파일이
  /// dashboard/files/에 있을 때만 채워지고(없으면 빈 문자열), 그때 file_url도 같이 채워진다.
  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);

  /// Range 요청 지원되는 정적 파일 URL(cmd/server가 서빙, 서버 origin 기준 상대경로). 영상
  /// 시킹·PDF 뷰어처럼 바이트를 그대로 읽어야 하는 뷰어는 gRPC 응답이 아니라 이 URL로 받는다.
  @$pb.TagNumber(7)
  $core.String get fileUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set fileUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFileUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearFileUrl() => $_clearField(7);
}

class ListWorkAttachmentsRequest extends $pb.GeneratedMessage {
  factory ListWorkAttachmentsRequest() => create();

  ListWorkAttachmentsRequest._();

  factory ListWorkAttachmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkAttachmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkAttachmentsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkAttachmentsRequest clone() =>
      ListWorkAttachmentsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkAttachmentsRequest copyWith(
          void Function(ListWorkAttachmentsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListWorkAttachmentsRequest))
          as ListWorkAttachmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkAttachmentsRequest create() => ListWorkAttachmentsRequest._();
  @$core.override
  ListWorkAttachmentsRequest createEmptyInstance() => create();
  static $pb.PbList<ListWorkAttachmentsRequest> createRepeated() =>
      $pb.PbList<ListWorkAttachmentsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListWorkAttachmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkAttachmentsRequest>(create);
  static ListWorkAttachmentsRequest? _defaultInstance;
}

class ListWorkAttachmentsResponse extends $pb.GeneratedMessage {
  factory ListWorkAttachmentsResponse({
    $core.Iterable<WorkAttachment>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListWorkAttachmentsResponse._();

  factory ListWorkAttachmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkAttachmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkAttachmentsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<WorkAttachment>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: WorkAttachment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkAttachmentsResponse clone() =>
      ListWorkAttachmentsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkAttachmentsResponse copyWith(
          void Function(ListWorkAttachmentsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListWorkAttachmentsResponse))
          as ListWorkAttachmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkAttachmentsResponse create() =>
      ListWorkAttachmentsResponse._();
  @$core.override
  ListWorkAttachmentsResponse createEmptyInstance() => create();
  static $pb.PbList<ListWorkAttachmentsResponse> createRepeated() =>
      $pb.PbList<ListWorkAttachmentsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListWorkAttachmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkAttachmentsResponse>(create);
  static ListWorkAttachmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkAttachment> get items => $_getList(0);
}

class Pass extends $pb.GeneratedMessage {
  factory Pass({
    $core.String? passId,
    $core.String? commonKey,
    $core.int? passNo,
    $core.String? passName,
    $core.String? masterProfileId,
    $core.String? controlWorkerId,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    if (commonKey != null) result.commonKey = commonKey;
    if (passNo != null) result.passNo = passNo;
    if (passName != null) result.passName = passName;
    if (masterProfileId != null) result.masterProfileId = masterProfileId;
    if (controlWorkerId != null) result.controlWorkerId = controlWorkerId;
    return result;
  }

  Pass._();

  factory Pass.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Pass.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pass',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'passId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'passNo', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'passName')
    ..aOS(5, _omitFieldNames ? '' : 'masterProfileId')
    ..aOS(6, _omitFieldNames ? '' : 'controlWorkerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pass clone() => Pass()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pass copyWith(void Function(Pass) updates) =>
      super.copyWith((message) => updates(message as Pass)) as Pass;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Pass create() => Pass._();
  @$core.override
  Pass createEmptyInstance() => create();
  static $pb.PbList<Pass> createRepeated() => $pb.PbList<Pass>();
  @$core.pragma('dart2js:noInline')
  static Pass getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Pass>(create);
  static Pass? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get passId => $_getSZ(0);
  @$pb.TagNumber(1)
  set passId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get passNo => $_getIZ(2);
  @$pb.TagNumber(3)
  set passNo($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get passName => $_getSZ(3);
  @$pb.TagNumber(4)
  set passName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get masterProfileId => $_getSZ(4);
  @$pb.TagNumber(5)
  set masterProfileId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMasterProfileId() => $_has(4);
  @$pb.TagNumber(5)
  void clearMasterProfileId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get controlWorkerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set controlWorkerId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasControlWorkerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearControlWorkerId() => $_clearField(6);
}

class ListPassesRequest extends $pb.GeneratedMessage {
  factory ListPassesRequest({
    $core.String? commonKey,
  }) {
    final result = create();
    if (commonKey != null) result.commonKey = commonKey;
    return result;
  }

  ListPassesRequest._();

  factory ListPassesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPassesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPassesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commonKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPassesRequest clone() => ListPassesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPassesRequest copyWith(void Function(ListPassesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPassesRequest))
          as ListPassesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPassesRequest create() => ListPassesRequest._();
  @$core.override
  ListPassesRequest createEmptyInstance() => create();
  static $pb.PbList<ListPassesRequest> createRepeated() =>
      $pb.PbList<ListPassesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPassesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPassesRequest>(create);
  static ListPassesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commonKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set commonKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommonKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommonKey() => $_clearField(1);
}

class ListPassesResponse extends $pb.GeneratedMessage {
  factory ListPassesResponse({
    $core.Iterable<Pass>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListPassesResponse._();

  factory ListPassesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPassesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPassesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<Pass>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: Pass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPassesResponse clone() => ListPassesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPassesResponse copyWith(void Function(ListPassesResponse) updates) =>
      super.copyWith((message) => updates(message as ListPassesResponse))
          as ListPassesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPassesResponse create() => ListPassesResponse._();
  @$core.override
  ListPassesResponse createEmptyInstance() => create();
  static $pb.PbList<ListPassesResponse> createRepeated() =>
      $pb.PbList<ListPassesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPassesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPassesResponse>(create);
  static ListPassesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Pass> get items => $_getList(0);
}

class WaveformPoint extends $pb.GeneratedMessage {
  factory WaveformPoint({
    $fixnum.Int64? id,
    $core.String? seriesId,
    $core.String? passId,
    $core.String? commonKey,
    $core.String? seriesRole,
    $core.String? masterProfileId,
    $core.String? workerId,
    $core.String? robotId,
    $core.int? timeMs,
    $core.double? currentA,
    $core.double? voltageV,
    $core.double? wireFeedSpeedMpm,
    $core.double? rotationSpeedRpm,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (seriesId != null) result.seriesId = seriesId;
    if (passId != null) result.passId = passId;
    if (commonKey != null) result.commonKey = commonKey;
    if (seriesRole != null) result.seriesRole = seriesRole;
    if (masterProfileId != null) result.masterProfileId = masterProfileId;
    if (workerId != null) result.workerId = workerId;
    if (robotId != null) result.robotId = robotId;
    if (timeMs != null) result.timeMs = timeMs;
    if (currentA != null) result.currentA = currentA;
    if (voltageV != null) result.voltageV = voltageV;
    if (wireFeedSpeedMpm != null) result.wireFeedSpeedMpm = wireFeedSpeedMpm;
    if (rotationSpeedRpm != null) result.rotationSpeedRpm = rotationSpeedRpm;
    return result;
  }

  WaveformPoint._();

  factory WaveformPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaveformPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaveformPoint',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'seriesId')
    ..aOS(3, _omitFieldNames ? '' : 'passId')
    ..aOS(4, _omitFieldNames ? '' : 'commonKey')
    ..aOS(5, _omitFieldNames ? '' : 'seriesRole')
    ..aOS(6, _omitFieldNames ? '' : 'masterProfileId')
    ..aOS(7, _omitFieldNames ? '' : 'workerId')
    ..aOS(8, _omitFieldNames ? '' : 'robotId')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'timeMs', $pb.PbFieldType.O3)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'currentA', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'voltageV', $pb.PbFieldType.OD)
    ..a<$core.double>(
        12, _omitFieldNames ? '' : 'wireFeedSpeedMpm', $pb.PbFieldType.OD)
    ..a<$core.double>(
        13, _omitFieldNames ? '' : 'rotationSpeedRpm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaveformPoint clone() => WaveformPoint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaveformPoint copyWith(void Function(WaveformPoint) updates) =>
      super.copyWith((message) => updates(message as WaveformPoint))
          as WaveformPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaveformPoint create() => WaveformPoint._();
  @$core.override
  WaveformPoint createEmptyInstance() => create();
  static $pb.PbList<WaveformPoint> createRepeated() =>
      $pb.PbList<WaveformPoint>();
  @$core.pragma('dart2js:noInline')
  static WaveformPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaveformPoint>(create);
  static WaveformPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get seriesId => $_getSZ(1);
  @$pb.TagNumber(2)
  set seriesId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeriesId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeriesId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get passId => $_getSZ(2);
  @$pb.TagNumber(3)
  set passId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get commonKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set commonKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCommonKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommonKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get seriesRole => $_getSZ(4);
  @$pb.TagNumber(5)
  set seriesRole($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSeriesRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeriesRole() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get masterProfileId => $_getSZ(5);
  @$pb.TagNumber(6)
  set masterProfileId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMasterProfileId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMasterProfileId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get workerId => $_getSZ(6);
  @$pb.TagNumber(7)
  set workerId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWorkerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorkerId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get robotId => $_getSZ(7);
  @$pb.TagNumber(8)
  set robotId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRobotId() => $_has(7);
  @$pb.TagNumber(8)
  void clearRobotId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get timeMs => $_getIZ(8);
  @$pb.TagNumber(9)
  set timeMs($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTimeMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get currentA => $_getN(9);
  @$pb.TagNumber(10)
  set currentA($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCurrentA() => $_has(9);
  @$pb.TagNumber(10)
  void clearCurrentA() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get voltageV => $_getN(10);
  @$pb.TagNumber(11)
  set voltageV($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVoltageV() => $_has(10);
  @$pb.TagNumber(11)
  void clearVoltageV() => $_clearField(11);

  /// "속도"가 아니라 와이어 송급 속도(m/min) — 예전 필드명 speed_value에서 고쳤다.
  @$pb.TagNumber(12)
  $core.double get wireFeedSpeedMpm => $_getN(11);
  @$pb.TagNumber(12)
  set wireFeedSpeedMpm($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasWireFeedSpeedMpm() => $_has(11);
  @$pb.TagNumber(12)
  void clearWireFeedSpeedMpm() => $_clearField(12);

  /// 회전 속도(rpm) — time_ms 시점에 맞는 값. 아직 원본 CSV에 이 채널이 없어서 대부분 비어
  /// 있다(향후 데이터 추가 예정, 채워지면 자동으로 값이 옴 — postgres-db/dashboard/init.sql 참고).
  @$pb.TagNumber(13)
  $core.double get rotationSpeedRpm => $_getN(12);
  @$pb.TagNumber(13)
  set rotationSpeedRpm($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRotationSpeedRpm() => $_has(12);
  @$pb.TagNumber(13)
  void clearRotationSpeedRpm() => $_clearField(13);
}

/// pass_id가 있으면 그 패스로만 좁혀 내려준다(파형은 전체가 12,000행대라 화면은 항상 패스
/// 단위로만 씀 — wireframe-prototype/web/js/store.js seriesForPass 참고). 비우면 전체.
class ListWaveformSeriesRequest extends $pb.GeneratedMessage {
  factory ListWaveformSeriesRequest({
    $core.String? passId,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    return result;
  }

  ListWaveformSeriesRequest._();

  factory ListWaveformSeriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWaveformSeriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWaveformSeriesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaveformSeriesRequest clone() =>
      ListWaveformSeriesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaveformSeriesRequest copyWith(
          void Function(ListWaveformSeriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListWaveformSeriesRequest))
          as ListWaveformSeriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWaveformSeriesRequest create() => ListWaveformSeriesRequest._();
  @$core.override
  ListWaveformSeriesRequest createEmptyInstance() => create();
  static $pb.PbList<ListWaveformSeriesRequest> createRepeated() =>
      $pb.PbList<ListWaveformSeriesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListWaveformSeriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWaveformSeriesRequest>(create);
  static ListWaveformSeriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get passId => $_getSZ(0);
  @$pb.TagNumber(1)
  set passId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);
}

class ListWaveformSeriesResponse extends $pb.GeneratedMessage {
  factory ListWaveformSeriesResponse({
    $core.Iterable<WaveformPoint>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListWaveformSeriesResponse._();

  factory ListWaveformSeriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWaveformSeriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWaveformSeriesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<WaveformPoint>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: WaveformPoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaveformSeriesResponse clone() =>
      ListWaveformSeriesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaveformSeriesResponse copyWith(
          void Function(ListWaveformSeriesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListWaveformSeriesResponse))
          as ListWaveformSeriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWaveformSeriesResponse create() => ListWaveformSeriesResponse._();
  @$core.override
  ListWaveformSeriesResponse createEmptyInstance() => create();
  static $pb.PbList<ListWaveformSeriesResponse> createRepeated() =>
      $pb.PbList<ListWaveformSeriesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListWaveformSeriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWaveformSeriesResponse>(create);
  static ListWaveformSeriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WaveformPoint> get items => $_getList(0);
}

/// role별로 묶은 포인트 하나 — GetPassWaveform 전용(위 WaveformPoint 플랫 목록과 달리
/// series[].points[] 구조, mockup-data 명세의 응답 계약 그대로).
class PassWaveformPoint extends $pb.GeneratedMessage {
  factory PassWaveformPoint({
    $core.int? t,
    $core.double? currentA,
    $core.double? voltageV,
    $core.double? wireFeedSpeedMpm,
    $core.double? rotationSpeedRpm,
  }) {
    final result = create();
    if (t != null) result.t = t;
    if (currentA != null) result.currentA = currentA;
    if (voltageV != null) result.voltageV = voltageV;
    if (wireFeedSpeedMpm != null) result.wireFeedSpeedMpm = wireFeedSpeedMpm;
    if (rotationSpeedRpm != null) result.rotationSpeedRpm = rotationSpeedRpm;
    return result;
  }

  PassWaveformPoint._();

  factory PassWaveformPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PassWaveformPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PassWaveformPoint',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 't', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'currentA', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'voltageV', $pb.PbFieldType.OD)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'wireFeedSpeedMpm', $pb.PbFieldType.OD)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'rotationSpeedRpm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassWaveformPoint clone() => PassWaveformPoint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassWaveformPoint copyWith(void Function(PassWaveformPoint) updates) =>
      super.copyWith((message) => updates(message as PassWaveformPoint))
          as PassWaveformPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PassWaveformPoint create() => PassWaveformPoint._();
  @$core.override
  PassWaveformPoint createEmptyInstance() => create();
  static $pb.PbList<PassWaveformPoint> createRepeated() =>
      $pb.PbList<PassWaveformPoint>();
  @$core.pragma('dart2js:noInline')
  static PassWaveformPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PassWaveformPoint>(create);
  static PassWaveformPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get t => $_getIZ(0);
  @$pb.TagNumber(1)
  set t($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasT() => $_has(0);
  @$pb.TagNumber(1)
  void clearT() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get currentA => $_getN(1);
  @$pb.TagNumber(2)
  set currentA($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentA() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentA() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get voltageV => $_getN(2);
  @$pb.TagNumber(3)
  set voltageV($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVoltageV() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoltageV() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get wireFeedSpeedMpm => $_getN(3);
  @$pb.TagNumber(4)
  set wireFeedSpeedMpm($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWireFeedSpeedMpm() => $_has(3);
  @$pb.TagNumber(4)
  void clearWireFeedSpeedMpm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get rotationSpeedRpm => $_getN(4);
  @$pb.TagNumber(5)
  set rotationSpeedRpm($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRotationSpeedRpm() => $_has(4);
  @$pb.TagNumber(5)
  void clearRotationSpeedRpm() => $_clearField(5);
}

class PassWaveformSeries extends $pb.GeneratedMessage {
  factory PassWaveformSeries({
    $core.String? role,
    $core.String? displayName,
    $core.String? masterProfileId,
    $core.String? workerId,
    $core.String? robotId,
    $core.Iterable<PassWaveformPoint>? points,
  }) {
    final result = create();
    if (role != null) result.role = role;
    if (displayName != null) result.displayName = displayName;
    if (masterProfileId != null) result.masterProfileId = masterProfileId;
    if (workerId != null) result.workerId = workerId;
    if (robotId != null) result.robotId = robotId;
    if (points != null) result.points.addAll(points);
    return result;
  }

  PassWaveformSeries._();

  factory PassWaveformSeries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PassWaveformSeries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PassWaveformSeries',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'masterProfileId')
    ..aOS(4, _omitFieldNames ? '' : 'workerId')
    ..aOS(5, _omitFieldNames ? '' : 'robotId')
    ..pc<PassWaveformPoint>(
        6, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM,
        subBuilder: PassWaveformPoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassWaveformSeries clone() => PassWaveformSeries()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassWaveformSeries copyWith(void Function(PassWaveformSeries) updates) =>
      super.copyWith((message) => updates(message as PassWaveformSeries))
          as PassWaveformSeries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PassWaveformSeries create() => PassWaveformSeries._();
  @$core.override
  PassWaveformSeries createEmptyInstance() => create();
  static $pb.PbList<PassWaveformSeries> createRepeated() =>
      $pb.PbList<PassWaveformSeries>();
  @$core.pragma('dart2js:noInline')
  static PassWaveformSeries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PassWaveformSeries>(create);
  static PassWaveformSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get masterProfileId => $_getSZ(2);
  @$pb.TagNumber(3)
  set masterProfileId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMasterProfileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMasterProfileId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set workerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get robotId => $_getSZ(4);
  @$pb.TagNumber(5)
  set robotId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRobotId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRobotId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<PassWaveformPoint> get points => $_getList(5);
}

class GetPassWaveformRequest extends $pb.GeneratedMessage {
  factory GetPassWaveformRequest({
    $core.String? passId,
    $core.String? normalize,
    $core.Iterable<$core.String>? roles,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    if (normalize != null) result.normalize = normalize;
    if (roles != null) result.roles.addAll(roles);
    return result;
  }

  GetPassWaveformRequest._();

  factory GetPassWaveformRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPassWaveformRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPassWaveformRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'passId')
    ..aOS(2, _omitFieldNames ? '' : 'normalize')
    ..pPS(3, _omitFieldNames ? '' : 'roles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPassWaveformRequest clone() =>
      GetPassWaveformRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPassWaveformRequest copyWith(
          void Function(GetPassWaveformRequest) updates) =>
      super.copyWith((message) => updates(message as GetPassWaveformRequest))
          as GetPassWaveformRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPassWaveformRequest create() => GetPassWaveformRequest._();
  @$core.override
  GetPassWaveformRequest createEmptyInstance() => create();
  static $pb.PbList<GetPassWaveformRequest> createRepeated() =>
      $pb.PbList<GetPassWaveformRequest>();
  @$core.pragma('dart2js:noInline')
  static GetPassWaveformRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPassWaveformRequest>(create);
  static GetPassWaveformRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get passId => $_getSZ(0);
  @$pb.TagNumber(1)
  set passId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get normalize => $_getSZ(1);
  @$pb.TagNumber(2)
  set normalize($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNormalize() => $_has(1);
  @$pb.TagNumber(2)
  void clearNormalize() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get roles => $_getList(2);
}

class GetPassWaveformResponse extends $pb.GeneratedMessage {
  factory GetPassWaveformResponse({
    $core.String? passId,
    $core.String? commonKey,
    $core.String? passName,
    $core.String? normalize,
    $core.Iterable<PassWaveformSeries>? series,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    if (commonKey != null) result.commonKey = commonKey;
    if (passName != null) result.passName = passName;
    if (normalize != null) result.normalize = normalize;
    if (series != null) result.series.addAll(series);
    return result;
  }

  GetPassWaveformResponse._();

  factory GetPassWaveformResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPassWaveformResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPassWaveformResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'passId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aOS(3, _omitFieldNames ? '' : 'passName')
    ..aOS(4, _omitFieldNames ? '' : 'normalize')
    ..pc<PassWaveformSeries>(
        5, _omitFieldNames ? '' : 'series', $pb.PbFieldType.PM,
        subBuilder: PassWaveformSeries.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPassWaveformResponse clone() =>
      GetPassWaveformResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPassWaveformResponse copyWith(
          void Function(GetPassWaveformResponse) updates) =>
      super.copyWith((message) => updates(message as GetPassWaveformResponse))
          as GetPassWaveformResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPassWaveformResponse create() => GetPassWaveformResponse._();
  @$core.override
  GetPassWaveformResponse createEmptyInstance() => create();
  static $pb.PbList<GetPassWaveformResponse> createRepeated() =>
      $pb.PbList<GetPassWaveformResponse>();
  @$core.pragma('dart2js:noInline')
  static GetPassWaveformResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPassWaveformResponse>(create);
  static GetPassWaveformResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get passId => $_getSZ(0);
  @$pb.TagNumber(1)
  set passId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get passName => $_getSZ(2);
  @$pb.TagNumber(3)
  set passName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get normalize => $_getSZ(3);
  @$pb.TagNumber(4)
  set normalize($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNormalize() => $_has(3);
  @$pb.TagNumber(4)
  void clearNormalize() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<PassWaveformSeries> get series => $_getList(4);
}

class QualityResult extends $pb.GeneratedMessage {
  factory QualityResult({
    $core.String? qualityResultId,
    $core.String? paperDocNo,
    $core.String? commonKey,
    $core.String? passId,
    $core.String? segmentId,
    $core.String? inspectedAt,
    $core.String? inspectorName,
    $core.String? judgement,
    $core.String? issueSummary,
    $core.String? itemName,
    $core.String? itemResult,
    $core.String? itemNote,
    $core.Iterable<QualityMedia>? media,
  }) {
    final result = create();
    if (qualityResultId != null) result.qualityResultId = qualityResultId;
    if (paperDocNo != null) result.paperDocNo = paperDocNo;
    if (commonKey != null) result.commonKey = commonKey;
    if (passId != null) result.passId = passId;
    if (segmentId != null) result.segmentId = segmentId;
    if (inspectedAt != null) result.inspectedAt = inspectedAt;
    if (inspectorName != null) result.inspectorName = inspectorName;
    if (judgement != null) result.judgement = judgement;
    if (issueSummary != null) result.issueSummary = issueSummary;
    if (itemName != null) result.itemName = itemName;
    if (itemResult != null) result.itemResult = itemResult;
    if (itemNote != null) result.itemNote = itemNote;
    if (media != null) result.media.addAll(media);
    return result;
  }

  QualityResult._();

  factory QualityResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'qualityResultId')
    ..aOS(2, _omitFieldNames ? '' : 'paperDocNo')
    ..aOS(3, _omitFieldNames ? '' : 'commonKey')
    ..aOS(4, _omitFieldNames ? '' : 'passId')
    ..aOS(5, _omitFieldNames ? '' : 'segmentId')
    ..aOS(6, _omitFieldNames ? '' : 'inspectedAt')
    ..aOS(7, _omitFieldNames ? '' : 'inspectorName')
    ..aOS(8, _omitFieldNames ? '' : 'judgement')
    ..aOS(9, _omitFieldNames ? '' : 'issueSummary')
    ..aOS(10, _omitFieldNames ? '' : 'itemName')
    ..aOS(11, _omitFieldNames ? '' : 'itemResult')
    ..aOS(12, _omitFieldNames ? '' : 'itemNote')
    ..pc<QualityMedia>(13, _omitFieldNames ? '' : 'media', $pb.PbFieldType.PM,
        subBuilder: QualityMedia.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityResult clone() => QualityResult()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityResult copyWith(void Function(QualityResult) updates) =>
      super.copyWith((message) => updates(message as QualityResult))
          as QualityResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityResult create() => QualityResult._();
  @$core.override
  QualityResult createEmptyInstance() => create();
  static $pb.PbList<QualityResult> createRepeated() =>
      $pb.PbList<QualityResult>();
  @$core.pragma('dart2js:noInline')
  static QualityResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityResult>(create);
  static QualityResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get qualityResultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set qualityResultId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQualityResultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQualityResultId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get paperDocNo => $_getSZ(1);
  @$pb.TagNumber(2)
  set paperDocNo($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPaperDocNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaperDocNo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commonKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set commonKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommonKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommonKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get passId => $_getSZ(3);
  @$pb.TagNumber(4)
  set passId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get segmentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set segmentId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSegmentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSegmentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get inspectedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set inspectedAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInspectedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearInspectedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get inspectorName => $_getSZ(6);
  @$pb.TagNumber(7)
  set inspectorName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInspectorName() => $_has(6);
  @$pb.TagNumber(7)
  void clearInspectorName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get judgement => $_getSZ(7);
  @$pb.TagNumber(8)
  set judgement($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasJudgement() => $_has(7);
  @$pb.TagNumber(8)
  void clearJudgement() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get issueSummary => $_getSZ(8);
  @$pb.TagNumber(9)
  set issueSummary($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIssueSummary() => $_has(8);
  @$pb.TagNumber(9)
  void clearIssueSummary() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get itemName => $_getSZ(9);
  @$pb.TagNumber(10)
  set itemName($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasItemName() => $_has(9);
  @$pb.TagNumber(10)
  void clearItemName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get itemResult => $_getSZ(10);
  @$pb.TagNumber(11)
  set itemResult($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasItemResult() => $_has(10);
  @$pb.TagNumber(11)
  void clearItemResult() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get itemNote => $_getSZ(11);
  @$pb.TagNumber(12)
  set itemNote($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasItemNote() => $_has(11);
  @$pb.TagNumber(12)
  void clearItemNote() => $_clearField(12);

  /// 성적서 스캔 PDF·현장 영상 — quality_result_id 그룹 하나에 0개 이상(같은 타입이 여러 개일
  /// 수 있음, 특히 영상). ListQualityResults가 같이 채워준다(GetQualityMedia 별도 호출 불필요).
  @$pb.TagNumber(13)
  $pb.PbList<QualityMedia> get media => $_getList(12);
}

/// media_type: "scan" | "video". url은 실제로 dashboard/files/에 있을 때만 채워진다
/// (WorkAttachment.file_url과 같은 규칙) — 아직 실물 없이 경로만 있는 값은 file_path만 오고
/// url은 빈다(data/README.md "scan_file은 스캔 PDF 경로(비면 PDF 미연동)..." 그대로).
class QualityMedia extends $pb.GeneratedMessage {
  factory QualityMedia({
    $core.String? mediaType,
    $core.String? filePath,
    $core.int? pageCount,
    $core.String? url,
  }) {
    final result = create();
    if (mediaType != null) result.mediaType = mediaType;
    if (filePath != null) result.filePath = filePath;
    if (pageCount != null) result.pageCount = pageCount;
    if (url != null) result.url = url;
    return result;
  }

  QualityMedia._();

  factory QualityMedia.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityMedia.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityMedia',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaType')
    ..aOS(2, _omitFieldNames ? '' : 'filePath')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageCount', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityMedia clone() => QualityMedia()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityMedia copyWith(void Function(QualityMedia) updates) =>
      super.copyWith((message) => updates(message as QualityMedia))
          as QualityMedia;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityMedia create() => QualityMedia._();
  @$core.override
  QualityMedia createEmptyInstance() => create();
  static $pb.PbList<QualityMedia> createRepeated() =>
      $pb.PbList<QualityMedia>();
  @$core.pragma('dart2js:noInline')
  static QualityMedia getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityMedia>(create);
  static QualityMedia? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaType => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get filePath => $_getSZ(1);
  @$pb.TagNumber(2)
  set filePath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFilePath() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilePath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);
}

class ListQualityResultsRequest extends $pb.GeneratedMessage {
  factory ListQualityResultsRequest({
    $core.String? commonKey,
    $core.String? passId,
  }) {
    final result = create();
    if (commonKey != null) result.commonKey = commonKey;
    if (passId != null) result.passId = passId;
    return result;
  }

  ListQualityResultsRequest._();

  factory ListQualityResultsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListQualityResultsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQualityResultsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commonKey')
    ..aOS(2, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityResultsRequest clone() =>
      ListQualityResultsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityResultsRequest copyWith(
          void Function(ListQualityResultsRequest) updates) =>
      super.copyWith((message) => updates(message as ListQualityResultsRequest))
          as ListQualityResultsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListQualityResultsRequest create() => ListQualityResultsRequest._();
  @$core.override
  ListQualityResultsRequest createEmptyInstance() => create();
  static $pb.PbList<ListQualityResultsRequest> createRepeated() =>
      $pb.PbList<ListQualityResultsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListQualityResultsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListQualityResultsRequest>(create);
  static ListQualityResultsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commonKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set commonKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommonKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommonKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get passId => $_getSZ(1);
  @$pb.TagNumber(2)
  set passId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassId() => $_clearField(2);
}

class ListQualityResultsResponse extends $pb.GeneratedMessage {
  factory ListQualityResultsResponse({
    $core.Iterable<QualityResult>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListQualityResultsResponse._();

  factory ListQualityResultsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListQualityResultsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQualityResultsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<QualityResult>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: QualityResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityResultsResponse clone() =>
      ListQualityResultsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityResultsResponse copyWith(
          void Function(ListQualityResultsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListQualityResultsResponse))
          as ListQualityResultsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListQualityResultsResponse create() => ListQualityResultsResponse._();
  @$core.override
  ListQualityResultsResponse createEmptyInstance() => create();
  static $pb.PbList<ListQualityResultsResponse> createRepeated() =>
      $pb.PbList<ListQualityResultsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListQualityResultsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListQualityResultsResponse>(create);
  static ListQualityResultsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QualityResult> get items => $_getList(0);
}

class QualityLink extends $pb.GeneratedMessage {
  factory QualityLink({
    $core.String? linkId,
    $core.String? commonKey,
    $core.String? qualityResultId,
    $core.String? passId,
    $core.String? segmentId,
    $core.int? segmentStartMs,
    $core.int? segmentEndMs,
    $core.String? note,
  }) {
    final result = create();
    if (linkId != null) result.linkId = linkId;
    if (commonKey != null) result.commonKey = commonKey;
    if (qualityResultId != null) result.qualityResultId = qualityResultId;
    if (passId != null) result.passId = passId;
    if (segmentId != null) result.segmentId = segmentId;
    if (segmentStartMs != null) result.segmentStartMs = segmentStartMs;
    if (segmentEndMs != null) result.segmentEndMs = segmentEndMs;
    if (note != null) result.note = note;
    return result;
  }

  QualityLink._();

  factory QualityLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityLink',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'linkId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aOS(3, _omitFieldNames ? '' : 'qualityResultId')
    ..aOS(4, _omitFieldNames ? '' : 'passId')
    ..aOS(5, _omitFieldNames ? '' : 'segmentId')
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'segmentStartMs', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'segmentEndMs', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityLink clone() => QualityLink()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityLink copyWith(void Function(QualityLink) updates) =>
      super.copyWith((message) => updates(message as QualityLink))
          as QualityLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityLink create() => QualityLink._();
  @$core.override
  QualityLink createEmptyInstance() => create();
  static $pb.PbList<QualityLink> createRepeated() => $pb.PbList<QualityLink>();
  @$core.pragma('dart2js:noInline')
  static QualityLink getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityLink>(create);
  static QualityLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get linkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set linkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLinkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLinkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get qualityResultId => $_getSZ(2);
  @$pb.TagNumber(3)
  set qualityResultId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQualityResultId() => $_has(2);
  @$pb.TagNumber(3)
  void clearQualityResultId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get passId => $_getSZ(3);
  @$pb.TagNumber(4)
  set passId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get segmentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set segmentId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSegmentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSegmentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get segmentStartMs => $_getIZ(5);
  @$pb.TagNumber(6)
  set segmentStartMs($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSegmentStartMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearSegmentStartMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get segmentEndMs => $_getIZ(6);
  @$pb.TagNumber(7)
  set segmentEndMs($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSegmentEndMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearSegmentEndMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get note => $_getSZ(7);
  @$pb.TagNumber(8)
  set note($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNote() => $_has(7);
  @$pb.TagNumber(8)
  void clearNote() => $_clearField(8);
}

class ListQualityLinksRequest extends $pb.GeneratedMessage {
  factory ListQualityLinksRequest({
    $core.String? commonKey,
    $core.String? passId,
  }) {
    final result = create();
    if (commonKey != null) result.commonKey = commonKey;
    if (passId != null) result.passId = passId;
    return result;
  }

  ListQualityLinksRequest._();

  factory ListQualityLinksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListQualityLinksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQualityLinksRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commonKey')
    ..aOS(2, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityLinksRequest clone() =>
      ListQualityLinksRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityLinksRequest copyWith(
          void Function(ListQualityLinksRequest) updates) =>
      super.copyWith((message) => updates(message as ListQualityLinksRequest))
          as ListQualityLinksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListQualityLinksRequest create() => ListQualityLinksRequest._();
  @$core.override
  ListQualityLinksRequest createEmptyInstance() => create();
  static $pb.PbList<ListQualityLinksRequest> createRepeated() =>
      $pb.PbList<ListQualityLinksRequest>();
  @$core.pragma('dart2js:noInline')
  static ListQualityLinksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListQualityLinksRequest>(create);
  static ListQualityLinksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commonKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set commonKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommonKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommonKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get passId => $_getSZ(1);
  @$pb.TagNumber(2)
  set passId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassId() => $_clearField(2);
}

class ListQualityLinksResponse extends $pb.GeneratedMessage {
  factory ListQualityLinksResponse({
    $core.Iterable<QualityLink>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListQualityLinksResponse._();

  factory ListQualityLinksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListQualityLinksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQualityLinksResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..pc<QualityLink>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: QualityLink.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityLinksResponse clone() =>
      ListQualityLinksResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityLinksResponse copyWith(
          void Function(ListQualityLinksResponse) updates) =>
      super.copyWith((message) => updates(message as ListQualityLinksResponse))
          as ListQualityLinksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListQualityLinksResponse create() => ListQualityLinksResponse._();
  @$core.override
  ListQualityLinksResponse createEmptyInstance() => create();
  static $pb.PbList<ListQualityLinksResponse> createRepeated() =>
      $pb.PbList<ListQualityLinksResponse>();
  @$core.pragma('dart2js:noInline')
  static ListQualityLinksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListQualityLinksResponse>(create);
  static ListQualityLinksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QualityLink> get items => $_getList(0);
}

class Context extends $pb.GeneratedMessage {
  factory Context({
    $core.String? commonKey,
    $core.String? workOrderId,
    $core.String? workOrderNo,
    $core.String? title,
    $core.String? jointId,
    $core.String? jointNo,
    $core.String? jointName,
    $core.String? workerId,
    $core.String? workerName,
    $core.String? equipmentId,
    $core.String? equipmentName,
    $core.String? workedAt,
  }) {
    final result = create();
    if (commonKey != null) result.commonKey = commonKey;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (workOrderNo != null) result.workOrderNo = workOrderNo;
    if (title != null) result.title = title;
    if (jointId != null) result.jointId = jointId;
    if (jointNo != null) result.jointNo = jointNo;
    if (jointName != null) result.jointName = jointName;
    if (workerId != null) result.workerId = workerId;
    if (workerName != null) result.workerName = workerName;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (workedAt != null) result.workedAt = workedAt;
    return result;
  }

  Context._();

  factory Context.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Context.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Context',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commonKey')
    ..aOS(2, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(3, _omitFieldNames ? '' : 'workOrderNo')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'jointId')
    ..aOS(6, _omitFieldNames ? '' : 'jointNo')
    ..aOS(7, _omitFieldNames ? '' : 'jointName')
    ..aOS(8, _omitFieldNames ? '' : 'workerId')
    ..aOS(9, _omitFieldNames ? '' : 'workerName')
    ..aOS(10, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(11, _omitFieldNames ? '' : 'equipmentName')
    ..aOS(12, _omitFieldNames ? '' : 'workedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Context clone() => Context()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Context copyWith(void Function(Context) updates) =>
      super.copyWith((message) => updates(message as Context)) as Context;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Context create() => Context._();
  @$core.override
  Context createEmptyInstance() => create();
  static $pb.PbList<Context> createRepeated() => $pb.PbList<Context>();
  @$core.pragma('dart2js:noInline')
  static Context getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Context>(create);
  static Context? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commonKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set commonKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommonKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommonKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workOrderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workOrderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workOrderNo => $_getSZ(2);
  @$pb.TagNumber(3)
  set workOrderNo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkOrderNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkOrderNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jointId => $_getSZ(4);
  @$pb.TagNumber(5)
  set jointId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJointId() => $_has(4);
  @$pb.TagNumber(5)
  void clearJointId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get jointNo => $_getSZ(5);
  @$pb.TagNumber(6)
  set jointNo($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJointNo() => $_has(5);
  @$pb.TagNumber(6)
  void clearJointNo() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get jointName => $_getSZ(6);
  @$pb.TagNumber(7)
  set jointName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasJointName() => $_has(6);
  @$pb.TagNumber(7)
  void clearJointName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get workerId => $_getSZ(7);
  @$pb.TagNumber(8)
  set workerId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWorkerId() => $_has(7);
  @$pb.TagNumber(8)
  void clearWorkerId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get workerName => $_getSZ(8);
  @$pb.TagNumber(9)
  set workerName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWorkerName() => $_has(8);
  @$pb.TagNumber(9)
  void clearWorkerName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get equipmentId => $_getSZ(9);
  @$pb.TagNumber(10)
  set equipmentId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEquipmentId() => $_has(9);
  @$pb.TagNumber(10)
  void clearEquipmentId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get equipmentName => $_getSZ(10);
  @$pb.TagNumber(11)
  set equipmentName($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEquipmentName() => $_has(10);
  @$pb.TagNumber(11)
  void clearEquipmentName() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get workedAt => $_getSZ(11);
  @$pb.TagNumber(12)
  set workedAt($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasWorkedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearWorkedAt() => $_clearField(12);
}

class GetContextRequest extends $pb.GeneratedMessage {
  factory GetContextRequest({
    $core.String? commonKey,
  }) {
    final result = create();
    if (commonKey != null) result.commonKey = commonKey;
    return result;
  }

  GetContextRequest._();

  factory GetContextRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetContextRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetContextRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commonKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContextRequest clone() => GetContextRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContextRequest copyWith(void Function(GetContextRequest) updates) =>
      super.copyWith((message) => updates(message as GetContextRequest))
          as GetContextRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetContextRequest create() => GetContextRequest._();
  @$core.override
  GetContextRequest createEmptyInstance() => create();
  static $pb.PbList<GetContextRequest> createRepeated() =>
      $pb.PbList<GetContextRequest>();
  @$core.pragma('dart2js:noInline')
  static GetContextRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetContextRequest>(create);
  static GetContextRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commonKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set commonKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommonKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommonKey() => $_clearField(1);
}

class GetContextResponse extends $pb.GeneratedMessage {
  factory GetContextResponse({
    Context? context,
  }) {
    final result = create();
    if (context != null) result.context = context;
    return result;
  }

  GetContextResponse._();

  factory GetContextResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetContextResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetContextResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacit.dashboard.v1'),
      createEmptyInstance: create)
    ..aOM<Context>(1, _omitFieldNames ? '' : 'context',
        subBuilder: Context.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContextResponse clone() => GetContextResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContextResponse copyWith(void Function(GetContextResponse) updates) =>
      super.copyWith((message) => updates(message as GetContextResponse))
          as GetContextResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetContextResponse create() => GetContextResponse._();
  @$core.override
  GetContextResponse createEmptyInstance() => create();
  static $pb.PbList<GetContextResponse> createRepeated() =>
      $pb.PbList<GetContextResponse>();
  @$core.pragma('dart2js:noInline')
  static GetContextResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetContextResponse>(create);
  static GetContextResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Context get context => $_getN(0);
  @$pb.TagNumber(1)
  set context(Context value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  Context ensureContext() => $_ensure(0);
}

/// 와이어프레임 프로토타입(serviceops/wireframe-prototype)의 data/*.csv를 postgres-db/dashboard로
/// 옮긴 것을 내려준다. 원본 CSV 테이블 그대로인 List* RPC와, wireframe-prototype/web/js/store.js의
/// 조회 로직(배정 겹침 필터, 이력 조인, 컨텍스트)을 SQL로 옮긴 조인/필터 RPC 두 종류가 있다.
/// 화면에 없는 조합은 안 만든다 — 필요해지면 그때 추가.
class DashboardServiceApi {
  final $pb.RpcClient _client;

  DashboardServiceApi(this._client);

  /// s0 장비 필터(체크박스)·라인 옵션, 필터 칩 라벨(id→이름) 용도가 대부분 — 콘텐츠 조회는
  /// equipment_name/line_name을 이미 조인해서 내려주는 ListCollectionEvents/
  /// ListEquipmentStatus/ListWorkHistory 쪽에서 처리한다.
  $async.Future<ListEquipmentResponse> listEquipment(
          $pb.ClientContext? ctx, ListEquipmentRequest request) =>
      _client.invoke<ListEquipmentResponse>(ctx, 'DashboardService',
          'ListEquipment', request, ListEquipmentResponse());

  /// 필터 드롭다운/칩 라벨 + 배정 정보 표시(인스펙터 패널)에 같이 쓰인다 — 드롭다운 전용 아님.
  $async.Future<ListProjectsResponse> listProjects(
          $pb.ClientContext? ctx, ListProjectsRequest request) =>
      _client.invoke<ListProjectsResponse>(ctx, 'DashboardService',
          'ListProjects', request, ListProjectsResponse());

  /// s0 드릴다운(프로젝트→작업자 옵션) 생성 + 인스펙터 패널의 "현재 배정" 판정(assignmentAt류)에
  /// 같이 쓰인다 — 드롭다운 전용 아님.
  $async.Future<ListCollectionAssignmentsResponse> listCollectionAssignments(
          $pb.ClientContext? ctx, ListCollectionAssignmentsRequest request) =>
      _client.invoke<ListCollectionAssignmentsResponse>(
          ctx,
          'DashboardService',
          'ListCollectionAssignments',
          request,
          ListCollectionAssignmentsResponse());

  /// s0 타임라인/이벤트 로그. date/equipment/connection/line/project/worker/unassigned 필터.
  /// project_ids·worker_ids는 collection_assignments와 이벤트 구간이 겹치는지로 매칭한다
  /// (store.js eventMatchesAssignmentFilter). equipment 조인이라 equipment_name/line_name도
  /// 같이 옴. from/to("HH:MM")는 date로 고른 하루 안의 시:분 구간(s0 타임라인 확대 t0/t1).
  $async.Future<ListCollectionEventsResponse> listCollectionEvents(
          $pb.ClientContext? ctx, ListCollectionEventsRequest request) =>
      _client.invoke<ListCollectionEventsResponse>(ctx, 'DashboardService',
          'ListCollectionEvents', request, ListCollectionEventsResponse());

  /// s0 KPI 카드 + 실시간 수집 상태 표(s1도 필터 없이 그대로 재사용). equipment + collection_
  /// status(스냅샷) LEFT JOIN이라 상태 없는 장비도 포함. 필터는 ListCollectionEvents와 동일한
  /// 배정 겹침 규칙이지만 "그 날 하루" 단위로 겹치는지를 본다(store.js snapshotFiltered).
  $async.Future<ListEquipmentStatusResponse> listEquipmentStatus(
          $pb.ClientContext? ctx, ListEquipmentStatusRequest request) =>
      _client.invoke<ListEquipmentStatusResponse>(ctx, 'DashboardService',
          'ListEquipmentStatus', request, ListEquipmentStatusResponse());

  /// 필터 드롭다운 전용(s2 작업지시 선택) — work_order_no/title은 ListWorkHistory가 이미
  /// 조인해서 내려주므로 다른 곳에서 따로 안 부른다.
  $async.Future<ListWorkOrdersResponse> listWorkOrders(
          $pb.ClientContext? ctx, ListWorkOrdersRequest request) =>
      _client.invoke<ListWorkOrdersResponse>(ctx, 'DashboardService',
          'ListWorkOrders', request, ListWorkOrdersResponse());

  /// 필터 드롭다운 전용(s2d 조인트 선택) — joint_no/name도 ListWorkHistory가 이미 조인해서
  /// 내려주므로 다른 곳에서 따로 안 부른다.
  $async.Future<ListJointsResponse> listJoints(
          $pb.ClientContext? ctx, ListJointsRequest request) =>
      _client.invoke<ListJointsResponse>(
          ctx, 'DashboardService', 'ListJoints', request, ListJointsResponse());

  /// 필터 드롭다운/칩 라벨 + 파형 범례 실명 표시(masterName/beginnerName)에 같이 쓰인다 —
  /// 드롭다운 전용 아님.
  $async.Future<ListWorkersResponse> listWorkers(
          $pb.ClientContext? ctx, ListWorkersRequest request) =>
      _client.invoke<ListWorkersResponse>(ctx, 'DashboardService',
          'ListWorkers', request, ListWorkersResponse());

  /// s2 검색/목록 표 + s2d 상세 헤더. work_orders/joints/workers/equipment 조인, passes/
  /// work_attachments 카운트(pass_count/attachment_count)까지 붙여서 내려주므로 행마다 별도
  /// 조회가 필요 없다. common_key는 부분 일치(substring), history_id는 정확히 일치(s2d 딥링크
  /// 단건 조회용).
  $async.Future<ListWorkHistoryResponse> listWorkHistory(
          $pb.ClientContext? ctx, ListWorkHistoryRequest request) =>
      _client.invoke<ListWorkHistoryResponse>(ctx, 'DashboardService',
          'ListWorkHistory', request, ListWorkHistoryResponse());

  /// s2 목록의 첨부 아이콘, s2d 첨부 탭(이미지/PDF/영상/오디오/텍스트) 목록·뷰어. 필터 없이
  /// 전체를 내려주면 FE가 history_id/file_type으로 골라 쓴다(store.js attachments()와 동일).
  /// 실 파일은 file_url(정적 /files/... 경로)로 받고, 이 응답 바디엔 바이트를 안 싣는다.
  $async.Future<ListWorkAttachmentsResponse> listWorkAttachments(
          $pb.ClientContext? ctx, ListWorkAttachmentsRequest request) =>
      _client.invoke<ListWorkAttachmentsResponse>(ctx, 'DashboardService',
          'ListWorkAttachments', request, ListWorkAttachmentsResponse());

  /// s3/s4 패스 선택 탭. common_key 필터(비우면 전체), pass_no 순으로 정렬해서 씀.
  $async.Future<ListPassesResponse> listPasses(
          $pb.ClientContext? ctx, ListPassesRequest request) =>
      _client.invoke<ListPassesResponse>(
          ctx, 'DashboardService', 'ListPasses', request, ListPassesResponse());

  /// waveform_series 테이블 그대로(플랫 목록, 포인트당 한 행). pass_id 필터(비우면 전체 —
  /// 테이블이 12,000행대라 화면은 항상 pass_id를 넣어 씀). 화면 자체는 role별로 묶인
  /// GetPassWaveform을 쓰고 이 RPC는 안 부른다 — 원본 테이블 참조/디버그용으로 남겨둠.
  $async.Future<ListWaveformSeriesResponse> listWaveformSeries(
          $pb.ClientContext? ctx, ListWaveformSeriesRequest request) =>
      _client.invoke<ListWaveformSeriesResponse>(ctx, 'DashboardService',
          'ListWaveformSeries', request, ListWaveformSeriesResponse());

  /// s3 파형 비교 그래프(명장/초보자/로봇 겹쳐보기) + s4 파형 배경 그래프. mockup-data/
  /// API-컬럼매핑-연동명세.md의 GET /api/v1/passes/{pass_id}/waveform 계약을 그대로 gRPC로
  /// 옮긴 것 — normalize="raw"면 이 서비스 자신의 DB(passes/waveform_series)에서,
  /// "dtw"(normalized)면 aiops를 gRPC로 호출해 합쳐서 낸다(internal/data/aiops). FE는 이
  /// 하나만 보고 raw/dtw 차이는 모른다. roles 비우면 그 pass의 전체 role.
  $async.Future<GetPassWaveformResponse> getPassWaveform(
          $pb.ClientContext? ctx, GetPassWaveformRequest request) =>
      _client.invoke<GetPassWaveformResponse>(ctx, 'DashboardService',
          'GetPassWaveform', request, GetPassWaveformResponse());

  /// s4 품질 판정 카드(성적서/불량 항목). quality_results 테이블 그대로(item당 한 행, flat) —
  /// 같은 quality_result_id가 item마다 반복되고 FE가 그룹으로 묶어 쓴다(store.js
  /// qualityGroups()). 성적서 스캔 PDF·현장 영상(media, scan/video)도 quality_result_id당
  /// 0개 이상 같이 옴 — 별도 호출 불필요. common_key/pass_id 필터(둘 다 비우면 전체).
  $async.Future<ListQualityResultsResponse> listQualityResults(
          $pb.ClientContext? ctx, ListQualityResultsRequest request) =>
      _client.invoke<ListQualityResultsResponse>(ctx, 'DashboardService',
          'ListQualityResults', request, ListQualityResultsResponse());

  /// s4 파형 구간 ↔ 품질결과 연결선(회색 밴드, 클릭하면 좌측 품질 판정으로 스크롤). segment_id·
  /// segment_start_ms/end_ms로 파형의 어느 구간이 어느 품질결과에 대응하는지 알려준다.
  /// common_key/pass_id 필터(둘 다 비우면 전체).
  $async.Future<ListQualityLinksResponse> listQualityLinks(
          $pb.ClientContext? ctx, ListQualityLinksRequest request) =>
      _client.invoke<ListQualityLinksResponse>(ctx, 'DashboardService',
          'ListQualityLinks', request, ListQualityLinksResponse());

  /// s3/s4 상단 컨텍스트 바(공통키 → 작업지시/조인트/작업자/장비). work_history 중 worked_at
  /// 최신 1건 + work_order/joint/worker/equipment 조인(store.js context()). 그 common_key로
  /// work_history가 없으면 common_key만 채운 빈 결과(work_order_no|joint_no 파싱 fallback).
  $async.Future<GetContextResponse> getContext(
          $pb.ClientContext? ctx, GetContextRequest request) =>
      _client.invoke<GetContextResponse>(
          ctx, 'DashboardService', 'GetContext', request, GetContextResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
