// This is a generated file - do not edit.
//
// Generated from mediatag/tool/v1/tool.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/timestamp.pb.dart' as $0;
import '../../asset/v1/asset.pbenum.dart' as $1;
import 'tool.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'tool.pbenum.dart';

class Tool extends $pb.GeneratedMessage {
  factory Tool({
    $core.String? toolId,
    $core.String? name,
    $core.String? endpoint,
    $core.String? remoteModelName,
    $core.String? toolVersion,
    ToolPattern? pattern,
    $core.String? payloadKind,
    $core.Iterable<$1.AssetKind>? supportedInputKinds,
    ToolUnit? unit,
    ToolDispatch? dispatch,
    $core.bool? enabled,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    if (name != null) result.name = name;
    if (endpoint != null) result.endpoint = endpoint;
    if (remoteModelName != null) result.remoteModelName = remoteModelName;
    if (toolVersion != null) result.toolVersion = toolVersion;
    if (pattern != null) result.pattern = pattern;
    if (payloadKind != null) result.payloadKind = payloadKind;
    if (supportedInputKinds != null)
      result.supportedInputKinds.addAll(supportedInputKinds);
    if (unit != null) result.unit = unit;
    if (dispatch != null) result.dispatch = dispatch;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  Tool._();

  factory Tool.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tool.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tool',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..aOS(4, _omitFieldNames ? '' : 'remoteModelName')
    ..aOS(5, _omitFieldNames ? '' : 'toolVersion')
    ..e<ToolPattern>(6, _omitFieldNames ? '' : 'pattern', $pb.PbFieldType.OE,
        defaultOrMaker: ToolPattern.TOOL_PATTERN_UNSPECIFIED,
        valueOf: ToolPattern.valueOf,
        enumValues: ToolPattern.values)
    ..aOS(7, _omitFieldNames ? '' : 'payloadKind')
    ..pc<$1.AssetKind>(
        8, _omitFieldNames ? '' : 'supportedInputKinds', $pb.PbFieldType.KE,
        valueOf: $1.AssetKind.valueOf,
        enumValues: $1.AssetKind.values,
        defaultEnumValue: $1.AssetKind.ASSET_KIND_UNSPECIFIED)
    ..e<ToolUnit>(9, _omitFieldNames ? '' : 'unit', $pb.PbFieldType.OE,
        defaultOrMaker: ToolUnit.TOOL_UNIT_UNSPECIFIED,
        valueOf: ToolUnit.valueOf,
        enumValues: ToolUnit.values)
    ..e<ToolDispatch>(10, _omitFieldNames ? '' : 'dispatch', $pb.PbFieldType.OE,
        defaultOrMaker: ToolDispatch.TOOL_DISPATCH_UNSPECIFIED,
        valueOf: ToolDispatch.valueOf,
        enumValues: ToolDispatch.values)
    ..aOB(11, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tool clone() => Tool()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tool copyWith(void Function(Tool) updates) =>
      super.copyWith((message) => updates(message as Tool)) as Tool;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tool create() => Tool._();
  @$core.override
  Tool createEmptyInstance() => create();
  static $pb.PbList<Tool> createRepeated() => $pb.PbList<Tool>();
  @$core.pragma('dart2js:noInline')
  static Tool getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tool>(create);
  static Tool? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set endpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndpoint() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get remoteModelName => $_getSZ(3);
  @$pb.TagNumber(4)
  set remoteModelName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRemoteModelName() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemoteModelName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get toolVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set toolVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToolVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  ToolPattern get pattern => $_getN(5);
  @$pb.TagNumber(6)
  set pattern(ToolPattern value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPattern() => $_has(5);
  @$pb.TagNumber(6)
  void clearPattern() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get payloadKind => $_getSZ(6);
  @$pb.TagNumber(7)
  set payloadKind($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPayloadKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearPayloadKind() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$1.AssetKind> get supportedInputKinds => $_getList(7);

  @$pb.TagNumber(9)
  ToolUnit get unit => $_getN(8);
  @$pb.TagNumber(9)
  set unit(ToolUnit value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUnit() => $_has(8);
  @$pb.TagNumber(9)
  void clearUnit() => $_clearField(9);

  @$pb.TagNumber(10)
  ToolDispatch get dispatch => $_getN(9);
  @$pb.TagNumber(10)
  set dispatch(ToolDispatch value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDispatch() => $_has(9);
  @$pb.TagNumber(10)
  void clearDispatch() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get enabled => $_getBF(10);
  @$pb.TagNumber(11)
  set enabled($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEnabled() => $_has(10);
  @$pb.TagNumber(11)
  void clearEnabled() => $_clearField(11);
}

class ToolRun extends $pb.GeneratedMessage {
  factory ToolRun({
    $core.String? runId,
    $core.String? toolId,
    RunTrigger? trigger,
    $core.String? targetId,
    RunStatus? status,
    $core.String? externalJobId,
    $core.String? errorCode,
    $core.String? errorMessage,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $core.int? queuePosition,
    $core.int? queueLength,
    $core.double? progressPercent,
    $core.int? estimatedRemainingSeconds,
    $core.int? attemptCount,
    $core.Iterable<$core.String>? outputAssetIds,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (toolId != null) result.toolId = toolId;
    if (trigger != null) result.trigger = trigger;
    if (targetId != null) result.targetId = targetId;
    if (status != null) result.status = status;
    if (externalJobId != null) result.externalJobId = externalJobId;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (queuePosition != null) result.queuePosition = queuePosition;
    if (queueLength != null) result.queueLength = queueLength;
    if (progressPercent != null) result.progressPercent = progressPercent;
    if (estimatedRemainingSeconds != null)
      result.estimatedRemainingSeconds = estimatedRemainingSeconds;
    if (attemptCount != null) result.attemptCount = attemptCount;
    if (outputAssetIds != null) result.outputAssetIds.addAll(outputAssetIds);
    return result;
  }

  ToolRun._();

  factory ToolRun.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolRun.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolRun',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'toolId')
    ..e<RunTrigger>(3, _omitFieldNames ? '' : 'trigger', $pb.PbFieldType.OE,
        defaultOrMaker: RunTrigger.RUN_TRIGGER_UNSPECIFIED,
        valueOf: RunTrigger.valueOf,
        enumValues: RunTrigger.values)
    ..aOS(4, _omitFieldNames ? '' : 'targetId')
    ..e<RunStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: RunStatus.RUN_STATUS_UNSPECIFIED,
        valueOf: RunStatus.valueOf,
        enumValues: RunStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'externalJobId')
    ..aOS(7, _omitFieldNames ? '' : 'errorCode')
    ..aOS(8, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..a<$core.int>(
        11, _omitFieldNames ? '' : 'queuePosition', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'queueLength', $pb.PbFieldType.O3)
    ..a<$core.double>(
        13, _omitFieldNames ? '' : 'progressPercent', $pb.PbFieldType.OD)
    ..a<$core.int>(14, _omitFieldNames ? '' : 'estimatedRemainingSeconds',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        15, _omitFieldNames ? '' : 'attemptCount', $pb.PbFieldType.O3)
    ..pPS(16, _omitFieldNames ? '' : 'outputAssetIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolRun clone() => ToolRun()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolRun copyWith(void Function(ToolRun) updates) =>
      super.copyWith((message) => updates(message as ToolRun)) as ToolRun;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolRun create() => ToolRun._();
  @$core.override
  ToolRun createEmptyInstance() => create();
  static $pb.PbList<ToolRun> createRepeated() => $pb.PbList<ToolRun>();
  @$core.pragma('dart2js:noInline')
  static ToolRun getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToolRun>(create);
  static ToolRun? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolId() => $_clearField(2);

  @$pb.TagNumber(3)
  RunTrigger get trigger => $_getN(2);
  @$pb.TagNumber(3)
  set trigger(RunTrigger value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTrigger() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrigger() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetId() => $_clearField(4);

  @$pb.TagNumber(5)
  RunStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(RunStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get externalJobId => $_getSZ(5);
  @$pb.TagNumber(6)
  set externalJobId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExternalJobId() => $_has(5);
  @$pb.TagNumber(6)
  void clearExternalJobId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get errorCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set errorCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorCode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get errorMessage => $_getSZ(7);
  @$pb.TagNumber(8)
  set errorMessage($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasErrorMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearErrorMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureUpdatedAt() => $_ensure(9);

  /// 아래는 저장하지 않는 실행 중 파생 값(tacit-tag 설계-23 §7.1)
  @$pb.TagNumber(11)
  $core.int get queuePosition => $_getIZ(10);
  @$pb.TagNumber(11)
  set queuePosition($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasQueuePosition() => $_has(10);
  @$pb.TagNumber(11)
  void clearQueuePosition() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get queueLength => $_getIZ(11);
  @$pb.TagNumber(12)
  set queueLength($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasQueueLength() => $_has(11);
  @$pb.TagNumber(12)
  void clearQueueLength() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get progressPercent => $_getN(12);
  @$pb.TagNumber(13)
  set progressPercent($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasProgressPercent() => $_has(12);
  @$pb.TagNumber(13)
  void clearProgressPercent() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get estimatedRemainingSeconds => $_getIZ(13);
  @$pb.TagNumber(14)
  set estimatedRemainingSeconds($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasEstimatedRemainingSeconds() => $_has(13);
  @$pb.TagNumber(14)
  void clearEstimatedRemainingSeconds() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get attemptCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set attemptCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAttemptCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearAttemptCount() => $_clearField(15);

  /// 이 실행이 만든 파생 Asset(provenance.run_id로 찾는다, 저장하지 않음)
  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get outputAssetIds => $_getList(15);
}

class ListToolsRequest extends $pb.GeneratedMessage {
  factory ListToolsRequest() => create();

  ListToolsRequest._();

  factory ListToolsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListToolsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListToolsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListToolsRequest clone() => ListToolsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListToolsRequest copyWith(void Function(ListToolsRequest) updates) =>
      super.copyWith((message) => updates(message as ListToolsRequest))
          as ListToolsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListToolsRequest create() => ListToolsRequest._();
  @$core.override
  ListToolsRequest createEmptyInstance() => create();
  static $pb.PbList<ListToolsRequest> createRepeated() =>
      $pb.PbList<ListToolsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListToolsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListToolsRequest>(create);
  static ListToolsRequest? _defaultInstance;
}

class ListToolsResponse extends $pb.GeneratedMessage {
  factory ListToolsResponse({
    $core.Iterable<Tool>? tools,
  }) {
    final result = create();
    if (tools != null) result.tools.addAll(tools);
    return result;
  }

  ListToolsResponse._();

  factory ListToolsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListToolsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListToolsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..pc<Tool>(1, _omitFieldNames ? '' : 'tools', $pb.PbFieldType.PM,
        subBuilder: Tool.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListToolsResponse clone() => ListToolsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListToolsResponse copyWith(void Function(ListToolsResponse) updates) =>
      super.copyWith((message) => updates(message as ListToolsResponse))
          as ListToolsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListToolsResponse create() => ListToolsResponse._();
  @$core.override
  ListToolsResponse createEmptyInstance() => create();
  static $pb.PbList<ListToolsResponse> createRepeated() =>
      $pb.PbList<ListToolsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListToolsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListToolsResponse>(create);
  static ListToolsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Tool> get tools => $_getList(0);
}

class CreateToolRequest extends $pb.GeneratedMessage {
  factory CreateToolRequest({
    Tool? tool,
  }) {
    final result = create();
    if (tool != null) result.tool = tool;
    return result;
  }

  CreateToolRequest._();

  factory CreateToolRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateToolRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateToolRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<Tool>(1, _omitFieldNames ? '' : 'tool', subBuilder: Tool.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateToolRequest clone() => CreateToolRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateToolRequest copyWith(void Function(CreateToolRequest) updates) =>
      super.copyWith((message) => updates(message as CreateToolRequest))
          as CreateToolRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateToolRequest create() => CreateToolRequest._();
  @$core.override
  CreateToolRequest createEmptyInstance() => create();
  static $pb.PbList<CreateToolRequest> createRepeated() =>
      $pb.PbList<CreateToolRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateToolRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateToolRequest>(create);
  static CreateToolRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Tool get tool => $_getN(0);
  @$pb.TagNumber(1)
  set tool(Tool value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTool() => $_has(0);
  @$pb.TagNumber(1)
  void clearTool() => $_clearField(1);
  @$pb.TagNumber(1)
  Tool ensureTool() => $_ensure(0);
}

class CreateToolResponse extends $pb.GeneratedMessage {
  factory CreateToolResponse({
    Tool? tool,
  }) {
    final result = create();
    if (tool != null) result.tool = tool;
    return result;
  }

  CreateToolResponse._();

  factory CreateToolResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateToolResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateToolResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<Tool>(1, _omitFieldNames ? '' : 'tool', subBuilder: Tool.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateToolResponse clone() => CreateToolResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateToolResponse copyWith(void Function(CreateToolResponse) updates) =>
      super.copyWith((message) => updates(message as CreateToolResponse))
          as CreateToolResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateToolResponse create() => CreateToolResponse._();
  @$core.override
  CreateToolResponse createEmptyInstance() => create();
  static $pb.PbList<CreateToolResponse> createRepeated() =>
      $pb.PbList<CreateToolResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateToolResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateToolResponse>(create);
  static CreateToolResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tool get tool => $_getN(0);
  @$pb.TagNumber(1)
  set tool(Tool value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTool() => $_has(0);
  @$pb.TagNumber(1)
  void clearTool() => $_clearField(1);
  @$pb.TagNumber(1)
  Tool ensureTool() => $_ensure(0);
}

class UpdateToolRequest extends $pb.GeneratedMessage {
  factory UpdateToolRequest({
    Tool? tool,
  }) {
    final result = create();
    if (tool != null) result.tool = tool;
    return result;
  }

  UpdateToolRequest._();

  factory UpdateToolRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateToolRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateToolRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<Tool>(1, _omitFieldNames ? '' : 'tool', subBuilder: Tool.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateToolRequest clone() => UpdateToolRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateToolRequest copyWith(void Function(UpdateToolRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateToolRequest))
          as UpdateToolRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateToolRequest create() => UpdateToolRequest._();
  @$core.override
  UpdateToolRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateToolRequest> createRepeated() =>
      $pb.PbList<UpdateToolRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateToolRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateToolRequest>(create);
  static UpdateToolRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Tool get tool => $_getN(0);
  @$pb.TagNumber(1)
  set tool(Tool value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTool() => $_has(0);
  @$pb.TagNumber(1)
  void clearTool() => $_clearField(1);
  @$pb.TagNumber(1)
  Tool ensureTool() => $_ensure(0);
}

class UpdateToolResponse extends $pb.GeneratedMessage {
  factory UpdateToolResponse({
    Tool? tool,
  }) {
    final result = create();
    if (tool != null) result.tool = tool;
    return result;
  }

  UpdateToolResponse._();

  factory UpdateToolResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateToolResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateToolResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<Tool>(1, _omitFieldNames ? '' : 'tool', subBuilder: Tool.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateToolResponse clone() => UpdateToolResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateToolResponse copyWith(void Function(UpdateToolResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateToolResponse))
          as UpdateToolResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateToolResponse create() => UpdateToolResponse._();
  @$core.override
  UpdateToolResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateToolResponse> createRepeated() =>
      $pb.PbList<UpdateToolResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateToolResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateToolResponse>(create);
  static UpdateToolResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tool get tool => $_getN(0);
  @$pb.TagNumber(1)
  set tool(Tool value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTool() => $_has(0);
  @$pb.TagNumber(1)
  void clearTool() => $_clearField(1);
  @$pb.TagNumber(1)
  Tool ensureTool() => $_ensure(0);
}

class DeleteToolRequest extends $pb.GeneratedMessage {
  factory DeleteToolRequest({
    $core.String? toolId,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    return result;
  }

  DeleteToolRequest._();

  factory DeleteToolRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteToolRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteToolRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteToolRequest clone() => DeleteToolRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteToolRequest copyWith(void Function(DeleteToolRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteToolRequest))
          as DeleteToolRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteToolRequest create() => DeleteToolRequest._();
  @$core.override
  DeleteToolRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteToolRequest> createRepeated() =>
      $pb.PbList<DeleteToolRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteToolRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteToolRequest>(create);
  static DeleteToolRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolId() => $_clearField(1);
}

class DeleteToolResponse extends $pb.GeneratedMessage {
  factory DeleteToolResponse() => create();

  DeleteToolResponse._();

  factory DeleteToolResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteToolResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteToolResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteToolResponse clone() => DeleteToolResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteToolResponse copyWith(void Function(DeleteToolResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteToolResponse))
          as DeleteToolResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteToolResponse create() => DeleteToolResponse._();
  @$core.override
  DeleteToolResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteToolResponse> createRepeated() =>
      $pb.PbList<DeleteToolResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteToolResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteToolResponse>(create);
  static DeleteToolResponse? _defaultInstance;
}

class StartRunRequest extends $pb.GeneratedMessage {
  factory StartRunRequest({
    $core.String? toolId,
    RunTrigger? trigger,
    $core.String? targetId,
  }) {
    final result = create();
    if (toolId != null) result.toolId = toolId;
    if (trigger != null) result.trigger = trigger;
    if (targetId != null) result.targetId = targetId;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolId')
    ..e<RunTrigger>(2, _omitFieldNames ? '' : 'trigger', $pb.PbFieldType.OE,
        defaultOrMaker: RunTrigger.RUN_TRIGGER_UNSPECIFIED,
        valueOf: RunTrigger.valueOf,
        enumValues: RunTrigger.values)
    ..aOS(3, _omitFieldNames ? '' : 'targetId')
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
  $core.String get toolId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolId($core.String value) => $_setString(0, value);
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
  $core.String get targetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetId() => $_clearField(3);
}

class StartRunResponse extends $pb.GeneratedMessage {
  factory StartRunResponse({
    ToolRun? run,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<ToolRun>(1, _omitFieldNames ? '' : 'run', subBuilder: ToolRun.create)
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
  ToolRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(ToolRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  ToolRun ensureRun() => $_ensure(0);
}

class GetRunRequest extends $pb.GeneratedMessage {
  factory GetRunRequest({
    $core.String? runId,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
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
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
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
    ToolRun? run,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<ToolRun>(1, _omitFieldNames ? '' : 'run', subBuilder: ToolRun.create)
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
  ToolRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(ToolRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  ToolRun ensureRun() => $_ensure(0);
}

class ListRunsRequest extends $pb.GeneratedMessage {
  factory ListRunsRequest({
    $core.String? targetId,
  }) {
    final result = create();
    if (targetId != null) result.targetId = targetId;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetId')
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

  /// 대상(Timeline·Clip·Asset) 기준. Timeline을 주면 그 타임라인 Clip 대상 실행도 포함한다.
  @$pb.TagNumber(1)
  $core.String get targetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetId() => $_clearField(1);
}

class ListRunsResponse extends $pb.GeneratedMessage {
  factory ListRunsResponse({
    $core.Iterable<ToolRun>? runs,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..pc<ToolRun>(1, _omitFieldNames ? '' : 'runs', $pb.PbFieldType.PM,
        subBuilder: ToolRun.create)
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
  $pb.PbList<ToolRun> get runs => $_getList(0);
}

class CancelRunRequest extends $pb.GeneratedMessage {
  factory CancelRunRequest({
    $core.String? runId,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
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
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);
}

class CancelRunResponse extends $pb.GeneratedMessage {
  factory CancelRunResponse({
    ToolRun? run,
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.tool.v1'),
      createEmptyInstance: create)
    ..aOM<ToolRun>(1, _omitFieldNames ? '' : 'run', subBuilder: ToolRun.create)
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
  ToolRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(ToolRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  ToolRun ensureRun() => $_ensure(0);
}

class ToolServiceApi {
  final $pb.RpcClient _client;

  ToolServiceApi(this._client);

  $async.Future<ListToolsResponse> listTools(
          $pb.ClientContext? ctx, ListToolsRequest request) =>
      _client.invoke<ListToolsResponse>(
          ctx, 'ToolService', 'ListTools', request, ListToolsResponse());
  $async.Future<CreateToolResponse> createTool(
          $pb.ClientContext? ctx, CreateToolRequest request) =>
      _client.invoke<CreateToolResponse>(
          ctx, 'ToolService', 'CreateTool', request, CreateToolResponse());

  /// 도구 전체 교체. tool.tool_id 필수
  $async.Future<UpdateToolResponse> updateTool(
          $pb.ClientContext? ctx, UpdateToolRequest request) =>
      _client.invoke<UpdateToolResponse>(
          ctx, 'ToolService', 'UpdateTool', request, UpdateToolResponse());

  /// 실행 이력이 있으면 FailedPrecondition — 대신 enabled=false로 끈다.
  $async.Future<DeleteToolResponse> deleteTool(
          $pb.ClientContext? ctx, DeleteToolRequest request) =>
      _client.invoke<DeleteToolResponse>(
          ctx, 'ToolService', 'DeleteTool', request, DeleteToolResponse());

  /// trigger는 MANUAL(Clip 하나 재계산 또는 Asset에 대한 요청)·AUTO_TAGGING(Timeline 전체)만 받는다.
  /// ASSET_UPLOADED는 서버(적재기)가 등록 시점에 스스로 만든다. 내장 도구(endpoint가 빈 도구, 예: audio-extract)는
  /// 서버가 바로 실행하고, 외부 도구는 디스패처가 생길 때까지 queued로 남는다. 결과는 GetRun(wait_for_terminal)의
  /// output_asset_ids.
  $async.Future<StartRunResponse> startRun(
          $pb.ClientContext? ctx, StartRunRequest request) =>
      _client.invoke<StartRunResponse>(
          ctx, 'ToolService', 'StartRun', request, StartRunResponse());
  $async.Future<GetRunResponse> getRun(
          $pb.ClientContext? ctx, GetRunRequest request) =>
      _client.invoke<GetRunResponse>(
          ctx, 'ToolService', 'GetRun', request, GetRunResponse());

  /// 화면 재진입 시 진행 중 실행 복구용. 짧은 폴링으로 주기 호출한다.
  $async.Future<ListRunsResponse> listRuns(
          $pb.ClientContext? ctx, ListRunsRequest request) =>
      _client.invoke<ListRunsResponse>(
          ctx, 'ToolService', 'ListRuns', request, ListRunsResponse());
  $async.Future<CancelRunResponse> cancelRun(
          $pb.ClientContext? ctx, CancelRunRequest request) =>
      _client.invoke<CancelRunResponse>(
          ctx, 'ToolService', 'CancelRun', request, CancelRunResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
