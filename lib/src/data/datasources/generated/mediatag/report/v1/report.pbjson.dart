// This is a generated file - do not edit.
//
// Generated from mediatag/report/v1/report.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/struct.pbjson.dart' as $1;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use sectionKindDescriptor instead')
const SectionKind$json = {
  '1': 'SectionKind',
  '2': [
    {'1': 'SECTION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SECTION_KIND_FITUP', '2': 1},
    {'1': 'SECTION_KIND_WELDING', '2': 2},
    {'1': 'SECTION_KIND_DIMENSIONAL', '2': 3},
    {'1': 'SECTION_KIND_PRESSURE', '2': 4},
    {'1': 'SECTION_KIND_NDT', '2': 5},
    {'1': 'SECTION_KIND_APPROVALS', '2': 6},
  ],
};

/// Descriptor for `SectionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sectionKindDescriptor = $convert.base64Decode(
    'CgtTZWN0aW9uS2luZBIcChhTRUNUSU9OX0tJTkRfVU5TUEVDSUZJRUQQABIWChJTRUNUSU9OX0'
    'tJTkRfRklUVVAQARIYChRTRUNUSU9OX0tJTkRfV0VMRElORxACEhwKGFNFQ1RJT05fS0lORF9E'
    'SU1FTlNJT05BTBADEhkKFVNFQ1RJT05fS0lORF9QUkVTU1VSRRAEEhQKEFNFQ1RJT05fS0lORF'
    '9ORFQQBRIaChZTRUNUSU9OX0tJTkRfQVBQUk9WQUxTEAY=');

@$core.Deprecated('Use reviewReasonDescriptor instead')
const ReviewReason$json = {
  '1': 'ReviewReason',
  '2': [
    {'1': 'REVIEW_REASON_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_REASON_LOW_CONFIDENCE', '2': 1},
    {'1': 'REVIEW_REASON_VLM_RECHECKED', '2': 2},
    {'1': 'REVIEW_REASON_SNAPPED', '2': 3},
    {'1': 'REVIEW_REASON_UNREADABLE', '2': 4},
  ],
};

/// Descriptor for `ReviewReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewReasonDescriptor = $convert.base64Decode(
    'CgxSZXZpZXdSZWFzb24SHQoZUkVWSUVXX1JFQVNPTl9VTlNQRUNJRklFRBAAEiAKHFJFVklFV1'
    '9SRUFTT05fTE9XX0NPTkZJREVOQ0UQARIfChtSRVZJRVdfUkVBU09OX1ZMTV9SRUNIRUNLRUQQ'
    'AhIZChVSRVZJRVdfUkVBU09OX1NOQVBQRUQQAxIcChhSRVZJRVdfUkVBU09OX1VOUkVBREFCTE'
    'UQBA==');

@$core.Deprecated('Use reportSetDescriptor instead')
const ReportSet$json = {
  '1': 'ReportSet',
  '2': [
    {'1': 'report_set_id', '3': 1, '4': 1, '5': 9, '10': 'reportSetId'},
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'source_asset_id', '3': 3, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {
      '1': 'page_start',
      '3': 4,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'pageStart',
      '17': true
    },
    {
      '1': 'page_end',
      '3': 5,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'pageEnd',
      '17': true
    },
    {'1': 'split_asset_id', '3': 12, '4': 1, '5': 9, '10': 'splitAssetId'},
    {'1': 'item_name', '3': 6, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'unit_no', '3': 7, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'project_no', '3': 8, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'item_abbr', '3': 9, '4': 1, '5': 9, '10': 'itemAbbr'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'sections',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.mediatag.report.v1.SectionSummary',
      '10': 'sections'
    },
    {'1': 'review_count', '3': 13, '4': 1, '5': 5, '10': 'reviewCount'},
  ],
  '8': [
    {'1': '_page_start'},
    {'1': '_page_end'},
  ],
};

/// Descriptor for `ReportSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportSetDescriptor = $convert.base64Decode(
    'CglSZXBvcnRTZXQSIgoNcmVwb3J0X3NldF9pZBgBIAEoCVILcmVwb3J0U2V0SWQSFQoGam9iX2'
    'lkGAIgASgJUgVqb2JJZBImCg9zb3VyY2VfYXNzZXRfaWQYAyABKAlSDXNvdXJjZUFzc2V0SWQS'
    'IgoKcGFnZV9zdGFydBgEIAEoBUgAUglwYWdlU3RhcnSIAQESHgoIcGFnZV9lbmQYBSABKAVIAV'
    'IHcGFnZUVuZIgBARIkCg5zcGxpdF9hc3NldF9pZBgMIAEoCVIMc3BsaXRBc3NldElkEhsKCWl0'
    'ZW1fbmFtZRgGIAEoCVIIaXRlbU5hbWUSFwoHdW5pdF9ubxgHIAEoCVIGdW5pdE5vEh0KCnByb2'
    'plY3Rfbm8YCCABKAlSCXByb2plY3RObxIbCglpdGVtX2FiYnIYCSABKAlSCGl0ZW1BYmJyEjkK'
    'CmNyZWF0ZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQX'
    'QSPgoIc2VjdGlvbnMYCyADKAsyIi5tZWRpYXRhZy5yZXBvcnQudjEuU2VjdGlvblN1bW1hcnlS'
    'CHNlY3Rpb25zEiEKDHJldmlld19jb3VudBgNIAEoBVILcmV2aWV3Q291bnRCDQoLX3BhZ2Vfc3'
    'RhcnRCCwoJX3BhZ2VfZW5k');

@$core.Deprecated('Use sectionSummaryDescriptor instead')
const SectionSummary$json = {
  '1': 'SectionSummary',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.mediatag.report.v1.SectionKind',
      '10': 'kind'
    },
    {
      '1': 'page_start',
      '3': 2,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'pageStart',
      '17': true
    },
    {
      '1': 'page_end',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'pageEnd',
      '17': true
    },
    {'1': 'overall_result', '3': 4, '4': 1, '5': 9, '10': 'overallResult'},
  ],
  '8': [
    {'1': '_page_start'},
    {'1': '_page_end'},
  ],
};

/// Descriptor for `SectionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectionSummaryDescriptor = $convert.base64Decode(
    'Cg5TZWN0aW9uU3VtbWFyeRIzCgRraW5kGAEgASgOMh8ubWVkaWF0YWcucmVwb3J0LnYxLlNlY3'
    'Rpb25LaW5kUgRraW5kEiIKCnBhZ2Vfc3RhcnQYAiABKAVIAFIJcGFnZVN0YXJ0iAEBEh4KCHBh'
    'Z2VfZW5kGAMgASgFSAFSB3BhZ2VFbmSIAQESJQoOb3ZlcmFsbF9yZXN1bHQYBCABKAlSDW92ZX'
    'JhbGxSZXN1bHRCDQoLX3BhZ2Vfc3RhcnRCCwoJX3BhZ2VfZW5k');

@$core.Deprecated('Use sectionDescriptor instead')
const Section$json = {
  '1': 'Section',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.mediatag.report.v1.SectionKind',
      '10': 'kind'
    },
    {
      '1': 'page_start',
      '3': 2,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'pageStart',
      '17': true
    },
    {
      '1': 'page_end',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'pageEnd',
      '17': true
    },
    {
      '1': 'fields',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'fields'
    },
  ],
  '8': [
    {'1': '_page_start'},
    {'1': '_page_end'},
  ],
};

/// Descriptor for `Section`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectionDescriptor = $convert.base64Decode(
    'CgdTZWN0aW9uEjMKBGtpbmQYASABKA4yHy5tZWRpYXRhZy5yZXBvcnQudjEuU2VjdGlvbktpbm'
    'RSBGtpbmQSIgoKcGFnZV9zdGFydBgCIAEoBUgAUglwYWdlU3RhcnSIAQESHgoIcGFnZV9lbmQY'
    'AyABKAVIAVIHcGFnZUVuZIgBARIvCgZmaWVsZHMYBCABKAsyFy5nb29nbGUucHJvdG9idWYuU3'
    'RydWN0UgZmaWVsZHNCDQoLX3BhZ2Vfc3RhcnRCCwoJX3BhZ2VfZW5k');

@$core.Deprecated('Use listReportSetsRequestDescriptor instead')
const ListReportSetsRequest$json = {
  '1': 'ListReportSetsRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `ListReportSetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReportSetsRequestDescriptor =
    $convert.base64Decode(
        'ChVMaXN0UmVwb3J0U2V0c1JlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZA==');

@$core.Deprecated('Use listReportSetsResponseDescriptor instead')
const ListReportSetsResponse$json = {
  '1': 'ListReportSetsResponse',
  '2': [
    {
      '1': 'report_sets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.report.v1.ReportSet',
      '10': 'reportSets'
    },
  ],
};

/// Descriptor for `ListReportSetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReportSetsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0UmVwb3J0U2V0c1Jlc3BvbnNlEj4KC3JlcG9ydF9zZXRzGAEgAygLMh0ubWVkaWF0YW'
        'cucmVwb3J0LnYxLlJlcG9ydFNldFIKcmVwb3J0U2V0cw==');

@$core.Deprecated('Use getReportSetRequestDescriptor instead')
const GetReportSetRequest$json = {
  '1': 'GetReportSetRequest',
  '2': [
    {'1': 'report_set_id', '3': 1, '4': 1, '5': 9, '10': 'reportSetId'},
  ],
};

/// Descriptor for `GetReportSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReportSetRequestDescriptor = $convert.base64Decode(
    'ChNHZXRSZXBvcnRTZXRSZXF1ZXN0EiIKDXJlcG9ydF9zZXRfaWQYASABKAlSC3JlcG9ydFNldE'
    'lk');

@$core.Deprecated('Use getReportSetResponseDescriptor instead')
const GetReportSetResponse$json = {
  '1': 'GetReportSetResponse',
  '2': [
    {
      '1': 'report_set',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.report.v1.ReportSet',
      '10': 'reportSet'
    },
    {
      '1': 'sections',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.report.v1.Section',
      '10': 'sections'
    },
    {
      '1': 'reviews',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.mediatag.report.v1.ReviewItem',
      '10': 'reviews'
    },
  ],
};

/// Descriptor for `GetReportSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReportSetResponseDescriptor = $convert.base64Decode(
    'ChRHZXRSZXBvcnRTZXRSZXNwb25zZRI8CgpyZXBvcnRfc2V0GAEgASgLMh0ubWVkaWF0YWcucm'
    'Vwb3J0LnYxLlJlcG9ydFNldFIJcmVwb3J0U2V0EjcKCHNlY3Rpb25zGAIgAygLMhsubWVkaWF0'
    'YWcucmVwb3J0LnYxLlNlY3Rpb25SCHNlY3Rpb25zEjgKB3Jldmlld3MYAyADKAsyHi5tZWRpYX'
    'RhZy5yZXBvcnQudjEuUmV2aWV3SXRlbVIHcmV2aWV3cw==');

@$core.Deprecated('Use reviewItemDescriptor instead')
const ReviewItem$json = {
  '1': 'ReviewItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'page', '17': true},
    {'1': 'field', '3': 3, '4': 1, '5': 9, '10': 'field'},
    {'1': 'column_name', '3': 4, '4': 1, '5': 9, '10': 'columnName'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'value', '17': true},
    {'1': 'raw', '3': 6, '4': 1, '5': 9, '10': 'raw'},
    {
      '1': 'ocr_score',
      '3': 7,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'ocrScore',
      '17': true
    },
    {'1': 'bbox', '3': 8, '4': 3, '5': 1, '10': 'bbox'},
    {
      '1': 'reason',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.mediatag.report.v1.ReviewReason',
      '10': 'reason'
    },
    {
      '1': 'corrected_value',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'correctedValue',
      '17': true
    },
    {'1': 'corrected_by', '3': 11, '4': 1, '5': 9, '10': 'correctedBy'},
    {
      '1': 'corrected_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'correctedAt'
    },
  ],
  '8': [
    {'1': '_page'},
    {'1': '_value'},
    {'1': '_ocr_score'},
    {'1': '_corrected_value'},
  ],
};

/// Descriptor for `ReviewItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewItemDescriptor = $convert.base64Decode(
    'CgpSZXZpZXdJdGVtEg4KAmlkGAEgASgDUgJpZBIXCgRwYWdlGAIgASgFSABSBHBhZ2WIAQESFA'
    'oFZmllbGQYAyABKAlSBWZpZWxkEh8KC2NvbHVtbl9uYW1lGAQgASgJUgpjb2x1bW5OYW1lEhkK'
    'BXZhbHVlGAUgASgJSAFSBXZhbHVliAEBEhAKA3JhdxgGIAEoCVIDcmF3EiAKCW9jcl9zY29yZR'
    'gHIAEoAUgCUghvY3JTY29yZYgBARISCgRiYm94GAggAygBUgRiYm94EjgKBnJlYXNvbhgJIAEo'
    'DjIgLm1lZGlhdGFnLnJlcG9ydC52MS5SZXZpZXdSZWFzb25SBnJlYXNvbhIsCg9jb3JyZWN0ZW'
    'RfdmFsdWUYCiABKAlIA1IOY29ycmVjdGVkVmFsdWWIAQESIQoMY29ycmVjdGVkX2J5GAsgASgJ'
    'Ugtjb3JyZWN0ZWRCeRI9Cgxjb3JyZWN0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgtjb3JyZWN0ZWRBdEIHCgVfcGFnZUIICgZfdmFsdWVCDAoKX29jcl9zY29yZUIS'
    'ChBfY29ycmVjdGVkX3ZhbHVl');

@$core.Deprecated('Use resolveReviewRequestDescriptor instead')
const ResolveReviewRequest$json = {
  '1': 'ResolveReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 3, '10': 'reviewId'},
    {
      '1': 'corrected_value',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'correctedValue',
      '17': true
    },
    {'1': 'corrected_by', '3': 3, '4': 1, '5': 9, '10': 'correctedBy'},
  ],
  '8': [
    {'1': '_corrected_value'},
  ],
};

/// Descriptor for `ResolveReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveReviewRequestDescriptor = $convert.base64Decode(
    'ChRSZXNvbHZlUmV2aWV3UmVxdWVzdBIbCglyZXZpZXdfaWQYASABKANSCHJldmlld0lkEiwKD2'
    'NvcnJlY3RlZF92YWx1ZRgCIAEoCUgAUg5jb3JyZWN0ZWRWYWx1ZYgBARIhCgxjb3JyZWN0ZWRf'
    'YnkYAyABKAlSC2NvcnJlY3RlZEJ5QhIKEF9jb3JyZWN0ZWRfdmFsdWU=');

@$core.Deprecated('Use resolveReviewResponseDescriptor instead')
const ResolveReviewResponse$json = {
  '1': 'ResolveReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.report.v1.ReviewItem',
      '10': 'review'
    },
  ],
};

/// Descriptor for `ResolveReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveReviewResponseDescriptor = $convert.base64Decode(
    'ChVSZXNvbHZlUmV2aWV3UmVzcG9uc2USNgoGcmV2aWV3GAEgASgLMh4ubWVkaWF0YWcucmVwb3'
    'J0LnYxLlJldmlld0l0ZW1SBnJldmlldw==');

@$core.Deprecated('Use matchReportSetRequestDescriptor instead')
const MatchReportSetRequest$json = {
  '1': 'MatchReportSetRequest',
  '2': [
    {'1': 'report_set_id', '3': 1, '4': 1, '5': 9, '10': 'reportSetId'},
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `MatchReportSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchReportSetRequestDescriptor = $convert.base64Decode(
    'ChVNYXRjaFJlcG9ydFNldFJlcXVlc3QSIgoNcmVwb3J0X3NldF9pZBgBIAEoCVILcmVwb3J0U2'
    'V0SWQSFQoGam9iX2lkGAIgASgJUgVqb2JJZA==');

@$core.Deprecated('Use matchReportSetResponseDescriptor instead')
const MatchReportSetResponse$json = {
  '1': 'MatchReportSetResponse',
  '2': [
    {
      '1': 'report_set',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.report.v1.ReportSet',
      '10': 'reportSet'
    },
  ],
};

/// Descriptor for `MatchReportSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchReportSetResponseDescriptor =
    $convert.base64Decode(
        'ChZNYXRjaFJlcG9ydFNldFJlc3BvbnNlEjwKCnJlcG9ydF9zZXQYASABKAsyHS5tZWRpYXRhZy'
        '5yZXBvcnQudjEuUmVwb3J0U2V0UglyZXBvcnRTZXQ=');

const $core.Map<$core.String, $core.dynamic> ReportServiceBase$json = {
  '1': 'ReportService',
  '2': [
    {
      '1': 'ListReportSets',
      '2': '.mediatag.report.v1.ListReportSetsRequest',
      '3': '.mediatag.report.v1.ListReportSetsResponse'
    },
    {
      '1': 'GetReportSet',
      '2': '.mediatag.report.v1.GetReportSetRequest',
      '3': '.mediatag.report.v1.GetReportSetResponse'
    },
    {
      '1': 'ResolveReview',
      '2': '.mediatag.report.v1.ResolveReviewRequest',
      '3': '.mediatag.report.v1.ResolveReviewResponse'
    },
    {
      '1': 'MatchReportSet',
      '2': '.mediatag.report.v1.MatchReportSetRequest',
      '3': '.mediatag.report.v1.MatchReportSetResponse'
    },
  ],
};

@$core.Deprecated('Use reportServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ReportServiceBase$messageJson = {
  '.mediatag.report.v1.ListReportSetsRequest': ListReportSetsRequest$json,
  '.mediatag.report.v1.ListReportSetsResponse': ListReportSetsResponse$json,
  '.mediatag.report.v1.ReportSet': ReportSet$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.report.v1.SectionSummary': SectionSummary$json,
  '.mediatag.report.v1.GetReportSetRequest': GetReportSetRequest$json,
  '.mediatag.report.v1.GetReportSetResponse': GetReportSetResponse$json,
  '.mediatag.report.v1.Section': Section$json,
  '.google.protobuf.Struct': $1.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $1.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $1.Value$json,
  '.google.protobuf.ListValue': $1.ListValue$json,
  '.mediatag.report.v1.ReviewItem': ReviewItem$json,
  '.mediatag.report.v1.ResolveReviewRequest': ResolveReviewRequest$json,
  '.mediatag.report.v1.ResolveReviewResponse': ResolveReviewResponse$json,
  '.mediatag.report.v1.MatchReportSetRequest': MatchReportSetRequest$json,
  '.mediatag.report.v1.MatchReportSetResponse': MatchReportSetResponse$json,
};

/// Descriptor for `ReportService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List reportServiceDescriptor = $convert.base64Decode(
    'Cg1SZXBvcnRTZXJ2aWNlEmcKDkxpc3RSZXBvcnRTZXRzEikubWVkaWF0YWcucmVwb3J0LnYxLk'
    'xpc3RSZXBvcnRTZXRzUmVxdWVzdBoqLm1lZGlhdGFnLnJlcG9ydC52MS5MaXN0UmVwb3J0U2V0'
    'c1Jlc3BvbnNlEmEKDEdldFJlcG9ydFNldBInLm1lZGlhdGFnLnJlcG9ydC52MS5HZXRSZXBvcn'
    'RTZXRSZXF1ZXN0GigubWVkaWF0YWcucmVwb3J0LnYxLkdldFJlcG9ydFNldFJlc3BvbnNlEmQK'
    'DVJlc29sdmVSZXZpZXcSKC5tZWRpYXRhZy5yZXBvcnQudjEuUmVzb2x2ZVJldmlld1JlcXVlc3'
    'QaKS5tZWRpYXRhZy5yZXBvcnQudjEuUmVzb2x2ZVJldmlld1Jlc3BvbnNlEmcKDk1hdGNoUmVw'
    'b3J0U2V0EikubWVkaWF0YWcucmVwb3J0LnYxLk1hdGNoUmVwb3J0U2V0UmVxdWVzdBoqLm1lZG'
    'lhdGFnLnJlcG9ydC52MS5NYXRjaFJlcG9ydFNldFJlc3BvbnNl');
