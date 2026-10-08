// This is a generated file - do not edit.
//
// Generated from mediatag/asset/v1/asset.proto.

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

import '../../../google/protobuf/struct.pb.dart' as $0;
import '../../../google/protobuf/timestamp.pb.dart' as $1;
import 'asset.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'asset.pbenum.dart';

class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $fixnum.Int64? assetId,
    AssetKind? kind,
    $core.String? fileName,
    $core.String? sha256,
    $core.String? mimeType,
    $fixnum.Int64? sizeBytes,
    $0.Struct? properties,
    $fixnum.Int64? equipmentId,
    $1.Timestamp? collectedAt,
    $1.Timestamp? recordedAt,
    Provenance? provenance,
    $core.String? contentUrl,
    $core.String? sourcePath,
    $fixnum.Int64? durationNs,
    $core.int? childCount,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (kind != null) result.kind = kind;
    if (fileName != null) result.fileName = fileName;
    if (sha256 != null) result.sha256 = sha256;
    if (mimeType != null) result.mimeType = mimeType;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    if (properties != null) result.properties = properties;
    if (equipmentId != null) result.equipmentId = equipmentId;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (provenance != null) result.provenance = provenance;
    if (contentUrl != null) result.contentUrl = contentUrl;
    if (sourcePath != null) result.sourcePath = sourcePath;
    if (durationNs != null) result.durationNs = durationNs;
    if (childCount != null) result.childCount = childCount;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'assetId')
    ..e<AssetKind>(2, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: AssetKind.ASSET_KIND_UNSPECIFIED,
        valueOf: AssetKind.valueOf,
        enumValues: AssetKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'fileName')
    ..aOS(4, _omitFieldNames ? '' : 'sha256')
    ..aOS(5, _omitFieldNames ? '' : 'mimeType')
    ..aInt64(6, _omitFieldNames ? '' : 'sizeBytes')
    ..aOM<$0.Struct>(7, _omitFieldNames ? '' : 'properties',
        subBuilder: $0.Struct.create)
    ..aInt64(8, _omitFieldNames ? '' : 'equipmentId')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<Provenance>(11, _omitFieldNames ? '' : 'provenance',
        subBuilder: Provenance.create)
    ..aOS(12, _omitFieldNames ? '' : 'contentUrl')
    ..aOS(13, _omitFieldNames ? '' : 'sourcePath')
    ..aInt64(14, _omitFieldNames ? '' : 'durationNs')
    ..a<$core.int>(15, _omitFieldNames ? '' : 'childCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => Asset()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  @$core.override
  Asset createEmptyInstance() => create();
  static $pb.PbList<Asset> createRepeated() => $pb.PbList<Asset>();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get assetId => $_getI64(0);
  @$pb.TagNumber(1)
  set assetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  AssetKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(AssetKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileName => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileName() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sha256 => $_getSZ(3);
  @$pb.TagNumber(4)
  set sha256($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSha256() => $_has(3);
  @$pb.TagNumber(4)
  void clearSha256() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get mimeType => $_getSZ(4);
  @$pb.TagNumber(5)
  set mimeType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMimeType() => $_has(4);
  @$pb.TagNumber(5)
  void clearMimeType() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sizeBytes => $_getI64(5);
  @$pb.TagNumber(6)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSizeBytes() => $_has(5);
  @$pb.TagNumber(6)
  void clearSizeBytes() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Struct get properties => $_getN(6);
  @$pb.TagNumber(7)
  set properties($0.Struct value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasProperties() => $_has(6);
  @$pb.TagNumber(7)
  void clearProperties() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Struct ensureProperties() => $_ensure(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get equipmentId => $_getI64(7);
  @$pb.TagNumber(8)
  set equipmentId($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEquipmentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearEquipmentId() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get collectedAt => $_getN(8);
  @$pb.TagNumber(9)
  set collectedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCollectedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCollectedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCollectedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get recordedAt => $_getN(9);
  @$pb.TagNumber(10)
  set recordedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureRecordedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  Provenance get provenance => $_getN(10);
  @$pb.TagNumber(11)
  set provenance(Provenance value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasProvenance() => $_has(10);
  @$pb.TagNumber(11)
  void clearProvenance() => $_clearField(11);
  @$pb.TagNumber(11)
  Provenance ensureProvenance() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get contentUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set contentUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasContentUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearContentUrl() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get sourcePath => $_getSZ(12);
  @$pb.TagNumber(13)
  set sourcePath($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSourcePath() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourcePath() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get durationNs => $_getI64(13);
  @$pb.TagNumber(14)
  set durationNs($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDurationNs() => $_has(13);
  @$pb.TagNumber(14)
  void clearDurationNs() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get childCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set childCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasChildCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearChildCount() => $_clearField(15);
}

/// 생성 경위. run_id·tool_id·tool_version은 셋 다 있거나 셋 다 없다(엔티티.md §6.2).
class Provenance extends $pb.GeneratedMessage {
  factory Provenance({
    $core.String? operation,
    $fixnum.Int64? runId,
    $fixnum.Int64? toolId,
    $core.String? toolVersion,
    $0.Struct? parameters,
    $fixnum.Int64? parentAssetId,
  }) {
    final result = create();
    if (operation != null) result.operation = operation;
    if (runId != null) result.runId = runId;
    if (toolId != null) result.toolId = toolId;
    if (toolVersion != null) result.toolVersion = toolVersion;
    if (parameters != null) result.parameters = parameters;
    if (parentAssetId != null) result.parentAssetId = parentAssetId;
    return result;
  }

  Provenance._();

  factory Provenance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Provenance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Provenance',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'operation')
    ..aInt64(2, _omitFieldNames ? '' : 'runId')
    ..aInt64(3, _omitFieldNames ? '' : 'toolId')
    ..aOS(4, _omitFieldNames ? '' : 'toolVersion')
    ..aOM<$0.Struct>(6, _omitFieldNames ? '' : 'parameters',
        subBuilder: $0.Struct.create)
    ..aInt64(7, _omitFieldNames ? '' : 'parentAssetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Provenance clone() => Provenance()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Provenance copyWith(void Function(Provenance) updates) =>
      super.copyWith((message) => updates(message as Provenance)) as Provenance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Provenance create() => Provenance._();
  @$core.override
  Provenance createEmptyInstance() => create();
  static $pb.PbList<Provenance> createRepeated() => $pb.PbList<Provenance>();
  @$core.pragma('dart2js:noInline')
  static Provenance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Provenance>(create);
  static Provenance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operation => $_getSZ(0);
  @$pb.TagNumber(1)
  set operation($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOperation() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperation() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get runId => $_getI64(1);
  @$pb.TagNumber(2)
  set runId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get toolId => $_getI64(2);
  @$pb.TagNumber(3)
  set toolId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toolVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set toolVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolVersion() => $_clearField(4);

  @$pb.TagNumber(6)
  $0.Struct get parameters => $_getN(4);
  @$pb.TagNumber(6)
  set parameters($0.Struct value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasParameters() => $_has(4);
  @$pb.TagNumber(6)
  void clearParameters() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Struct ensureParameters() => $_ensure(4);

  @$pb.TagNumber(7)
  $fixnum.Int64 get parentAssetId => $_getI64(5);
  @$pb.TagNumber(7)
  set parentAssetId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(7)
  $core.bool hasParentAssetId() => $_has(5);
  @$pb.TagNumber(7)
  void clearParentAssetId() => $_clearField(7);
}

class ImportAssetFromSourceRequest extends $pb.GeneratedMessage {
  factory ImportAssetFromSourceRequest({
    $core.String? sourceUrl,
  }) {
    final result = create();
    if (sourceUrl != null) result.sourceUrl = sourceUrl;
    return result;
  }

  ImportAssetFromSourceRequest._();

  factory ImportAssetFromSourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImportAssetFromSourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportAssetFromSourceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sourceUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportAssetFromSourceRequest clone() =>
      ImportAssetFromSourceRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportAssetFromSourceRequest copyWith(
          void Function(ImportAssetFromSourceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ImportAssetFromSourceRequest))
          as ImportAssetFromSourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportAssetFromSourceRequest create() =>
      ImportAssetFromSourceRequest._();
  @$core.override
  ImportAssetFromSourceRequest createEmptyInstance() => create();
  static $pb.PbList<ImportAssetFromSourceRequest> createRepeated() =>
      $pb.PbList<ImportAssetFromSourceRequest>();
  @$core.pragma('dart2js:noInline')
  static ImportAssetFromSourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportAssetFromSourceRequest>(create);
  static ImportAssetFromSourceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sourceUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set sourceUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceUrl() => $_clearField(1);
}

class ImportAssetFromSourceResponse extends $pb.GeneratedMessage {
  factory ImportAssetFromSourceResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  ImportAssetFromSourceResponse._();

  factory ImportAssetFromSourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImportAssetFromSourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportAssetFromSourceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportAssetFromSourceResponse clone() =>
      ImportAssetFromSourceResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportAssetFromSourceResponse copyWith(
          void Function(ImportAssetFromSourceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ImportAssetFromSourceResponse))
          as ImportAssetFromSourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportAssetFromSourceResponse create() =>
      ImportAssetFromSourceResponse._();
  @$core.override
  ImportAssetFromSourceResponse createEmptyInstance() => create();
  static $pb.PbList<ImportAssetFromSourceResponse> createRepeated() =>
      $pb.PbList<ImportAssetFromSourceResponse>();
  @$core.pragma('dart2js:noInline')
  static ImportAssetFromSourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportAssetFromSourceResponse>(create);
  static ImportAssetFromSourceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class ListAssetsRequest extends $pb.GeneratedMessage {
  factory ListAssetsRequest({
    $core.int? pageSize,
    $core.String? pageToken,
    AssetKind? kind,
    $fixnum.Int64? parentAssetId,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (kind != null) result.kind = kind;
    if (parentAssetId != null) result.parentAssetId = parentAssetId;
    return result;
  }

  ListAssetsRequest._();

  factory ListAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssetsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..e<AssetKind>(3, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: AssetKind.ASSET_KIND_UNSPECIFIED,
        valueOf: AssetKind.valueOf,
        enumValues: AssetKind.values)
    ..aInt64(4, _omitFieldNames ? '' : 'parentAssetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsRequest clone() => ListAssetsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsRequest copyWith(void Function(ListAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAssetsRequest))
          as ListAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetsRequest create() => ListAssetsRequest._();
  @$core.override
  ListAssetsRequest createEmptyInstance() => create();
  static $pb.PbList<ListAssetsRequest> createRepeated() =>
      $pb.PbList<ListAssetsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssetsRequest>(create);
  static ListAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  AssetKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(AssetKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get parentAssetId => $_getI64(3);
  @$pb.TagNumber(4)
  set parentAssetId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentAssetId() => $_clearField(4);
}

class ListAssetsResponse extends $pb.GeneratedMessage {
  factory ListAssetsResponse({
    $core.Iterable<Asset>? assets,
    $core.String? nextPageToken,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListAssetsResponse._();

  factory ListAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssetsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..pc<Asset>(1, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM,
        subBuilder: Asset.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsResponse clone() => ListAssetsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsResponse copyWith(void Function(ListAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAssetsResponse))
          as ListAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetsResponse create() => ListAssetsResponse._();
  @$core.override
  ListAssetsResponse createEmptyInstance() => create();
  static $pb.PbList<ListAssetsResponse> createRepeated() =>
      $pb.PbList<ListAssetsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssetsResponse>(create);
  static ListAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class GetAssetRequest extends $pb.GeneratedMessage {
  factory GetAssetRequest({
    $fixnum.Int64? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  GetAssetRequest._();

  factory GetAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetRequest clone() => GetAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetRequest copyWith(void Function(GetAssetRequest) updates) =>
      super.copyWith((message) => updates(message as GetAssetRequest))
          as GetAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetRequest create() => GetAssetRequest._();
  @$core.override
  GetAssetRequest createEmptyInstance() => create();
  static $pb.PbList<GetAssetRequest> createRepeated() =>
      $pb.PbList<GetAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetRequest>(create);
  static GetAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get assetId => $_getI64(0);
  @$pb.TagNumber(1)
  set assetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class GetAssetResponse extends $pb.GeneratedMessage {
  factory GetAssetResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  GetAssetResponse._();

  factory GetAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetResponse clone() => GetAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetResponse copyWith(void Function(GetAssetResponse) updates) =>
      super.copyWith((message) => updates(message as GetAssetResponse))
          as GetAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetResponse create() => GetAssetResponse._();
  @$core.override
  GetAssetResponse createEmptyInstance() => create();
  static $pb.PbList<GetAssetResponse> createRepeated() =>
      $pb.PbList<GetAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetResponse>(create);
  static GetAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class DeleteAssetRequest extends $pb.GeneratedMessage {
  factory DeleteAssetRequest({
    $fixnum.Int64? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  DeleteAssetRequest._();

  factory DeleteAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAssetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAssetRequest clone() => DeleteAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAssetRequest copyWith(void Function(DeleteAssetRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteAssetRequest))
          as DeleteAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAssetRequest create() => DeleteAssetRequest._();
  @$core.override
  DeleteAssetRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteAssetRequest> createRepeated() =>
      $pb.PbList<DeleteAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAssetRequest>(create);
  static DeleteAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get assetId => $_getI64(0);
  @$pb.TagNumber(1)
  set assetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class DeleteAssetResponse extends $pb.GeneratedMessage {
  factory DeleteAssetResponse() => create();

  DeleteAssetResponse._();

  factory DeleteAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAssetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAssetResponse clone() => DeleteAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAssetResponse copyWith(void Function(DeleteAssetResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteAssetResponse))
          as DeleteAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAssetResponse create() => DeleteAssetResponse._();
  @$core.override
  DeleteAssetResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteAssetResponse> createRepeated() =>
      $pb.PbList<DeleteAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAssetResponse>(create);
  static DeleteAssetResponse? _defaultInstance;
}

class ListDuplicateAssetsRequest extends $pb.GeneratedMessage {
  factory ListDuplicateAssetsRequest({
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListDuplicateAssetsRequest._();

  factory ListDuplicateAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDuplicateAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDuplicateAssetsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateAssetsRequest clone() =>
      ListDuplicateAssetsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateAssetsRequest copyWith(
          void Function(ListDuplicateAssetsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListDuplicateAssetsRequest))
          as ListDuplicateAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDuplicateAssetsRequest create() => ListDuplicateAssetsRequest._();
  @$core.override
  ListDuplicateAssetsRequest createEmptyInstance() => create();
  static $pb.PbList<ListDuplicateAssetsRequest> createRepeated() =>
      $pb.PbList<ListDuplicateAssetsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDuplicateAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDuplicateAssetsRequest>(create);
  static ListDuplicateAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => $_clearField(2);
}

class ListDuplicateAssetsResponse extends $pb.GeneratedMessage {
  factory ListDuplicateAssetsResponse({
    $core.Iterable<DuplicateGroup>? groups,
    $core.String? nextPageToken,
  }) {
    final result = create();
    if (groups != null) result.groups.addAll(groups);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListDuplicateAssetsResponse._();

  factory ListDuplicateAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDuplicateAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDuplicateAssetsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..pc<DuplicateGroup>(1, _omitFieldNames ? '' : 'groups', $pb.PbFieldType.PM,
        subBuilder: DuplicateGroup.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateAssetsResponse clone() =>
      ListDuplicateAssetsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateAssetsResponse copyWith(
          void Function(ListDuplicateAssetsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDuplicateAssetsResponse))
          as ListDuplicateAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDuplicateAssetsResponse create() =>
      ListDuplicateAssetsResponse._();
  @$core.override
  ListDuplicateAssetsResponse createEmptyInstance() => create();
  static $pb.PbList<ListDuplicateAssetsResponse> createRepeated() =>
      $pb.PbList<ListDuplicateAssetsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDuplicateAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDuplicateAssetsResponse>(create);
  static ListDuplicateAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DuplicateGroup> get groups => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

/// 같은 sha256의 Asset들. 이름·원본 위치·첨부가 서로 다를 수 있다.
class DuplicateGroup extends $pb.GeneratedMessage {
  factory DuplicateGroup({
    $core.String? sha256,
    $core.Iterable<Asset>? assets,
  }) {
    final result = create();
    if (sha256 != null) result.sha256 = sha256;
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  DuplicateGroup._();

  factory DuplicateGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DuplicateGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateGroup',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sha256')
    ..pc<Asset>(2, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM,
        subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateGroup clone() => DuplicateGroup()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateGroup copyWith(void Function(DuplicateGroup) updates) =>
      super.copyWith((message) => updates(message as DuplicateGroup))
          as DuplicateGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DuplicateGroup create() => DuplicateGroup._();
  @$core.override
  DuplicateGroup createEmptyInstance() => create();
  static $pb.PbList<DuplicateGroup> createRepeated() =>
      $pb.PbList<DuplicateGroup>();
  @$core.pragma('dart2js:noInline')
  static DuplicateGroup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DuplicateGroup>(create);
  static DuplicateGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sha256 => $_getSZ(0);
  @$pb.TagNumber(1)
  set sha256($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSha256() => $_has(0);
  @$pb.TagNumber(1)
  void clearSha256() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Asset> get assets => $_getList(1);
}

class JobAsset extends $pb.GeneratedMessage {
  factory JobAsset({
    Asset? asset,
    $fixnum.Int64? passId,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    if (passId != null) result.passId = passId;
    return result;
  }

  JobAsset._();

  factory JobAsset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JobAsset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JobAsset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..aInt64(2, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobAsset clone() => JobAsset()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobAsset copyWith(void Function(JobAsset) updates) =>
      super.copyWith((message) => updates(message as JobAsset)) as JobAsset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobAsset create() => JobAsset._();
  @$core.override
  JobAsset createEmptyInstance() => create();
  static $pb.PbList<JobAsset> createRepeated() => $pb.PbList<JobAsset>();
  @$core.pragma('dart2js:noInline')
  static JobAsset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobAsset>(create);
  static JobAsset? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get passId => $_getI64(1);
  @$pb.TagNumber(2)
  set passId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassId() => $_clearField(2);
}

class ListJobAssetsRequest extends $pb.GeneratedMessage {
  factory ListJobAssetsRequest({
    $fixnum.Int64? jobId,
    $fixnum.Int64? passId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (passId != null) result.passId = passId;
    return result;
  }

  ListJobAssetsRequest._();

  factory ListJobAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJobAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobAssetsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aInt64(2, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobAssetsRequest clone() =>
      ListJobAssetsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobAssetsRequest copyWith(void Function(ListJobAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListJobAssetsRequest))
          as ListJobAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobAssetsRequest create() => ListJobAssetsRequest._();
  @$core.override
  ListJobAssetsRequest createEmptyInstance() => create();
  static $pb.PbList<ListJobAssetsRequest> createRepeated() =>
      $pb.PbList<ListJobAssetsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListJobAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJobAssetsRequest>(create);
  static ListJobAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobId => $_getI64(0);
  @$pb.TagNumber(1)
  set jobId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  /// 설정하면 그 패스의 첨부만. 0이면 작업 공용 첨부만.
  @$pb.TagNumber(2)
  $fixnum.Int64 get passId => $_getI64(1);
  @$pb.TagNumber(2)
  set passId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassId() => $_clearField(2);
}

class ListJobAssetsResponse extends $pb.GeneratedMessage {
  factory ListJobAssetsResponse({
    $core.Iterable<JobAsset>? assets,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  ListJobAssetsResponse._();

  factory ListJobAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListJobAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobAssetsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..pc<JobAsset>(1, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM,
        subBuilder: JobAsset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobAssetsResponse clone() =>
      ListJobAssetsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobAssetsResponse copyWith(
          void Function(ListJobAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListJobAssetsResponse))
          as ListJobAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobAssetsResponse create() => ListJobAssetsResponse._();
  @$core.override
  ListJobAssetsResponse createEmptyInstance() => create();
  static $pb.PbList<ListJobAssetsResponse> createRepeated() =>
      $pb.PbList<ListJobAssetsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListJobAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListJobAssetsResponse>(create);
  static ListJobAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<JobAsset> get assets => $_getList(0);
}

class AttachAssetRequest extends $pb.GeneratedMessage {
  factory AttachAssetRequest({
    $fixnum.Int64? jobId,
    $fixnum.Int64? assetId,
    $fixnum.Int64? passId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (assetId != null) result.assetId = assetId;
    if (passId != null) result.passId = passId;
    return result;
  }

  AttachAssetRequest._();

  factory AttachAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachAssetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aInt64(2, _omitFieldNames ? '' : 'assetId')
    ..aInt64(3, _omitFieldNames ? '' : 'passId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachAssetRequest clone() => AttachAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachAssetRequest copyWith(void Function(AttachAssetRequest) updates) =>
      super.copyWith((message) => updates(message as AttachAssetRequest))
          as AttachAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachAssetRequest create() => AttachAssetRequest._();
  @$core.override
  AttachAssetRequest createEmptyInstance() => create();
  static $pb.PbList<AttachAssetRequest> createRepeated() =>
      $pb.PbList<AttachAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static AttachAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachAssetRequest>(create);
  static AttachAssetRequest? _defaultInstance;

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
  $fixnum.Int64 get passId => $_getI64(2);
  @$pb.TagNumber(3)
  set passId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassId() => $_clearField(3);
}

class AttachAssetResponse extends $pb.GeneratedMessage {
  factory AttachAssetResponse({
    JobAsset? attachment,
  }) {
    final result = create();
    if (attachment != null) result.attachment = attachment;
    return result;
  }

  AttachAssetResponse._();

  factory AttachAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachAssetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOM<JobAsset>(1, _omitFieldNames ? '' : 'attachment',
        subBuilder: JobAsset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachAssetResponse clone() => AttachAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachAssetResponse copyWith(void Function(AttachAssetResponse) updates) =>
      super.copyWith((message) => updates(message as AttachAssetResponse))
          as AttachAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachAssetResponse create() => AttachAssetResponse._();
  @$core.override
  AttachAssetResponse createEmptyInstance() => create();
  static $pb.PbList<AttachAssetResponse> createRepeated() =>
      $pb.PbList<AttachAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static AttachAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachAssetResponse>(create);
  static AttachAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  JobAsset get attachment => $_getN(0);
  @$pb.TagNumber(1)
  set attachment(JobAsset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAttachment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttachment() => $_clearField(1);
  @$pb.TagNumber(1)
  JobAsset ensureAttachment() => $_ensure(0);
}

class DetachAssetRequest extends $pb.GeneratedMessage {
  factory DetachAssetRequest({
    $fixnum.Int64? jobId,
    $fixnum.Int64? assetId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  DetachAssetRequest._();

  factory DetachAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DetachAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DetachAssetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aInt64(2, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetachAssetRequest clone() => DetachAssetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetachAssetRequest copyWith(void Function(DetachAssetRequest) updates) =>
      super.copyWith((message) => updates(message as DetachAssetRequest))
          as DetachAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DetachAssetRequest create() => DetachAssetRequest._();
  @$core.override
  DetachAssetRequest createEmptyInstance() => create();
  static $pb.PbList<DetachAssetRequest> createRepeated() =>
      $pb.PbList<DetachAssetRequest>();
  @$core.pragma('dart2js:noInline')
  static DetachAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DetachAssetRequest>(create);
  static DetachAssetRequest? _defaultInstance;

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
}

class DetachAssetResponse extends $pb.GeneratedMessage {
  factory DetachAssetResponse() => create();

  DetachAssetResponse._();

  factory DetachAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DetachAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DetachAssetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetachAssetResponse clone() => DetachAssetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetachAssetResponse copyWith(void Function(DetachAssetResponse) updates) =>
      super.copyWith((message) => updates(message as DetachAssetResponse))
          as DetachAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DetachAssetResponse create() => DetachAssetResponse._();
  @$core.override
  DetachAssetResponse createEmptyInstance() => create();
  static $pb.PbList<DetachAssetResponse> createRepeated() =>
      $pb.PbList<DetachAssetResponse>();
  @$core.pragma('dart2js:noInline')
  static DetachAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DetachAssetResponse>(create);
  static DetachAssetResponse? _defaultInstance;
}

class ListUploadFormatsRequest extends $pb.GeneratedMessage {
  factory ListUploadFormatsRequest() => create();

  ListUploadFormatsRequest._();

  factory ListUploadFormatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUploadFormatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUploadFormatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUploadFormatsRequest clone() =>
      ListUploadFormatsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUploadFormatsRequest copyWith(
          void Function(ListUploadFormatsRequest) updates) =>
      super.copyWith((message) => updates(message as ListUploadFormatsRequest))
          as ListUploadFormatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUploadFormatsRequest create() => ListUploadFormatsRequest._();
  @$core.override
  ListUploadFormatsRequest createEmptyInstance() => create();
  static $pb.PbList<ListUploadFormatsRequest> createRepeated() =>
      $pb.PbList<ListUploadFormatsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListUploadFormatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUploadFormatsRequest>(create);
  static ListUploadFormatsRequest? _defaultInstance;
}

class ListUploadFormatsResponse extends $pb.GeneratedMessage {
  factory ListUploadFormatsResponse({
    $core.Iterable<UploadFormat>? formats,
    $fixnum.Int64? maxBytes,
  }) {
    final result = create();
    if (formats != null) result.formats.addAll(formats);
    if (maxBytes != null) result.maxBytes = maxBytes;
    return result;
  }

  ListUploadFormatsResponse._();

  factory ListUploadFormatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUploadFormatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUploadFormatsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..pc<UploadFormat>(1, _omitFieldNames ? '' : 'formats', $pb.PbFieldType.PM,
        subBuilder: UploadFormat.create)
    ..aInt64(2, _omitFieldNames ? '' : 'maxBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUploadFormatsResponse clone() =>
      ListUploadFormatsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUploadFormatsResponse copyWith(
          void Function(ListUploadFormatsResponse) updates) =>
      super.copyWith((message) => updates(message as ListUploadFormatsResponse))
          as ListUploadFormatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUploadFormatsResponse create() => ListUploadFormatsResponse._();
  @$core.override
  ListUploadFormatsResponse createEmptyInstance() => create();
  static $pb.PbList<ListUploadFormatsResponse> createRepeated() =>
      $pb.PbList<ListUploadFormatsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListUploadFormatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUploadFormatsResponse>(create);
  static ListUploadFormatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UploadFormat> get formats => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set maxBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxBytes() => $_clearField(2);
}

/// 받는 자료 한 종류.
class UploadFormat extends $pb.GeneratedMessage {
  factory UploadFormat({
    $core.String? name,
    $core.String? label,
    $core.Iterable<$core.String>? extensions,
    $core.String? rule,
    AssetKind? kind,
    $core.bool? timeOriginRequired,
    $core.Iterable<$core.String>? steps,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (label != null) result.label = label;
    if (extensions != null) result.extensions.addAll(extensions);
    if (rule != null) result.rule = rule;
    if (kind != null) result.kind = kind;
    if (timeOriginRequired != null)
      result.timeOriginRequired = timeOriginRequired;
    if (steps != null) result.steps.addAll(steps);
    return result;
  }

  UploadFormat._();

  factory UploadFormat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadFormat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadFormat',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.asset.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..pPS(3, _omitFieldNames ? '' : 'extensions')
    ..aOS(4, _omitFieldNames ? '' : 'rule')
    ..e<AssetKind>(5, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: AssetKind.ASSET_KIND_UNSPECIFIED,
        valueOf: AssetKind.valueOf,
        enumValues: AssetKind.values)
    ..aOB(6, _omitFieldNames ? '' : 'timeOriginRequired')
    ..pPS(7, _omitFieldNames ? '' : 'steps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFormat clone() => UploadFormat()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadFormat copyWith(void Function(UploadFormat) updates) =>
      super.copyWith((message) => updates(message as UploadFormat))
          as UploadFormat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFormat create() => UploadFormat._();
  @$core.override
  UploadFormat createEmptyInstance() => create();
  static $pb.PbList<UploadFormat> createRepeated() =>
      $pb.PbList<UploadFormat>();
  @$core.pragma('dart2js:noInline')
  static UploadFormat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadFormat>(create);
  static UploadFormat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get extensions => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get rule => $_getSZ(3);
  @$pb.TagNumber(4)
  set rule($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRule() => $_has(3);
  @$pb.TagNumber(4)
  void clearRule() => $_clearField(4);

  @$pb.TagNumber(5)
  AssetKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(AssetKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get timeOriginRequired => $_getBF(5);
  @$pb.TagNumber(6)
  set timeOriginRequired($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimeOriginRequired() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimeOriginRequired() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get steps => $_getList(6);
}

class AssetServiceApi {
  final $pb.RpcClient _client;

  AssetServiceApi(this._client);

  /// 외부 source URL(fileservice://...)에서 서버가 바이트를 가져와 Asset으로 등록한다.
  /// 미구현(UNIMPLEMENTED) — 허용 주소 규칙(SSRF 방지)과 함께 업로드 경로를 설계할 때 만든다.
  $async.Future<ImportAssetFromSourceResponse> importAssetFromSource(
          $pb.ClientContext? ctx, ImportAssetFromSourceRequest request) =>
      _client.invoke<ImportAssetFromSourceResponse>(ctx, 'AssetService',
          'ImportAssetFromSource', request, ImportAssetFromSourceResponse());

  /// Asset 목록(페이지·kind 필터·부모 필터). 작업별 목록은 ListJobAssets.
  $async.Future<ListAssetsResponse> listAssets(
          $pb.ClientContext? ctx, ListAssetsRequest request) =>
      _client.invoke<ListAssetsResponse>(
          ctx, 'AssetService', 'ListAssets', request, ListAssetsResponse());
  $async.Future<GetAssetResponse> getAsset(
          $pb.ClientContext? ctx, GetAssetRequest request) =>
      _client.invoke<GetAssetResponse>(
          ctx, 'AssetService', 'GetAsset', request, GetAssetResponse());

  /// 첨부(job_asset)·파생 부모(다른 Asset의 parent_asset_id)·성적서 원본으로 쓰이는 Asset은 FailedPrecondition.
  $async.Future<DeleteAssetResponse> deleteAsset(
          $pb.ClientContext? ctx, DeleteAssetRequest request) =>
      _client.invoke<DeleteAssetResponse>(
          ctx, 'AssetService', 'DeleteAsset', request, DeleteAssetResponse());

  /// 내용(sha256)이 같은 Asset 묶음 목록. 중복은 등록을 막지 않고 여기서 확인해 사람이 정리한다.
  $async.Future<ListDuplicateAssetsResponse> listDuplicateAssets(
          $pb.ClientContext? ctx, ListDuplicateAssetsRequest request) =>
      _client.invoke<ListDuplicateAssetsResponse>(ctx, 'AssetService',
          'ListDuplicateAssets', request, ListDuplicateAssetsResponse());

  /// 화면 업로드(POST /assets, multipart)가 받는 자료 형식. 서버는 파일 내용으로 종류를 정한다 — 확장자는 파일 선택 창에
  /// 쓸 안내 값이다. 표에 없는 파일도 올릴 수 있고(종류 미지정으로 등록만), 실행 파일은 거절한다.
  $async.Future<ListUploadFormatsResponse> listUploadFormats(
          $pb.ClientContext? ctx, ListUploadFormatsRequest request) =>
      _client.invoke<ListUploadFormatsResponse>(ctx, 'AssetService',
          'ListUploadFormats', request, ListUploadFormatsResponse());

  /// 첨부(job_asset) — "이 작업의 자료인가". Clip으로 놓으면 서버가 자동 첨부하므로, 이 RPC는
  /// 타임라인에 놓지 않고 작업 자료로만 둘 때(PDF 등)와 패스를 고칠 때 쓴다.
  /// 작업의 첨부 목록
  $async.Future<ListJobAssetsResponse> listJobAssets(
          $pb.ClientContext? ctx, ListJobAssetsRequest request) =>
      _client.invoke<ListJobAssetsResponse>(ctx, 'AssetService',
          'ListJobAssets', request, ListJobAssetsResponse());

  /// 첨부. 이미 첨부돼 있으면 pass_id만 고친다(upsert).
  /// pass_id가 다른 작업의 패스면 InvalidArgument.
  $async.Future<AttachAssetResponse> attachAsset(
          $pb.ClientContext? ctx, AttachAssetRequest request) =>
      _client.invoke<AttachAssetResponse>(
          ctx, 'AssetService', 'AttachAsset', request, AttachAssetResponse());

  /// Clip이나 매칭된 성적서 세트가 쓰는 첨부면 FailedPrecondition.
  $async.Future<DetachAssetResponse> detachAsset(
          $pb.ClientContext? ctx, DetachAssetRequest request) =>
      _client.invoke<DetachAssetResponse>(
          ctx, 'AssetService', 'DetachAsset', request, DetachAssetResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
