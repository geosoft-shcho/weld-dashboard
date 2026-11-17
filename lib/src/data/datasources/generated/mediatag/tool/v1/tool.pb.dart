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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/field_mask.pb.dart' as $0;
import '../../asset/v1/asset.pbenum.dart' as $1;
import 'tool.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'tool.pbenum.dart';

class Tool extends $pb.GeneratedMessage {
  factory Tool({
    $fixnum.Int64? toolId,
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
    $core.String? description,
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
    if (description != null) result.description = description;
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
    ..aInt64(1, _omitFieldNames ? '' : 'toolId')
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
    ..aOS(12, _omitFieldNames ? '' : 'description')
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
  $fixnum.Int64 get toolId => $_getI64(0);
  @$pb.TagNumber(1)
  set toolId($fixnum.Int64 value) => $_setInt64(0, value);
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

  @$pb.TagNumber(12)
  $core.String get description => $_getSZ(11);
  @$pb.TagNumber(12)
  set description($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDescription() => $_has(11);
  @$pb.TagNumber(12)
  void clearDescription() => $_clearField(12);
}

class ListToolsRequest extends $pb.GeneratedMessage {
  factory ListToolsRequest({
    $core.bool? includeDisabled,
  }) {
    final result = create();
    if (includeDisabled != null) result.includeDisabled = includeDisabled;
    return result;
  }

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
    ..aOB(1, _omitFieldNames ? '' : 'includeDisabled')
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

  @$pb.TagNumber(1)
  $core.bool get includeDisabled => $_getBF(0);
  @$pb.TagNumber(1)
  set includeDisabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeDisabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeDisabled() => $_clearField(1);
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
    $0.FieldMask? updateMask,
  }) {
    final result = create();
    if (tool != null) result.tool = tool;
    if (updateMask != null) result.updateMask = updateMask;
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
    ..aOM<$0.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $0.FieldMask.create)
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

  @$pb.TagNumber(2)
  $0.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($0.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.FieldMask ensureUpdateMask() => $_ensure(1);
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
    $fixnum.Int64? toolId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'toolId')
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
  $fixnum.Int64 get toolId => $_getI64(0);
  @$pb.TagNumber(1)
  set toolId($fixnum.Int64 value) => $_setInt64(0, value);
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

class ToolServiceApi {
  final $pb.RpcClient _client;

  ToolServiceApi(this._client);

  /// 도구 목록. 기본은 켜진(enabled) 도구만 — 화면의 도구 고르기용. 꺼진 도구까지 받으려면 include_disabled를 켠다
  /// (도구 관리 화면, 실행 이력·클립 출처의 도구 이름 찾기).
  $async.Future<ListToolsResponse> listTools(
          $pb.ClientContext? ctx, ListToolsRequest request) =>
      _client.invoke<ListToolsResponse>(
          ctx, 'ToolService', 'ListTools', request, ListToolsResponse());
  $async.Future<CreateToolResponse> createTool(
          $pb.ClientContext? ctx, CreateToolRequest request) =>
      _client.invoke<CreateToolResponse>(
          ctx, 'ToolService', 'CreateTool', request, CreateToolResponse());

  /// 도구를 고친다(update_mask에 든 칸만 — 다른 수정 RPC와 같다). tool.tool_id 필수. 켜고 끄기는 update_mask "enabled".
  /// 고칠 수 있는 칸: name, endpoint, remote_model_name, tool_version, pattern, payload_kind, supported_input_kinds, unit,
  /// dispatch, enabled.
  $async.Future<UpdateToolResponse> updateTool(
          $pb.ClientContext? ctx, UpdateToolRequest request) =>
      _client.invoke<UpdateToolResponse>(
          ctx, 'ToolService', 'UpdateTool', request, UpdateToolResponse());

  /// 행을 실제로 지운다(되돌릴 수 없음). 실행 이력이 있으면 FailedPrecondition — 대신 enabled=false로 끈다.
  $async.Future<DeleteToolResponse> deleteTool(
          $pb.ClientContext? ctx, DeleteToolRequest request) =>
      _client.invoke<DeleteToolResponse>(
          ctx, 'ToolService', 'DeleteTool', request, DeleteToolResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
