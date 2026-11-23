// This is a generated file - do not edit.
//
// Generated from mediatag/trace/v1/trace.proto.

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

import '../../../google/protobuf/struct.pb.dart' as $2;
import '../../../google/protobuf/timestamp.pb.dart' as $0;
import '../../run/v1/run.pb.dart' as $1;
import 'trace.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'trace.pbenum.dart';

class Trace extends $pb.GeneratedMessage {
  factory Trace({
    $fixnum.Int64? traceId,
    $core.String? source,
    $core.String? fileName,
    $fixnum.Int64? totalBytes,
    $fixnum.Int64? receivedBytes,
    $fixnum.Int64? assetId,
    $core.String? lastEvent,
    TraceStatus? status,
    $core.String? errorCode,
    $core.String? errorMessage,
    $0.Timestamp? publishedAt,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $core.double? progressPercent,
    $core.Iterable<$fixnum.Int64>? embedPendingClipIds,
    $1.Run? run,
  }) {
    final result = create();
    if (traceId != null) result.traceId = traceId;
    if (source != null) result.source = source;
    if (fileName != null) result.fileName = fileName;
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (receivedBytes != null) result.receivedBytes = receivedBytes;
    if (assetId != null) result.assetId = assetId;
    if (lastEvent != null) result.lastEvent = lastEvent;
    if (status != null) result.status = status;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (publishedAt != null) result.publishedAt = publishedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (progressPercent != null) result.progressPercent = progressPercent;
    if (embedPendingClipIds != null)
      result.embedPendingClipIds.addAll(embedPendingClipIds);
    if (run != null) result.run = run;
    return result;
  }

  Trace._();

  factory Trace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Trace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Trace',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.trace.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'traceId')
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..aOS(3, _omitFieldNames ? '' : 'fileName')
    ..aInt64(4, _omitFieldNames ? '' : 'totalBytes')
    ..aInt64(5, _omitFieldNames ? '' : 'receivedBytes')
    ..aInt64(6, _omitFieldNames ? '' : 'assetId')
    ..aOS(7, _omitFieldNames ? '' : 'lastEvent')
    ..e<TraceStatus>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: TraceStatus.TRACE_STATUS_UNSPECIFIED,
        valueOf: TraceStatus.valueOf,
        enumValues: TraceStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'errorCode')
    ..aOS(10, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'publishedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..a<$core.double>(
        15, _omitFieldNames ? '' : 'progressPercent', $pb.PbFieldType.OD)
    ..p<$fixnum.Int64>(
        16, _omitFieldNames ? '' : 'embedPendingClipIds', $pb.PbFieldType.K6)
    ..aOM<$1.Run>(17, _omitFieldNames ? '' : 'run', subBuilder: $1.Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trace clone() => Trace()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trace copyWith(void Function(Trace) updates) =>
      super.copyWith((message) => updates(message as Trace)) as Trace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Trace create() => Trace._();
  @$core.override
  Trace createEmptyInstance() => create();
  static $pb.PbList<Trace> createRepeated() => $pb.PbList<Trace>();
  @$core.pragma('dart2js:noInline')
  static Trace getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Trace>(create);
  static Trace? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get traceId => $_getI64(0);
  @$pb.TagNumber(1)
  set traceId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileName => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileName() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileName() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set totalBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get receivedBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set receivedBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReceivedBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearReceivedBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get assetId => $_getI64(5);
  @$pb.TagNumber(6)
  set assetId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssetId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssetId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get lastEvent => $_getSZ(6);
  @$pb.TagNumber(7)
  set lastEvent($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLastEvent() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastEvent() => $_clearField(7);

  @$pb.TagNumber(8)
  TraceStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(TraceStatus value) => $_setField(8, value);
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
  $0.Timestamp get publishedAt => $_getN(10);
  @$pb.TagNumber(11)
  set publishedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPublishedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearPublishedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensurePublishedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get updatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set updatedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureUpdatedAt() => $_ensure(12);

  @$pb.TagNumber(15)
  $core.double get progressPercent => $_getN(13);
  @$pb.TagNumber(15)
  set progressPercent($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(15)
  $core.bool hasProgressPercent() => $_has(13);
  @$pb.TagNumber(15)
  void clearProgressPercent() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<$fixnum.Int64> get embedPendingClipIds => $_getList(14);

  @$pb.TagNumber(17)
  $1.Run get run => $_getN(15);
  @$pb.TagNumber(17)
  set run($1.Run value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRun() => $_has(15);
  @$pb.TagNumber(17)
  void clearRun() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Run ensureRun() => $_ensure(15);
}

class TraceEvent extends $pb.GeneratedMessage {
  factory TraceEvent({
    $fixnum.Int64? eventId,
    $core.String? name,
    $core.String? status,
    $fixnum.Int64? runId,
    $2.Struct? detail,
    $core.String? errorCode,
    $core.String? errorMessage,
    $0.Timestamp? at,
  }) {
    final result = create();
    if (eventId != null) result.eventId = eventId;
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (runId != null) result.runId = runId;
    if (detail != null) result.detail = detail;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (at != null) result.at = at;
    return result;
  }

  TraceEvent._();

  factory TraceEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.trace.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aInt64(4, _omitFieldNames ? '' : 'runId')
    ..aOM<$2.Struct>(5, _omitFieldNames ? '' : 'detail',
        subBuilder: $2.Struct.create)
    ..aOS(6, _omitFieldNames ? '' : 'errorCode')
    ..aOS(7, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceEvent clone() => TraceEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceEvent copyWith(void Function(TraceEvent) updates) =>
      super.copyWith((message) => updates(message as TraceEvent)) as TraceEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceEvent create() => TraceEvent._();
  @$core.override
  TraceEvent createEmptyInstance() => create();
  static $pb.PbList<TraceEvent> createRepeated() => $pb.PbList<TraceEvent>();
  @$core.pragma('dart2js:noInline')
  static TraceEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceEvent>(create);
  static TraceEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get eventId => $_getI64(0);
  @$pb.TagNumber(1)
  set eventId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get runId => $_getI64(3);
  @$pb.TagNumber(4)
  set runId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRunId() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Struct get detail => $_getN(4);
  @$pb.TagNumber(5)
  set detail($2.Struct value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Struct ensureDetail() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get errorCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set errorCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasErrorCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearErrorCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get errorMessage => $_getSZ(6);
  @$pb.TagNumber(7)
  set errorMessage($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorMessage() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get at => $_getN(7);
  @$pb.TagNumber(8)
  set at($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureAt() => $_ensure(7);
}

class ListTracesRequest extends $pb.GeneratedMessage {
  factory ListTracesRequest({
    TraceStatus? status,
    $fixnum.Int64? assetId,
    $core.Iterable<$fixnum.Int64>? traceIds,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (assetId != null) result.assetId = assetId;
    if (traceIds != null) result.traceIds.addAll(traceIds);
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListTracesRequest._();

  factory ListTracesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTracesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTracesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.trace.v1'),
      createEmptyInstance: create)
    ..e<TraceStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: TraceStatus.TRACE_STATUS_UNSPECIFIED,
        valueOf: TraceStatus.valueOf,
        enumValues: TraceStatus.values)
    ..aInt64(2, _omitFieldNames ? '' : 'assetId')
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'traceIds', $pb.PbFieldType.K6)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesRequest clone() => ListTracesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesRequest copyWith(void Function(ListTracesRequest) updates) =>
      super.copyWith((message) => updates(message as ListTracesRequest))
          as ListTracesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTracesRequest create() => ListTracesRequest._();
  @$core.override
  ListTracesRequest createEmptyInstance() => create();
  static $pb.PbList<ListTracesRequest> createRepeated() =>
      $pb.PbList<ListTracesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTracesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTracesRequest>(create);
  static ListTracesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  TraceStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(TraceStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get assetId => $_getI64(1);
  @$pb.TagNumber(2)
  set assetId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get traceIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => $_clearField(5);
}

class ListTracesResponse extends $pb.GeneratedMessage {
  factory ListTracesResponse({
    $core.Iterable<Trace>? traces,
    $core.String? nextPageToken,
    $fixnum.Int64? totalCount,
  }) {
    final result = create();
    if (traces != null) result.traces.addAll(traces);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ListTracesResponse._();

  factory ListTracesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTracesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTracesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.trace.v1'),
      createEmptyInstance: create)
    ..pc<Trace>(1, _omitFieldNames ? '' : 'traces', $pb.PbFieldType.PM,
        subBuilder: Trace.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesResponse clone() => ListTracesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTracesResponse copyWith(void Function(ListTracesResponse) updates) =>
      super.copyWith((message) => updates(message as ListTracesResponse))
          as ListTracesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTracesResponse create() => ListTracesResponse._();
  @$core.override
  ListTracesResponse createEmptyInstance() => create();
  static $pb.PbList<ListTracesResponse> createRepeated() =>
      $pb.PbList<ListTracesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTracesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTracesResponse>(create);
  static ListTracesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trace> get traces => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalCount => $_getI64(2);
  @$pb.TagNumber(3)
  set totalCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class GetTraceRequest extends $pb.GeneratedMessage {
  factory GetTraceRequest({
    $fixnum.Int64? traceId,
  }) {
    final result = create();
    if (traceId != null) result.traceId = traceId;
    return result;
  }

  GetTraceRequest._();

  factory GetTraceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTraceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTraceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.trace.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'traceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceRequest clone() => GetTraceRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceRequest copyWith(void Function(GetTraceRequest) updates) =>
      super.copyWith((message) => updates(message as GetTraceRequest))
          as GetTraceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTraceRequest create() => GetTraceRequest._();
  @$core.override
  GetTraceRequest createEmptyInstance() => create();
  static $pb.PbList<GetTraceRequest> createRepeated() =>
      $pb.PbList<GetTraceRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTraceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTraceRequest>(create);
  static GetTraceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get traceId => $_getI64(0);
  @$pb.TagNumber(1)
  set traceId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);
}

class GetTraceResponse extends $pb.GeneratedMessage {
  factory GetTraceResponse({
    Trace? trace,
    $core.Iterable<TraceEvent>? events,
  }) {
    final result = create();
    if (trace != null) result.trace = trace;
    if (events != null) result.events.addAll(events);
    return result;
  }

  GetTraceResponse._();

  factory GetTraceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTraceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTraceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.trace.v1'),
      createEmptyInstance: create)
    ..aOM<Trace>(1, _omitFieldNames ? '' : 'trace', subBuilder: Trace.create)
    ..pc<TraceEvent>(2, _omitFieldNames ? '' : 'events', $pb.PbFieldType.PM,
        subBuilder: TraceEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceResponse clone() => GetTraceResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTraceResponse copyWith(void Function(GetTraceResponse) updates) =>
      super.copyWith((message) => updates(message as GetTraceResponse))
          as GetTraceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTraceResponse create() => GetTraceResponse._();
  @$core.override
  GetTraceResponse createEmptyInstance() => create();
  static $pb.PbList<GetTraceResponse> createRepeated() =>
      $pb.PbList<GetTraceResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTraceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTraceResponse>(create);
  static GetTraceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trace get trace => $_getN(0);
  @$pb.TagNumber(1)
  set trace(Trace value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrace() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrace() => $_clearField(1);
  @$pb.TagNumber(1)
  Trace ensureTrace() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<TraceEvent> get events => $_getList(1);
}

class TraceServiceApi {
  final $pb.RpcClient _client;

  TraceServiceApi(this._client);

  /// 최근 여정 목록, 새것부터. 진행 중 화면은 status = RUNNING으로 1~2초 폴링한다.
  $async.Future<ListTracesResponse> listTraces(
          $pb.ClientContext? ctx, ListTracesRequest request) =>
      _client.invoke<ListTracesResponse>(
          ctx, 'TraceService', 'ListTraces', request, ListTracesResponse());

  /// 여정 한 건과 이벤트 전부(오래된 것부터). 없으면 NotFound.
  $async.Future<GetTraceResponse> getTrace(
          $pb.ClientContext? ctx, GetTraceRequest request) =>
      _client.invoke<GetTraceResponse>(
          ctx, 'TraceService', 'GetTrace', request, GetTraceResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
