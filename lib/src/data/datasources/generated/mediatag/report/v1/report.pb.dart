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
    $fixnum.Int64? reportSetId,
    $fixnum.Int64? jobId,
    $fixnum.Int64? sourceAssetId,
    $core.int? pageStart,
    $core.int? pageEnd,
    $core.String? itemName,
    $core.String? unitNo,
    $core.String? projectNo,
    $core.String? itemAbbr,
    $0.Timestamp? createdAt,
    $core.Iterable<SectionSummary>? sections,
    $fixnum.Int64? splitAssetId,
    $core.int? reviewCount,
    $core.String? commonKey,
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
    if (commonKey != null) result.commonKey = commonKey;
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
    ..aInt64(1, _omitFieldNames ? '' : 'reportSetId')
    ..aInt64(2, _omitFieldNames ? '' : 'jobId')
    ..aInt64(3, _omitFieldNames ? '' : 'sourceAssetId')
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
    ..aInt64(12, _omitFieldNames ? '' : 'splitAssetId')
    ..a<$core.int>(13, _omitFieldNames ? '' : 'reviewCount', $pb.PbFieldType.O3)
    ..aOS(14, _omitFieldNames ? '' : 'commonKey')
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
  $fixnum.Int64 get reportSetId => $_getI64(0);
  @$pb.TagNumber(1)
  set reportSetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get jobId => $_getI64(1);
  @$pb.TagNumber(2)
  set jobId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sourceAssetId => $_getI64(2);
  @$pb.TagNumber(3)
  set sourceAssetId($fixnum.Int64 value) => $_setInt64(2, value);
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
  $fixnum.Int64 get splitAssetId => $_getI64(11);
  @$pb.TagNumber(12)
  set splitAssetId($fixnum.Int64 value) => $_setInt64(11, value);
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

  @$pb.TagNumber(14)
  $core.String get commonKey => $_getSZ(13);
  @$pb.TagNumber(14)
  set commonKey($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCommonKey() => $_has(13);
  @$pb.TagNumber(14)
  void clearCommonKey() => $_clearField(14);
}

class SectionSummary extends $pb.GeneratedMessage {
  factory SectionSummary({
    SectionKind? kind,
    $core.int? pageStart,
    $core.int? pageEnd,
    $core.String? overallResult,
    $fixnum.Int64? assetId,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (pageStart != null) result.pageStart = pageStart;
    if (pageEnd != null) result.pageEnd = pageEnd;
    if (overallResult != null) result.overallResult = overallResult;
    if (assetId != null) result.assetId = assetId;
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
    ..aInt64(5, _omitFieldNames ? '' : 'assetId')
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

  /// 이 문서(양식 한 건)만 잘라 낸 PDF Asset. 쪽 번호는 원본 기준 그대로다. 문서 하나를 따로 작업에 붙일 때
  /// AssetService.AttachAsset에 이 값을 준다. 결재 구간처럼 문서가 아닌 섹션은 0.
  @$pb.TagNumber(5)
  $fixnum.Int64 get assetId => $_getI64(4);
  @$pb.TagNumber(5)
  set assetId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssetId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssetId() => $_clearField(5);
}

class Section extends $pb.GeneratedMessage {
  factory Section({
    SectionKind? kind,
    $core.int? pageStart,
    $core.int? pageEnd,
    $1.Struct? fields,
    $fixnum.Int64? assetId,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (pageStart != null) result.pageStart = pageStart;
    if (pageEnd != null) result.pageEnd = pageEnd;
    if (fields != null) result.fields = fields;
    if (assetId != null) result.assetId = assetId;
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
    ..aInt64(5, _omitFieldNames ? '' : 'assetId')
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
  /// ponytail: 섹션 8종 × 수십 컬럼을 메시지로 옮기지 않고 Struct 하나로 둔다. 화면이 필드별
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

  @$pb.TagNumber(5)
  $fixnum.Int64 get assetId => $_getI64(4);
  @$pb.TagNumber(5)
  set assetId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssetId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssetId() => $_clearField(5);
}

class ListReportSetsRequest extends $pb.GeneratedMessage {
  factory ListReportSetsRequest({
    $fixnum.Int64? jobId,
    $core.String? commonKey,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (commonKey != null) result.commonKey = commonKey;
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
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
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
    $fixnum.Int64? reportSetId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'reportSetId')
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
  $fixnum.Int64 get reportSetId => $_getI64(0);
  @$pb.TagNumber(1)
  set reportSetId($fixnum.Int64 value) => $_setInt64(0, value);
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
    $fixnum.Int64? reportSetId,
    $fixnum.Int64? jobId,
    $core.String? commonKey,
  }) {
    final result = create();
    if (reportSetId != null) result.reportSetId = reportSetId;
    if (jobId != null) result.jobId = jobId;
    if (commonKey != null) result.commonKey = commonKey;
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
    ..aInt64(1, _omitFieldNames ? '' : 'reportSetId')
    ..aInt64(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'commonKey')
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
  $fixnum.Int64 get reportSetId => $_getI64(0);
  @$pb.TagNumber(1)
  set reportSetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get jobId => $_getI64(1);
  @$pb.TagNumber(2)
  set jobId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commonKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set commonKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommonKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommonKey() => $_clearField(3);
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

class ListQualityResultsRequest extends $pb.GeneratedMessage {
  factory ListQualityResultsRequest({
    $fixnum.Int64? jobId,
    $core.String? commonKey,
    $core.String? jointNo,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (commonKey != null) result.commonKey = commonKey;
    if (jointNo != null) result.jointNo = jointNo;
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aOS(3, _omitFieldNames ? '' : 'jointNo')
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
  $core.String get jointNo => $_getSZ(2);
  @$pb.TagNumber(3)
  set jointNo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJointNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearJointNo() => $_clearField(3);
}

class ListQualityResultsResponse extends $pb.GeneratedMessage {
  factory ListQualityResultsResponse({
    $core.Iterable<QualityReport>? reports,
  }) {
    final result = create();
    if (reports != null) result.reports.addAll(reports);
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
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..pc<QualityReport>(1, _omitFieldNames ? '' : 'reports', $pb.PbFieldType.PM,
        subBuilder: QualityReport.create)
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
  $pb.PbList<QualityReport> get reports => $_getList(0);
}

/// 성적서 세트 하나의 품질 결과. 검사는 두 층이다:
///   inspections — 검사 종류별 머리 정보와 판정. 취부·용접 외관·치수·기밀은 품목 전체에 대한 것이라 이음부를 골라도 같다.
///   joints      — 이음부 표. 한 행 = 확인번호 하나의 UT·MT 결과. 작업(job.joint_no)과는 확인번호로 잇는다.
class QualityReport extends $pb.GeneratedMessage {
  factory QualityReport({
    $fixnum.Int64? reportSetId,
    $core.String? commonKey,
    $fixnum.Int64? splitAssetId,
    $core.Iterable<QualityInspection>? inspections,
    $core.Iterable<JointQuality>? joints,
  }) {
    final result = create();
    if (reportSetId != null) result.reportSetId = reportSetId;
    if (commonKey != null) result.commonKey = commonKey;
    if (splitAssetId != null) result.splitAssetId = splitAssetId;
    if (inspections != null) result.inspections.addAll(inspections);
    if (joints != null) result.joints.addAll(joints);
    return result;
  }

  QualityReport._();

  factory QualityReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityReport',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'reportSetId')
    ..aOS(2, _omitFieldNames ? '' : 'commonKey')
    ..aInt64(3, _omitFieldNames ? '' : 'splitAssetId')
    ..pc<QualityInspection>(
        4, _omitFieldNames ? '' : 'inspections', $pb.PbFieldType.PM,
        subBuilder: QualityInspection.create)
    ..pc<JointQuality>(5, _omitFieldNames ? '' : 'joints', $pb.PbFieldType.PM,
        subBuilder: JointQuality.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityReport clone() => QualityReport()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityReport copyWith(void Function(QualityReport) updates) =>
      super.copyWith((message) => updates(message as QualityReport))
          as QualityReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityReport create() => QualityReport._();
  @$core.override
  QualityReport createEmptyInstance() => create();
  static $pb.PbList<QualityReport> createRepeated() =>
      $pb.PbList<QualityReport>();
  @$core.pragma('dart2js:noInline')
  static QualityReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityReport>(create);
  static QualityReport? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get reportSetId => $_getI64(0);
  @$pb.TagNumber(1)
  set reportSetId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commonKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set commonKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommonKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommonKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get splitAssetId => $_getI64(2);
  @$pb.TagNumber(3)
  set splitAssetId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSplitAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSplitAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<QualityInspection> get inspections => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<JointQuality> get joints => $_getList(4);
}

class QualityInspection extends $pb.GeneratedMessage {
  factory QualityInspection({
    SectionKind? kind,
    $core.String? method,
    $core.String? reportNo,
    $core.String? reportDate,
    $core.String? result,
    $core.int? pageStart,
    $core.int? pageEnd,
    $core.String? agency,
    $core.Iterable<QualityCheck>? checks,
  }) {
    final result$ = create();
    if (kind != null) result$.kind = kind;
    if (method != null) result$.method = method;
    if (reportNo != null) result$.reportNo = reportNo;
    if (reportDate != null) result$.reportDate = reportDate;
    if (result != null) result$.result = result;
    if (pageStart != null) result$.pageStart = pageStart;
    if (pageEnd != null) result$.pageEnd = pageEnd;
    if (agency != null) result$.agency = agency;
    if (checks != null) result$.checks.addAll(checks);
    return result$;
  }

  QualityInspection._();

  factory QualityInspection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityInspection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityInspection',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..e<SectionKind>(1, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: SectionKind.SECTION_KIND_UNSPECIFIED,
        valueOf: SectionKind.valueOf,
        enumValues: SectionKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'method')
    ..aOS(3, _omitFieldNames ? '' : 'reportNo')
    ..aOS(4, _omitFieldNames ? '' : 'reportDate')
    ..aOS(5, _omitFieldNames ? '' : 'result')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'pageStart', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'pageEnd', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'agency')
    ..pc<QualityCheck>(9, _omitFieldNames ? '' : 'checks', $pb.PbFieldType.PM,
        subBuilder: QualityCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityInspection clone() => QualityInspection()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityInspection copyWith(void Function(QualityInspection) updates) =>
      super.copyWith((message) => updates(message as QualityInspection))
          as QualityInspection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityInspection create() => QualityInspection._();
  @$core.override
  QualityInspection createEmptyInstance() => create();
  static $pb.PbList<QualityInspection> createRepeated() =>
      $pb.PbList<QualityInspection>();
  @$core.pragma('dart2js:noInline')
  static QualityInspection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityInspection>(create);
  static QualityInspection? _defaultInstance;

  @$pb.TagNumber(1)
  SectionKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SectionKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reportNo => $_getSZ(2);
  @$pb.TagNumber(3)
  set reportNo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReportNo() => $_has(2);
  @$pb.TagNumber(3)
  void clearReportNo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reportDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set reportDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReportDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearReportDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get result => $_getSZ(4);
  @$pb.TagNumber(5)
  set result($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResult() => $_has(4);
  @$pb.TagNumber(5)
  void clearResult() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageStart => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageStart($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageStart() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageStart() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get pageEnd => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageEnd($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageEnd() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageEnd() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get agency => $_getSZ(7);
  @$pb.TagNumber(8)
  set agency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAgency() => $_has(7);
  @$pb.TagNumber(8)
  void clearAgency() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<QualityCheck> get checks => $_getList(8);
}

class QualityCheck extends $pb.GeneratedMessage {
  factory QualityCheck({
    $core.String? name,
    $core.String? criterion,
    $core.String? actual,
    $core.String? result,
  }) {
    final result$ = create();
    if (name != null) result$.name = name;
    if (criterion != null) result$.criterion = criterion;
    if (actual != null) result$.actual = actual;
    if (result != null) result$.result = result;
    return result$;
  }

  QualityCheck._();

  factory QualityCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityCheck',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'criterion')
    ..aOS(3, _omitFieldNames ? '' : 'actual')
    ..aOS(4, _omitFieldNames ? '' : 'result')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityCheck clone() => QualityCheck()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityCheck copyWith(void Function(QualityCheck) updates) =>
      super.copyWith((message) => updates(message as QualityCheck))
          as QualityCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityCheck create() => QualityCheck._();
  @$core.override
  QualityCheck createEmptyInstance() => create();
  static $pb.PbList<QualityCheck> createRepeated() =>
      $pb.PbList<QualityCheck>();
  @$core.pragma('dart2js:noInline')
  static QualityCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityCheck>(create);
  static QualityCheck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get criterion => $_getSZ(1);
  @$pb.TagNumber(2)
  set criterion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCriterion() => $_has(1);
  @$pb.TagNumber(2)
  void clearCriterion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get actual => $_getSZ(2);
  @$pb.TagNumber(3)
  set actual($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActual() => $_has(2);
  @$pb.TagNumber(3)
  void clearActual() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get result => $_getSZ(3);
  @$pb.TagNumber(4)
  set result($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResult() => $_has(3);
  @$pb.TagNumber(4)
  void clearResult() => $_clearField(4);
}

/// 확인번호 하나. UT 표에만·MT 표에만 있는 번호도 온다 — MT에만 있는 것은 원주 이음이 아닌 짧은 용접(UT 대상 아님)이다.
class JointQuality extends $pb.GeneratedMessage {
  factory JointQuality({
    $core.String? jointNo,
    $core.Iterable<$fixnum.Int64>? jobIds,
    UtResult? ut,
    MtResult? mt,
  }) {
    final result = create();
    if (jointNo != null) result.jointNo = jointNo;
    if (jobIds != null) result.jobIds.addAll(jobIds);
    if (ut != null) result.ut = ut;
    if (mt != null) result.mt = mt;
    return result;
  }

  JointQuality._();

  factory JointQuality.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JointQuality.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JointQuality',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jointNo')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'jobIds', $pb.PbFieldType.K6)
    ..aOM<UtResult>(3, _omitFieldNames ? '' : 'ut', subBuilder: UtResult.create)
    ..aOM<MtResult>(4, _omitFieldNames ? '' : 'mt', subBuilder: MtResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JointQuality clone() => JointQuality()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JointQuality copyWith(void Function(JointQuality) updates) =>
      super.copyWith((message) => updates(message as JointQuality))
          as JointQuality;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JointQuality create() => JointQuality._();
  @$core.override
  JointQuality createEmptyInstance() => create();
  static $pb.PbList<JointQuality> createRepeated() =>
      $pb.PbList<JointQuality>();
  @$core.pragma('dart2js:noInline')
  static JointQuality getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JointQuality>(create);
  static JointQuality? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jointNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set jointNo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJointNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearJointNo() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get jobIds => $_getList(1);

  @$pb.TagNumber(3)
  UtResult get ut => $_getN(2);
  @$pb.TagNumber(3)
  set ut(UtResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUt() => $_clearField(3);
  @$pb.TagNumber(3)
  UtResult ensureUt() => $_ensure(2);

  @$pb.TagNumber(4)
  MtResult get mt => $_getN(3);
  @$pb.TagNumber(4)
  set mt(MtResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMt() => $_has(3);
  @$pb.TagNumber(4)
  void clearMt() => $_clearField(4);
  @$pb.TagNumber(4)
  MtResult ensureMt() => $_ensure(3);
}

class UtResult extends $pb.GeneratedMessage {
  factory UtResult({
    $core.String? thicknessMm,
    $core.double? lengthMm,
    $core.int? probeAngle,
    $core.String? indication,
    $core.String? evaluation,
    $core.String? result,
    $core.String? inspectionDate,
  }) {
    final result$ = create();
    if (thicknessMm != null) result$.thicknessMm = thicknessMm;
    if (lengthMm != null) result$.lengthMm = lengthMm;
    if (probeAngle != null) result$.probeAngle = probeAngle;
    if (indication != null) result$.indication = indication;
    if (evaluation != null) result$.evaluation = evaluation;
    if (result != null) result$.result = result;
    if (inspectionDate != null) result$.inspectionDate = inspectionDate;
    return result$;
  }

  UtResult._();

  factory UtResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UtResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UtResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'thicknessMm')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lengthMm', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'probeAngle', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'indication')
    ..aOS(5, _omitFieldNames ? '' : 'evaluation')
    ..aOS(6, _omitFieldNames ? '' : 'result')
    ..aOS(7, _omitFieldNames ? '' : 'inspectionDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UtResult clone() => UtResult()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UtResult copyWith(void Function(UtResult) updates) =>
      super.copyWith((message) => updates(message as UtResult)) as UtResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UtResult create() => UtResult._();
  @$core.override
  UtResult createEmptyInstance() => create();
  static $pb.PbList<UtResult> createRepeated() => $pb.PbList<UtResult>();
  @$core.pragma('dart2js:noInline')
  static UtResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UtResult>(create);
  static UtResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get thicknessMm => $_getSZ(0);
  @$pb.TagNumber(1)
  set thicknessMm($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThicknessMm() => $_has(0);
  @$pb.TagNumber(1)
  void clearThicknessMm() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get lengthMm => $_getN(1);
  @$pb.TagNumber(2)
  set lengthMm($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLengthMm() => $_has(1);
  @$pb.TagNumber(2)
  void clearLengthMm() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get probeAngle => $_getIZ(2);
  @$pb.TagNumber(3)
  set probeAngle($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProbeAngle() => $_has(2);
  @$pb.TagNumber(3)
  void clearProbeAngle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get indication => $_getSZ(3);
  @$pb.TagNumber(4)
  set indication($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIndication() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndication() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get evaluation => $_getSZ(4);
  @$pb.TagNumber(5)
  set evaluation($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEvaluation() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvaluation() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get result => $_getSZ(5);
  @$pb.TagNumber(6)
  set result($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResult() => $_has(5);
  @$pb.TagNumber(6)
  void clearResult() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get inspectionDate => $_getSZ(6);
  @$pb.TagNumber(7)
  set inspectionDate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInspectionDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearInspectionDate() => $_clearField(7);
}

class MtResult extends $pb.GeneratedMessage {
  factory MtResult({
    $core.double? checkLengthMm,
    $core.double? indicationLengthMm,
    $core.String? indication,
    $core.String? result,
  }) {
    final result$ = create();
    if (checkLengthMm != null) result$.checkLengthMm = checkLengthMm;
    if (indicationLengthMm != null)
      result$.indicationLengthMm = indicationLengthMm;
    if (indication != null) result$.indication = indication;
    if (result != null) result$.result = result;
    return result$;
  }

  MtResult._();

  factory MtResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MtResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MtResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.report.v1'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1, _omitFieldNames ? '' : 'checkLengthMm', $pb.PbFieldType.OD)
    ..a<$core.double>(
        2, _omitFieldNames ? '' : 'indicationLengthMm', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'indication')
    ..aOS(4, _omitFieldNames ? '' : 'result')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MtResult clone() => MtResult()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MtResult copyWith(void Function(MtResult) updates) =>
      super.copyWith((message) => updates(message as MtResult)) as MtResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MtResult create() => MtResult._();
  @$core.override
  MtResult createEmptyInstance() => create();
  static $pb.PbList<MtResult> createRepeated() => $pb.PbList<MtResult>();
  @$core.pragma('dart2js:noInline')
  static MtResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MtResult>(create);
  static MtResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get checkLengthMm => $_getN(0);
  @$pb.TagNumber(1)
  set checkLengthMm($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckLengthMm() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckLengthMm() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get indicationLengthMm => $_getN(1);
  @$pb.TagNumber(2)
  set indicationLengthMm($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndicationLengthMm() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndicationLengthMm() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get indication => $_getSZ(2);
  @$pb.TagNumber(3)
  set indication($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIndication() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndication() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get result => $_getSZ(3);
  @$pb.TagNumber(4)
  set result($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResult() => $_has(3);
  @$pb.TagNumber(4)
  void clearResult() => $_clearField(4);
}

/// 사용처: 대시보드(s4 품질 판정 카드).
class ReportServiceApi {
  final $pb.RpcClient _client;

  ReportServiceApi(this._client);

  /// 작업(job_id) 또는 품목(common_key)의 성적서 세트 목록. 섹션 본문은 빼고 준다.
  /// job_id를 주면 그 작업에 매칭된 세트와 그 작업의 품목에 매칭된 세트를 함께 준다.
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

  /// 세트를 작업 또는 품목에 매칭한다. 잘라 낸 PDF(split_asset_id)를 같은 트랜잭션에서 첨부한다.
  ///   job_id: 그 작업에 매칭하고 세트의 common_key도 그 작업의 품목으로 채운다(PDF는 그 작업에 첨부).
  ///   common_key만: 품목에 매칭한다(PDF는 그 품목의 작업 모두에 첨부). 이음부 단위 작업은 이쪽을 쓴다.
  ///   둘 다 비면 매칭을 푼다(첨부는 그대로 — 필요하면 DetachAsset).
  $async.Future<MatchReportSetResponse> matchReportSet(
          $pb.ClientContext? ctx, MatchReportSetRequest request) =>
      _client.invoke<MatchReportSetResponse>(ctx, 'ReportService',
          'MatchReportSet', request, MatchReportSetResponse());

  /// 작업·이음부 기준 품질 결과: 검사 종류별 판정과 이음부별 UT·MT 표. 성적서 원문 전체는 GetReportSet.
  /// job_id(그 작업의 이음부) 또는 common_key(+joint_no). 이음부를 안 주면 품목의 이음부 전체가 표로 온다.
  $async.Future<ListQualityResultsResponse> listQualityResults(
          $pb.ClientContext? ctx, ListQualityResultsRequest request) =>
      _client.invoke<ListQualityResultsResponse>(ctx, 'ReportService',
          'ListQualityResults', request, ListQualityResultsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
