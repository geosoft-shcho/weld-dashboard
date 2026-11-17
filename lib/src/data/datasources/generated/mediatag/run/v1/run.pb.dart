// This is a generated file - do not edit.
//
// Generated from mediatag/run/v1/run.proto.

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

import '../../../google/protobuf/timestamp.pb.dart' as $0;
import 'run.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'run.pbenum.dart';

enum RunTarget_Target { jobId, assetId, clipId, notSet }

/// run이 돌 대상. 셋 중 하나만 채운다.
class RunTarget extends $pb.GeneratedMessage {
  factory RunTarget({
    $fixnum.Int64? jobId,
    $fixnum.Int64? assetId,
    $fixnum.Int64? clipId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (assetId != null) result.assetId = assetId;
    if (clipId != null) result.clipId = clipId;
    return result;
  }

  RunTarget._();

  factory RunTarget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunTarget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RunTarget_Target> _RunTarget_TargetByTag = {
    1: RunTarget_Target.jobId,
    2: RunTarget_Target.assetId,
    3: RunTarget_Target.clipId,
    0: RunTarget_Target.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunTarget',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aInt64(2, _omitFieldNames ? '' : 'assetId')
    ..aInt64(3, _omitFieldNames ? '' : 'clipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunTarget clone() => RunTarget()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunTarget copyWith(void Function(RunTarget) updates) =>
      super.copyWith((message) => updates(message as RunTarget)) as RunTarget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunTarget create() => RunTarget._();
  @$core.override
  RunTarget createEmptyInstance() => create();
  static $pb.PbList<RunTarget> createRepeated() => $pb.PbList<RunTarget>();
  @$core.pragma('dart2js:noInline')
  static RunTarget getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RunTarget>(create);
  static RunTarget? _defaultInstance;

  RunTarget_Target whichTarget() => _RunTarget_TargetByTag[$_whichOneof(0)]!;
  void clearTarget() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobId => $_getI64(0);
  @$pb.TagNumber(1)
  set jobId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get assetId => $_getI64(1);
  @$pb.TagNumber(2)
  set assetId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get clipId => $_getI64(2);
  @$pb.TagNumber(3)
  set clipId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClipId() => $_has(2);
  @$pb.TagNumber(3)
  void clearClipId() => $_clearField(3);
}

enum Run_What { toolId, stage, notSet }

/// 실행 1건 — 큐의 한 칸.
class Run extends $pb.GeneratedMessage {
  factory Run({
    $fixnum.Int64? runId,
    $fixnum.Int64? toolId,
    $core.String? stage,
    $fixnum.Int64? parentRunId,
    $fixnum.Int64? traceId,
    RunTrigger? trigger,
    RunTarget? target,
    RunStatus? status,
    $core.String? errorCode,
    $core.String? errorMessage,
    $core.String? externalJobId,
    $core.int? attemptCount,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $0.Timestamp? startedAt,
    $core.String? queue,
    $core.int? queuePosition,
    $core.int? queueLength,
    RunWait? wait,
    $core.double? progressPercent,
    $core.int? estimatedRemainingSeconds,
    $core.Iterable<$fixnum.Int64>? outputAssetIds,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (toolId != null) result.toolId = toolId;
    if (stage != null) result.stage = stage;
    if (parentRunId != null) result.parentRunId = parentRunId;
    if (traceId != null) result.traceId = traceId;
    if (trigger != null) result.trigger = trigger;
    if (target != null) result.target = target;
    if (status != null) result.status = status;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (externalJobId != null) result.externalJobId = externalJobId;
    if (attemptCount != null) result.attemptCount = attemptCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (startedAt != null) result.startedAt = startedAt;
    if (queue != null) result.queue = queue;
    if (queuePosition != null) result.queuePosition = queuePosition;
    if (queueLength != null) result.queueLength = queueLength;
    if (wait != null) result.wait = wait;
    if (progressPercent != null) result.progressPercent = progressPercent;
    if (estimatedRemainingSeconds != null)
      result.estimatedRemainingSeconds = estimatedRemainingSeconds;
    if (outputAssetIds != null) result.outputAssetIds.addAll(outputAssetIds);
    return result;
  }

  Run._();

  factory Run.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Run.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Run_What> _Run_WhatByTag = {
    2: Run_What.toolId,
    3: Run_What.stage,
    0: Run_What.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Run',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aInt64(1, _omitFieldNames ? '' : 'runId')
    ..aInt64(2, _omitFieldNames ? '' : 'toolId')
    ..aOS(3, _omitFieldNames ? '' : 'stage')
    ..aInt64(4, _omitFieldNames ? '' : 'parentRunId')
    ..aInt64(5, _omitFieldNames ? '' : 'traceId')
    ..e<RunTrigger>(6, _omitFieldNames ? '' : 'trigger', $pb.PbFieldType.OE,
        defaultOrMaker: RunTrigger.RUN_TRIGGER_UNSPECIFIED,
        valueOf: RunTrigger.valueOf,
        enumValues: RunTrigger.values)
    ..aOM<RunTarget>(7, _omitFieldNames ? '' : 'target',
        subBuilder: RunTarget.create)
    ..e<RunStatus>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: RunStatus.RUN_STATUS_UNSPECIFIED,
        valueOf: RunStatus.valueOf,
        enumValues: RunStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'errorCode')
    ..aOS(10, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(11, _omitFieldNames ? '' : 'externalJobId')
    ..a<$core.int>(
        12, _omitFieldNames ? '' : 'attemptCount', $pb.PbFieldType.O3)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'queue')
    ..a<$core.int>(
        17, _omitFieldNames ? '' : 'queuePosition', $pb.PbFieldType.O3)
    ..a<$core.int>(18, _omitFieldNames ? '' : 'queueLength', $pb.PbFieldType.O3)
    ..aOM<RunWait>(19, _omitFieldNames ? '' : 'wait',
        subBuilder: RunWait.create)
    ..a<$core.double>(
        20, _omitFieldNames ? '' : 'progressPercent', $pb.PbFieldType.OD)
    ..a<$core.int>(21, _omitFieldNames ? '' : 'estimatedRemainingSeconds',
        $pb.PbFieldType.O3)
    ..p<$fixnum.Int64>(
        22, _omitFieldNames ? '' : 'outputAssetIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Run clone() => Run()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Run copyWith(void Function(Run) updates) =>
      super.copyWith((message) => updates(message as Run)) as Run;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Run create() => Run._();
  @$core.override
  Run createEmptyInstance() => create();
  static $pb.PbList<Run> createRepeated() => $pb.PbList<Run>();
  @$core.pragma('dart2js:noInline')
  static Run getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Run>(create);
  static Run? _defaultInstance;

  Run_What whichWhat() => _Run_WhatByTag[$_whichOneof(0)]!;
  void clearWhat() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get runId => $_getI64(0);
  @$pb.TagNumber(1)
  set runId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get toolId => $_getI64(1);
  @$pb.TagNumber(2)
  set toolId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get stage => $_getSZ(2);
  @$pb.TagNumber(3)
  set stage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStage() => $_has(2);
  @$pb.TagNumber(3)
  void clearStage() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get parentRunId => $_getI64(3);
  @$pb.TagNumber(4)
  set parentRunId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentRunId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get traceId => $_getI64(4);
  @$pb.TagNumber(5)
  set traceId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTraceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTraceId() => $_clearField(5);

  @$pb.TagNumber(6)
  RunTrigger get trigger => $_getN(5);
  @$pb.TagNumber(6)
  set trigger(RunTrigger value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTrigger() => $_has(5);
  @$pb.TagNumber(6)
  void clearTrigger() => $_clearField(6);

  @$pb.TagNumber(7)
  RunTarget get target => $_getN(6);
  @$pb.TagNumber(7)
  set target(RunTarget value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTarget() => $_has(6);
  @$pb.TagNumber(7)
  void clearTarget() => $_clearField(7);
  @$pb.TagNumber(7)
  RunTarget ensureTarget() => $_ensure(6);

  @$pb.TagNumber(8)
  RunStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(RunStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get errorCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set errorCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasErrorCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearErrorCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get errorMessage => $_getSZ(9);
  @$pb.TagNumber(10)
  set errorMessage($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasErrorMessage() => $_has(9);
  @$pb.TagNumber(10)
  void clearErrorMessage() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get externalJobId => $_getSZ(10);
  @$pb.TagNumber(11)
  set externalJobId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExternalJobId() => $_has(10);
  @$pb.TagNumber(11)
  void clearExternalJobId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get attemptCount => $_getIZ(11);
  @$pb.TagNumber(12)
  set attemptCount($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAttemptCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearAttemptCount() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get updatedAt => $_getN(13);
  @$pb.TagNumber(14)
  set updatedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasUpdatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearUpdatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureUpdatedAt() => $_ensure(13);

  /// RUNNING일 때 돌기 시작한 시각. 서버 안 run은 워커가 꺼낸 시각, 외부 도구는 진행 신호를 처음 받은 시각이라 진행 신호를 안 주는
  /// 도구는 비어 있다 — 그때는 updated_at을 본다.
  @$pb.TagNumber(15)
  $0.Timestamp get startedAt => $_getN(14);
  @$pb.TagNumber(15)
  set startedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasStartedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearStartedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureStartedAt() => $_ensure(14);

  /// 아래는 저장하지 않고 읽을 때 센다
  @$pb.TagNumber(16)
  $core.String get queue => $_getSZ(15);
  @$pb.TagNumber(16)
  set queue($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasQueue() => $_has(15);
  @$pb.TagNumber(16)
  void clearQueue() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get queuePosition => $_getIZ(16);
  @$pb.TagNumber(17)
  set queuePosition($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasQueuePosition() => $_has(16);
  @$pb.TagNumber(17)
  void clearQueuePosition() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get queueLength => $_getIZ(17);
  @$pb.TagNumber(18)
  set queueLength($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasQueueLength() => $_has(17);
  @$pb.TagNumber(18)
  void clearQueueLength() => $_clearField(18);

  @$pb.TagNumber(19)
  RunWait get wait => $_getN(18);
  @$pb.TagNumber(19)
  set wait(RunWait value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasWait() => $_has(18);
  @$pb.TagNumber(19)
  void clearWait() => $_clearField(19);
  @$pb.TagNumber(19)
  RunWait ensureWait() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.double get progressPercent => $_getN(19);
  @$pb.TagNumber(20)
  set progressPercent($core.double value) => $_setDouble(19, value);
  @$pb.TagNumber(20)
  $core.bool hasProgressPercent() => $_has(19);
  @$pb.TagNumber(20)
  void clearProgressPercent() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get estimatedRemainingSeconds => $_getIZ(20);
  @$pb.TagNumber(21)
  set estimatedRemainingSeconds($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasEstimatedRemainingSeconds() => $_has(20);
  @$pb.TagNumber(21)
  void clearEstimatedRemainingSeconds() => $_clearField(21);

  @$pb.TagNumber(22)
  $pb.PbList<$fixnum.Int64> get outputAssetIds => $_getList(21);
}

/// QUEUED인 run이 왜 · 얼마나 기다리나. 실제 값만 준다 — 시작 예정 시각 같은 추정은 주지 않는다.
class RunWait extends $pb.GeneratedMessage {
  factory RunWait({
    WaitReason? reason,
    $core.int? ahead,
    $core.int? running,
    $core.int? workers,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    if (ahead != null) result.ahead = ahead;
    if (running != null) result.running = running;
    if (workers != null) result.workers = workers;
    return result;
  }

  RunWait._();

  factory RunWait.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunWait.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunWait',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..e<WaitReason>(1, _omitFieldNames ? '' : 'reason', $pb.PbFieldType.OE,
        defaultOrMaker: WaitReason.WAIT_REASON_UNSPECIFIED,
        valueOf: WaitReason.valueOf,
        enumValues: WaitReason.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'ahead', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'running', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'workers', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunWait clone() => RunWait()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunWait copyWith(void Function(RunWait) updates) =>
      super.copyWith((message) => updates(message as RunWait)) as RunWait;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunWait create() => RunWait._();
  @$core.override
  RunWait createEmptyInstance() => create();
  static $pb.PbList<RunWait> createRepeated() => $pb.PbList<RunWait>();
  @$core.pragma('dart2js:noInline')
  static RunWait getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RunWait>(create);
  static RunWait? _defaultInstance;

  @$pb.TagNumber(1)
  WaitReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason(WaitReason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get ahead => $_getIZ(1);
  @$pb.TagNumber(2)
  set ahead($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAhead() => $_has(1);
  @$pb.TagNumber(2)
  void clearAhead() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get running => $_getIZ(2);
  @$pb.TagNumber(3)
  set running($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunning() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunning() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get workers => $_getIZ(3);
  @$pb.TagNumber(4)
  set workers($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkers() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkers() => $_clearField(4);
}

class StartRunRequest extends $pb.GeneratedMessage {
  factory StartRunRequest({
    $fixnum.Int64? toolId,
    RunTrigger? trigger,
    RunTarget? target,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    if (trigger != null) result.trigger = trigger;
    if (target != null) result.target = target;
    return result;
  }

  StartRunRequest._();

  factory StartRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartRunRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'toolId')
    ..e<RunTrigger>(2, _omitFieldNames ? '' : 'trigger', $pb.PbFieldType.OE,
        defaultOrMaker: RunTrigger.RUN_TRIGGER_UNSPECIFIED,
        valueOf: RunTrigger.valueOf,
        enumValues: RunTrigger.values)
    ..aOM<RunTarget>(3, _omitFieldNames ? '' : 'target',
        subBuilder: RunTarget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRunRequest clone() => StartRunRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRunRequest copyWith(void Function(StartRunRequest) updates) =>
      super.copyWith((message) => updates(message as StartRunRequest))
          as StartRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartRunRequest create() => StartRunRequest._();
  @$core.override
  StartRunRequest createEmptyInstance() => create();
  static $pb.PbList<StartRunRequest> createRepeated() =>
      $pb.PbList<StartRunRequest>();
  @$core.pragma('dart2js:noInline')
  static StartRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartRunRequest>(create);
  static StartRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get toolId => $_getI64(0);
  @$pb.TagNumber(1)
  set toolId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolId() => $_clearField(1);

  @$pb.TagNumber(2)
  RunTrigger get trigger => $_getN(1);
  @$pb.TagNumber(2)
  set trigger(RunTrigger value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTrigger() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrigger() => $_clearField(2);

  @$pb.TagNumber(3)
  RunTarget get target => $_getN(2);
  @$pb.TagNumber(3)
  set target(RunTarget value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);
  @$pb.TagNumber(3)
  RunTarget ensureTarget() => $_ensure(2);
}

class StartRunResponse extends $pb.GeneratedMessage {
  factory StartRunResponse({
    Run? run,
  }) {
    final result = create();
    if (run != null) result.run = run;
    return result;
  }

  StartRunResponse._();

  factory StartRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartRunResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aOM<Run>(1, _omitFieldNames ? '' : 'run', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRunResponse clone() => StartRunResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRunResponse copyWith(void Function(StartRunResponse) updates) =>
      super.copyWith((message) => updates(message as StartRunResponse))
          as StartRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartRunResponse create() => StartRunResponse._();
  @$core.override
  StartRunResponse createEmptyInstance() => create();
  static $pb.PbList<StartRunResponse> createRepeated() =>
      $pb.PbList<StartRunResponse>();
  @$core.pragma('dart2js:noInline')
  static StartRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartRunResponse>(create);
  static StartRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Run get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(Run value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  Run ensureRun() => $_ensure(0);
}

class GetRunRequest extends $pb.GeneratedMessage {
  factory GetRunRequest({
    $fixnum.Int64? runId,
    $core.bool? waitForTerminal,
    $core.int? waitTimeoutSeconds,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (waitForTerminal != null) result.waitForTerminal = waitForTerminal;
    if (waitTimeoutSeconds != null)
      result.waitTimeoutSeconds = waitTimeoutSeconds;
    return result;
  }

  GetRunRequest._();

  factory GetRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRunRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'runId')
    ..aOB(2, _omitFieldNames ? '' : 'waitForTerminal')
    ..a<$core.int>(
        3, _omitFieldNames ? '' : 'waitTimeoutSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunRequest clone() => GetRunRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunRequest copyWith(void Function(GetRunRequest) updates) =>
      super.copyWith((message) => updates(message as GetRunRequest))
          as GetRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRunRequest create() => GetRunRequest._();
  @$core.override
  GetRunRequest createEmptyInstance() => create();
  static $pb.PbList<GetRunRequest> createRepeated() =>
      $pb.PbList<GetRunRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRunRequest>(create);
  static GetRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get runId => $_getI64(0);
  @$pb.TagNumber(1)
  set runId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get waitForTerminal => $_getBF(1);
  @$pb.TagNumber(2)
  set waitForTerminal($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWaitForTerminal() => $_has(1);
  @$pb.TagNumber(2)
  void clearWaitForTerminal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get waitTimeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set waitTimeoutSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWaitTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearWaitTimeoutSeconds() => $_clearField(3);
}

class GetRunResponse extends $pb.GeneratedMessage {
  factory GetRunResponse({
    Run? run,
  }) {
    final result = create();
    if (run != null) result.run = run;
    return result;
  }

  GetRunResponse._();

  factory GetRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRunResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aOM<Run>(1, _omitFieldNames ? '' : 'run', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunResponse clone() => GetRunResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunResponse copyWith(void Function(GetRunResponse) updates) =>
      super.copyWith((message) => updates(message as GetRunResponse))
          as GetRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRunResponse create() => GetRunResponse._();
  @$core.override
  GetRunResponse createEmptyInstance() => create();
  static $pb.PbList<GetRunResponse> createRepeated() =>
      $pb.PbList<GetRunResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRunResponse>(create);
  static GetRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Run get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(Run value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  Run ensureRun() => $_ensure(0);
}

class ListRunsRequest extends $pb.GeneratedMessage {
  factory ListRunsRequest({
    RunTarget? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListRunsRequest._();

  factory ListRunsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRunsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRunsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aOM<RunTarget>(1, _omitFieldNames ? '' : 'target',
        subBuilder: RunTarget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRunsRequest clone() => ListRunsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRunsRequest copyWith(void Function(ListRunsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRunsRequest))
          as ListRunsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRunsRequest create() => ListRunsRequest._();
  @$core.override
  ListRunsRequest createEmptyInstance() => create();
  static $pb.PbList<ListRunsRequest> createRepeated() =>
      $pb.PbList<ListRunsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRunsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRunsRequest>(create);
  static ListRunsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  RunTarget get target => $_getN(0);
  @$pb.TagNumber(1)
  set target(RunTarget value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  RunTarget ensureTarget() => $_ensure(0);
}

class ListRunsResponse extends $pb.GeneratedMessage {
  factory ListRunsResponse({
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  ListRunsResponse._();

  factory ListRunsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRunsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRunsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..pc<Run>(1, _omitFieldNames ? '' : 'runs', $pb.PbFieldType.PM,
        subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRunsResponse clone() => ListRunsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRunsResponse copyWith(void Function(ListRunsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRunsResponse))
          as ListRunsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRunsResponse create() => ListRunsResponse._();
  @$core.override
  ListRunsResponse createEmptyInstance() => create();
  static $pb.PbList<ListRunsResponse> createRepeated() =>
      $pb.PbList<ListRunsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRunsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRunsResponse>(create);
  static ListRunsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Run> get runs => $_getList(0);
}

class CancelRunRequest extends $pb.GeneratedMessage {
  factory CancelRunRequest({
    $fixnum.Int64? runId,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    return result;
  }

  CancelRunRequest._();

  factory CancelRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRunRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'runId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunRequest clone() => CancelRunRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunRequest copyWith(void Function(CancelRunRequest) updates) =>
      super.copyWith((message) => updates(message as CancelRunRequest))
          as CancelRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRunRequest create() => CancelRunRequest._();
  @$core.override
  CancelRunRequest createEmptyInstance() => create();
  static $pb.PbList<CancelRunRequest> createRepeated() =>
      $pb.PbList<CancelRunRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRunRequest>(create);
  static CancelRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get runId => $_getI64(0);
  @$pb.TagNumber(1)
  set runId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);
}

class CancelRunResponse extends $pb.GeneratedMessage {
  factory CancelRunResponse({
    Run? run,
  }) {
    final result = create();
    if (run != null) result.run = run;
    return result;
  }

  CancelRunResponse._();

  factory CancelRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRunResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aOM<Run>(1, _omitFieldNames ? '' : 'run', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunResponse clone() => CancelRunResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunResponse copyWith(void Function(CancelRunResponse) updates) =>
      super.copyWith((message) => updates(message as CancelRunResponse))
          as CancelRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRunResponse create() => CancelRunResponse._();
  @$core.override
  CancelRunResponse createEmptyInstance() => create();
  static $pb.PbList<CancelRunResponse> createRepeated() =>
      $pb.PbList<CancelRunResponse>();
  @$core.pragma('dart2js:noInline')
  static CancelRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRunResponse>(create);
  static CancelRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Run get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(Run value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  Run ensureRun() => $_ensure(0);
}

class GetQueueRequest extends $pb.GeneratedMessage {
  factory GetQueueRequest() => create();

  GetQueueRequest._();

  factory GetQueueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQueueRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueRequest clone() => GetQueueRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueRequest copyWith(void Function(GetQueueRequest) updates) =>
      super.copyWith((message) => updates(message as GetQueueRequest))
          as GetQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetQueueRequest create() => GetQueueRequest._();
  @$core.override
  GetQueueRequest createEmptyInstance() => create();
  static $pb.PbList<GetQueueRequest> createRepeated() =>
      $pb.PbList<GetQueueRequest>();
  @$core.pragma('dart2js:noInline')
  static GetQueueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQueueRequest>(create);
  static GetQueueRequest? _defaultInstance;
}

class GetQueueResponse extends $pb.GeneratedMessage {
  factory GetQueueResponse({
    $core.Iterable<Queue>? queues,
  }) {
    final result = create();
    if (queues != null) result.queues.addAll(queues);
    return result;
  }

  GetQueueResponse._();

  factory GetQueueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQueueResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..pc<Queue>(1, _omitFieldNames ? '' : 'queues', $pb.PbFieldType.PM,
        subBuilder: Queue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueResponse clone() => GetQueueResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueResponse copyWith(void Function(GetQueueResponse) updates) =>
      super.copyWith((message) => updates(message as GetQueueResponse))
          as GetQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetQueueResponse create() => GetQueueResponse._();
  @$core.override
  GetQueueResponse createEmptyInstance() => create();
  static $pb.PbList<GetQueueResponse> createRepeated() =>
      $pb.PbList<GetQueueResponse>();
  @$core.pragma('dart2js:noInline')
  static GetQueueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQueueResponse>(create);
  static GetQueueResponse? _defaultInstance;

  /// 대기열마다 한 줄, 이름순. 서버 안 대기열(postprocess · work)은 비어도 나오고, 외부 서버는 run이 있을 때만 나온다.
  /// 여정(TraceService)이 기다리는 중이면 Trace.run.queue로 여기서 그 대기열을 찾는다.
  @$pb.TagNumber(1)
  $pb.PbList<Queue> get queues => $_getList(0);
}

/// 대기열 하나 — 이름은 Run.queue와 같다. 동시 수를 정하는 자원(이 서버의 워커 · 외부 서버의 자리)마다 하나다.
class Queue extends $pb.GeneratedMessage {
  factory Queue({
    $core.String? queue,
    $core.int? workers,
    $core.int? running,
    $core.int? waiting,
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (queue != null) result.queue = queue;
    if (workers != null) result.workers = workers;
    if (running != null) result.running = running;
    if (waiting != null) result.waiting = waiting;
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  Queue._();

  factory Queue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Queue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Queue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.run.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'queue')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'workers', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'running', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'waiting', $pb.PbFieldType.O3)
    ..pc<Run>(5, _omitFieldNames ? '' : 'runs', $pb.PbFieldType.PM,
        subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Queue clone() => Queue()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Queue copyWith(void Function(Queue) updates) =>
      super.copyWith((message) => updates(message as Queue)) as Queue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Queue create() => Queue._();
  @$core.override
  Queue createEmptyInstance() => create();
  static $pb.PbList<Queue> createRepeated() => $pb.PbList<Queue>();
  @$core.pragma('dart2js:noInline')
  static Queue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Queue>(create);
  static Queue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get queue => $_getSZ(0);
  @$pb.TagNumber(1)
  set queue($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQueue() => $_has(0);
  @$pb.TagNumber(1)
  void clearQueue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get workers => $_getIZ(1);
  @$pb.TagNumber(2)
  set workers($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkers() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkers() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get running => $_getIZ(2);
  @$pb.TagNumber(3)
  set running($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunning() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunning() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get waiting => $_getIZ(3);
  @$pb.TagNumber(4)
  set waiting($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWaiting() => $_has(3);
  @$pb.TagNumber(4)
  void clearWaiting() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Run> get runs => $_getList(4);
}

class RunServiceApi {
  final $pb.RpcClient _client;

  RunServiceApi(this._client);

  /// 도구 하나를 대상 하나에 돌려 달라고 요청한다. run을 큐에 넣고 바로 돌려준다(status = QUEUED) — 끝날 때까지 기다리지 않는다.
  /// 결과는 GetRun(wait_for_terminal)으로 받고, 도구가 만든 파일은 output_asset_ids에 있다.
  ///   tool_id: 돌릴 도구(ToolService.ListTools). target: asset_id · clip_id · job_id 중 하나.
  ///   trigger: MANUAL(사람이 한 건을 돌림 — Asset 하나 또는 Clip 하나), AUTO_TAGGING(작업의 타임라인 전체 — 대상은 작업).
  ///            ASSET_UPLOADED는 보내지 않는다 — 서버가 스스로 거는 실행의 표시다(보내면 InvalidArgument).
  ///   MANUAL 대상: pdf-to-text는 PDF 클립(원본 PDF를 다시 인식하고 세트를 다시 세운다 — 본인 품목이 있거나 작업이 고른 세트가 있으면
  ///   아무것도 지우지 않고 FAILED), audio-extract는 영상 Asset 또는 영상 클립(클립이면 원본 전체에서 뽑은 소리를 그 클립과 같은 구간에
  ///   오디오 클립으로 놓는다). STT를 클립에 돌리면 그 클립 구간만 인식하고 자막 클립을 그 클립 위치 기준으로 놓는다. Asset에 돌리면
  ///   그 파일이 붙은 작업마다 촬영 시각 기준으로 놓는다. 포즈도 같다.
  /// 돌릴 수 없는 run은 기록만 남기고 바로 FAILED로 돌려준다: 처리할 서버가 연결되지 않은 도구면 error_code = not_connected,
  /// 소리 없는 영상에 faster-whisper STT면 invalid_target.
  $async.Future<StartRunResponse> startRun(
          $pb.ClientContext? ctx, StartRunRequest request) =>
      _client.invoke<StartRunResponse>(
          ctx, 'RunService', 'StartRun', request, StartRunResponse());
  $async.Future<GetRunResponse> getRun(
          $pb.ClientContext? ctx, GetRunRequest request) =>
      _client.invoke<GetRunResponse>(
          ctx, 'RunService', 'GetRun', request, GetRunResponse());

  /// 대상 기준 run 목록(생성 순). 화면 재진입 시 진행 중 run 복구용으로 짧게 폴링한다.
  $async.Future<ListRunsResponse> listRuns(
          $pb.ClientContext? ctx, ListRunsRequest request) =>
      _client.invoke<ListRunsResponse>(
          ctx, 'RunService', 'ListRuns', request, ListRunsResponse());
  $async.Future<CancelRunResponse> cancelRun(
          $pb.ClientContext? ctx, CancelRunRequest request) =>
      _client.invoke<CancelRunResponse>(
          ctx, 'RunService', 'CancelRun', request, CancelRunResponse());

  /// 서버 전체 대기열 — 기다리는(QUEUED) · 도는(RUNNING) run 전부(단계 · 도구)와 대기열마다 동시 수. 큐 모니터링 화면용으로 짧게 폴링한다.
  /// 끝난 run은 ListRuns로 본다.
  $async.Future<GetQueueResponse> getQueue(
          $pb.ClientContext? ctx, GetQueueRequest request) =>
      _client.invoke<GetQueueResponse>(
          ctx, 'RunService', 'GetQueue', request, GetQueueResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
