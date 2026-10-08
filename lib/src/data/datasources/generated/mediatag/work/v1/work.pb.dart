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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/field_mask.pb.dart' as $1;
import '../../../google/protobuf/timestamp.pb.dart' as $0;
import '../../asset/v1/asset.pb.dart' as $2;
import 'work.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'work.pbenum.dart';

/// 작업 공간 = 공사. PDF DB·CARO의 project_no와 같은 값.
class Project extends $pb.GeneratedMessage {
  factory Project({
    $core.String? projectNo,
    $core.String? projectName,
    $core.String? siteName,
    $core.String? customer,
    $fixnum.Int64? projectId,
  }) {
    final result = create();
    if (projectNo != null) result.projectNo = projectNo;
    if (projectName != null) result.projectName = projectName;
    if (siteName != null) result.siteName = siteName;
    if (customer != null) result.customer = customer;
    if (projectId != null) result.projectId = projectId;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectNo')
    ..aOS(2, _omitFieldNames ? '' : 'projectName')
    ..aOS(3, _omitFieldNames ? '' : 'siteName')
    ..aOS(4, _omitFieldNames ? '' : 'customer')
    ..aInt64(5, _omitFieldNames ? '' : 'projectId')
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
  $core.String get projectNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectNo() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $core.String get customer => $_getSZ(3);
  @$pb.TagNumber(4)
  set customer($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomer() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomer() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get projectId => $_getI64(4);
  @$pb.TagNumber(5)
  set projectId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProjectId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProjectId() => $_clearField(5);
}

/// 작업자. 명장/대조군 구분은 비교·학습 데이터의 핵심.
class Worker extends $pb.GeneratedMessage {
  factory Worker({
    $fixnum.Int64? workerId,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'workerId')
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
  $fixnum.Int64 get workerId => $_getI64(0);
  @$pb.TagNumber(1)
  set workerId($fixnum.Int64 value) => $_setInt64(0, value);
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

/// 수집 장비(카메라·마이크·센서·용접기 패널 등).
class Equipment extends $pb.GeneratedMessage {
  factory Equipment({
    $fixnum.Int64? equipmentId,
    $core.String? equipmentName,
    $core.String? lineName,
    $core.String? equipmentCode,
  }) {
    final result = create();
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (lineName != null) result.lineName = lineName;
    if (equipmentCode != null) result.equipmentCode = equipmentCode;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'equipmentId')
    ..aOS(2, _omitFieldNames ? '' : 'equipmentName')
    ..aOS(3, _omitFieldNames ? '' : 'lineName')
    ..aOS(4, _omitFieldNames ? '' : 'equipmentCode')
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
  $fixnum.Int64 get equipmentId => $_getI64(0);
  @$pb.TagNumber(1)
  set equipmentId($fixnum.Int64 value) => $_setInt64(0, value);
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
  $core.String get equipmentCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set equipmentCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEquipmentCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearEquipmentCode() => $_clearField(4);
}

/// 작업 1회 = 이력 1건 = 타임라인 1개.
class Job extends $pb.GeneratedMessage {
  factory Job({
    $fixnum.Int64? jobId,
    $core.String? commonKey,
    $core.String? projectNo,
    $core.String? unitNo,
    $core.String? itemCode,
    $core.String? itemName,
    $core.String? itemNo,
    $core.String? operationNo,
    $core.String? material,
    $core.double? outerDiameterMm,
    $core.double? thicknessMm,
    $fixnum.Int64? workerId,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $core.String? jointNo,
    $core.String? jobKey,
    $fixnum.Int64? projectId,
    $core.String? jobName,
    $fixnum.Int64? projectItemId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (commonKey != null) result.commonKey = commonKey;
    if (projectNo != null) result.projectNo = projectNo;
    if (unitNo != null) result.unitNo = unitNo;
    if (itemCode != null) result.itemCode = itemCode;
    if (itemName != null) result.itemName = itemName;
    if (itemNo != null) result.itemNo = itemNo;
    if (operationNo != null) result.operationNo = operationNo;
    if (material != null) result.material = material;
    if (outerDiameterMm != null) result.outerDiameterMm = outerDiameterMm;
    if (thicknessMm != null) result.thicknessMm = thicknessMm;
    if (workerId != null) result.workerId = workerId;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (jointNo != null) result.jointNo = jointNo;
    if (jobKey != null) result.jobKey = jobKey;
    if (projectId != null) result.projectId = projectId;
    if (jobName != null) result.jobName = jobName;
    if (projectItemId != null) result.projectItemId = projectItemId;
    return result;
  }

  Job._();

  factory Job.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Job.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Job',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aOS(3, _omitFieldNames ? '' : 'projectNo')
    ..aOS(4, _omitFieldNames ? '' : 'unitNo')
    ..aOS(5, _omitFieldNames ? '' : 'itemCode')
    ..aOS(6, _omitFieldNames ? '' : 'itemName')
    ..aOS(8, _omitFieldNames ? '' : 'itemNo')
    ..aOS(9, _omitFieldNames ? '' : 'operationNo')
    ..aOS(10, _omitFieldNames ? '' : 'material')
    ..a<$core.double>(
        11, _omitFieldNames ? '' : 'outerDiameterMm', $pb.PbFieldType.OD)
    ..a<$core.double>(
        12, _omitFieldNames ? '' : 'thicknessMm', $pb.PbFieldType.OD)
    ..aInt64(13, _omitFieldNames ? '' : 'workerId')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'jointNo')
    ..aOS(17, _omitFieldNames ? '' : 'jobKey')
    ..aInt64(18, _omitFieldNames ? '' : 'projectId')
    ..aOS(19, _omitFieldNames ? '' : 'jobName')
    ..aInt64(20, _omitFieldNames ? '' : 'projectItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Job clone() => Job()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Job copyWith(void Function(Job) updates) =>
      super.copyWith((message) => updates(message as Job)) as Job;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Job create() => Job._();
  @$core.override
  Job createEmptyInstance() => create();
  static $pb.PbList<Job> createRepeated() => $pb.PbList<Job>();
  @$core.pragma('dart2js:noInline')
  static Job getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Job>(create);
  static Job? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobId => $_getI64(0);
  @$pb.TagNumber(1)
  set jobId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get projectNo => $_getSZ(2);
  @$pb.TagNumber(3)
  set projectNo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProjectNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unitNo => $_getSZ(3);
  @$pb.TagNumber(4)
  set unitNo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitNo() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitNo() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get itemCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set itemCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasItemCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearItemCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get itemName => $_getSZ(5);
  @$pb.TagNumber(6)
  set itemName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasItemName() => $_has(5);
  @$pb.TagNumber(6)
  void clearItemName() => $_clearField(6);

  @$pb.TagNumber(8)
  $core.String get itemNo => $_getSZ(6);
  @$pb.TagNumber(8)
  set itemNo($core.String value) => $_setString(6, value);
  @$pb.TagNumber(8)
  $core.bool hasItemNo() => $_has(6);
  @$pb.TagNumber(8)
  void clearItemNo() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get operationNo => $_getSZ(7);
  @$pb.TagNumber(9)
  set operationNo($core.String value) => $_setString(7, value);
  @$pb.TagNumber(9)
  $core.bool hasOperationNo() => $_has(7);
  @$pb.TagNumber(9)
  void clearOperationNo() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get material => $_getSZ(8);
  @$pb.TagNumber(10)
  set material($core.String value) => $_setString(8, value);
  @$pb.TagNumber(10)
  $core.bool hasMaterial() => $_has(8);
  @$pb.TagNumber(10)
  void clearMaterial() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get outerDiameterMm => $_getN(9);
  @$pb.TagNumber(11)
  set outerDiameterMm($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(11)
  $core.bool hasOuterDiameterMm() => $_has(9);
  @$pb.TagNumber(11)
  void clearOuterDiameterMm() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get thicknessMm => $_getN(10);
  @$pb.TagNumber(12)
  set thicknessMm($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(12)
  $core.bool hasThicknessMm() => $_has(10);
  @$pb.TagNumber(12)
  void clearThicknessMm() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get workerId => $_getI64(11);
  @$pb.TagNumber(13)
  set workerId($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(13)
  $core.bool hasWorkerId() => $_has(11);
  @$pb.TagNumber(13)
  void clearWorkerId() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get startedAt => $_getN(12);
  @$pb.TagNumber(14)
  set startedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasStartedAt() => $_has(12);
  @$pb.TagNumber(14)
  void clearStartedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureStartedAt() => $_ensure(12);

  @$pb.TagNumber(15)
  $0.Timestamp get endedAt => $_getN(13);
  @$pb.TagNumber(15)
  set endedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasEndedAt() => $_has(13);
  @$pb.TagNumber(15)
  void clearEndedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureEndedAt() => $_ensure(13);

  /// 이음부 번호('DGT-ELA-01', 성적서 UT 표의 확인번호). 작업을 이음부(원주 이음 한 곳) 단위로 만든 경우에만 있다 —
  /// 비면 품목 전체 작업. 같은 common_key(품목) 아래에 이음부마다 작업이 하나씩 있다.
  @$pb.TagNumber(16)
  $core.String get jointNo => $_getSZ(14);
  @$pb.TagNumber(16)
  set jointNo($core.String value) => $_setString(14, value);
  @$pb.TagNumber(16)
  $core.bool hasJointNo() => $_has(14);
  @$pb.TagNumber(16)
  void clearJointNo() => $_clearField(16);

  /// 사람이 읽는 조합 키: JOB-{common_key}-[{이음부}-]{YYYYMMDD}_{hash4}. 공사·호기·품목·이음부가 바뀌면 다시 만들어진다 —
  /// 식별·저장에는 job_id를 쓰고, 이 값은 화면 표시와 외부 자료 대조에만 쓴다.
  @$pb.TagNumber(17)
  $core.String get jobKey => $_getSZ(15);
  @$pb.TagNumber(17)
  set jobKey($core.String value) => $_setString(15, value);
  @$pb.TagNumber(17)
  $core.bool hasJobKey() => $_has(15);
  @$pb.TagNumber(17)
  void clearJobKey() => $_clearField(17);

  /// 공사의 번호(project_no와 같은 공사). 만들거나 고칠 때 project_no 대신 이 값을 줘도 된다(둘 다 주면 이 값을 따른다).
  @$pb.TagNumber(18)
  $fixnum.Int64 get projectId => $_getI64(16);
  @$pb.TagNumber(18)
  set projectId($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(18)
  $core.bool hasProjectId() => $_has(16);
  @$pb.TagNumber(18)
  void clearProjectId() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get jobName => $_getSZ(17);
  @$pb.TagNumber(19)
  set jobName($core.String value) => $_setString(17, value);
  @$pb.TagNumber(19)
  $core.bool hasJobName() => $_has(17);
  @$pb.TagNumber(19)
  void clearJobName() => $_clearField(19);

  /// 배정된 품목(공사·호기·품목)의 번호. 읽기 전용 — 만들거나 고칠 때는 project·unit_no·item_code로 정하고, 그 배정이
  /// 없으면 서버가 만든다. 0이면 배정이 아직 안 붙은 작업.
  @$pb.TagNumber(20)
  $fixnum.Int64 get projectItemId => $_getI64(18);
  @$pb.TagNumber(20)
  set projectItemId($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(20)
  $core.bool hasProjectItemId() => $_has(18);
  @$pb.TagNumber(20)
  void clearProjectItemId() => $_clearField(20);
}

/// 공사·호기에 배정한 품목 한 줄. (project_id, unit_no, item_code)가 유일하다. 이름은 배정 줄마다 따로 둔다.
class ItemAssignment extends $pb.GeneratedMessage {
  factory ItemAssignment({
    $fixnum.Int64? projectItemId,
    $fixnum.Int64? projectId,
    $core.String? unitNo,
    $core.String? itemCode,
    $core.String? itemName,
  }) {
    final result = create();
    if (projectItemId != null) result.projectItemId = projectItemId;
    if (projectId != null) result.projectId = projectId;
    if (unitNo != null) result.unitNo = unitNo;
    if (itemCode != null) result.itemCode = itemCode;
    if (itemName != null) result.itemName = itemName;
    return result;
  }

  ItemAssignment._();

  factory ItemAssignment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ItemAssignment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemAssignment',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'projectItemId')
    ..aInt64(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'unitNo')
    ..aOS(4, _omitFieldNames ? '' : 'itemCode')
    ..aOS(5, _omitFieldNames ? '' : 'itemName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemAssignment clone() => ItemAssignment()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemAssignment copyWith(void Function(ItemAssignment) updates) =>
      super.copyWith((message) => updates(message as ItemAssignment))
          as ItemAssignment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ItemAssignment create() => ItemAssignment._();
  @$core.override
  ItemAssignment createEmptyInstance() => create();
  static $pb.PbList<ItemAssignment> createRepeated() =>
      $pb.PbList<ItemAssignment>();
  @$core.pragma('dart2js:noInline')
  static ItemAssignment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ItemAssignment>(create);
  static ItemAssignment? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get projectItemId => $_getI64(0);
  @$pb.TagNumber(1)
  set projectItemId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitNo => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitNo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasItemCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get itemName => $_getSZ(4);
  @$pb.TagNumber(5)
  set itemName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasItemName() => $_has(4);
  @$pb.TagNumber(5)
  void clearItemName() => $_clearField(5);
}

/// 품목 코드와 이름(ListItems). 같은 코드에 이름이 여러 개면 여러 줄로 나온다.
class Item extends $pb.GeneratedMessage {
  factory Item({
    $core.String? itemCode,
    $core.String? itemName,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (itemName != null) result.itemName = itemName;
    return result;
  }

  Item._();

  factory Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Item',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aOS(2, _omitFieldNames ? '' : 'itemName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item clone() => Item()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item copyWith(void Function(Item) updates) =>
      super.copyWith((message) => updates(message as Item)) as Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Item create() => Item._();
  @$core.override
  Item createEmptyInstance() => create();
  static $pb.PbList<Item> createRepeated() => $pb.PbList<Item>();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Item>(create);
  static Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemName => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemName() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemName() => $_clearField(2);
}

class CreateProjectItemsRequest extends $pb.GeneratedMessage {
  factory CreateProjectItemsRequest({
    $fixnum.Int64? projectId,
    $core.Iterable<ItemAssignment>? items,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    if (items != null) result.items.addAll(items);
    return result;
  }

  CreateProjectItemsRequest._();

  factory CreateProjectItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateProjectItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectItemsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'projectId')
    ..pc<ItemAssignment>(2, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: ItemAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectItemsRequest clone() =>
      CreateProjectItemsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectItemsRequest copyWith(
          void Function(CreateProjectItemsRequest) updates) =>
      super.copyWith((message) => updates(message as CreateProjectItemsRequest))
          as CreateProjectItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectItemsRequest create() => CreateProjectItemsRequest._();
  @$core.override
  CreateProjectItemsRequest createEmptyInstance() => create();
  static $pb.PbList<CreateProjectItemsRequest> createRepeated() =>
      $pb.PbList<CreateProjectItemsRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectItemsRequest>(create);
  static CreateProjectItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get projectId => $_getI64(0);
  @$pb.TagNumber(1)
  set projectId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ItemAssignment> get items => $_getList(1);
}

class CreateProjectItemsResponse extends $pb.GeneratedMessage {
  factory CreateProjectItemsResponse({
    $core.Iterable<ItemAssignment>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  CreateProjectItemsResponse._();

  factory CreateProjectItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateProjectItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectItemsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<ItemAssignment>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: ItemAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectItemsResponse clone() =>
      CreateProjectItemsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectItemsResponse copyWith(
          void Function(CreateProjectItemsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateProjectItemsResponse))
          as CreateProjectItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectItemsResponse create() => CreateProjectItemsResponse._();
  @$core.override
  CreateProjectItemsResponse createEmptyInstance() => create();
  static $pb.PbList<CreateProjectItemsResponse> createRepeated() =>
      $pb.PbList<CreateProjectItemsResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectItemsResponse>(create);
  static CreateProjectItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ItemAssignment> get items => $_getList(0);
}

class UpdateProjectItemRequest extends $pb.GeneratedMessage {
  factory UpdateProjectItemRequest({
    ItemAssignment? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  UpdateProjectItemRequest._();

  factory UpdateProjectItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProjectItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProjectItemRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<ItemAssignment>(1, _omitFieldNames ? '' : 'item',
        subBuilder: ItemAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectItemRequest clone() =>
      UpdateProjectItemRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectItemRequest copyWith(
          void Function(UpdateProjectItemRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateProjectItemRequest))
          as UpdateProjectItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectItemRequest create() => UpdateProjectItemRequest._();
  @$core.override
  UpdateProjectItemRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateProjectItemRequest> createRepeated() =>
      $pb.PbList<UpdateProjectItemRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProjectItemRequest>(create);
  static UpdateProjectItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ItemAssignment get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(ItemAssignment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  ItemAssignment ensureItem() => $_ensure(0);
}

class UpdateProjectItemResponse extends $pb.GeneratedMessage {
  factory UpdateProjectItemResponse({
    ItemAssignment? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  UpdateProjectItemResponse._();

  factory UpdateProjectItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProjectItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProjectItemResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<ItemAssignment>(1, _omitFieldNames ? '' : 'item',
        subBuilder: ItemAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectItemResponse clone() =>
      UpdateProjectItemResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectItemResponse copyWith(
          void Function(UpdateProjectItemResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateProjectItemResponse))
          as UpdateProjectItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectItemResponse create() => UpdateProjectItemResponse._();
  @$core.override
  UpdateProjectItemResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateProjectItemResponse> createRepeated() =>
      $pb.PbList<UpdateProjectItemResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProjectItemResponse>(create);
  static UpdateProjectItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ItemAssignment get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(ItemAssignment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  ItemAssignment ensureItem() => $_ensure(0);
}

class ListItemsRequest extends $pb.GeneratedMessage {
  factory ListItemsRequest({
    $fixnum.Int64? projectId,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    return result;
  }

  ListItemsRequest._();

  factory ListItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItemsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsRequest clone() => ListItemsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsRequest copyWith(void Function(ListItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListItemsRequest))
          as ListItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItemsRequest create() => ListItemsRequest._();
  @$core.override
  ListItemsRequest createEmptyInstance() => create();
  static $pb.PbList<ListItemsRequest> createRepeated() =>
      $pb.PbList<ListItemsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListItemsRequest>(create);
  static ListItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get projectId => $_getI64(0);
  @$pb.TagNumber(1)
  set projectId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListItemsResponse extends $pb.GeneratedMessage {
  factory ListItemsResponse({
    $core.Iterable<Item>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListItemsResponse._();

  factory ListItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItemsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<Item>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsResponse clone() => ListItemsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsResponse copyWith(void Function(ListItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListItemsResponse))
          as ListItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItemsResponse create() => ListItemsResponse._();
  @$core.override
  ListItemsResponse createEmptyInstance() => create();
  static $pb.PbList<ListItemsResponse> createRepeated() =>
      $pb.PbList<ListItemsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListItemsResponse>(create);
  static ListItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Item> get items => $_getList(0);
}

class Pass extends $pb.GeneratedMessage {
  factory Pass({
    $fixnum.Int64? passId,
    $fixnum.Int64? jobId,
    $core.int? passNo,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    if (jobId != null) result.jobId = jobId;
    if (passNo != null) result.passNo = passNo;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'passId')
    ..aInt64(2, _omitFieldNames ? '' : 'jobId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'passNo', $pb.PbFieldType.O3)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
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
  $fixnum.Int64 get passId => $_getI64(0);
  @$pb.TagNumber(1)
  set passId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get jobId => $_getI64(1);
  @$pb.TagNumber(2)
  set jobId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get passNo => $_getIZ(2);
  @$pb.TagNumber(3)
  set passNo($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get startedAt => $_getN(3);
  @$pb.TagNumber(4)
  set startedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStartedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureStartedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get endedAt => $_getN(4);
  @$pb.TagNumber(5)
  set endedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEndedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEndedAt() => $_ensure(4);
}

/// 목록 한 행. 이름·개수는 조인·집계한 표시용 값이다.
class JobSummary extends $pb.GeneratedMessage {
  factory JobSummary({
    Job? job,
    $core.String? workerName,
    $core.bool? isMaster,
    $core.Iterable<$core.String>? equipmentNames,
    $core.int? passCount,
    $core.int? attachmentCount,
    $core.bool? hasReport,
  }) {
    final result = create();
    if (job != null) result.job = job;
    if (workerName != null) result.workerName = workerName;
    if (isMaster != null) result.isMaster = isMaster;
    if (equipmentNames != null) result.equipmentNames.addAll(equipmentNames);
    if (passCount != null) result.passCount = passCount;
    if (attachmentCount != null) result.attachmentCount = attachmentCount;
    if (hasReport != null) result.hasReport = hasReport;
    return result;
  }

  JobSummary._();

  factory JobSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JobSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JobSummary',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..aOS(2, _omitFieldNames ? '' : 'workerName')
    ..aOB(3, _omitFieldNames ? '' : 'isMaster')
    ..pPS(4, _omitFieldNames ? '' : 'equipmentNames')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'passCount', $pb.PbFieldType.O3)
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'attachmentCount', $pb.PbFieldType.O3)
    ..aOB(7, _omitFieldNames ? '' : 'hasReport')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobSummary clone() => JobSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobSummary copyWith(void Function(JobSummary) updates) =>
      super.copyWith((message) => updates(message as JobSummary)) as JobSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobSummary create() => JobSummary._();
  @$core.override
  JobSummary createEmptyInstance() => create();
  static $pb.PbList<JobSummary> createRepeated() => $pb.PbList<JobSummary>();
  @$core.pragma('dart2js:noInline')
  static JobSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JobSummary>(create);
  static JobSummary? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set workerName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkerName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isMaster => $_getBF(2);
  @$pb.TagNumber(3)
  set isMaster($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsMaster() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsMaster() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get equipmentNames => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get passCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set passCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get attachmentCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set attachmentCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAttachmentCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttachmentCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get hasReport => $_getBF(6);
  @$pb.TagNumber(7)
  set hasReport($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHasReport() => $_has(6);
  @$pb.TagNumber(7)
  void clearHasReport() => $_clearField(7);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
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
    $core.Iterable<Project>? projects,
  }) {
    final result = create();
    if (projects != null) result.projects.addAll(projects);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<Project>(1, _omitFieldNames ? '' : 'projects', $pb.PbFieldType.PM,
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
  $pb.PbList<Project> get projects => $_getList(0);
}

class CreateProjectRequest extends $pb.GeneratedMessage {
  factory CreateProjectRequest({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  CreateProjectRequest._();

  factory CreateProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectRequest clone() =>
      CreateProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectRequest copyWith(void Function(CreateProjectRequest) updates) =>
      super.copyWith((message) => updates(message as CreateProjectRequest))
          as CreateProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest create() => CreateProjectRequest._();
  @$core.override
  CreateProjectRequest createEmptyInstance() => create();
  static $pb.PbList<CreateProjectRequest> createRepeated() =>
      $pb.PbList<CreateProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectRequest>(create);
  static CreateProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class CreateProjectResponse extends $pb.GeneratedMessage {
  factory CreateProjectResponse({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  CreateProjectResponse._();

  factory CreateProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectResponse clone() =>
      CreateProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectResponse copyWith(
          void Function(CreateProjectResponse) updates) =>
      super.copyWith((message) => updates(message as CreateProjectResponse))
          as CreateProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse create() => CreateProjectResponse._();
  @$core.override
  CreateProjectResponse createEmptyInstance() => create();
  static $pb.PbList<CreateProjectResponse> createRepeated() =>
      $pb.PbList<CreateProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectResponse>(create);
  static CreateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class CreateWorkerRequest extends $pb.GeneratedMessage {
  factory CreateWorkerRequest({
    Worker? worker,
  }) {
    final result = create();
    if (worker != null) result.worker = worker;
    return result;
  }

  CreateWorkerRequest._();

  factory CreateWorkerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateWorkerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWorkerRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Worker>(1, _omitFieldNames ? '' : 'worker', subBuilder: Worker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWorkerRequest clone() => CreateWorkerRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWorkerRequest copyWith(void Function(CreateWorkerRequest) updates) =>
      super.copyWith((message) => updates(message as CreateWorkerRequest))
          as CreateWorkerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateWorkerRequest create() => CreateWorkerRequest._();
  @$core.override
  CreateWorkerRequest createEmptyInstance() => create();
  static $pb.PbList<CreateWorkerRequest> createRepeated() =>
      $pb.PbList<CreateWorkerRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateWorkerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWorkerRequest>(create);
  static CreateWorkerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Worker get worker => $_getN(0);
  @$pb.TagNumber(1)
  set worker(Worker value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorker() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorker() => $_clearField(1);
  @$pb.TagNumber(1)
  Worker ensureWorker() => $_ensure(0);
}

class CreateWorkerResponse extends $pb.GeneratedMessage {
  factory CreateWorkerResponse({
    Worker? worker,
  }) {
    final result = create();
    if (worker != null) result.worker = worker;
    return result;
  }

  CreateWorkerResponse._();

  factory CreateWorkerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateWorkerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWorkerResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Worker>(1, _omitFieldNames ? '' : 'worker', subBuilder: Worker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWorkerResponse clone() =>
      CreateWorkerResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWorkerResponse copyWith(void Function(CreateWorkerResponse) updates) =>
      super.copyWith((message) => updates(message as CreateWorkerResponse))
          as CreateWorkerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateWorkerResponse create() => CreateWorkerResponse._();
  @$core.override
  CreateWorkerResponse createEmptyInstance() => create();
  static $pb.PbList<CreateWorkerResponse> createRepeated() =>
      $pb.PbList<CreateWorkerResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateWorkerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWorkerResponse>(create);
  static CreateWorkerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Worker get worker => $_getN(0);
  @$pb.TagNumber(1)
  set worker(Worker value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorker() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorker() => $_clearField(1);
  @$pb.TagNumber(1)
  Worker ensureWorker() => $_ensure(0);
}

class UpdateWorkerRequest extends $pb.GeneratedMessage {
  factory UpdateWorkerRequest({
    Worker? worker,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (worker != null) result.worker = worker;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateWorkerRequest._();

  factory UpdateWorkerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateWorkerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateWorkerRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Worker>(1, _omitFieldNames ? '' : 'worker', subBuilder: Worker.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkerRequest clone() => UpdateWorkerRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkerRequest copyWith(void Function(UpdateWorkerRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateWorkerRequest))
          as UpdateWorkerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateWorkerRequest create() => UpdateWorkerRequest._();
  @$core.override
  UpdateWorkerRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateWorkerRequest> createRepeated() =>
      $pb.PbList<UpdateWorkerRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateWorkerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateWorkerRequest>(create);
  static UpdateWorkerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Worker get worker => $_getN(0);
  @$pb.TagNumber(1)
  set worker(Worker value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorker() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorker() => $_clearField(1);
  @$pb.TagNumber(1)
  Worker ensureWorker() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateWorkerResponse extends $pb.GeneratedMessage {
  factory UpdateWorkerResponse({
    Worker? worker,
  }) {
    final result = create();
    if (worker != null) result.worker = worker;
    return result;
  }

  UpdateWorkerResponse._();

  factory UpdateWorkerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateWorkerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateWorkerResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Worker>(1, _omitFieldNames ? '' : 'worker', subBuilder: Worker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkerResponse clone() =>
      UpdateWorkerResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkerResponse copyWith(void Function(UpdateWorkerResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateWorkerResponse))
          as UpdateWorkerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateWorkerResponse create() => UpdateWorkerResponse._();
  @$core.override
  UpdateWorkerResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateWorkerResponse> createRepeated() =>
      $pb.PbList<UpdateWorkerResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateWorkerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateWorkerResponse>(create);
  static UpdateWorkerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Worker get worker => $_getN(0);
  @$pb.TagNumber(1)
  set worker(Worker value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorker() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorker() => $_clearField(1);
  @$pb.TagNumber(1)
  Worker ensureWorker() => $_ensure(0);
}

class DeleteWorkerRequest extends $pb.GeneratedMessage {
  factory DeleteWorkerRequest({
    $fixnum.Int64? workerId,
  }) {
    final result = create();
    if (workerId != null) result.workerId = workerId;
    return result;
  }

  DeleteWorkerRequest._();

  factory DeleteWorkerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteWorkerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteWorkerRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'workerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWorkerRequest clone() => DeleteWorkerRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWorkerRequest copyWith(void Function(DeleteWorkerRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteWorkerRequest))
          as DeleteWorkerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteWorkerRequest create() => DeleteWorkerRequest._();
  @$core.override
  DeleteWorkerRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteWorkerRequest> createRepeated() =>
      $pb.PbList<DeleteWorkerRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteWorkerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteWorkerRequest>(create);
  static DeleteWorkerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get workerId => $_getI64(0);
  @$pb.TagNumber(1)
  set workerId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkerId() => $_clearField(1);
}

class DeleteWorkerResponse extends $pb.GeneratedMessage {
  factory DeleteWorkerResponse() => create();

  DeleteWorkerResponse._();

  factory DeleteWorkerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteWorkerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteWorkerResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWorkerResponse clone() =>
      DeleteWorkerResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWorkerResponse copyWith(void Function(DeleteWorkerResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteWorkerResponse))
          as DeleteWorkerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteWorkerResponse create() => DeleteWorkerResponse._();
  @$core.override
  DeleteWorkerResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteWorkerResponse> createRepeated() =>
      $pb.PbList<DeleteWorkerResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteWorkerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteWorkerResponse>(create);
  static DeleteWorkerResponse? _defaultInstance;
}

class CreateEquipmentRequest extends $pb.GeneratedMessage {
  factory CreateEquipmentRequest({
    Equipment? equipment,
  }) {
    final result = create();
    if (equipment != null) result.equipment = equipment;
    return result;
  }

  CreateEquipmentRequest._();

  factory CreateEquipmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateEquipmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateEquipmentRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Equipment>(1, _omitFieldNames ? '' : 'equipment',
        subBuilder: Equipment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEquipmentRequest clone() =>
      CreateEquipmentRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEquipmentRequest copyWith(
          void Function(CreateEquipmentRequest) updates) =>
      super.copyWith((message) => updates(message as CreateEquipmentRequest))
          as CreateEquipmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateEquipmentRequest create() => CreateEquipmentRequest._();
  @$core.override
  CreateEquipmentRequest createEmptyInstance() => create();
  static $pb.PbList<CreateEquipmentRequest> createRepeated() =>
      $pb.PbList<CreateEquipmentRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateEquipmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateEquipmentRequest>(create);
  static CreateEquipmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Equipment get equipment => $_getN(0);
  @$pb.TagNumber(1)
  set equipment(Equipment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipment() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipment() => $_clearField(1);
  @$pb.TagNumber(1)
  Equipment ensureEquipment() => $_ensure(0);
}

class CreateEquipmentResponse extends $pb.GeneratedMessage {
  factory CreateEquipmentResponse({
    Equipment? equipment,
  }) {
    final result = create();
    if (equipment != null) result.equipment = equipment;
    return result;
  }

  CreateEquipmentResponse._();

  factory CreateEquipmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateEquipmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateEquipmentResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Equipment>(1, _omitFieldNames ? '' : 'equipment',
        subBuilder: Equipment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEquipmentResponse clone() =>
      CreateEquipmentResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEquipmentResponse copyWith(
          void Function(CreateEquipmentResponse) updates) =>
      super.copyWith((message) => updates(message as CreateEquipmentResponse))
          as CreateEquipmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateEquipmentResponse create() => CreateEquipmentResponse._();
  @$core.override
  CreateEquipmentResponse createEmptyInstance() => create();
  static $pb.PbList<CreateEquipmentResponse> createRepeated() =>
      $pb.PbList<CreateEquipmentResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateEquipmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateEquipmentResponse>(create);
  static CreateEquipmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Equipment get equipment => $_getN(0);
  @$pb.TagNumber(1)
  set equipment(Equipment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipment() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipment() => $_clearField(1);
  @$pb.TagNumber(1)
  Equipment ensureEquipment() => $_ensure(0);
}

class UpdateEquipmentRequest extends $pb.GeneratedMessage {
  factory UpdateEquipmentRequest({
    Equipment? equipment,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (equipment != null) result.equipment = equipment;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateEquipmentRequest._();

  factory UpdateEquipmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateEquipmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateEquipmentRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Equipment>(1, _omitFieldNames ? '' : 'equipment',
        subBuilder: Equipment.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEquipmentRequest clone() =>
      UpdateEquipmentRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEquipmentRequest copyWith(
          void Function(UpdateEquipmentRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateEquipmentRequest))
          as UpdateEquipmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateEquipmentRequest create() => UpdateEquipmentRequest._();
  @$core.override
  UpdateEquipmentRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateEquipmentRequest> createRepeated() =>
      $pb.PbList<UpdateEquipmentRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateEquipmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateEquipmentRequest>(create);
  static UpdateEquipmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Equipment get equipment => $_getN(0);
  @$pb.TagNumber(1)
  set equipment(Equipment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipment() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipment() => $_clearField(1);
  @$pb.TagNumber(1)
  Equipment ensureEquipment() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateEquipmentResponse extends $pb.GeneratedMessage {
  factory UpdateEquipmentResponse({
    Equipment? equipment,
  }) {
    final result = create();
    if (equipment != null) result.equipment = equipment;
    return result;
  }

  UpdateEquipmentResponse._();

  factory UpdateEquipmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateEquipmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateEquipmentResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Equipment>(1, _omitFieldNames ? '' : 'equipment',
        subBuilder: Equipment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEquipmentResponse clone() =>
      UpdateEquipmentResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEquipmentResponse copyWith(
          void Function(UpdateEquipmentResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateEquipmentResponse))
          as UpdateEquipmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateEquipmentResponse create() => UpdateEquipmentResponse._();
  @$core.override
  UpdateEquipmentResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateEquipmentResponse> createRepeated() =>
      $pb.PbList<UpdateEquipmentResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateEquipmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateEquipmentResponse>(create);
  static UpdateEquipmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Equipment get equipment => $_getN(0);
  @$pb.TagNumber(1)
  set equipment(Equipment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipment() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipment() => $_clearField(1);
  @$pb.TagNumber(1)
  Equipment ensureEquipment() => $_ensure(0);
}

class DeleteEquipmentRequest extends $pb.GeneratedMessage {
  factory DeleteEquipmentRequest({
    $fixnum.Int64? equipmentId,
  }) {
    final result = create();
    if (equipmentId != null) result.equipmentId = equipmentId;
    return result;
  }

  DeleteEquipmentRequest._();

  factory DeleteEquipmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteEquipmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteEquipmentRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'equipmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEquipmentRequest clone() =>
      DeleteEquipmentRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEquipmentRequest copyWith(
          void Function(DeleteEquipmentRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteEquipmentRequest))
          as DeleteEquipmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteEquipmentRequest create() => DeleteEquipmentRequest._();
  @$core.override
  DeleteEquipmentRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteEquipmentRequest> createRepeated() =>
      $pb.PbList<DeleteEquipmentRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteEquipmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteEquipmentRequest>(create);
  static DeleteEquipmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get equipmentId => $_getI64(0);
  @$pb.TagNumber(1)
  set equipmentId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEquipmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEquipmentId() => $_clearField(1);
}

class DeleteEquipmentResponse extends $pb.GeneratedMessage {
  factory DeleteEquipmentResponse() => create();

  DeleteEquipmentResponse._();

  factory DeleteEquipmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteEquipmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteEquipmentResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEquipmentResponse clone() =>
      DeleteEquipmentResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEquipmentResponse copyWith(
          void Function(DeleteEquipmentResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteEquipmentResponse))
          as DeleteEquipmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteEquipmentResponse create() => DeleteEquipmentResponse._();
  @$core.override
  DeleteEquipmentResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteEquipmentResponse> createRepeated() =>
      $pb.PbList<DeleteEquipmentResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteEquipmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteEquipmentResponse>(create);
  static DeleteEquipmentResponse? _defaultInstance;
}

class UpdateProjectRequest extends $pb.GeneratedMessage {
  factory UpdateProjectRequest({
    Project? project,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateProjectRequest._();

  factory UpdateProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProjectRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectRequest clone() =>
      UpdateProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectRequest copyWith(void Function(UpdateProjectRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateProjectRequest))
          as UpdateProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectRequest create() => UpdateProjectRequest._();
  @$core.override
  UpdateProjectRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateProjectRequest> createRepeated() =>
      $pb.PbList<UpdateProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProjectRequest>(create);
  static UpdateProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateProjectResponse extends $pb.GeneratedMessage {
  factory UpdateProjectResponse({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  UpdateProjectResponse._();

  factory UpdateProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProjectResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectResponse clone() =>
      UpdateProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectResponse copyWith(
          void Function(UpdateProjectResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateProjectResponse))
          as UpdateProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectResponse create() => UpdateProjectResponse._();
  @$core.override
  UpdateProjectResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateProjectResponse> createRepeated() =>
      $pb.PbList<UpdateProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProjectResponse>(create);
  static UpdateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class DeleteProjectRequest extends $pb.GeneratedMessage {
  factory DeleteProjectRequest({
    $core.String? projectNo,
    $fixnum.Int64? projectId,
  }) {
    final result = create();
    if (projectNo != null) result.projectNo = projectNo;
    if (projectId != null) result.projectId = projectId;
    return result;
  }

  DeleteProjectRequest._();

  factory DeleteProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProjectRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectNo')
    ..aInt64(2, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectRequest clone() =>
      DeleteProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectRequest copyWith(void Function(DeleteProjectRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteProjectRequest))
          as DeleteProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest create() => DeleteProjectRequest._();
  @$core.override
  DeleteProjectRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteProjectRequest> createRepeated() =>
      $pb.PbList<DeleteProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProjectRequest>(create);
  static DeleteProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectNo() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);
}

class DeleteProjectResponse extends $pb.GeneratedMessage {
  factory DeleteProjectResponse() => create();

  DeleteProjectResponse._();

  factory DeleteProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProjectResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectResponse clone() =>
      DeleteProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectResponse copyWith(
          void Function(DeleteProjectResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteProjectResponse))
          as DeleteProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse create() => DeleteProjectResponse._();
  @$core.override
  DeleteProjectResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteProjectResponse> createRepeated() =>
      $pb.PbList<DeleteProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProjectResponse>(create);
  static DeleteProjectResponse? _defaultInstance;
}

class CreateJobRequest extends $pb.GeneratedMessage {
  factory CreateJobRequest({
    Job? job,
    $core.Iterable<Pass>? passes,
  }) {
    final result = create();
    if (job != null) result.job = job;
    if (passes != null) result.passes.addAll(passes);
    return result;
  }

  CreateJobRequest._();

  factory CreateJobRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateJobRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateJobRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..pc<Pass>(2, _omitFieldNames ? '' : 'passes', $pb.PbFieldType.PM,
        subBuilder: Pass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateJobRequest clone() => CreateJobRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateJobRequest copyWith(void Function(CreateJobRequest) updates) =>
      super.copyWith((message) => updates(message as CreateJobRequest))
          as CreateJobRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateJobRequest create() => CreateJobRequest._();
  @$core.override
  CreateJobRequest createEmptyInstance() => create();
  static $pb.PbList<CreateJobRequest> createRepeated() =>
      $pb.PbList<CreateJobRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateJobRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateJobRequest>(create);
  static CreateJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);

  /// 선택. 함께 만들 패스 — pass_no(1 이상, 서로 달라야 한다)만 필수이고 시각은 비워도 된다. pass_id·job_id는 무시한다.
  @$pb.TagNumber(2)
  $pb.PbList<Pass> get passes => $_getList(1);
}

class CreateJobResponse extends $pb.GeneratedMessage {
  factory CreateJobResponse({
    Job? job,
    $core.Iterable<Pass>? passes,
  }) {
    final result = create();
    if (job != null) result.job = job;
    if (passes != null) result.passes.addAll(passes);
    return result;
  }

  CreateJobResponse._();

  factory CreateJobResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateJobResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateJobResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..pc<Pass>(2, _omitFieldNames ? '' : 'passes', $pb.PbFieldType.PM,
        subBuilder: Pass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateJobResponse clone() => CreateJobResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateJobResponse copyWith(void Function(CreateJobResponse) updates) =>
      super.copyWith((message) => updates(message as CreateJobResponse))
          as CreateJobResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateJobResponse create() => CreateJobResponse._();
  @$core.override
  CreateJobResponse createEmptyInstance() => create();
  static $pb.PbList<CreateJobResponse> createRepeated() =>
      $pb.PbList<CreateJobResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateJobResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateJobResponse>(create);
  static CreateJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Pass> get passes => $_getList(1);
}

class UpdateJobRequest extends $pb.GeneratedMessage {
  factory UpdateJobRequest({
    Job? job,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (job != null) result.job = job;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateJobRequest._();

  factory UpdateJobRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateJobRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateJobRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateJobRequest clone() => UpdateJobRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateJobRequest copyWith(void Function(UpdateJobRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateJobRequest))
          as UpdateJobRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateJobRequest create() => UpdateJobRequest._();
  @$core.override
  UpdateJobRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateJobRequest> createRepeated() =>
      $pb.PbList<UpdateJobRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateJobRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateJobRequest>(create);
  static UpdateJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);

  /// project_no(또는 project_id), unit_no, item_code, job_name, item_no, joint_no, operation_no, material,
  /// outer_diameter_mm, thickness_mm, worker_id, started_at, ended_at
  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateJobResponse extends $pb.GeneratedMessage {
  factory UpdateJobResponse({
    Job? job,
  }) {
    final result = create();
    if (job != null) result.job = job;
    return result;
  }

  UpdateJobResponse._();

  factory UpdateJobResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateJobResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateJobResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateJobResponse clone() => UpdateJobResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateJobResponse copyWith(void Function(UpdateJobResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateJobResponse))
          as UpdateJobResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateJobResponse create() => UpdateJobResponse._();
  @$core.override
  UpdateJobResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateJobResponse> createRepeated() =>
      $pb.PbList<UpdateJobResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateJobResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateJobResponse>(create);
  static UpdateJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);
}

class DeleteJobRequest extends $pb.GeneratedMessage {
  factory DeleteJobRequest({
    $fixnum.Int64? jobId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  DeleteJobRequest._();

  factory DeleteJobRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteJobRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteJobRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteJobRequest clone() => DeleteJobRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteJobRequest copyWith(void Function(DeleteJobRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteJobRequest))
          as DeleteJobRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteJobRequest create() => DeleteJobRequest._();
  @$core.override
  DeleteJobRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteJobRequest> createRepeated() =>
      $pb.PbList<DeleteJobRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteJobRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteJobRequest>(create);
  static DeleteJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobId => $_getI64(0);
  @$pb.TagNumber(1)
  set jobId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

class DeleteJobResponse extends $pb.GeneratedMessage {
  factory DeleteJobResponse() => create();

  DeleteJobResponse._();

  factory DeleteJobResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteJobResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteJobResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteJobResponse clone() => DeleteJobResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteJobResponse copyWith(void Function(DeleteJobResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteJobResponse))
          as DeleteJobResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteJobResponse create() => DeleteJobResponse._();
  @$core.override
  DeleteJobResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteJobResponse> createRepeated() =>
      $pb.PbList<DeleteJobResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteJobResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteJobResponse>(create);
  static DeleteJobResponse? _defaultInstance;
}

class CreatePassRequest extends $pb.GeneratedMessage {
  factory CreatePassRequest({
    Pass? pass,
  }) {
    final result = create();
    if (pass != null) result.pass = pass;
    return result;
  }

  CreatePassRequest._();

  factory CreatePassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePassRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Pass>(1, _omitFieldNames ? '' : 'pass', subBuilder: Pass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePassRequest clone() => CreatePassRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePassRequest copyWith(void Function(CreatePassRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePassRequest))
          as CreatePassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePassRequest create() => CreatePassRequest._();
  @$core.override
  CreatePassRequest createEmptyInstance() => create();
  static $pb.PbList<CreatePassRequest> createRepeated() =>
      $pb.PbList<CreatePassRequest>();
  @$core.pragma('dart2js:noInline')
  static CreatePassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePassRequest>(create);
  static CreatePassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Pass get pass => $_getN(0);
  @$pb.TagNumber(1)
  set pass(Pass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPass() => $_has(0);
  @$pb.TagNumber(1)
  void clearPass() => $_clearField(1);
  @$pb.TagNumber(1)
  Pass ensurePass() => $_ensure(0);
}

class CreatePassResponse extends $pb.GeneratedMessage {
  factory CreatePassResponse({
    Pass? pass,
  }) {
    final result = create();
    if (pass != null) result.pass = pass;
    return result;
  }

  CreatePassResponse._();

  factory CreatePassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePassResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Pass>(1, _omitFieldNames ? '' : 'pass', subBuilder: Pass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePassResponse clone() => CreatePassResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePassResponse copyWith(void Function(CreatePassResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePassResponse))
          as CreatePassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePassResponse create() => CreatePassResponse._();
  @$core.override
  CreatePassResponse createEmptyInstance() => create();
  static $pb.PbList<CreatePassResponse> createRepeated() =>
      $pb.PbList<CreatePassResponse>();
  @$core.pragma('dart2js:noInline')
  static CreatePassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePassResponse>(create);
  static CreatePassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pass get pass => $_getN(0);
  @$pb.TagNumber(1)
  set pass(Pass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPass() => $_has(0);
  @$pb.TagNumber(1)
  void clearPass() => $_clearField(1);
  @$pb.TagNumber(1)
  Pass ensurePass() => $_ensure(0);
}

class UpdatePassRequest extends $pb.GeneratedMessage {
  factory UpdatePassRequest({
    Pass? pass,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (pass != null) result.pass = pass;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdatePassRequest._();

  factory UpdatePassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePassRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Pass>(1, _omitFieldNames ? '' : 'pass', subBuilder: Pass.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePassRequest clone() => UpdatePassRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePassRequest copyWith(void Function(UpdatePassRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePassRequest))
          as UpdatePassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePassRequest create() => UpdatePassRequest._();
  @$core.override
  UpdatePassRequest createEmptyInstance() => create();
  static $pb.PbList<UpdatePassRequest> createRepeated() =>
      $pb.PbList<UpdatePassRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdatePassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePassRequest>(create);
  static UpdatePassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Pass get pass => $_getN(0);
  @$pb.TagNumber(1)
  set pass(Pass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPass() => $_has(0);
  @$pb.TagNumber(1)
  void clearPass() => $_clearField(1);
  @$pb.TagNumber(1)
  Pass ensurePass() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdatePassResponse extends $pb.GeneratedMessage {
  factory UpdatePassResponse({
    Pass? pass,
  }) {
    final result = create();
    if (pass != null) result.pass = pass;
    return result;
  }

  UpdatePassResponse._();

  factory UpdatePassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePassResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Pass>(1, _omitFieldNames ? '' : 'pass', subBuilder: Pass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePassResponse clone() => UpdatePassResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePassResponse copyWith(void Function(UpdatePassResponse) updates) =>
      super.copyWith((message) => updates(message as UpdatePassResponse))
          as UpdatePassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePassResponse create() => UpdatePassResponse._();
  @$core.override
  UpdatePassResponse createEmptyInstance() => create();
  static $pb.PbList<UpdatePassResponse> createRepeated() =>
      $pb.PbList<UpdatePassResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdatePassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePassResponse>(create);
  static UpdatePassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pass get pass => $_getN(0);
  @$pb.TagNumber(1)
  set pass(Pass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPass() => $_has(0);
  @$pb.TagNumber(1)
  void clearPass() => $_clearField(1);
  @$pb.TagNumber(1)
  Pass ensurePass() => $_ensure(0);
}

class DeletePassRequest extends $pb.GeneratedMessage {
  factory DeletePassRequest({
    $fixnum.Int64? passId,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    return result;
  }

  DeletePassRequest._();

  factory DeletePassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePassRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePassRequest clone() => DeletePassRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePassRequest copyWith(void Function(DeletePassRequest) updates) =>
      super.copyWith((message) => updates(message as DeletePassRequest))
          as DeletePassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePassRequest create() => DeletePassRequest._();
  @$core.override
  DeletePassRequest createEmptyInstance() => create();
  static $pb.PbList<DeletePassRequest> createRepeated() =>
      $pb.PbList<DeletePassRequest>();
  @$core.pragma('dart2js:noInline')
  static DeletePassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePassRequest>(create);
  static DeletePassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get passId => $_getI64(0);
  @$pb.TagNumber(1)
  set passId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);
}

class DeletePassResponse extends $pb.GeneratedMessage {
  factory DeletePassResponse() => create();

  DeletePassResponse._();

  factory DeletePassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePassResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePassResponse clone() => DeletePassResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePassResponse copyWith(void Function(DeletePassResponse) updates) =>
      super.copyWith((message) => updates(message as DeletePassResponse))
          as DeletePassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePassResponse create() => DeletePassResponse._();
  @$core.override
  DeletePassResponse createEmptyInstance() => create();
  static $pb.PbList<DeletePassResponse> createRepeated() =>
      $pb.PbList<DeletePassResponse>();
  @$core.pragma('dart2js:noInline')
  static DeletePassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePassResponse>(create);
  static DeletePassResponse? _defaultInstance;
}

class ListJobFiltersRequest extends $pb.GeneratedMessage {
  factory ListJobFiltersRequest() => create();

  ListJobFiltersRequest._();

  factory ListJobFiltersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJobFiltersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobFiltersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobFiltersRequest clone() =>
      ListJobFiltersRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobFiltersRequest copyWith(
          void Function(ListJobFiltersRequest) updates) =>
      super.copyWith((message) => updates(message as ListJobFiltersRequest))
          as ListJobFiltersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobFiltersRequest create() => ListJobFiltersRequest._();
  @$core.override
  ListJobFiltersRequest createEmptyInstance() => create();
  static $pb.PbList<ListJobFiltersRequest> createRepeated() =>
      $pb.PbList<ListJobFiltersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListJobFiltersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJobFiltersRequest>(create);
  static ListJobFiltersRequest? _defaultInstance;
}

/// 드롭다운 값. 고른 값은 ListJobs의 project_no·unit_no·item_code·worker_id·equipment_id에 넣는다.
class ListJobFiltersResponse extends $pb.GeneratedMessage {
  factory ListJobFiltersResponse({
    $core.Iterable<ProjectFilter>? projects,
    $core.Iterable<Worker>? workers,
    $core.Iterable<Equipment>? equipment,
  }) {
    final result = create();
    if (projects != null) result.projects.addAll(projects);
    if (workers != null) result.workers.addAll(workers);
    if (equipment != null) result.equipment.addAll(equipment);
    return result;
  }

  ListJobFiltersResponse._();

  factory ListJobFiltersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJobFiltersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobFiltersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<ProjectFilter>(
        1, _omitFieldNames ? '' : 'projects', $pb.PbFieldType.PM,
        subBuilder: ProjectFilter.create)
    ..pc<Worker>(2, _omitFieldNames ? '' : 'workers', $pb.PbFieldType.PM,
        subBuilder: Worker.create)
    ..pc<Equipment>(3, _omitFieldNames ? '' : 'equipment', $pb.PbFieldType.PM,
        subBuilder: Equipment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobFiltersResponse clone() =>
      ListJobFiltersResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobFiltersResponse copyWith(
          void Function(ListJobFiltersResponse) updates) =>
      super.copyWith((message) => updates(message as ListJobFiltersResponse))
          as ListJobFiltersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobFiltersResponse create() => ListJobFiltersResponse._();
  @$core.override
  ListJobFiltersResponse createEmptyInstance() => create();
  static $pb.PbList<ListJobFiltersResponse> createRepeated() =>
      $pb.PbList<ListJobFiltersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListJobFiltersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJobFiltersResponse>(create);
  static ListJobFiltersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProjectFilter> get projects => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Worker> get workers => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Equipment> get equipment => $_getList(2);
}

/// 공사 하나와 그 공사에 배정된 호기·품목(tacit.project_item). 작업이 없는 호기·품목도 나온다.
class ProjectFilter extends $pb.GeneratedMessage {
  factory ProjectFilter({
    Project? project,
    $core.Iterable<ProjectUnit>? units,
  }) {
    final result = create();
    if (project != null) result.project = project;
    if (units != null) result.units.addAll(units);
    return result;
  }

  ProjectFilter._();

  factory ProjectFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProjectFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProjectFilter',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..pc<ProjectUnit>(2, _omitFieldNames ? '' : 'units', $pb.PbFieldType.PM,
        subBuilder: ProjectUnit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectFilter clone() => ProjectFilter()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectFilter copyWith(void Function(ProjectFilter) updates) =>
      super.copyWith((message) => updates(message as ProjectFilter))
          as ProjectFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectFilter create() => ProjectFilter._();
  @$core.override
  ProjectFilter createEmptyInstance() => create();
  static $pb.PbList<ProjectFilter> createRepeated() =>
      $pb.PbList<ProjectFilter>();
  @$core.pragma('dart2js:noInline')
  static ProjectFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProjectFilter>(create);
  static ProjectFilter? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ProjectUnit> get units => $_getList(1);
}

/// 품목은 호기 아래에 묶는다 — 호기마다 품목이 다르다(TP129 1호기엔 LD-D가 없음).
class ProjectUnit extends $pb.GeneratedMessage {
  factory ProjectUnit({
    $core.String? unitNo,
    $core.Iterable<$core.String>? itemCodes,
    $core.Iterable<ProjectItem>? items,
  }) {
    final result = create();
    if (unitNo != null) result.unitNo = unitNo;
    if (itemCodes != null) result.itemCodes.addAll(itemCodes);
    if (items != null) result.items.addAll(items);
    return result;
  }

  ProjectUnit._();

  factory ProjectUnit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProjectUnit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProjectUnit',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitNo')
    ..pPS(2, _omitFieldNames ? '' : 'itemCodes')
    ..pc<ProjectItem>(3, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: ProjectItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectUnit clone() => ProjectUnit()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectUnit copyWith(void Function(ProjectUnit) updates) =>
      super.copyWith((message) => updates(message as ProjectUnit))
          as ProjectUnit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectUnit create() => ProjectUnit._();
  @$core.override
  ProjectUnit createEmptyInstance() => create();
  static $pb.PbList<ProjectUnit> createRepeated() => $pb.PbList<ProjectUnit>();
  @$core.pragma('dart2js:noInline')
  static ProjectUnit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProjectUnit>(create);
  static ProjectUnit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitNo() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get itemCodes => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ProjectItem> get items => $_getList(2);
}

/// 배정된 품목 하나와 그 품목 작업의 이음부. 작업이 없거나 이음부 단위 작업이 없는 품목은 joint_nos가 비어 있다.
class ProjectItem extends $pb.GeneratedMessage {
  factory ProjectItem({
    $core.String? itemCode,
    $core.Iterable<$core.String>? jointNos,
    $core.Iterable<ProjectJoint>? joints,
    $core.String? itemName,
    $fixnum.Int64? projectItemId,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (jointNos != null) result.jointNos.addAll(jointNos);
    if (joints != null) result.joints.addAll(joints);
    if (itemName != null) result.itemName = itemName;
    if (projectItemId != null) result.projectItemId = projectItemId;
    return result;
  }

  ProjectItem._();

  factory ProjectItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProjectItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProjectItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..pPS(2, _omitFieldNames ? '' : 'jointNos')
    ..pc<ProjectJoint>(3, _omitFieldNames ? '' : 'joints', $pb.PbFieldType.PM,
        subBuilder: ProjectJoint.create)
    ..aOS(4, _omitFieldNames ? '' : 'itemName')
    ..aInt64(5, _omitFieldNames ? '' : 'projectItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectItem clone() => ProjectItem()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectItem copyWith(void Function(ProjectItem) updates) =>
      super.copyWith((message) => updates(message as ProjectItem))
          as ProjectItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectItem create() => ProjectItem._();
  @$core.override
  ProjectItem createEmptyInstance() => create();
  static $pb.PbList<ProjectItem> createRepeated() => $pb.PbList<ProjectItem>();
  @$core.pragma('dart2js:noInline')
  static ProjectItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProjectItem>(create);
  static ProjectItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get jointNos => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ProjectJoint> get joints => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get itemName => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasItemName() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemName() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get projectItemId => $_getI64(4);
  @$pb.TagNumber(5)
  set projectItemId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProjectItemId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProjectItemId() => $_clearField(5);
}

/// 이음부 하나와 그 이음부 작업들에 있는 패스 번호. 패스가 없는 작업(성적서에서 만든 TP129 등)은 pass_nos가 비어 있다.
class ProjectJoint extends $pb.GeneratedMessage {
  factory ProjectJoint({
    $core.String? jointNo,
    $core.Iterable<$core.int>? passNos,
  }) {
    final result = create();
    if (jointNo != null) result.jointNo = jointNo;
    if (passNos != null) result.passNos.addAll(passNos);
    return result;
  }

  ProjectJoint._();

  factory ProjectJoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProjectJoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProjectJoint',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jointNo')
    ..p<$core.int>(2, _omitFieldNames ? '' : 'passNos', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectJoint clone() => ProjectJoint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectJoint copyWith(void Function(ProjectJoint) updates) =>
      super.copyWith((message) => updates(message as ProjectJoint))
          as ProjectJoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectJoint create() => ProjectJoint._();
  @$core.override
  ProjectJoint createEmptyInstance() => create();
  static $pb.PbList<ProjectJoint> createRepeated() =>
      $pb.PbList<ProjectJoint>();
  @$core.pragma('dart2js:noInline')
  static ProjectJoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProjectJoint>(create);
  static ProjectJoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jointNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set jointNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJointNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearJointNo() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get passNos => $_getList(1);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
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
    $core.Iterable<Worker>? workers,
  }) {
    final result = create();
    if (workers != null) result.workers.addAll(workers);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<Worker>(1, _omitFieldNames ? '' : 'workers', $pb.PbFieldType.PM,
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
  $pb.PbList<Worker> get workers => $_getList(0);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
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
    $core.Iterable<Equipment>? equipment,
  }) {
    final result = create();
    if (equipment != null) result.equipment.addAll(equipment);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<Equipment>(1, _omitFieldNames ? '' : 'equipment', $pb.PbFieldType.PM,
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
  $pb.PbList<Equipment> get equipment => $_getList(0);
}

/// 필터는 모두 선택이고 AND로 묶인다. 정렬은 started_at 내림차순, 같으면 job_id 내림차순.
class ListJobsRequest extends $pb.GeneratedMessage {
  factory ListJobsRequest({
    $core.String? projectNo,
    $core.String? commonKey,
    $core.String? itemCode,
    $fixnum.Int64? workerId,
    $core.bool? masterOnly,
    $fixnum.Int64? equipmentId,
    $0.Timestamp? startedFrom,
    $0.Timestamp? startedTo,
    $core.int? pageSize,
    $core.String? pageToken,
    $core.String? unitNo,
    $core.String? jointNo,
    $core.int? passNo,
    $fixnum.Int64? projectId,
  }) {
    final result = create();
    if (projectNo != null) result.projectNo = projectNo;
    if (commonKey != null) result.commonKey = commonKey;
    if (itemCode != null) result.itemCode = itemCode;
    if (workerId != null) result.workerId = workerId;
    if (masterOnly != null) result.masterOnly = masterOnly;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (startedFrom != null) result.startedFrom = startedFrom;
    if (startedTo != null) result.startedTo = startedTo;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (unitNo != null) result.unitNo = unitNo;
    if (jointNo != null) result.jointNo = jointNo;
    if (passNo != null) result.passNo = passNo;
    if (projectId != null) result.projectId = projectId;
    return result;
  }

  ListJobsRequest._();

  factory ListJobsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJobsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectNo')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aOS(3, _omitFieldNames ? '' : 'itemCode')
    ..aInt64(4, _omitFieldNames ? '' : 'workerId')
    ..aOB(5, _omitFieldNames ? '' : 'masterOnly')
    ..aInt64(6, _omitFieldNames ? '' : 'equipmentId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startedTo',
        subBuilder: $0.Timestamp.create)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(10, _omitFieldNames ? '' : 'pageToken')
    ..aOS(11, _omitFieldNames ? '' : 'unitNo')
    ..aOS(12, _omitFieldNames ? '' : 'jointNo')
    ..a<$core.int>(13, _omitFieldNames ? '' : 'passNo', $pb.PbFieldType.O3)
    ..aInt64(14, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsRequest clone() => ListJobsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsRequest copyWith(void Function(ListJobsRequest) updates) =>
      super.copyWith((message) => updates(message as ListJobsRequest))
          as ListJobsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobsRequest create() => ListJobsRequest._();
  @$core.override
  ListJobsRequest createEmptyInstance() => create();
  static $pb.PbList<ListJobsRequest> createRepeated() =>
      $pb.PbList<ListJobsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListJobsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJobsRequest>(create);
  static ListJobsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectNo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get workerId => $_getI64(3);
  @$pb.TagNumber(4)
  set workerId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get masterOnly => $_getBF(4);
  @$pb.TagNumber(5)
  set masterOnly($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMasterOnly() => $_has(4);
  @$pb.TagNumber(5)
  void clearMasterOnly() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get equipmentId => $_getI64(5);
  @$pb.TagNumber(6)
  set equipmentId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEquipmentId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEquipmentId() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get startedFrom => $_getN(6);
  @$pb.TagNumber(7)
  set startedFrom($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStartedFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureStartedFrom() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get startedTo => $_getN(7);
  @$pb.TagNumber(8)
  set startedTo($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartedTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartedTo() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartedTo() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get pageSize => $_getIZ(8);
  @$pb.TagNumber(9)
  set pageSize($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPageSize() => $_has(8);
  @$pb.TagNumber(9)
  void clearPageSize() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get pageToken => $_getSZ(9);
  @$pb.TagNumber(10)
  set pageToken($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPageToken() => $_has(9);
  @$pb.TagNumber(10)
  void clearPageToken() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get unitNo => $_getSZ(10);
  @$pb.TagNumber(11)
  set unitNo($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUnitNo() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnitNo() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get jointNo => $_getSZ(11);
  @$pb.TagNumber(12)
  set jointNo($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasJointNo() => $_has(11);
  @$pb.TagNumber(12)
  void clearJointNo() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get passNo => $_getIZ(12);
  @$pb.TagNumber(13)
  set passNo($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPassNo() => $_has(12);
  @$pb.TagNumber(13)
  void clearPassNo() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get projectId => $_getI64(13);
  @$pb.TagNumber(14)
  set projectId($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasProjectId() => $_has(13);
  @$pb.TagNumber(14)
  void clearProjectId() => $_clearField(14);
}

class ListJobsResponse extends $pb.GeneratedMessage {
  factory ListJobsResponse({
    $core.Iterable<JobSummary>? jobs,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = create();
    if (jobs != null) result.jobs.addAll(jobs);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ListJobsResponse._();

  factory ListJobsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJobsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<JobSummary>(1, _omitFieldNames ? '' : 'jobs', $pb.PbFieldType.PM,
        subBuilder: JobSummary.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsResponse clone() => ListJobsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsResponse copyWith(void Function(ListJobsResponse) updates) =>
      super.copyWith((message) => updates(message as ListJobsResponse))
          as ListJobsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobsResponse create() => ListJobsResponse._();
  @$core.override
  ListJobsResponse createEmptyInstance() => create();
  static $pb.PbList<ListJobsResponse> createRepeated() =>
      $pb.PbList<ListJobsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListJobsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJobsResponse>(create);
  static ListJobsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<JobSummary> get jobs => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class GetJobRequest extends $pb.GeneratedMessage {
  factory GetJobRequest({
    $fixnum.Int64? jobId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  GetJobRequest._();

  factory GetJobRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetJobRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetJobRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobRequest clone() => GetJobRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobRequest copyWith(void Function(GetJobRequest) updates) =>
      super.copyWith((message) => updates(message as GetJobRequest))
          as GetJobRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobRequest create() => GetJobRequest._();
  @$core.override
  GetJobRequest createEmptyInstance() => create();
  static $pb.PbList<GetJobRequest> createRepeated() =>
      $pb.PbList<GetJobRequest>();
  @$core.pragma('dart2js:noInline')
  static GetJobRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetJobRequest>(create);
  static GetJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobId => $_getI64(0);
  @$pb.TagNumber(1)
  set jobId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

class GetJobResponse extends $pb.GeneratedMessage {
  factory GetJobResponse({
    Job? job,
    $core.Iterable<Pass>? passes,
    Worker? worker,
    $core.Iterable<Equipment>? equipment,
  }) {
    final result = create();
    if (job != null) result.job = job;
    if (passes != null) result.passes.addAll(passes);
    if (worker != null) result.worker = worker;
    if (equipment != null) result.equipment.addAll(equipment);
    return result;
  }

  GetJobResponse._();

  factory GetJobResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetJobResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetJobResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..pc<Pass>(2, _omitFieldNames ? '' : 'passes', $pb.PbFieldType.PM,
        subBuilder: Pass.create)
    ..aOM<Worker>(3, _omitFieldNames ? '' : 'worker', subBuilder: Worker.create)
    ..pc<Equipment>(4, _omitFieldNames ? '' : 'equipment', $pb.PbFieldType.PM,
        subBuilder: Equipment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobResponse clone() => GetJobResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJobResponse copyWith(void Function(GetJobResponse) updates) =>
      super.copyWith((message) => updates(message as GetJobResponse))
          as GetJobResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobResponse create() => GetJobResponse._();
  @$core.override
  GetJobResponse createEmptyInstance() => create();
  static $pb.PbList<GetJobResponse> createRepeated() =>
      $pb.PbList<GetJobResponse>();
  @$core.pragma('dart2js:noInline')
  static GetJobResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetJobResponse>(create);
  static GetJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Pass> get passes => $_getList(1);

  @$pb.TagNumber(3)
  Worker get worker => $_getN(2);
  @$pb.TagNumber(3)
  set worker(Worker value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWorker() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorker() => $_clearField(3);
  @$pb.TagNumber(3)
  Worker ensureWorker() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<Equipment> get equipment => $_getList(3);
}

/// 노드의 위치. 클라이언트는 받은 값을 그대로 parent로 돌려보낸다.
/// level 단계의 ID가 비어 있으면 그 단계가 "미지정" 노드다(Pass 단계면 "작업 공용").
///   - 장비 미지정: equipment_id 없는 Asset
///   - 공사 미지정: project_no 없는 Job, 또는 (장비별) 작업에 첨부 안 된 Asset
///   - 품목 미지정: common_key 없는 Job, 또는 (장비별) 작업에 첨부 안 된 Asset
///   - 작업 미지정: (장비별) 작업에 첨부 안 된 Asset. 자식은 Pass 없이 바로 Asset
///   - 작업 공용:   job_asset.pass_id가 빈 첨부
/// 작업자별 보기에는 작업에 첨부 안 된 Asset이 나오지 않는다(작업자는 작업을 거쳐 안다).
class CollectionPath extends $pb.GeneratedMessage {
  factory CollectionPath({
    CollectionView? view,
    CollectionLevel? level,
    $fixnum.Int64? equipmentId,
    $fixnum.Int64? workerId,
    $core.String? projectNo,
    $fixnum.Int64? jobId,
    $fixnum.Int64? passId,
    $core.String? commonKey,
  }) {
    final result = create();
    if (view != null) result.view = view;
    if (level != null) result.level = level;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (workerId != null) result.workerId = workerId;
    if (projectNo != null) result.projectNo = projectNo;
    if (jobId != null) result.jobId = jobId;
    if (passId != null) result.passId = passId;
    if (commonKey != null) result.commonKey = commonKey;
    return result;
  }

  CollectionPath._();

  factory CollectionPath.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectionPath.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectionPath',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..e<CollectionView>(1, _omitFieldNames ? '' : 'view', $pb.PbFieldType.OE,
        defaultOrMaker: CollectionView.COLLECTION_VIEW_UNSPECIFIED,
        valueOf: CollectionView.valueOf,
        enumValues: CollectionView.values)
    ..e<CollectionLevel>(2, _omitFieldNames ? '' : 'level', $pb.PbFieldType.OE,
        defaultOrMaker: CollectionLevel.COLLECTION_LEVEL_UNSPECIFIED,
        valueOf: CollectionLevel.valueOf,
        enumValues: CollectionLevel.values)
    ..aInt64(3, _omitFieldNames ? '' : 'equipmentId')
    ..aInt64(4, _omitFieldNames ? '' : 'workerId')
    ..aOS(5, _omitFieldNames ? '' : 'projectNo')
    ..aInt64(6, _omitFieldNames ? '' : 'jobId')
    ..aInt64(7, _omitFieldNames ? '' : 'passId')
    ..aOS(8, _omitFieldNames ? '' : 'commonKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionPath clone() => CollectionPath()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionPath copyWith(void Function(CollectionPath) updates) =>
      super.copyWith((message) => updates(message as CollectionPath))
          as CollectionPath;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionPath create() => CollectionPath._();
  @$core.override
  CollectionPath createEmptyInstance() => create();
  static $pb.PbList<CollectionPath> createRepeated() =>
      $pb.PbList<CollectionPath>();
  @$core.pragma('dart2js:noInline')
  static CollectionPath getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectionPath>(create);
  static CollectionPath? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionView get view => $_getN(0);
  @$pb.TagNumber(1)
  set view(CollectionView value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasView() => $_has(0);
  @$pb.TagNumber(1)
  void clearView() => $_clearField(1);

  @$pb.TagNumber(2)
  CollectionLevel get level => $_getN(1);
  @$pb.TagNumber(2)
  set level(CollectionLevel value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get equipmentId => $_getI64(2);
  @$pb.TagNumber(3)
  set equipmentId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEquipmentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEquipmentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get workerId => $_getI64(3);
  @$pb.TagNumber(4)
  set workerId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get projectNo => $_getSZ(4);
  @$pb.TagNumber(5)
  set projectNo($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProjectNo() => $_has(4);
  @$pb.TagNumber(5)
  void clearProjectNo() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get jobId => $_getI64(5);
  @$pb.TagNumber(6)
  set jobId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJobId() => $_has(5);
  @$pb.TagNumber(6)
  void clearJobId() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get passId => $_getI64(6);
  @$pb.TagNumber(7)
  set passId($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPassId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPassId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get commonKey => $_getSZ(7);
  @$pb.TagNumber(8)
  set commonKey($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCommonKey() => $_has(7);
  @$pb.TagNumber(8)
  void clearCommonKey() => $_clearField(8);
}

class ListCollectionNodesRequest extends $pb.GeneratedMessage {
  factory ListCollectionNodesRequest({
    CollectionPath? parent,
    $fixnum.Int64? startOffsetNs,
    $fixnum.Int64? endOffsetNs,
    TimeBasis? basis,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (startOffsetNs != null) result.startOffsetNs = startOffsetNs;
    if (endOffsetNs != null) result.endOffsetNs = endOffsetNs;
    if (basis != null) result.basis = basis;
    return result;
  }

  ListCollectionNodesRequest._();

  factory ListCollectionNodesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionNodesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionNodesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<CollectionPath>(1, _omitFieldNames ? '' : 'parent',
        subBuilder: CollectionPath.create)
    ..aInt64(2, _omitFieldNames ? '' : 'startOffsetNs')
    ..aInt64(3, _omitFieldNames ? '' : 'endOffsetNs')
    ..e<TimeBasis>(4, _omitFieldNames ? '' : 'basis', $pb.PbFieldType.OE,
        defaultOrMaker: TimeBasis.TIME_BASIS_UNSPECIFIED,
        valueOf: TimeBasis.valueOf,
        enumValues: TimeBasis.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionNodesRequest clone() =>
      ListCollectionNodesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionNodesRequest copyWith(
          void Function(ListCollectionNodesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCollectionNodesRequest))
          as ListCollectionNodesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionNodesRequest create() => ListCollectionNodesRequest._();
  @$core.override
  ListCollectionNodesRequest createEmptyInstance() => create();
  static $pb.PbList<ListCollectionNodesRequest> createRepeated() =>
      $pb.PbList<ListCollectionNodesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCollectionNodesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionNodesRequest>(create);
  static ListCollectionNodesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionPath get parent => $_getN(0);
  @$pb.TagNumber(1)
  set parent(CollectionPath value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);
  @$pb.TagNumber(1)
  CollectionPath ensureParent() => $_ensure(0);

  /// 선택 구간. parent에 job_id가 있을 때만 쓴다. job.started_at 기준 나노초 오프셋이고
  /// asset.recorded_at이 [start, end) 안에 드는 Asset만 센다. Pass를 골랐고 구간을
  /// 비우면 pass.started_at~ended_at이 구간이다.
  @$pb.TagNumber(2)
  $fixnum.Int64 get startOffsetNs => $_getI64(1);
  @$pb.TagNumber(2)
  set startOffsetNs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartOffsetNs() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartOffsetNs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endOffsetNs => $_getI64(2);
  @$pb.TagNumber(3)
  set endOffsetNs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndOffsetNs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndOffsetNs() => $_clearField(3);

  /// 노드 started_at·ended_at의 기준. 비우면 WORK.
  @$pb.TagNumber(4)
  TimeBasis get basis => $_getN(3);
  @$pb.TagNumber(4)
  set basis(TimeBasis value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBasis() => $_has(3);
  @$pb.TagNumber(4)
  void clearBasis() => $_clearField(4);
}

class ListCollectionNodesResponse extends $pb.GeneratedMessage {
  factory ListCollectionNodesResponse({
    $core.Iterable<CollectionNode>? nodes,
  }) {
    final result = create();
    if (nodes != null) result.nodes.addAll(nodes);
    return result;
  }

  ListCollectionNodesResponse._();

  factory ListCollectionNodesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionNodesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionNodesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..pc<CollectionNode>(1, _omitFieldNames ? '' : 'nodes', $pb.PbFieldType.PM,
        subBuilder: CollectionNode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionNodesResponse clone() =>
      ListCollectionNodesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionNodesResponse copyWith(
          void Function(ListCollectionNodesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCollectionNodesResponse))
          as ListCollectionNodesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionNodesResponse create() =>
      ListCollectionNodesResponse._();
  @$core.override
  ListCollectionNodesResponse createEmptyInstance() => create();
  static $pb.PbList<ListCollectionNodesResponse> createRepeated() =>
      $pb.PbList<ListCollectionNodesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCollectionNodesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionNodesResponse>(create);
  static ListCollectionNodesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CollectionNode> get nodes => $_getList(0);
}

class CollectionNode extends $pb.GeneratedMessage {
  factory CollectionNode({
    CollectionPath? path,
    $core.String? label,
    $core.bool? hasChildren,
    CollectionSummary? summary,
    $2.Asset? asset,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (label != null) result.label = label;
    if (hasChildren != null) result.hasChildren = hasChildren;
    if (summary != null) result.summary = summary;
    if (asset != null) result.asset = asset;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  CollectionNode._();

  factory CollectionNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectionNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectionNode',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<CollectionPath>(1, _omitFieldNames ? '' : 'path',
        subBuilder: CollectionPath.create)
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOB(3, _omitFieldNames ? '' : 'hasChildren')
    ..aOM<CollectionSummary>(4, _omitFieldNames ? '' : 'summary',
        subBuilder: CollectionSummary.create)
    ..aOM<$2.Asset>(5, _omitFieldNames ? '' : 'asset',
        subBuilder: $2.Asset.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionNode clone() => CollectionNode()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionNode copyWith(void Function(CollectionNode) updates) =>
      super.copyWith((message) => updates(message as CollectionNode))
          as CollectionNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionNode create() => CollectionNode._();
  @$core.override
  CollectionNode createEmptyInstance() => create();
  static $pb.PbList<CollectionNode> createRepeated() =>
      $pb.PbList<CollectionNode>();
  @$core.pragma('dart2js:noInline')
  static CollectionNode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectionNode>(create);
  static CollectionNode? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionPath get path => $_getN(0);
  @$pb.TagNumber(1)
  set path(CollectionPath value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
  @$pb.TagNumber(1)
  CollectionPath ensurePath() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasChildren => $_getBF(2);
  @$pb.TagNumber(3)
  set hasChildren($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasChildren() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasChildren() => $_clearField(3);

  @$pb.TagNumber(4)
  CollectionSummary get summary => $_getN(3);
  @$pb.TagNumber(4)
  set summary(CollectionSummary value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);
  @$pb.TagNumber(4)
  CollectionSummary ensureSummary() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Asset get asset => $_getN(4);
  @$pb.TagNumber(5)
  set asset($2.Asset value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAsset() => $_has(4);
  @$pb.TagNumber(5)
  void clearAsset() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Asset ensureAsset() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get startedAt => $_getN(5);
  @$pb.TagNumber(6)
  set startedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStartedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureStartedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get endedAt => $_getN(6);
  @$pb.TagNumber(7)
  set endedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEndedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEndedAt() => $_ensure(6);
}

/// asset_id를 먼저 중복 제거한 뒤 집계한다(Asset 하나가 여러 작업에 첨부될 수 있음).
class CollectionSummary extends $pb.GeneratedMessage {
  factory CollectionSummary({
    $fixnum.Int64? assetCount,
    $fixnum.Int64? totalSizeBytes,
    $0.Timestamp? firstRecordedAt,
    $0.Timestamp? lastRecordedAt,
    $0.Timestamp? lastCollectedAt,
    $fixnum.Int64? jobCount,
    $fixnum.Int64? workDurationSeconds,
  }) {
    final result = create();
    if (assetCount != null) result.assetCount = assetCount;
    if (totalSizeBytes != null) result.totalSizeBytes = totalSizeBytes;
    if (firstRecordedAt != null) result.firstRecordedAt = firstRecordedAt;
    if (lastRecordedAt != null) result.lastRecordedAt = lastRecordedAt;
    if (lastCollectedAt != null) result.lastCollectedAt = lastCollectedAt;
    if (jobCount != null) result.jobCount = jobCount;
    if (workDurationSeconds != null)
      result.workDurationSeconds = workDurationSeconds;
    return result;
  }

  CollectionSummary._();

  factory CollectionSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectionSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectionSummary',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'assetCount')
    ..aInt64(2, _omitFieldNames ? '' : 'totalSizeBytes')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'firstRecordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'lastRecordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'lastCollectedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(6, _omitFieldNames ? '' : 'jobCount')
    ..aInt64(7, _omitFieldNames ? '' : 'workDurationSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionSummary clone() => CollectionSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionSummary copyWith(void Function(CollectionSummary) updates) =>
      super.copyWith((message) => updates(message as CollectionSummary))
          as CollectionSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionSummary create() => CollectionSummary._();
  @$core.override
  CollectionSummary createEmptyInstance() => create();
  static $pb.PbList<CollectionSummary> createRepeated() =>
      $pb.PbList<CollectionSummary>();
  @$core.pragma('dart2js:noInline')
  static CollectionSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectionSummary>(create);
  static CollectionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get assetCount => $_getI64(0);
  @$pb.TagNumber(1)
  set assetCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalSizeBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set totalSizeBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalSizeBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSizeBytes() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get firstRecordedAt => $_getN(2);
  @$pb.TagNumber(3)
  set firstRecordedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFirstRecordedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirstRecordedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureFirstRecordedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get lastRecordedAt => $_getN(3);
  @$pb.TagNumber(4)
  set lastRecordedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastRecordedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastRecordedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureLastRecordedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get lastCollectedAt => $_getN(4);
  @$pb.TagNumber(5)
  set lastCollectedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastCollectedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastCollectedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureLastCollectedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get jobCount => $_getI64(5);
  @$pb.TagNumber(6)
  set jobCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJobCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearJobCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get workDurationSeconds => $_getI64(6);
  @$pb.TagNumber(7)
  set workDurationSeconds($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWorkDurationSeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorkDurationSeconds() => $_clearField(7);
}

class GetPassWaveformRequest extends $pb.GeneratedMessage {
  factory GetPassWaveformRequest({
    $fixnum.Int64? passId,
    $core.Iterable<$core.String>? channels,
    $core.int? maxPoints,
    $fixnum.Int64? comparisonPassId,
    WaveformNormalize? normalize,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    if (channels != null) result.channels.addAll(channels);
    if (maxPoints != null) result.maxPoints = maxPoints;
    if (comparisonPassId != null) result.comparisonPassId = comparisonPassId;
    if (normalize != null) result.normalize = normalize;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'passId')
    ..pPS(2, _omitFieldNames ? '' : 'channels')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'maxPoints', $pb.PbFieldType.O3)
    ..aInt64(4, _omitFieldNames ? '' : 'comparisonPassId')
    ..e<WaveformNormalize>(
        5, _omitFieldNames ? '' : 'normalize', $pb.PbFieldType.OE,
        defaultOrMaker: WaveformNormalize.WAVEFORM_NORMALIZE_UNSPECIFIED,
        valueOf: WaveformNormalize.valueOf,
        enumValues: WaveformNormalize.values)
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
  $fixnum.Int64 get passId => $_getI64(0);
  @$pb.TagNumber(1)
  set passId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);

  /// 비우면 전체 채널(DTW면 용접 4채널). "imu"를 적으면 앞·뒤 IMU 열두 채널(imu_front_acc_x~imu_back_gyro_z), 축 이름만(gyro_x) 적으면 그 축의 앞·뒤 둘을 뜻한다.
  /// 이름이 통일되는 채널은 통일 이름(current_a 등)·파일 원본 이름(전류_A 등) 어느 쪽으로 적어도 된다.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get channels => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get maxPoints => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxPoints($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxPoints() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxPoints() => $_clearField(3);

  /// 비교할 패스. 화면이 비교 작업(지금은 명장 작업을 직접 고름 — ListJobs master_only, 추천 알고리즘이 생기면
  /// 그 결과)의 패스 목록(GetJob의 passes)에서 고른다. ListJobs의 pass_no로 찾은 작업도 GetJob으로 패스의 pass_id를 받는다. 패스 수가 작업마다 다르니 처음↔처음, 끝↔끝, 가운데는 같은
  /// pass_no로 짝짓는 것을 권한다.
  @$pb.TagNumber(4)
  $fixnum.Int64 get comparisonPassId => $_getI64(3);
  @$pb.TagNumber(4)
  set comparisonPassId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComparisonPassId() => $_has(3);
  @$pb.TagNumber(4)
  void clearComparisonPassId() => $_clearField(4);

  @$pb.TagNumber(5)
  WaveformNormalize get normalize => $_getN(4);
  @$pb.TagNumber(5)
  set normalize(WaveformNormalize value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNormalize() => $_has(4);
  @$pb.TagNumber(5)
  void clearNormalize() => $_clearField(5);
}

class GetPassWaveformResponse extends $pb.GeneratedMessage {
  factory GetPassWaveformResponse({
    PassWaveform? target,
    PassWaveform? comparison,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (comparison != null) result.comparison = comparison;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOM<PassWaveform>(1, _omitFieldNames ? '' : 'target',
        subBuilder: PassWaveform.create)
    ..aOM<PassWaveform>(2, _omitFieldNames ? '' : 'comparison',
        subBuilder: PassWaveform.create)
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
  PassWaveform get target => $_getN(0);
  @$pb.TagNumber(1)
  set target(PassWaveform value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  PassWaveform ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  PassWaveform get comparison => $_getN(1);
  @$pb.TagNumber(2)
  set comparison(PassWaveform value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasComparison() => $_has(1);
  @$pb.TagNumber(2)
  void clearComparison() => $_clearField(2);
  @$pb.TagNumber(2)
  PassWaveform ensureComparison() => $_ensure(1);
}

class PassWaveform extends $pb.GeneratedMessage {
  factory PassWaveform({
    $fixnum.Int64? jobId,
    $fixnum.Int64? passId,
    $core.int? passNo,
    $core.String? workerName,
    $core.bool? isMaster,
    $core.Iterable<WaveformSeries>? series,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (passId != null) result.passId = passId;
    if (passNo != null) result.passNo = passNo;
    if (workerName != null) result.workerName = workerName;
    if (isMaster != null) result.isMaster = isMaster;
    if (series != null) result.series.addAll(series);
    return result;
  }

  PassWaveform._();

  factory PassWaveform.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PassWaveform.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PassWaveform',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aInt64(2, _omitFieldNames ? '' : 'passId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'passNo', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'workerName')
    ..aOB(5, _omitFieldNames ? '' : 'isMaster')
    ..pc<WaveformSeries>(6, _omitFieldNames ? '' : 'series', $pb.PbFieldType.PM,
        subBuilder: WaveformSeries.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassWaveform clone() => PassWaveform()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassWaveform copyWith(void Function(PassWaveform) updates) =>
      super.copyWith((message) => updates(message as PassWaveform))
          as PassWaveform;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PassWaveform create() => PassWaveform._();
  @$core.override
  PassWaveform createEmptyInstance() => create();
  static $pb.PbList<PassWaveform> createRepeated() =>
      $pb.PbList<PassWaveform>();
  @$core.pragma('dart2js:noInline')
  static PassWaveform getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PassWaveform>(create);
  static PassWaveform? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobId => $_getI64(0);
  @$pb.TagNumber(1)
  set jobId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get passId => $_getI64(1);
  @$pb.TagNumber(2)
  set passId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get passNo => $_getIZ(2);
  @$pb.TagNumber(3)
  set passNo($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workerName => $_getSZ(3);
  @$pb.TagNumber(4)
  set workerName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkerName() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkerName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isMaster => $_getBF(4);
  @$pb.TagNumber(5)
  set isMaster($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsMaster() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsMaster() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<WaveformSeries> get series => $_getList(5);
}

/// 표준화 CSV 한 파일에서 자른 구간. 두 작업을 겹쳐 보도록 시각은 패스 시작 기준 오프셋이다.
class WaveformSeries extends $pb.GeneratedMessage {
  factory WaveformSeries({
    $fixnum.Int64? assetId,
    $fixnum.Int64? equipmentId,
    $core.Iterable<$fixnum.Int64>? tOffsetNs,
    $core.Iterable<WaveformChannel>? channels,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (tOffsetNs != null) result.tOffsetNs.addAll(tOffsetNs);
    if (channels != null) result.channels.addAll(channels);
    return result;
  }

  WaveformSeries._();

  factory WaveformSeries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaveformSeries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaveformSeries',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'assetId')
    ..aInt64(2, _omitFieldNames ? '' : 'equipmentId')
    ..p<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'tOffsetNs', $pb.PbFieldType.K6)
    ..pc<WaveformChannel>(
        4, _omitFieldNames ? '' : 'channels', $pb.PbFieldType.PM,
        subBuilder: WaveformChannel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaveformSeries clone() => WaveformSeries()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaveformSeries copyWith(void Function(WaveformSeries) updates) =>
      super.copyWith((message) => updates(message as WaveformSeries))
          as WaveformSeries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaveformSeries create() => WaveformSeries._();
  @$core.override
  WaveformSeries createEmptyInstance() => create();
  static $pb.PbList<WaveformSeries> createRepeated() =>
      $pb.PbList<WaveformSeries>();
  @$core.pragma('dart2js:noInline')
  static WaveformSeries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaveformSeries>(create);
  static WaveformSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get assetId => $_getI64(0);
  @$pb.TagNumber(1)
  set assetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get equipmentId => $_getI64(1);
  @$pb.TagNumber(2)
  set equipmentId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get tOffsetNs => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<WaveformChannel> get channels => $_getList(3);
}

class WaveformChannel extends $pb.GeneratedMessage {
  factory WaveformChannel({
    $core.String? name,
    $core.String? unit,
    $core.Iterable<$core.double>? values,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (unit != null) result.unit = unit;
    if (values != null) result.values.addAll(values);
    return result;
  }

  WaveformChannel._();

  factory WaveformChannel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaveformChannel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaveformChannel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.work.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'unit')
    ..p<$core.double>(3, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaveformChannel clone() => WaveformChannel()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaveformChannel copyWith(void Function(WaveformChannel) updates) =>
      super.copyWith((message) => updates(message as WaveformChannel))
          as WaveformChannel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaveformChannel create() => WaveformChannel._();
  @$core.override
  WaveformChannel createEmptyInstance() => create();
  static $pb.PbList<WaveformChannel> createRepeated() =>
      $pb.PbList<WaveformChannel>();
  @$core.pragma('dart2js:noInline')
  static WaveformChannel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaveformChannel>(create);
  static WaveformChannel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unit => $_getSZ(1);
  @$pb.TagNumber(2)
  set unit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnit() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.double> get values => $_getList(2);
}

/// 사용처: 대시보드(s0 수집 현황, s2 작업 이력·필터, s3 파형 비교, s3/s4 컨텍스트), 컴포즈(열 작업 고르기).
class WorkServiceApi {
  final $pb.RpcClient _client;

  WorkServiceApi(this._client);

  $async.Future<ListProjectsResponse> listProjects(
          $pb.ClientContext? ctx, ListProjectsRequest request) =>
      _client.invoke<ListProjectsResponse>(
          ctx, 'WorkService', 'ListProjects', request, ListProjectsResponse());

  /// 공사를 만든다. project.project_no는 필수이고 발급 후 불변. 같은 번호가 있으면 AlreadyExists.
  $async.Future<CreateProjectResponse> createProject(
          $pb.ClientContext? ctx, CreateProjectRequest request) =>
      _client.invoke<CreateProjectResponse>(ctx, 'WorkService', 'CreateProject',
          request, CreateProjectResponse());
  $async.Future<ListWorkersResponse> listWorkers(
          $pb.ClientContext? ctx, ListWorkersRequest request) =>
      _client.invoke<ListWorkersResponse>(
          ctx, 'WorkService', 'ListWorkers', request, ListWorkersResponse());

  /// 작업자를 만든다. worker.worker_name 필수.
  $async.Future<CreateWorkerResponse> createWorker(
          $pb.ClientContext? ctx, CreateWorkerRequest request) =>
      _client.invoke<CreateWorkerResponse>(
          ctx, 'WorkService', 'CreateWorker', request, CreateWorkerResponse());

  /// update_mask: worker_name, team, is_master
  $async.Future<UpdateWorkerResponse> updateWorker(
          $pb.ClientContext? ctx, UpdateWorkerRequest request) =>
      _client.invoke<UpdateWorkerResponse>(
          ctx, 'WorkService', 'UpdateWorker', request, UpdateWorkerResponse());

  /// 작업을 맡은 작업자는 FailedPrecondition.
  $async.Future<DeleteWorkerResponse> deleteWorker(
          $pb.ClientContext? ctx, DeleteWorkerRequest request) =>
      _client.invoke<DeleteWorkerResponse>(
          ctx, 'WorkService', 'DeleteWorker', request, DeleteWorkerResponse());
  $async.Future<ListEquipmentResponse> listEquipment(
          $pb.ClientContext? ctx, ListEquipmentRequest request) =>
      _client.invoke<ListEquipmentResponse>(ctx, 'WorkService', 'ListEquipment',
          request, ListEquipmentResponse());

  /// 장비를 만든다. equipment.equipment_name 필수. equipment_code가 겹치면 AlreadyExists.
  $async.Future<CreateEquipmentResponse> createEquipment(
          $pb.ClientContext? ctx, CreateEquipmentRequest request) =>
      _client.invoke<CreateEquipmentResponse>(ctx, 'WorkService',
          'CreateEquipment', request, CreateEquipmentResponse());

  /// update_mask: equipment_name, line_name, equipment_code
  $async.Future<UpdateEquipmentResponse> updateEquipment(
          $pb.ClientContext? ctx, UpdateEquipmentRequest request) =>
      _client.invoke<UpdateEquipmentResponse>(ctx, 'WorkService',
          'UpdateEquipment', request, UpdateEquipmentResponse());

  /// 그 장비로 기록한 Asset이 있으면 FailedPrecondition.
  $async.Future<DeleteEquipmentResponse> deleteEquipment(
          $pb.ClientContext? ctx, DeleteEquipmentRequest request) =>
      _client.invoke<DeleteEquipmentResponse>(ctx, 'WorkService',
          'DeleteEquipment', request, DeleteEquipmentResponse());

  /// 공사의 호기에 품목을 배정한다(묶음). 작업을 만들기 전에 품목을 미리 등록할 때 쓴다. 이미 있는 배정은 그대로 두고
  /// (이름도 안 바꾼다) 그 줄을 돌려준다. project_id·unit_no·item_code·item_name 필수, 없는 공사면 InvalidArgument.
  $async.Future<CreateProjectItemsResponse> createProjectItems(
          $pb.ClientContext? ctx, CreateProjectItemsRequest request) =>
      _client.invoke<CreateProjectItemsResponse>(ctx, 'WorkService',
          'CreateProjectItems', request, CreateProjectItemsResponse());

  /// 배정 줄의 품목 이름을 고친다(item.project_item_id·item_name 필수). 그 배정을 가리키는 작업 모두의 item_name이 바뀐다.
  $async.Future<UpdateProjectItemResponse> updateProjectItem(
          $pb.ClientContext? ctx, UpdateProjectItemRequest request) =>
      _client.invoke<UpdateProjectItemResponse>(ctx, 'WorkService',
          'UpdateProjectItem', request, UpdateProjectItemResponse());

  /// 배정에 쓰인 품목(코드·이름)을 중복 없이. 품목을 넣을 때 이름을 다시 고르는 추천 목록으로 쓴다.
  $async.Future<ListItemsResponse> listItems(
          $pb.ClientContext? ctx, ListItemsRequest request) =>
      _client.invoke<ListItemsResponse>(
          ctx, 'WorkService', 'ListItems', request, ListItemsResponse());

  /// 작업 목록(ListJobs) 필터의 드롭다운 값을 한 번에: 공사(호기·품목 포함)·작업자·장비.
  $async.Future<ListJobFiltersResponse> listJobFilters(
          $pb.ClientContext? ctx, ListJobFiltersRequest request) =>
      _client.invoke<ListJobFiltersResponse>(ctx, 'WorkService',
          'ListJobFilters', request, ListJobFiltersResponse());

  /// 작업 목록. 행마다 표시용 이름·개수를 붙여 준다(행별 추가 조회 불필요).
  $async.Future<ListJobsResponse> listJobs(
          $pb.ClientContext? ctx, ListJobsRequest request) =>
      _client.invoke<ListJobsResponse>(
          ctx, 'WorkService', 'ListJobs', request, ListJobsResponse());

  /// 공사 이름·현장·발주처를 고친다(update_mask: project_name, site_name, customer). 공사 번호는 못 바꾼다.
  $async.Future<UpdateProjectResponse> updateProject(
          $pb.ClientContext? ctx, UpdateProjectRequest request) =>
      _client.invoke<UpdateProjectResponse>(ctx, 'WorkService', 'UpdateProject',
          request, UpdateProjectResponse());

  /// 작업이 하나라도 있는 공사는 FailedPrecondition.
  $async.Future<DeleteProjectResponse> deleteProject(
          $pb.ClientContext? ctx, DeleteProjectRequest request) =>
      _client.invoke<DeleteProjectResponse>(ctx, 'WorkService', 'DeleteProject',
          request, DeleteProjectResponse());

  /// 작업을 만든다. 필수: job.project_no(또는 project_id)·unit_no·item_code(공백 없이, 정규화된 값 — '05'·'TFPB')·joint_no·started_at, 그리고 item_name(이미 배정된 품목이면 안 줘도 되고, 줘도 저장된 이름을 따른다).
  /// job_id·job_key·common_key는 서버가 정하고 보낸 값은 무시한다. 공사·작업자가 없으면 InvalidArgument.
  /// passes를 주면 패스도 함께 만든다 — 하나라도 틀리면 작업도 만들어지지 않는다. 나중에 더할 때는 CreatePass.
  $async.Future<CreateJobResponse> createJob(
          $pb.ClientContext? ctx, CreateJobRequest request) =>
      _client.invoke<CreateJobResponse>(
          ctx, 'WorkService', 'CreateJob', request, CreateJobResponse());

  /// 작업을 고친다(update_mask에 든 칸만). job_id는 그대로이고, 공사·호기·품목·이음부·시작 시각이 바뀌면 common_key·job_key를
  /// 다시 만든다 — 성적서는 품목(common_key)에 붙어 있어 바뀐 품목의 성적서를 보게 된다. 필수 칸은 비울 수 없다.
  $async.Future<UpdateJobResponse> updateJob(
          $pb.ClientContext? ctx, UpdateJobRequest request) =>
      _client.invoke<UpdateJobResponse>(
          ctx, 'WorkService', 'UpdateJob', request, UpdateJobResponse());

  /// 작업과 그 패스를 지운다. 첨부·타임라인·매칭된 성적서 세트가 있으면 FailedPrecondition(먼저 떼거나 지운다).
  $async.Future<DeleteJobResponse> deleteJob(
          $pb.ClientContext? ctx, DeleteJobRequest request) =>
      _client.invoke<DeleteJobResponse>(
          ctx, 'WorkService', 'DeleteJob', request, DeleteJobResponse());

  /// 패스를 만든다. pass.job_id·pass_no(1 이상)는 필수. 같은 번호의 패스가 있으면 AlreadyExists.
  $async.Future<CreatePassResponse> createPass(
          $pb.ClientContext? ctx, CreatePassRequest request) =>
      _client.invoke<CreatePassResponse>(
          ctx, 'WorkService', 'CreatePass', request, CreatePassResponse());

  /// 패스를 고친다(update_mask: pass_no, started_at, ended_at).
  $async.Future<UpdatePassResponse> updatePass(
          $pb.ClientContext? ctx, UpdatePassRequest request) =>
      _client.invoke<UpdatePassResponse>(
          ctx, 'WorkService', 'UpdatePass', request, UpdatePassResponse());

  /// 패스를 지운다. 그 패스에 붙어 있던 첨부는 작업 공용이 된다.
  $async.Future<DeletePassResponse> deletePass(
          $pb.ClientContext? ctx, DeletePassRequest request) =>
      _client.invoke<DeletePassResponse>(
          ctx, 'WorkService', 'DeletePass', request, DeletePassResponse());

  /// 작업 + 패스 + 작업자 + 쓰인 장비
  $async.Future<GetJobResponse> getJob(
          $pb.ClientContext? ctx, GetJobRequest request) =>
      _client.invoke<GetJobResponse>(
          ctx, 'WorkService', 'GetJob', request, GetJobResponse());

  /// 수집 현황 계층을 한 단계씩 조회한다. 장비가 기록한 자료(원본과 원본을 대신하는 표준화본·잘라 낸 PDF)만 센다 —
  /// 도구 결과물(STT·포즈·잘라 낸 이미지·추출 JSON)은 작업 첨부(ListJobAssets)·타임라인에서 본다.
  $async.Future<ListCollectionNodesResponse> listCollectionNodes(
          $pb.ClientContext? ctx, ListCollectionNodesRequest request) =>
      _client.invoke<ListCollectionNodesResponse>(ctx, 'WorkService',
          'ListCollectionNodes', request, ListCollectionNodesResponse());

  /// 패스 하나의 센서 파형. comparison_pass_id를 주면 그 패스의 파형도 함께 준다.
  /// 파형은 표준화 파생 CSV(operation=timeseries_normalize)에서 패스 구간만큼 잘라 낸다.
  $async.Future<GetPassWaveformResponse> getPassWaveform(
          $pb.ClientContext? ctx, GetPassWaveformRequest request) =>
      _client.invoke<GetPassWaveformResponse>(ctx, 'WorkService',
          'GetPassWaveform', request, GetPassWaveformResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
