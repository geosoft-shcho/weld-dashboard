// This is a generated file - do not edit.
//
// Generated from mediatag/compose/v1/compose.proto.

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

import '../../../google/protobuf/field_mask.pb.dart' as $3;
import '../../../google/protobuf/struct.pb.dart' as $1;
import '../../../google/protobuf/timestamp.pb.dart' as $0;
import '../../asset/v1/asset.pb.dart' as $2;
import 'compose.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'compose.pbenum.dart';

class LabelRef extends $pb.GeneratedMessage {
  factory LabelRef({
    $core.String? vocabKey,
    $core.String? valueId,
  }) {
    final result = create();
    if (vocabKey != null) result.vocabKey = vocabKey;
    if (valueId != null) result.valueId = valueId;
    return result;
  }

  LabelRef._();

  factory LabelRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LabelRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LabelRef',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vocabKey')
    ..aOS(2, _omitFieldNames ? '' : 'valueId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelRef clone() => LabelRef()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelRef copyWith(void Function(LabelRef) updates) =>
      super.copyWith((message) => updates(message as LabelRef)) as LabelRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LabelRef create() => LabelRef._();
  @$core.override
  LabelRef createEmptyInstance() => create();
  static $pb.PbList<LabelRef> createRepeated() => $pb.PbList<LabelRef>();
  @$core.pragma('dart2js:noInline')
  static LabelRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LabelRef>(create);
  static LabelRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vocabKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set vocabKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVocabKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearVocabKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get valueId => $_getSZ(1);
  @$pb.TagNumber(2)
  set valueId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValueId() => $_has(1);
  @$pb.TagNumber(2)
  void clearValueId() => $_clearField(2);
}

class Timeline extends $pb.GeneratedMessage {
  factory Timeline({
    $core.String? jobId,
    $core.String? name,
    TimelineStatus? status,
    $core.String? description,
    $core.Iterable<LabelRef>? labels,
    $0.Timestamp? embeddedAt,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (description != null) result.description = description;
    if (labels != null) result.labels.addAll(labels);
    if (embeddedAt != null) result.embeddedAt = embeddedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Timeline._();

  factory Timeline.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Timeline.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Timeline',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<TimelineStatus>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: TimelineStatus.TIMELINE_STATUS_UNSPECIFIED,
        valueOf: TimelineStatus.valueOf,
        enumValues: TimelineStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..pc<LabelRef>(5, _omitFieldNames ? '' : 'labels', $pb.PbFieldType.PM,
        subBuilder: LabelRef.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'embeddedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timeline clone() => Timeline()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timeline copyWith(void Function(Timeline) updates) =>
      super.copyWith((message) => updates(message as Timeline)) as Timeline;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Timeline create() => Timeline._();
  @$core.override
  Timeline createEmptyInstance() => create();
  static $pb.PbList<Timeline> createRepeated() => $pb.PbList<Timeline>();
  @$core.pragma('dart2js:noInline')
  static Timeline getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timeline>(create);
  static Timeline? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  TimelineStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(TimelineStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<LabelRef> get labels => $_getList(4);

  @$pb.TagNumber(6)
  $0.Timestamp get embeddedAt => $_getN(5);
  @$pb.TagNumber(6)
  set embeddedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEmbeddedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEmbeddedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEmbeddedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureUpdatedAt() => $_ensure(7);
}

class Track extends $pb.GeneratedMessage {
  factory Track({
    $core.String? trackId,
    $core.String? jobId,
    $core.String? name,
    $core.int? order,
    $core.bool? visible,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final result = create();
    if (trackId != null) result.trackId = trackId;
    if (jobId != null) result.jobId = jobId;
    if (name != null) result.name = name;
    if (order != null) result.order = order;
    if (visible != null) result.visible = visible;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Track._();

  factory Track.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Track.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Track',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'order', $pb.PbFieldType.O3)
    ..aOB(5, _omitFieldNames ? '' : 'visible')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Track clone() => Track()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Track copyWith(void Function(Track) updates) =>
      super.copyWith((message) => updates(message as Track)) as Track;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Track create() => Track._();
  @$core.override
  Track createEmptyInstance() => create();
  static $pb.PbList<Track> createRepeated() => $pb.PbList<Track>();
  @$core.pragma('dart2js:noInline')
  static Track getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Track>(create);
  static Track? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get order => $_getIZ(3);
  @$pb.TagNumber(4)
  set order($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrder() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get visible => $_getBF(4);
  @$pb.TagNumber(5)
  set visible($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVisible() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisible() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUpdatedAt() => $_ensure(6);
}

class Clip extends $pb.GeneratedMessage {
  factory Clip({
    $core.String? clipId,
    $core.String? trackId,
    ClipKind? kind,
    $fixnum.Int64? timelineStartNs,
    $fixnum.Int64? timelineEndNs,
    ClipSource? source,
    $core.String? labelValueId,
    $core.String? description,
    ClipProvenance? provenance,
    $0.Timestamp? embeddedAt,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final result = create();
    if (clipId != null) result.clipId = clipId;
    if (trackId != null) result.trackId = trackId;
    if (kind != null) result.kind = kind;
    if (timelineStartNs != null) result.timelineStartNs = timelineStartNs;
    if (timelineEndNs != null) result.timelineEndNs = timelineEndNs;
    if (source != null) result.source = source;
    if (labelValueId != null) result.labelValueId = labelValueId;
    if (description != null) result.description = description;
    if (provenance != null) result.provenance = provenance;
    if (embeddedAt != null) result.embeddedAt = embeddedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Clip._();

  factory Clip.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Clip.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Clip',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOS(2, _omitFieldNames ? '' : 'trackId')
    ..e<ClipKind>(3, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: ClipKind.CLIP_KIND_UNSPECIFIED,
        valueOf: ClipKind.valueOf,
        enumValues: ClipKind.values)
    ..aInt64(4, _omitFieldNames ? '' : 'timelineStartNs')
    ..aInt64(5, _omitFieldNames ? '' : 'timelineEndNs')
    ..aOM<ClipSource>(6, _omitFieldNames ? '' : 'source',
        subBuilder: ClipSource.create)
    ..aOS(7, _omitFieldNames ? '' : 'labelValueId')
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..aOM<ClipProvenance>(9, _omitFieldNames ? '' : 'provenance',
        subBuilder: ClipProvenance.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'embeddedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Clip clone() => Clip()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Clip copyWith(void Function(Clip) updates) =>
      super.copyWith((message) => updates(message as Clip)) as Clip;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Clip create() => Clip._();
  @$core.override
  Clip createEmptyInstance() => create();
  static $pb.PbList<Clip> createRepeated() => $pb.PbList<Clip>();
  @$core.pragma('dart2js:noInline')
  static Clip getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Clip>(create);
  static Clip? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackId() => $_clearField(2);

  @$pb.TagNumber(3)
  ClipKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ClipKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  /// 타임라인 위 구간 [start, end), 필수. 같은 트랙의 Clip끼리 겹치면 FAILED_PRECONDITION
  @$pb.TagNumber(4)
  $fixnum.Int64 get timelineStartNs => $_getI64(3);
  @$pb.TagNumber(4)
  set timelineStartNs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimelineStartNs() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimelineStartNs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timelineEndNs => $_getI64(4);
  @$pb.TagNumber(5)
  set timelineEndNs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimelineEndNs() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimelineEndNs() => $_clearField(5);

  @$pb.TagNumber(6)
  ClipSource get source => $_getN(5);
  @$pb.TagNumber(6)
  set source(ClipSource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);
  @$pb.TagNumber(6)
  ClipSource ensureSource() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get labelValueId => $_getSZ(6);
  @$pb.TagNumber(7)
  set labelValueId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLabelValueId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLabelValueId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  ClipProvenance get provenance => $_getN(8);
  @$pb.TagNumber(9)
  set provenance(ClipProvenance value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasProvenance() => $_has(8);
  @$pb.TagNumber(9)
  void clearProvenance() => $_clearField(9);
  @$pb.TagNumber(9)
  ClipProvenance ensureProvenance() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get embeddedAt => $_getN(9);
  @$pb.TagNumber(10)
  set embeddedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEmbeddedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearEmbeddedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEmbeddedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureCreatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureUpdatedAt() => $_ensure(11);
}

/// 가리키는 Asset과 그 안의 범위. start/end·locator가 모두 비면 Asset 전체.
class ClipSource extends $pb.GeneratedMessage {
  factory ClipSource({
    $core.String? assetId,
    $fixnum.Int64? startNs,
    $fixnum.Int64? endNs,
    $1.Struct? locator,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (startNs != null) result.startNs = startNs;
    if (endNs != null) result.endNs = endNs;
    if (locator != null) result.locator = locator;
    return result;
  }

  ClipSource._();

  factory ClipSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClipSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipSource',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aInt64(2, _omitFieldNames ? '' : 'startNs')
    ..aInt64(3, _omitFieldNames ? '' : 'endNs')
    ..aOM<$1.Struct>(4, _omitFieldNames ? '' : 'locator',
        subBuilder: $1.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipSource clone() => ClipSource()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipSource copyWith(void Function(ClipSource) updates) =>
      super.copyWith((message) => updates(message as ClipSource)) as ClipSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClipSource create() => ClipSource._();
  @$core.override
  ClipSource createEmptyInstance() => create();
  static $pb.PbList<ClipSource> createRepeated() => $pb.PbList<ClipSource>();
  @$core.pragma('dart2js:noInline')
  static ClipSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipSource>(create);
  static ClipSource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get startNs => $_getI64(1);
  @$pb.TagNumber(2)
  set startNs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartNs() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartNs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endNs => $_getI64(2);
  @$pb.TagNumber(3)
  set endNs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndNs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndNs() => $_clearField(3);

  /// kind별 위치(자유 형식 JSON). pdf: {"page": N}, image: {"x","y","width","height"}(0~1 비율),
  /// pointcloud: {"points": [[x,y,z], ...]}. 영상 속 영역은 locator가 아니라 REGION Clip으로 둔다.
  @$pb.TagNumber(4)
  $1.Struct get locator => $_getN(3);
  @$pb.TagNumber(4)
  set locator($1.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLocator() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocator() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Struct ensureLocator() => $_ensure(3);
}

class ClipProvenance extends $pb.GeneratedMessage {
  factory ClipProvenance({
    $core.double? confidence,
    $core.bool? reviewed,
    $core.String? runId,
    $core.String? toolId,
    $core.String? toolVersion,
    $core.Iterable<$core.String>? inputClipIds,
  }) {
    final result = create();
    if (confidence != null) result.confidence = confidence;
    if (reviewed != null) result.reviewed = reviewed;
    if (runId != null) result.runId = runId;
    if (toolId != null) result.toolId = toolId;
    if (toolVersion != null) result.toolVersion = toolVersion;
    if (inputClipIds != null) result.inputClipIds.addAll(inputClipIds);
    return result;
  }

  ClipProvenance._();

  factory ClipProvenance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClipProvenance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipProvenance',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1, _omitFieldNames ? '' : 'confidence', $pb.PbFieldType.OD)
    ..aOB(2, _omitFieldNames ? '' : 'reviewed')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'toolId')
    ..aOS(5, _omitFieldNames ? '' : 'toolVersion')
    ..pPS(6, _omitFieldNames ? '' : 'inputClipIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipProvenance clone() => ClipProvenance()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipProvenance copyWith(void Function(ClipProvenance) updates) =>
      super.copyWith((message) => updates(message as ClipProvenance))
          as ClipProvenance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClipProvenance create() => ClipProvenance._();
  @$core.override
  ClipProvenance createEmptyInstance() => create();
  static $pb.PbList<ClipProvenance> createRepeated() =>
      $pb.PbList<ClipProvenance>();
  @$core.pragma('dart2js:noInline')
  static ClipProvenance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipProvenance>(create);
  static ClipProvenance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get confidence => $_getN(0);
  @$pb.TagNumber(1)
  set confidence($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfidence() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfidence() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reviewed => $_getBF(1);
  @$pb.TagNumber(2)
  set reviewed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReviewed() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toolId => $_getSZ(3);
  @$pb.TagNumber(4)
  set toolId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolId() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get toolVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set toolVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToolVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get inputClipIds => $_getList(5);
}

class GetTimelineRequest extends $pb.GeneratedMessage {
  factory GetTimelineRequest({
    $core.String? jobId,
    $core.String? passId,
    $core.bool? includeAssets,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (passId != null) result.passId = passId;
    if (includeAssets != null) result.includeAssets = includeAssets;
    return result;
  }

  GetTimelineRequest._();

  factory GetTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'passId')
    ..aOB(3, _omitFieldNames ? '' : 'includeAssets')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineRequest clone() => GetTimelineRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineRequest copyWith(void Function(GetTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetTimelineRequest))
          as GetTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTimelineRequest create() => GetTimelineRequest._();
  @$core.override
  GetTimelineRequest createEmptyInstance() => create();
  static $pb.PbList<GetTimelineRequest> createRepeated() =>
      $pb.PbList<GetTimelineRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineRequest>(create);
  static GetTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  /// 선택. 주면 그 패스 구간(pass.started_at~ended_at을 job.started_at 기준 ns로 바꾼 값)과
  /// 겹치는 클립만 준다. 트랙은 전부 준다(빈 트랙도 행으로 보이게).
  @$pb.TagNumber(2)
  $core.String get passId => $_getSZ(1);
  @$pb.TagNumber(2)
  set passId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeAssets => $_getBF(2);
  @$pb.TagNumber(3)
  set includeAssets($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncludeAssets() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeAssets() => $_clearField(3);
}

class GetTimelineResponse extends $pb.GeneratedMessage {
  factory GetTimelineResponse({
    Timeline? timeline,
    $core.Iterable<Track>? tracks,
    $core.Iterable<Clip>? clips,
    $core.Iterable<$2.Asset>? assets,
    $fixnum.Int64? windowStartNs,
    $fixnum.Int64? windowEndNs,
  }) {
    final result = create();
    if (timeline != null) result.timeline = timeline;
    if (tracks != null) result.tracks.addAll(tracks);
    if (clips != null) result.clips.addAll(clips);
    if (assets != null) result.assets.addAll(assets);
    if (windowStartNs != null) result.windowStartNs = windowStartNs;
    if (windowEndNs != null) result.windowEndNs = windowEndNs;
    return result;
  }

  GetTimelineResponse._();

  factory GetTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Timeline>(1, _omitFieldNames ? '' : 'timeline',
        subBuilder: Timeline.create)
    ..pc<Track>(2, _omitFieldNames ? '' : 'tracks', $pb.PbFieldType.PM,
        subBuilder: Track.create)
    ..pc<Clip>(3, _omitFieldNames ? '' : 'clips', $pb.PbFieldType.PM,
        subBuilder: Clip.create)
    ..pc<$2.Asset>(4, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM,
        subBuilder: $2.Asset.create)
    ..aInt64(5, _omitFieldNames ? '' : 'windowStartNs')
    ..aInt64(6, _omitFieldNames ? '' : 'windowEndNs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineResponse clone() => GetTimelineResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineResponse copyWith(void Function(GetTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as GetTimelineResponse))
          as GetTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTimelineResponse create() => GetTimelineResponse._();
  @$core.override
  GetTimelineResponse createEmptyInstance() => create();
  static $pb.PbList<GetTimelineResponse> createRepeated() =>
      $pb.PbList<GetTimelineResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineResponse>(create);
  static GetTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Timeline get timeline => $_getN(0);
  @$pb.TagNumber(1)
  set timeline(Timeline value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeline() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeline() => $_clearField(1);
  @$pb.TagNumber(1)
  Timeline ensureTimeline() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Track> get tracks => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Clip> get clips => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$2.Asset> get assets => $_getList(3);

  /// pass_id를 줬을 때 그 패스 구간(Timeline 시간축, [start, end)). 화면이 이 구간으로 확대해 연다.
  @$pb.TagNumber(5)
  $fixnum.Int64 get windowStartNs => $_getI64(4);
  @$pb.TagNumber(5)
  set windowStartNs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWindowStartNs() => $_has(4);
  @$pb.TagNumber(5)
  void clearWindowStartNs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get windowEndNs => $_getI64(5);
  @$pb.TagNumber(6)
  set windowEndNs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWindowEndNs() => $_has(5);
  @$pb.TagNumber(6)
  void clearWindowEndNs() => $_clearField(6);
}

class ListTimelinesRequest extends $pb.GeneratedMessage {
  factory ListTimelinesRequest({
    $core.String? projectNo,
    TimelineStatus? status,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = create();
    if (projectNo != null) result.projectNo = projectNo;
    if (status != null) result.status = status;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListTimelinesRequest._();

  factory ListTimelinesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTimelinesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTimelinesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectNo')
    ..e<TimelineStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: TimelineStatus.TIMELINE_STATUS_UNSPECIFIED,
        valueOf: TimelineStatus.valueOf,
        enumValues: TimelineStatus.values)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTimelinesRequest clone() =>
      ListTimelinesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTimelinesRequest copyWith(void Function(ListTimelinesRequest) updates) =>
      super.copyWith((message) => updates(message as ListTimelinesRequest))
          as ListTimelinesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTimelinesRequest create() => ListTimelinesRequest._();
  @$core.override
  ListTimelinesRequest createEmptyInstance() => create();
  static $pb.PbList<ListTimelinesRequest> createRepeated() =>
      $pb.PbList<ListTimelinesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTimelinesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTimelinesRequest>(create);
  static ListTimelinesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectNo() => $_clearField(1);

  @$pb.TagNumber(2)
  TimelineStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(TimelineStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

class ListTimelinesResponse extends $pb.GeneratedMessage {
  factory ListTimelinesResponse({
    $core.Iterable<Timeline>? timelines,
    $core.String? nextPageToken,
  }) {
    final result = create();
    if (timelines != null) result.timelines.addAll(timelines);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListTimelinesResponse._();

  factory ListTimelinesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTimelinesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTimelinesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..pc<Timeline>(1, _omitFieldNames ? '' : 'timelines', $pb.PbFieldType.PM,
        subBuilder: Timeline.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTimelinesResponse clone() =>
      ListTimelinesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTimelinesResponse copyWith(
          void Function(ListTimelinesResponse) updates) =>
      super.copyWith((message) => updates(message as ListTimelinesResponse))
          as ListTimelinesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTimelinesResponse create() => ListTimelinesResponse._();
  @$core.override
  ListTimelinesResponse createEmptyInstance() => create();
  static $pb.PbList<ListTimelinesResponse> createRepeated() =>
      $pb.PbList<ListTimelinesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTimelinesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTimelinesResponse>(create);
  static ListTimelinesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Timeline> get timelines => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class UpdateTimelineRequest extends $pb.GeneratedMessage {
  factory UpdateTimelineRequest({
    Timeline? timeline,
    $3.FieldMask? updateMask,
  }) {
    final result = create();
    if (timeline != null) result.timeline = timeline;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateTimelineRequest._();

  factory UpdateTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTimelineRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Timeline>(1, _omitFieldNames ? '' : 'timeline',
        subBuilder: Timeline.create)
    ..aOM<$3.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $3.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTimelineRequest clone() =>
      UpdateTimelineRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTimelineRequest copyWith(
          void Function(UpdateTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateTimelineRequest))
          as UpdateTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTimelineRequest create() => UpdateTimelineRequest._();
  @$core.override
  UpdateTimelineRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateTimelineRequest> createRepeated() =>
      $pb.PbList<UpdateTimelineRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTimelineRequest>(create);
  static UpdateTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Timeline get timeline => $_getN(0);
  @$pb.TagNumber(1)
  set timeline(Timeline value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeline() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeline() => $_clearField(1);
  @$pb.TagNumber(1)
  Timeline ensureTimeline() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($3.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateTimelineResponse extends $pb.GeneratedMessage {
  factory UpdateTimelineResponse({
    Timeline? timeline,
  }) {
    final result = create();
    if (timeline != null) result.timeline = timeline;
    return result;
  }

  UpdateTimelineResponse._();

  factory UpdateTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTimelineResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Timeline>(1, _omitFieldNames ? '' : 'timeline',
        subBuilder: Timeline.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTimelineResponse clone() =>
      UpdateTimelineResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTimelineResponse copyWith(
          void Function(UpdateTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateTimelineResponse))
          as UpdateTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTimelineResponse create() => UpdateTimelineResponse._();
  @$core.override
  UpdateTimelineResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateTimelineResponse> createRepeated() =>
      $pb.PbList<UpdateTimelineResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTimelineResponse>(create);
  static UpdateTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Timeline get timeline => $_getN(0);
  @$pb.TagNumber(1)
  set timeline(Timeline value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeline() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeline() => $_clearField(1);
  @$pb.TagNumber(1)
  Timeline ensureTimeline() => $_ensure(0);
}

class ChangeTimelineStatusRequest extends $pb.GeneratedMessage {
  factory ChangeTimelineStatusRequest({
    $core.String? jobId,
    TimelineStatus? fromStatus,
    TimelineStatus? toStatus,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (fromStatus != null) result.fromStatus = fromStatus;
    if (toStatus != null) result.toStatus = toStatus;
    return result;
  }

  ChangeTimelineStatusRequest._();

  factory ChangeTimelineStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeTimelineStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeTimelineStatusRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..e<TimelineStatus>(
        2, _omitFieldNames ? '' : 'fromStatus', $pb.PbFieldType.OE,
        defaultOrMaker: TimelineStatus.TIMELINE_STATUS_UNSPECIFIED,
        valueOf: TimelineStatus.valueOf,
        enumValues: TimelineStatus.values)
    ..e<TimelineStatus>(
        3, _omitFieldNames ? '' : 'toStatus', $pb.PbFieldType.OE,
        defaultOrMaker: TimelineStatus.TIMELINE_STATUS_UNSPECIFIED,
        valueOf: TimelineStatus.valueOf,
        enumValues: TimelineStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTimelineStatusRequest clone() =>
      ChangeTimelineStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTimelineStatusRequest copyWith(
          void Function(ChangeTimelineStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ChangeTimelineStatusRequest))
          as ChangeTimelineStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeTimelineStatusRequest create() =>
      ChangeTimelineStatusRequest._();
  @$core.override
  ChangeTimelineStatusRequest createEmptyInstance() => create();
  static $pb.PbList<ChangeTimelineStatusRequest> createRepeated() =>
      $pb.PbList<ChangeTimelineStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static ChangeTimelineStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeTimelineStatusRequest>(create);
  static ChangeTimelineStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  TimelineStatus get fromStatus => $_getN(1);
  @$pb.TagNumber(2)
  set fromStatus(TimelineStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFromStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  TimelineStatus get toStatus => $_getN(2);
  @$pb.TagNumber(3)
  set toStatus(TimelineStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasToStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearToStatus() => $_clearField(3);
}

class ChangeTimelineStatusResponse extends $pb.GeneratedMessage {
  factory ChangeTimelineStatusResponse({
    Timeline? timeline,
  }) {
    final result = create();
    if (timeline != null) result.timeline = timeline;
    return result;
  }

  ChangeTimelineStatusResponse._();

  factory ChangeTimelineStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeTimelineStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeTimelineStatusResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Timeline>(1, _omitFieldNames ? '' : 'timeline',
        subBuilder: Timeline.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTimelineStatusResponse clone() =>
      ChangeTimelineStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTimelineStatusResponse copyWith(
          void Function(ChangeTimelineStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ChangeTimelineStatusResponse))
          as ChangeTimelineStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeTimelineStatusResponse create() =>
      ChangeTimelineStatusResponse._();
  @$core.override
  ChangeTimelineStatusResponse createEmptyInstance() => create();
  static $pb.PbList<ChangeTimelineStatusResponse> createRepeated() =>
      $pb.PbList<ChangeTimelineStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static ChangeTimelineStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeTimelineStatusResponse>(create);
  static ChangeTimelineStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Timeline get timeline => $_getN(0);
  @$pb.TagNumber(1)
  set timeline(Timeline value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeline() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeline() => $_clearField(1);
  @$pb.TagNumber(1)
  Timeline ensureTimeline() => $_ensure(0);
}

class DeleteTimelineRequest extends $pb.GeneratedMessage {
  factory DeleteTimelineRequest({
    $core.String? jobId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  DeleteTimelineRequest._();

  factory DeleteTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTimelineRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTimelineRequest clone() =>
      DeleteTimelineRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTimelineRequest copyWith(
          void Function(DeleteTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteTimelineRequest))
          as DeleteTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTimelineRequest create() => DeleteTimelineRequest._();
  @$core.override
  DeleteTimelineRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteTimelineRequest> createRepeated() =>
      $pb.PbList<DeleteTimelineRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTimelineRequest>(create);
  static DeleteTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

class DeleteTimelineResponse extends $pb.GeneratedMessage {
  factory DeleteTimelineResponse() => create();

  DeleteTimelineResponse._();

  factory DeleteTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTimelineResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTimelineResponse clone() =>
      DeleteTimelineResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTimelineResponse copyWith(
          void Function(DeleteTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteTimelineResponse))
          as DeleteTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTimelineResponse create() => DeleteTimelineResponse._();
  @$core.override
  DeleteTimelineResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteTimelineResponse> createRepeated() =>
      $pb.PbList<DeleteTimelineResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTimelineResponse>(create);
  static DeleteTimelineResponse? _defaultInstance;
}

class CreateTrackRequest extends $pb.GeneratedMessage {
  factory CreateTrackRequest({
    Track? track,
  }) {
    final result = create();
    if (track != null) result.track = track;
    return result;
  }

  CreateTrackRequest._();

  factory CreateTrackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTrackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTrackRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Track>(1, _omitFieldNames ? '' : 'track', subBuilder: Track.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTrackRequest clone() => CreateTrackRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTrackRequest copyWith(void Function(CreateTrackRequest) updates) =>
      super.copyWith((message) => updates(message as CreateTrackRequest))
          as CreateTrackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTrackRequest create() => CreateTrackRequest._();
  @$core.override
  CreateTrackRequest createEmptyInstance() => create();
  static $pb.PbList<CreateTrackRequest> createRepeated() =>
      $pb.PbList<CreateTrackRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateTrackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTrackRequest>(create);
  static CreateTrackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Track get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(Track value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  Track ensureTrack() => $_ensure(0);
}

class CreateTrackResponse extends $pb.GeneratedMessage {
  factory CreateTrackResponse({
    Track? track,
  }) {
    final result = create();
    if (track != null) result.track = track;
    return result;
  }

  CreateTrackResponse._();

  factory CreateTrackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTrackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTrackResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Track>(1, _omitFieldNames ? '' : 'track', subBuilder: Track.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTrackResponse clone() => CreateTrackResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTrackResponse copyWith(void Function(CreateTrackResponse) updates) =>
      super.copyWith((message) => updates(message as CreateTrackResponse))
          as CreateTrackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTrackResponse create() => CreateTrackResponse._();
  @$core.override
  CreateTrackResponse createEmptyInstance() => create();
  static $pb.PbList<CreateTrackResponse> createRepeated() =>
      $pb.PbList<CreateTrackResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateTrackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTrackResponse>(create);
  static CreateTrackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Track get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(Track value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  Track ensureTrack() => $_ensure(0);
}

class UpdateTrackRequest extends $pb.GeneratedMessage {
  factory UpdateTrackRequest({
    Track? track,
    $3.FieldMask? updateMask,
  }) {
    final result = create();
    if (track != null) result.track = track;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateTrackRequest._();

  factory UpdateTrackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTrackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTrackRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Track>(1, _omitFieldNames ? '' : 'track', subBuilder: Track.create)
    ..aOM<$3.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $3.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTrackRequest clone() => UpdateTrackRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTrackRequest copyWith(void Function(UpdateTrackRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateTrackRequest))
          as UpdateTrackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTrackRequest create() => UpdateTrackRequest._();
  @$core.override
  UpdateTrackRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateTrackRequest> createRepeated() =>
      $pb.PbList<UpdateTrackRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateTrackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTrackRequest>(create);
  static UpdateTrackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Track get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(Track value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  Track ensureTrack() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($3.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateTrackResponse extends $pb.GeneratedMessage {
  factory UpdateTrackResponse({
    Track? track,
  }) {
    final result = create();
    if (track != null) result.track = track;
    return result;
  }

  UpdateTrackResponse._();

  factory UpdateTrackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTrackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTrackResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Track>(1, _omitFieldNames ? '' : 'track', subBuilder: Track.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTrackResponse clone() => UpdateTrackResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTrackResponse copyWith(void Function(UpdateTrackResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateTrackResponse))
          as UpdateTrackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTrackResponse create() => UpdateTrackResponse._();
  @$core.override
  UpdateTrackResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateTrackResponse> createRepeated() =>
      $pb.PbList<UpdateTrackResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateTrackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTrackResponse>(create);
  static UpdateTrackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Track get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(Track value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  Track ensureTrack() => $_ensure(0);
}

class DeleteTrackRequest extends $pb.GeneratedMessage {
  factory DeleteTrackRequest({
    $core.String? trackId,
  }) {
    final result = create();
    if (trackId != null) result.trackId = trackId;
    return result;
  }

  DeleteTrackRequest._();

  factory DeleteTrackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTrackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTrackRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTrackRequest clone() => DeleteTrackRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTrackRequest copyWith(void Function(DeleteTrackRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteTrackRequest))
          as DeleteTrackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTrackRequest create() => DeleteTrackRequest._();
  @$core.override
  DeleteTrackRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteTrackRequest> createRepeated() =>
      $pb.PbList<DeleteTrackRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteTrackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTrackRequest>(create);
  static DeleteTrackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);
}

class DeleteTrackResponse extends $pb.GeneratedMessage {
  factory DeleteTrackResponse() => create();

  DeleteTrackResponse._();

  factory DeleteTrackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTrackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTrackResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTrackResponse clone() => DeleteTrackResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTrackResponse copyWith(void Function(DeleteTrackResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteTrackResponse))
          as DeleteTrackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTrackResponse create() => DeleteTrackResponse._();
  @$core.override
  DeleteTrackResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteTrackResponse> createRepeated() =>
      $pb.PbList<DeleteTrackResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteTrackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTrackResponse>(create);
  static DeleteTrackResponse? _defaultInstance;
}

class CreateClipRequest extends $pb.GeneratedMessage {
  factory CreateClipRequest({
    Clip? clip,
  }) {
    final result = create();
    if (clip != null) result.clip = clip;
    return result;
  }

  CreateClipRequest._();

  factory CreateClipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateClipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateClipRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Clip>(1, _omitFieldNames ? '' : 'clip', subBuilder: Clip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateClipRequest clone() => CreateClipRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateClipRequest copyWith(void Function(CreateClipRequest) updates) =>
      super.copyWith((message) => updates(message as CreateClipRequest))
          as CreateClipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateClipRequest create() => CreateClipRequest._();
  @$core.override
  CreateClipRequest createEmptyInstance() => create();
  static $pb.PbList<CreateClipRequest> createRepeated() =>
      $pb.PbList<CreateClipRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateClipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateClipRequest>(create);
  static CreateClipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Clip get clip => $_getN(0);
  @$pb.TagNumber(1)
  set clip(Clip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClip() => $_has(0);
  @$pb.TagNumber(1)
  void clearClip() => $_clearField(1);
  @$pb.TagNumber(1)
  Clip ensureClip() => $_ensure(0);
}

class CreateClipResponse extends $pb.GeneratedMessage {
  factory CreateClipResponse({
    Clip? clip,
  }) {
    final result = create();
    if (clip != null) result.clip = clip;
    return result;
  }

  CreateClipResponse._();

  factory CreateClipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateClipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateClipResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Clip>(1, _omitFieldNames ? '' : 'clip', subBuilder: Clip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateClipResponse clone() => CreateClipResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateClipResponse copyWith(void Function(CreateClipResponse) updates) =>
      super.copyWith((message) => updates(message as CreateClipResponse))
          as CreateClipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateClipResponse create() => CreateClipResponse._();
  @$core.override
  CreateClipResponse createEmptyInstance() => create();
  static $pb.PbList<CreateClipResponse> createRepeated() =>
      $pb.PbList<CreateClipResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateClipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateClipResponse>(create);
  static CreateClipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Clip get clip => $_getN(0);
  @$pb.TagNumber(1)
  set clip(Clip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClip() => $_has(0);
  @$pb.TagNumber(1)
  void clearClip() => $_clearField(1);
  @$pb.TagNumber(1)
  Clip ensureClip() => $_ensure(0);
}

class UpdateClipRequest extends $pb.GeneratedMessage {
  factory UpdateClipRequest({
    Clip? clip,
    $3.FieldMask? updateMask,
  }) {
    final result = create();
    if (clip != null) result.clip = clip;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateClipRequest._();

  factory UpdateClipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateClipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateClipRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Clip>(1, _omitFieldNames ? '' : 'clip', subBuilder: Clip.create)
    ..aOM<$3.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $3.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateClipRequest clone() => UpdateClipRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateClipRequest copyWith(void Function(UpdateClipRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateClipRequest))
          as UpdateClipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateClipRequest create() => UpdateClipRequest._();
  @$core.override
  UpdateClipRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateClipRequest> createRepeated() =>
      $pb.PbList<UpdateClipRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateClipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateClipRequest>(create);
  static UpdateClipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Clip get clip => $_getN(0);
  @$pb.TagNumber(1)
  set clip(Clip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClip() => $_has(0);
  @$pb.TagNumber(1)
  void clearClip() => $_clearField(1);
  @$pb.TagNumber(1)
  Clip ensureClip() => $_ensure(0);

  /// track_id, timeline_start_ns, timeline_end_ns, source, label_value_id, description,
  /// provenance.reviewed
  @$pb.TagNumber(2)
  $3.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($3.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateClipResponse extends $pb.GeneratedMessage {
  factory UpdateClipResponse({
    Clip? clip,
  }) {
    final result = create();
    if (clip != null) result.clip = clip;
    return result;
  }

  UpdateClipResponse._();

  factory UpdateClipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateClipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateClipResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<Clip>(1, _omitFieldNames ? '' : 'clip', subBuilder: Clip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateClipResponse clone() => UpdateClipResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateClipResponse copyWith(void Function(UpdateClipResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateClipResponse))
          as UpdateClipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateClipResponse create() => UpdateClipResponse._();
  @$core.override
  UpdateClipResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateClipResponse> createRepeated() =>
      $pb.PbList<UpdateClipResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateClipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateClipResponse>(create);
  static UpdateClipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Clip get clip => $_getN(0);
  @$pb.TagNumber(1)
  set clip(Clip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClip() => $_has(0);
  @$pb.TagNumber(1)
  void clearClip() => $_clearField(1);
  @$pb.TagNumber(1)
  Clip ensureClip() => $_ensure(0);
}

class DeleteClipRequest extends $pb.GeneratedMessage {
  factory DeleteClipRequest({
    $core.String? clipId,
  }) {
    final result = create();
    if (clipId != null) result.clipId = clipId;
    return result;
  }

  DeleteClipRequest._();

  factory DeleteClipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteClipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteClipRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteClipRequest clone() => DeleteClipRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteClipRequest copyWith(void Function(DeleteClipRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteClipRequest))
          as DeleteClipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteClipRequest create() => DeleteClipRequest._();
  @$core.override
  DeleteClipRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteClipRequest> createRepeated() =>
      $pb.PbList<DeleteClipRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteClipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteClipRequest>(create);
  static DeleteClipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);
}

class DeleteClipResponse extends $pb.GeneratedMessage {
  factory DeleteClipResponse() => create();

  DeleteClipResponse._();

  factory DeleteClipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteClipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteClipResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteClipResponse clone() => DeleteClipResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteClipResponse copyWith(void Function(DeleteClipResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteClipResponse))
          as DeleteClipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteClipResponse create() => DeleteClipResponse._();
  @$core.override
  DeleteClipResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteClipResponse> createRepeated() =>
      $pb.PbList<DeleteClipResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteClipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteClipResponse>(create);
  static DeleteClipResponse? _defaultInstance;
}

class LabelVocab extends $pb.GeneratedMessage {
  factory LabelVocab({
    $core.String? key,
    $core.String? parentVocabKey,
    $core.String? parentValueId,
    $core.Iterable<LabelValue>? values,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (parentVocabKey != null) result.parentVocabKey = parentVocabKey;
    if (parentValueId != null) result.parentValueId = parentValueId;
    if (values != null) result.values.addAll(values);
    return result;
  }

  LabelVocab._();

  factory LabelVocab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LabelVocab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LabelVocab',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'parentVocabKey')
    ..aOS(3, _omitFieldNames ? '' : 'parentValueId')
    ..pc<LabelValue>(4, _omitFieldNames ? '' : 'values', $pb.PbFieldType.PM,
        subBuilder: LabelValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelVocab clone() => LabelVocab()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelVocab copyWith(void Function(LabelVocab) updates) =>
      super.copyWith((message) => updates(message as LabelVocab)) as LabelVocab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LabelVocab create() => LabelVocab._();
  @$core.override
  LabelVocab createEmptyInstance() => create();
  static $pb.PbList<LabelVocab> createRepeated() => $pb.PbList<LabelVocab>();
  @$core.pragma('dart2js:noInline')
  static LabelVocab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LabelVocab>(create);
  static LabelVocab? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentVocabKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentVocabKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentVocabKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentVocabKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get parentValueId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentValueId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentValueId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentValueId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<LabelValue> get values => $_getList(3);
}

class LabelValue extends $pb.GeneratedMessage {
  factory LabelValue({
    $core.String? valueId,
    $core.String? vocabKey,
    $core.String? name,
    $core.bool? deprecated,
    $core.String? description,
  }) {
    final result = create();
    if (valueId != null) result.valueId = valueId;
    if (vocabKey != null) result.vocabKey = vocabKey;
    if (name != null) result.name = name;
    if (deprecated != null) result.deprecated = deprecated;
    if (description != null) result.description = description;
    return result;
  }

  LabelValue._();

  factory LabelValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LabelValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LabelValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'valueId')
    ..aOS(2, _omitFieldNames ? '' : 'vocabKey')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOB(4, _omitFieldNames ? '' : 'deprecated')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelValue clone() => LabelValue()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelValue copyWith(void Function(LabelValue) updates) =>
      super.copyWith((message) => updates(message as LabelValue)) as LabelValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LabelValue create() => LabelValue._();
  @$core.override
  LabelValue createEmptyInstance() => create();
  static $pb.PbList<LabelValue> createRepeated() => $pb.PbList<LabelValue>();
  @$core.pragma('dart2js:noInline')
  static LabelValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LabelValue>(create);
  static LabelValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get valueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set valueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearValueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vocabKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set vocabKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVocabKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearVocabKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get deprecated => $_getBF(3);
  @$pb.TagNumber(4)
  set deprecated($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeprecated() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeprecated() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);
}

class ListLabelVocabsRequest extends $pb.GeneratedMessage {
  factory ListLabelVocabsRequest({
    $core.bool? includeDeprecated,
  }) {
    final result = create();
    if (includeDeprecated != null) result.includeDeprecated = includeDeprecated;
    return result;
  }

  ListLabelVocabsRequest._();

  factory ListLabelVocabsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLabelVocabsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLabelVocabsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeDeprecated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLabelVocabsRequest clone() =>
      ListLabelVocabsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLabelVocabsRequest copyWith(
          void Function(ListLabelVocabsRequest) updates) =>
      super.copyWith((message) => updates(message as ListLabelVocabsRequest))
          as ListLabelVocabsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLabelVocabsRequest create() => ListLabelVocabsRequest._();
  @$core.override
  ListLabelVocabsRequest createEmptyInstance() => create();
  static $pb.PbList<ListLabelVocabsRequest> createRepeated() =>
      $pb.PbList<ListLabelVocabsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListLabelVocabsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLabelVocabsRequest>(create);
  static ListLabelVocabsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includeDeprecated => $_getBF(0);
  @$pb.TagNumber(1)
  set includeDeprecated($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeDeprecated() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeDeprecated() => $_clearField(1);
}

class ListLabelVocabsResponse extends $pb.GeneratedMessage {
  factory ListLabelVocabsResponse({
    $core.Iterable<LabelVocab>? vocabs,
  }) {
    final result = create();
    if (vocabs != null) result.vocabs.addAll(vocabs);
    return result;
  }

  ListLabelVocabsResponse._();

  factory ListLabelVocabsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLabelVocabsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLabelVocabsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..pc<LabelVocab>(1, _omitFieldNames ? '' : 'vocabs', $pb.PbFieldType.PM,
        subBuilder: LabelVocab.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLabelVocabsResponse clone() =>
      ListLabelVocabsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLabelVocabsResponse copyWith(
          void Function(ListLabelVocabsResponse) updates) =>
      super.copyWith((message) => updates(message as ListLabelVocabsResponse))
          as ListLabelVocabsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLabelVocabsResponse create() => ListLabelVocabsResponse._();
  @$core.override
  ListLabelVocabsResponse createEmptyInstance() => create();
  static $pb.PbList<ListLabelVocabsResponse> createRepeated() =>
      $pb.PbList<ListLabelVocabsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListLabelVocabsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLabelVocabsResponse>(create);
  static ListLabelVocabsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LabelVocab> get vocabs => $_getList(0);
}

class CreateLabelVocabRequest extends $pb.GeneratedMessage {
  factory CreateLabelVocabRequest({
    LabelVocab? vocab,
  }) {
    final result = create();
    if (vocab != null) result.vocab = vocab;
    return result;
  }

  CreateLabelVocabRequest._();

  factory CreateLabelVocabRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateLabelVocabRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateLabelVocabRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<LabelVocab>(1, _omitFieldNames ? '' : 'vocab',
        subBuilder: LabelVocab.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelVocabRequest clone() =>
      CreateLabelVocabRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelVocabRequest copyWith(
          void Function(CreateLabelVocabRequest) updates) =>
      super.copyWith((message) => updates(message as CreateLabelVocabRequest))
          as CreateLabelVocabRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLabelVocabRequest create() => CreateLabelVocabRequest._();
  @$core.override
  CreateLabelVocabRequest createEmptyInstance() => create();
  static $pb.PbList<CreateLabelVocabRequest> createRepeated() =>
      $pb.PbList<CreateLabelVocabRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateLabelVocabRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateLabelVocabRequest>(create);
  static CreateLabelVocabRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LabelVocab get vocab => $_getN(0);
  @$pb.TagNumber(1)
  set vocab(LabelVocab value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVocab() => $_has(0);
  @$pb.TagNumber(1)
  void clearVocab() => $_clearField(1);
  @$pb.TagNumber(1)
  LabelVocab ensureVocab() => $_ensure(0);
}

class CreateLabelVocabResponse extends $pb.GeneratedMessage {
  factory CreateLabelVocabResponse({
    LabelVocab? vocab,
  }) {
    final result = create();
    if (vocab != null) result.vocab = vocab;
    return result;
  }

  CreateLabelVocabResponse._();

  factory CreateLabelVocabResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateLabelVocabResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateLabelVocabResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<LabelVocab>(1, _omitFieldNames ? '' : 'vocab',
        subBuilder: LabelVocab.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelVocabResponse clone() =>
      CreateLabelVocabResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelVocabResponse copyWith(
          void Function(CreateLabelVocabResponse) updates) =>
      super.copyWith((message) => updates(message as CreateLabelVocabResponse))
          as CreateLabelVocabResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLabelVocabResponse create() => CreateLabelVocabResponse._();
  @$core.override
  CreateLabelVocabResponse createEmptyInstance() => create();
  static $pb.PbList<CreateLabelVocabResponse> createRepeated() =>
      $pb.PbList<CreateLabelVocabResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateLabelVocabResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateLabelVocabResponse>(create);
  static CreateLabelVocabResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LabelVocab get vocab => $_getN(0);
  @$pb.TagNumber(1)
  set vocab(LabelVocab value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVocab() => $_has(0);
  @$pb.TagNumber(1)
  void clearVocab() => $_clearField(1);
  @$pb.TagNumber(1)
  LabelVocab ensureVocab() => $_ensure(0);
}

class CreateLabelValueRequest extends $pb.GeneratedMessage {
  factory CreateLabelValueRequest({
    $core.String? vocabKey,
    $core.String? name,
    $core.String? description,
  }) {
    final result = create();
    if (vocabKey != null) result.vocabKey = vocabKey;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    return result;
  }

  CreateLabelValueRequest._();

  factory CreateLabelValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateLabelValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateLabelValueRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vocabKey')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelValueRequest clone() =>
      CreateLabelValueRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelValueRequest copyWith(
          void Function(CreateLabelValueRequest) updates) =>
      super.copyWith((message) => updates(message as CreateLabelValueRequest))
          as CreateLabelValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLabelValueRequest create() => CreateLabelValueRequest._();
  @$core.override
  CreateLabelValueRequest createEmptyInstance() => create();
  static $pb.PbList<CreateLabelValueRequest> createRepeated() =>
      $pb.PbList<CreateLabelValueRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateLabelValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateLabelValueRequest>(create);
  static CreateLabelValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vocabKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set vocabKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVocabKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearVocabKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);
}

class CreateLabelValueResponse extends $pb.GeneratedMessage {
  factory CreateLabelValueResponse({
    LabelValue? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  CreateLabelValueResponse._();

  factory CreateLabelValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateLabelValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateLabelValueResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<LabelValue>(1, _omitFieldNames ? '' : 'value',
        subBuilder: LabelValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelValueResponse clone() =>
      CreateLabelValueResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateLabelValueResponse copyWith(
          void Function(CreateLabelValueResponse) updates) =>
      super.copyWith((message) => updates(message as CreateLabelValueResponse))
          as CreateLabelValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLabelValueResponse create() => CreateLabelValueResponse._();
  @$core.override
  CreateLabelValueResponse createEmptyInstance() => create();
  static $pb.PbList<CreateLabelValueResponse> createRepeated() =>
      $pb.PbList<CreateLabelValueResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateLabelValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateLabelValueResponse>(create);
  static CreateLabelValueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LabelValue get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(LabelValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  LabelValue ensureValue() => $_ensure(0);
}

class UpdateLabelValueRequest extends $pb.GeneratedMessage {
  factory UpdateLabelValueRequest({
    LabelValue? value,
    $3.FieldMask? updateMask,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateLabelValueRequest._();

  factory UpdateLabelValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateLabelValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateLabelValueRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<LabelValue>(1, _omitFieldNames ? '' : 'value',
        subBuilder: LabelValue.create)
    ..aOM<$3.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $3.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLabelValueRequest clone() =>
      UpdateLabelValueRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLabelValueRequest copyWith(
          void Function(UpdateLabelValueRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateLabelValueRequest))
          as UpdateLabelValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateLabelValueRequest create() => UpdateLabelValueRequest._();
  @$core.override
  UpdateLabelValueRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateLabelValueRequest> createRepeated() =>
      $pb.PbList<UpdateLabelValueRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateLabelValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateLabelValueRequest>(create);
  static UpdateLabelValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LabelValue get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(LabelValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  LabelValue ensureValue() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($3.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateLabelValueResponse extends $pb.GeneratedMessage {
  factory UpdateLabelValueResponse({
    LabelValue? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  UpdateLabelValueResponse._();

  factory UpdateLabelValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateLabelValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateLabelValueResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.compose.v1'),
      createEmptyInstance: create)
    ..aOM<LabelValue>(1, _omitFieldNames ? '' : 'value',
        subBuilder: LabelValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLabelValueResponse clone() =>
      UpdateLabelValueResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLabelValueResponse copyWith(
          void Function(UpdateLabelValueResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateLabelValueResponse))
          as UpdateLabelValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateLabelValueResponse create() => UpdateLabelValueResponse._();
  @$core.override
  UpdateLabelValueResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateLabelValueResponse> createRepeated() =>
      $pb.PbList<UpdateLabelValueResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateLabelValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateLabelValueResponse>(create);
  static UpdateLabelValueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LabelValue get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(LabelValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  LabelValue ensureValue() => $_ensure(0);
}

class MediaComposeServiceApi {
  final $pb.RpcClient _client;

  MediaComposeServiceApi(this._client);

  /// 타임라인 + 전 트랙 + 클립(+ 클립이 가리키는 Asset)을 한 번에. 아직 편집 안 한 작업이면
  /// 빈 draft 타임라인을 준다(행은 만들지 않음). pass_id를 주면 그 패스 구간과 겹치는 클립만 준다.
  $async.Future<GetTimelineResponse> getTimeline(
          $pb.ClientContext? ctx, GetTimelineRequest request) =>
      _client.invoke<GetTimelineResponse>(ctx, 'MediaComposeService',
          'GetTimeline', request, GetTimelineResponse());
  $async.Future<ListTimelinesResponse> listTimelines(
          $pb.ClientContext? ctx, ListTimelinesRequest request) =>
      _client.invoke<ListTimelinesResponse>(ctx, 'MediaComposeService',
          'ListTimelines', request, ListTimelinesResponse());

  /// name, description, labels
  $async.Future<UpdateTimelineResponse> updateTimeline(
          $pb.ClientContext? ctx, UpdateTimelineRequest request) =>
      _client.invoke<UpdateTimelineResponse>(ctx, 'MediaComposeService',
          'UpdateTimeline', request, UpdateTimelineResponse());

  /// 현재 상태가 from_status일 때만 바꾼다. 아니면 Aborted(다른 요청이 먼저 바꿈).
  $async.Future<ChangeTimelineStatusResponse> changeTimelineStatus(
          $pb.ClientContext? ctx, ChangeTimelineStatusRequest request) =>
      _client.invoke<ChangeTimelineStatusResponse>(ctx, 'MediaComposeService',
          'ChangeTimelineStatus', request, ChangeTimelineStatusResponse());

  /// 편집 초기화: 타임라인과 트랙·클립을 지운다(작업·첨부는 그대로).
  $async.Future<DeleteTimelineResponse> deleteTimeline(
          $pb.ClientContext? ctx, DeleteTimelineRequest request) =>
      _client.invoke<DeleteTimelineResponse>(ctx, 'MediaComposeService',
          'DeleteTimeline', request, DeleteTimelineResponse());
  $async.Future<CreateTrackResponse> createTrack(
          $pb.ClientContext? ctx, CreateTrackRequest request) =>
      _client.invoke<CreateTrackResponse>(ctx, 'MediaComposeService',
          'CreateTrack', request, CreateTrackResponse());

  /// name, order, visible
  $async.Future<UpdateTrackResponse> updateTrack(
          $pb.ClientContext? ctx, UpdateTrackRequest request) =>
      _client.invoke<UpdateTrackResponse>(ctx, 'MediaComposeService',
          'UpdateTrack', request, UpdateTrackResponse());

  /// 트랙의 클립도 함께 지워진다.
  $async.Future<DeleteTrackResponse> deleteTrack(
          $pb.ClientContext? ctx, DeleteTrackRequest request) =>
      _client.invoke<DeleteTrackResponse>(ctx, 'MediaComposeService',
          'DeleteTrack', request, DeleteTrackResponse());

  /// 같은 트랙 클립과 구간이 겹치면 FailedPrecondition. source.asset_id가 이 작업에
  /// 첨부되지 않았으면 같은 트랜잭션에서 작업 공용으로 첨부한다.
  $async.Future<CreateClipResponse> createClip(
          $pb.ClientContext? ctx, CreateClipRequest request) =>
      _client.invoke<CreateClipResponse>(ctx, 'MediaComposeService',
          'CreateClip', request, CreateClipResponse());

  /// 오류 조건·자동 첨부는 CreateClip과 같다. 검수는 update_mask "provenance.reviewed".
  $async.Future<UpdateClipResponse> updateClip(
          $pb.ClientContext? ctx, UpdateClipRequest request) =>
      _client.invoke<UpdateClipResponse>(ctx, 'MediaComposeService',
          'UpdateClip', request, UpdateClipResponse());
  $async.Future<DeleteClipResponse> deleteClip(
          $pb.ClientContext? ctx, DeleteClipRequest request) =>
      _client.invoke<DeleteClipResponse>(ctx, 'MediaComposeService',
          'DeleteClip', request, DeleteClipResponse());
}

/// 통제 어휘(어휘 = 분류 축, 값 = 그 축의 선택지). 모든 공사가 같이 쓴다. 값은 지우지 않고
/// deprecated로 숨긴다.
class LabelServiceApi {
  final $pb.RpcClient _client;

  LabelServiceApi(this._client);

  /// 전체 어휘와 값. 어휘 수가 적어 페이지를 두지 않는다.
  $async.Future<ListLabelVocabsResponse> listLabelVocabs(
          $pb.ClientContext? ctx, ListLabelVocabsRequest request) =>
      _client.invoke<ListLabelVocabsResponse>(ctx, 'LabelService',
          'ListLabelVocabs', request, ListLabelVocabsResponse());
  $async.Future<CreateLabelVocabResponse> createLabelVocab(
          $pb.ClientContext? ctx, CreateLabelVocabRequest request) =>
      _client.invoke<CreateLabelVocabResponse>(ctx, 'LabelService',
          'CreateLabelVocab', request, CreateLabelVocabResponse());
  $async.Future<CreateLabelValueResponse> createLabelValue(
          $pb.ClientContext? ctx, CreateLabelValueRequest request) =>
      _client.invoke<CreateLabelValueResponse>(ctx, 'LabelService',
          'CreateLabelValue', request, CreateLabelValueResponse());

  /// name·deprecated·description만 바꿀 수 있다. 이름을 바꿔도 Clip은 value_id로
  /// 가리키므로 따로 갱신할 게 없다.
  $async.Future<UpdateLabelValueResponse> updateLabelValue(
          $pb.ClientContext? ctx, UpdateLabelValueRequest request) =>
      _client.invoke<UpdateLabelValueResponse>(ctx, 'LabelService',
          'UpdateLabelValue', request, UpdateLabelValueResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
