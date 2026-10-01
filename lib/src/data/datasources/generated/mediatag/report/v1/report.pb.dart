// This is a generated file - do not edit.
//
// Generated from mediatag/report/v1/report.proto.

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

import '../../../google/protobuf/struct.pb.dart' as $1;
import '../../../google/protobuf/timestamp.pb.dart' as $0;
import 'report.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'report.pbenum.dart';

class ReportSet extends $pb.GeneratedMessage {
  factory ReportSet({
    $core.String? reportSetId,
    $core.String? jobId,
    $core.String? sourceAssetId,
    $core.int? pageStart,
    $core.int? pageEnd,
    $core.String? itemName,
    $core.String? unitNo,
    $core.String? projectNo,
    $core.String? itemAbbr,
    $0.Timestamp? createdAt,
    $core.Iterable<SectionSummary>? sections,
    $core.String? splitAssetId,
    $core.int? reviewCount,
  }) {
    final result = create();
    if (reportSetId != null) result.reportSetId = reportSetId;
    if (jobId != null) result.jobId = jobId;
    if (sourceAssetId != null) result.sourceAssetId = sourceAssetId;
    if (pageStart != null) result.pageStart = pageStart;
    if (pageEnd != null) result.pageEnd = pageEnd;
    if (itemName != null) result.itemName = itemName;
    if (unitNo != null) result.unitNo = unitNo;
    if (projectNo != null) result.projectNo = projectNo;
    if (itemAbbr != null) result.itemAbbr = itemAbbr;
    if (createdAt != null) result.createdAt = createdAt;
    if (sections != null) result.sections.addAll(sections);
    if (splitAssetId != null) result.splitAssetId = splitAssetId;
    if (reviewCount != null) result.reviewCount = reviewCount;
    return result;
  }

  ReportSet._();

  factory ReportSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportSet',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportSetId')
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceAssetId')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pageStart', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'pageEnd', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'itemName')
    ..aOS(7, _omitFieldNames ? '' : 'unitNo')
    ..aOS(8, _omitFieldNames ? '' : 'projectNo')
    ..aOS(9, _omitFieldNames ? '' : 'itemAbbr')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..pc<SectionSummary>(
        11, _omitFieldNames ? '' : 'sections', $pb.PbFieldType.PM,
        subBuilder: SectionSummary.create)
    ..aOS(12, _omitFieldNames ? '' : 'splitAssetId')
    ..a<$core.int>(13, _omitFieldNames ? '' : 'reviewCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportSet clone() => ReportSet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportSet copyWith(void Function(ReportSet) updates) =>
      super.copyWith((message) => updates(message as ReportSet)) as ReportSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportSet create() => ReportSet._();
  @$core.override
  ReportSet createEmptyInstance() => create();
  static $pb.PbList<ReportSet> createRepeated() => $pb.PbList<ReportSet>();
  @$core.pragma('dart2js:noInline')
  static ReportSet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportSet>(create);
  static ReportSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportSetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportSetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceAssetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageStart => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageStart($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageEnd => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageEnd($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageEnd() => $_clearField(5);

  /// OCR로 읽은 원문 값(정규화 전). 매칭 재료이자 근거
  @$pb.TagNumber(6)
  $core.String get itemName => $_getSZ(5);
  @$pb.TagNumber(6)
  set itemName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasItemName() => $_has(5);
  @$pb.TagNumber(6)
  void clearItemName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get unitNo => $_getSZ(6);
  @$pb.TagNumber(7)
  set unitNo($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnitNo() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnitNo() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get projectNo => $_getSZ(7);
  @$pb.TagNumber(8)
  set projectNo($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProjectNo() => $_has(7);
  @$pb.TagNumber(8)
  void clearProjectNo() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get itemAbbr => $_getSZ(8);
  @$pb.TagNumber(9)
  set itemAbbr($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasItemAbbr() => $_has(8);
  @$pb.TagNumber(9)
  void clearItemAbbr() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<SectionSummary> get sections => $_getList(10);

  /// 원본에서 이 세트 구간만 잘라 낸 작업별 PDF(파생 Asset). 작업 화면·첨부는 이것. 비면 아직 안 잘랐다.
  /// 잘라 낸 PDF 안의 쪽 = 원본 쪽 - page_start + 1
  @$pb.TagNumber(12)
  $core.String get splitAssetId => $_getSZ(11);
  @$pb.TagNumber(12)
  set splitAssetId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSplitAssetId() => $_has(11);
  @$pb.TagNumber(12)
  void clearSplitAssetId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get reviewCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set reviewCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasReviewCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearReviewCount() => $_clearField(13);
}

class SectionSummary extends $pb.GeneratedMessage {
  factory SectionSummary({
    SectionKind? kind,
    $core.int? pageStart,
    $core.int? pageEnd,
    $core.String? overallResult,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (pageStart != null) result.pageStart = pageStart;
    if (pageEnd != null) result.pageEnd = pageEnd;
    if (overallResult != null) result.overallResult = overallResult;
    return result;
  }

  SectionSummary._();

  factory SectionSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SectionSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SectionSummary',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..e<SectionKind>(1, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: SectionKind.SECTION_KIND_UNSPECIFIED,
        valueOf: SectionKind.valueOf,
        enumValues: SectionKind.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageStart', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageEnd', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'overallResult')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SectionSummary clone() => SectionSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SectionSummary copyWith(void Function(SectionSummary) updates) =>
      super.copyWith((message) => updates(message as SectionSummary))
          as SectionSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SectionSummary create() => SectionSummary._();
  @$core.override
  SectionSummary createEmptyInstance() => create();
  static $pb.PbList<SectionSummary> createRepeated() =>
      $pb.PbList<SectionSummary>();
  @$core.pragma('dart2js:noInline')
  static SectionSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SectionSummary>(create);
  static SectionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  SectionKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SectionKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageStart => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageStart($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageStart() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageEnd => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageEnd($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageEnd() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get overallResult => $_getSZ(3);
  @$pb.TagNumber(4)
  set overallResult($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverallResult() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverallResult() => $_clearField(4);
}

class Section extends $pb.GeneratedMessage {
  factory Section({
    SectionKind? kind,
    $core.int? pageStart,
    $core.int? pageEnd,
    $1.Struct? fields,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (pageStart != null) result.pageStart = pageStart;
    if (pageEnd != null) result.pageEnd = pageEnd;
    if (fields != null) result.fields = fields;
    return result;
  }

  Section._();

  factory Section.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Section.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Section',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..e<SectionKind>(1, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: SectionKind.SECTION_KIND_UNSPECIFIED,
        valueOf: SectionKind.valueOf,
        enumValues: SectionKind.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageStart', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageEnd', $pb.PbFieldType.O3)
    ..aOM<$1.Struct>(4, _omitFieldNames ? '' : 'fields',
        subBuilder: $1.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Section clone() => Section()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Section copyWith(void Function(Section) updates) =>
      super.copyWith((message) => updates(message as Section)) as Section;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Section create() => Section._();
  @$core.override
  Section createEmptyInstance() => create();
  static $pb.PbList<Section> createRepeated() => $pb.PbList<Section>();
  @$core.pragma('dart2js:noInline')
  static Section getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Section>(create);
  static Section? _defaultInstance;

  @$pb.TagNumber(1)
  SectionKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SectionKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageStart => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageStart($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageStart() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageEnd => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageEnd($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageEnd() => $_clearField(3);

  /// 섹션 행의 컬럼 전체(id·report_set_id·created_at 제외)와 자식 테이블 배열
  /// (예: dimension_points, gauge_readings, ut_joints). 키는 DB 컬럼·테이블 이름 그대로.
  /// ponytail: 섹션 6종 × 수십 컬럼을 메시지로 옮기지 않고 Struct 하나로 둔다. 화면이 필드별
  /// 타입 검사가 필요해지면 섹션별 메시지로 바꾼다.
  @$pb.TagNumber(4)
  $1.Struct get fields => $_getN(3);
  @$pb.TagNumber(4)
  set fields($1.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFields() => $_has(3);
  @$pb.TagNumber(4)
  void clearFields() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Struct ensureFields() => $_ensure(3);
}

class ListReportSetsRequest extends $pb.GeneratedMessage {
  factory ListReportSetsRequest({
    $core.String? jobId,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  ListReportSetsRequest._();

  factory ListReportSetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReportSetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReportSetsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportSetsRequest clone() =>
      ListReportSetsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportSetsRequest copyWith(
          void Function(ListReportSetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReportSetsRequest))
          as ListReportSetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReportSetsRequest create() => ListReportSetsRequest._();
  @$core.override
  ListReportSetsRequest createEmptyInstance() => create();
  static $pb.PbList<ListReportSetsRequest> createRepeated() =>
      $pb.PbList<ListReportSetsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListReportSetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReportSetsRequest>(create);
  static ListReportSetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

class ListReportSetsResponse extends $pb.GeneratedMessage {
  factory ListReportSetsResponse({
    $core.Iterable<ReportSet>? reportSets,
  }) {
    final result = create();
    if (reportSets != null) result.reportSets.addAll(reportSets);
    return result;
  }

  ListReportSetsResponse._();

  factory ListReportSetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReportSetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReportSetsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..pc<ReportSet>(1, _omitFieldNames ? '' : 'reportSets', $pb.PbFieldType.PM,
        subBuilder: ReportSet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportSetsResponse clone() =>
      ListReportSetsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportSetsResponse copyWith(
          void Function(ListReportSetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReportSetsResponse))
          as ListReportSetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReportSetsResponse create() => ListReportSetsResponse._();
  @$core.override
  ListReportSetsResponse createEmptyInstance() => create();
  static $pb.PbList<ListReportSetsResponse> createRepeated() =>
      $pb.PbList<ListReportSetsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListReportSetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReportSetsResponse>(create);
  static ListReportSetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReportSet> get reportSets => $_getList(0);
}

class GetReportSetRequest extends $pb.GeneratedMessage {
  factory GetReportSetRequest({
    $core.String? reportSetId,
  }) {
    final result = create();
    if (reportSetId != null) result.reportSetId = reportSetId;
    return result;
  }

  GetReportSetRequest._();

  factory GetReportSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReportSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReportSetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportSetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportSetRequest clone() => GetReportSetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportSetRequest copyWith(void Function(GetReportSetRequest) updates) =>
      super.copyWith((message) => updates(message as GetReportSetRequest))
          as GetReportSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReportSetRequest create() => GetReportSetRequest._();
  @$core.override
  GetReportSetRequest createEmptyInstance() => create();
  static $pb.PbList<GetReportSetRequest> createRepeated() =>
      $pb.PbList<GetReportSetRequest>();
  @$core.pragma('dart2js:noInline')
  static GetReportSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReportSetRequest>(create);
  static GetReportSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportSetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportSetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSetId() => $_clearField(1);
}

class GetReportSetResponse extends $pb.GeneratedMessage {
  factory GetReportSetResponse({
    ReportSet? reportSet,
    $core.Iterable<Section>? sections,
    $core.Iterable<ReviewItem>? reviews,
  }) {
    final result = create();
    if (reportSet != null) result.reportSet = reportSet;
    if (sections != null) result.sections.addAll(sections);
    if (reviews != null) result.reviews.addAll(reviews);
    return result;
  }

  GetReportSetResponse._();

  factory GetReportSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReportSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReportSetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOM<ReportSet>(1, _omitFieldNames ? '' : 'reportSet',
        subBuilder: ReportSet.create)
    ..pc<Section>(2, _omitFieldNames ? '' : 'sections', $pb.PbFieldType.PM,
        subBuilder: Section.create)
    ..pc<ReviewItem>(3, _omitFieldNames ? '' : 'reviews', $pb.PbFieldType.PM,
        subBuilder: ReviewItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportSetResponse clone() =>
      GetReportSetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportSetResponse copyWith(void Function(GetReportSetResponse) updates) =>
      super.copyWith((message) => updates(message as GetReportSetResponse))
          as GetReportSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReportSetResponse create() => GetReportSetResponse._();
  @$core.override
  GetReportSetResponse createEmptyInstance() => create();
  static $pb.PbList<GetReportSetResponse> createRepeated() =>
      $pb.PbList<GetReportSetResponse>();
  @$core.pragma('dart2js:noInline')
  static GetReportSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReportSetResponse>(create);
  static GetReportSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReportSet get reportSet => $_getN(0);
  @$pb.TagNumber(1)
  set reportSet(ReportSet value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSet() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSet() => $_clearField(1);
  @$pb.TagNumber(1)
  ReportSet ensureReportSet() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Section> get sections => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ReviewItem> get reviews => $_getList(2);
}

/// 확인 목록 한 칸(doc.report_review) — 정확한지 애매해 사람이 볼 칸. 값은 섹션·세트에 그대로 들어 있고
/// 여기는 표시다. 형식에 안 맞아 비운 칸(UNREADABLE)은 원문이 여기에만 있다.
class ReviewItem extends $pb.GeneratedMessage {
  factory ReviewItem({
    $fixnum.Int64? id,
    $core.int? page,
    $core.String? field_3,
    $core.String? columnName,
    $core.String? value,
    $core.String? raw,
    $core.double? ocrScore,
    $core.Iterable<$core.double>? bbox,
    ReviewReason? reason,
    $core.String? correctedValue,
    $core.String? correctedBy,
    $0.Timestamp? correctedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (page != null) result.page = page;
    if (field_3 != null) result.field_3 = field_3;
    if (columnName != null) result.columnName = columnName;
    if (value != null) result.value = value;
    if (raw != null) result.raw = raw;
    if (ocrScore != null) result.ocrScore = ocrScore;
    if (bbox != null) result.bbox.addAll(bbox);
    if (reason != null) result.reason = reason;
    if (correctedValue != null) result.correctedValue = correctedValue;
    if (correctedBy != null) result.correctedBy = correctedBy;
    if (correctedAt != null) result.correctedAt = correctedAt;
    return result;
  }

  ReviewItem._();

  factory ReviewItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'page', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'field')
    ..aOS(4, _omitFieldNames ? '' : 'columnName')
    ..aOS(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'raw')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'ocrScore', $pb.PbFieldType.OD)
    ..p<$core.double>(8, _omitFieldNames ? '' : 'bbox', $pb.PbFieldType.KD)
    ..e<ReviewReason>(9, _omitFieldNames ? '' : 'reason', $pb.PbFieldType.OE,
        defaultOrMaker: ReviewReason.REVIEW_REASON_UNSPECIFIED,
        valueOf: ReviewReason.valueOf,
        enumValues: ReviewReason.values)
    ..aOS(10, _omitFieldNames ? '' : 'correctedValue')
    ..aOS(11, _omitFieldNames ? '' : 'correctedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'correctedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewItem clone() => ReviewItem()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewItem copyWith(void Function(ReviewItem) updates) =>
      super.copyWith((message) => updates(message as ReviewItem)) as ReviewItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewItem create() => ReviewItem._();
  @$core.override
  ReviewItem createEmptyInstance() => create();
  static $pb.PbList<ReviewItem> createRepeated() => $pb.PbList<ReviewItem>();
  @$core.pragma('dart2js:noInline')
  static ReviewItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewItem>(create);
  static ReviewItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get page => $_getIZ(1);
  @$pb.TagNumber(2)
  set page($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get field_3 => $_getSZ(2);
  @$pb.TagNumber(3)
  set field_3($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasField_3() => $_has(2);
  @$pb.TagNumber(3)
  void clearField_3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get columnName => $_getSZ(3);
  @$pb.TagNumber(4)
  set columnName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColumnName() => $_has(3);
  @$pb.TagNumber(4)
  void clearColumnName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(5)
  set value($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get raw => $_getSZ(5);
  @$pb.TagNumber(6)
  set raw($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRaw() => $_has(5);
  @$pb.TagNumber(6)
  void clearRaw() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get ocrScore => $_getN(6);
  @$pb.TagNumber(7)
  set ocrScore($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOcrScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearOcrScore() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.double> get bbox => $_getList(7);

  @$pb.TagNumber(9)
  ReviewReason get reason => $_getN(8);
  @$pb.TagNumber(9)
  set reason(ReviewReason value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get correctedValue => $_getSZ(9);
  @$pb.TagNumber(10)
  set correctedValue($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCorrectedValue() => $_has(9);
  @$pb.TagNumber(10)
  void clearCorrectedValue() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get correctedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set correctedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCorrectedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearCorrectedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get correctedAt => $_getN(11);
  @$pb.TagNumber(12)
  set correctedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCorrectedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCorrectedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCorrectedAt() => $_ensure(11);
}

class ResolveReviewRequest extends $pb.GeneratedMessage {
  factory ResolveReviewRequest({
    $fixnum.Int64? reviewId,
    $core.String? correctedValue,
    $core.String? correctedBy,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (correctedValue != null) result.correctedValue = correctedValue;
    if (correctedBy != null) result.correctedBy = correctedBy;
    return result;
  }

  ResolveReviewRequest._();

  factory ResolveReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'correctedValue')
    ..aOS(3, _omitFieldNames ? '' : 'correctedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveReviewRequest clone() =>
      ResolveReviewRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveReviewRequest copyWith(void Function(ResolveReviewRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveReviewRequest))
          as ResolveReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveReviewRequest create() => ResolveReviewRequest._();
  @$core.override
  ResolveReviewRequest createEmptyInstance() => create();
  static $pb.PbList<ResolveReviewRequest> createRepeated() =>
      $pb.PbList<ResolveReviewRequest>();
  @$core.pragma('dart2js:noInline')
  static ResolveReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveReviewRequest>(create);
  static ResolveReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get reviewId => $_getI64(0);
  @$pb.TagNumber(1)
  set reviewId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get correctedValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set correctedValue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCorrectedValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearCorrectedValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get correctedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set correctedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCorrectedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearCorrectedBy() => $_clearField(3);
}

class ResolveReviewResponse extends $pb.GeneratedMessage {
  factory ResolveReviewResponse({
    ReviewItem? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  ResolveReviewResponse._();

  factory ResolveReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveReviewResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOM<ReviewItem>(1, _omitFieldNames ? '' : 'review',
        subBuilder: ReviewItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveReviewResponse clone() =>
      ResolveReviewResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveReviewResponse copyWith(
          void Function(ResolveReviewResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveReviewResponse))
          as ResolveReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveReviewResponse create() => ResolveReviewResponse._();
  @$core.override
  ResolveReviewResponse createEmptyInstance() => create();
  static $pb.PbList<ResolveReviewResponse> createRepeated() =>
      $pb.PbList<ResolveReviewResponse>();
  @$core.pragma('dart2js:noInline')
  static ResolveReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveReviewResponse>(create);
  static ResolveReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReviewItem get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(ReviewItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  ReviewItem ensureReview() => $_ensure(0);
}

class MatchReportSetRequest extends $pb.GeneratedMessage {
  factory MatchReportSetRequest({
    $core.String? reportSetId,
    $core.String? jobId,
  }) {
    final result = create();
    if (reportSetId != null) result.reportSetId = reportSetId;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  MatchReportSetRequest._();

  factory MatchReportSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchReportSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchReportSetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportSetId')
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchReportSetRequest clone() =>
      MatchReportSetRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchReportSetRequest copyWith(
          void Function(MatchReportSetRequest) updates) =>
      super.copyWith((message) => updates(message as MatchReportSetRequest))
          as MatchReportSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchReportSetRequest create() => MatchReportSetRequest._();
  @$core.override
  MatchReportSetRequest createEmptyInstance() => create();
  static $pb.PbList<MatchReportSetRequest> createRepeated() =>
      $pb.PbList<MatchReportSetRequest>();
  @$core.pragma('dart2js:noInline')
  static MatchReportSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchReportSetRequest>(create);
  static MatchReportSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportSetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportSetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);
}

class MatchReportSetResponse extends $pb.GeneratedMessage {
  factory MatchReportSetResponse({
    ReportSet? reportSet,
  }) {
    final result = create();
    if (reportSet != null) result.reportSet = reportSet;
    return result;
  }

  MatchReportSetResponse._();

  factory MatchReportSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchReportSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchReportSetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOM<ReportSet>(1, _omitFieldNames ? '' : 'reportSet',
        subBuilder: ReportSet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchReportSetResponse clone() =>
      MatchReportSetResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchReportSetResponse copyWith(
          void Function(MatchReportSetResponse) updates) =>
      super.copyWith((message) => updates(message as MatchReportSetResponse))
          as MatchReportSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchReportSetResponse create() => MatchReportSetResponse._();
  @$core.override
  MatchReportSetResponse createEmptyInstance() => create();
  static $pb.PbList<MatchReportSetResponse> createRepeated() =>
      $pb.PbList<MatchReportSetResponse>();
  @$core.pragma('dart2js:noInline')
  static MatchReportSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchReportSetResponse>(create);
  static MatchReportSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReportSet get reportSet => $_getN(0);
  @$pb.TagNumber(1)
  set reportSet(ReportSet value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSet() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSet() => $_clearField(1);
  @$pb.TagNumber(1)
  ReportSet ensureReportSet() => $_ensure(0);
}

/// 사용처: 대시보드(s4 품질 판정 카드).
class ReportServiceApi {
  final $pb.RpcClient _client;

  ReportServiceApi(this._client);

  /// 작업의 성적서 세트 목록. 섹션 본문은 빼고 준다.
  $async.Future<ListReportSetsResponse> listReportSets(
          $pb.ClientContext? ctx, ListReportSetsRequest request) =>
      _client.invoke<ListReportSetsResponse>(ctx, 'ReportService',
          'ListReportSets', request, ListReportSetsResponse());

  /// 세트 하나 + 섹션 본문 전체.
  $async.Future<GetReportSetResponse> getReportSet(
          $pb.ClientContext? ctx, GetReportSetRequest request) =>
      _client.invoke<GetReportSetResponse>(ctx, 'ReportService', 'GetReportSet',
          request, GetReportSetResponse());

  /// 확인 목록 한 칸을 확인·보정한다. corrected_value가 비면 "원문이 맞음"으로 확인만 한다.
  /// 섹션·세트의 값은 바꾸지 않는다(원문은 근거로 남기고 보정값은 여기) — 매칭은 보정값을 먼저 쓴다.
  $async.Future<ResolveReviewResponse> resolveReview(
          $pb.ClientContext? ctx, ResolveReviewRequest request) =>
      _client.invoke<ResolveReviewResponse>(ctx, 'ReportService',
          'ResolveReview', request, ResolveReviewResponse());

  /// 세트를 작업에 매칭한다. 잘라 낸 PDF(split_asset_id)를 그 작업에 같은 트랜잭션에서 첨부한다.
  /// job_id가 비면 매칭을 푼다(첨부는 그대로 — 필요하면 DetachAsset).
  $async.Future<MatchReportSetResponse> matchReportSet(
          $pb.ClientContext? ctx, MatchReportSetRequest request) =>
      _client.invoke<MatchReportSetResponse>(ctx, 'ReportService',
          'MatchReportSet', request, MatchReportSetResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
