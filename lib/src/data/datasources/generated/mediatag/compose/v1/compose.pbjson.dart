// This is a generated file - do not edit.
//
// Generated from mediatag/compose/v1/compose.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/field_mask.pbjson.dart' as $3;
import '../../../google/protobuf/struct.pbjson.dart' as $1;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../asset/v1/asset.pbjson.dart' as $2;

@$core.Deprecated('Use timelineStatusDescriptor instead')
const TimelineStatus$json = {
  '1': 'TimelineStatus',
  '2': [
    {'1': 'TIMELINE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TIMELINE_STATUS_DRAFT', '2': 1},
    {'1': 'TIMELINE_STATUS_SUGGESTED', '2': 2},
    {'1': 'TIMELINE_STATUS_CONFIRMED', '2': 3},
    {'1': 'TIMELINE_STATUS_REJECTED', '2': 4},
  ],
};

/// Descriptor for `TimelineStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List timelineStatusDescriptor = $convert.base64Decode(
    'Cg5UaW1lbGluZVN0YXR1cxIfChtUSU1FTElORV9TVEFUVVNfVU5TUEVDSUZJRUQQABIZChVUSU'
    '1FTElORV9TVEFUVVNfRFJBRlQQARIdChlUSU1FTElORV9TVEFUVVNfU1VHR0VTVEVEEAISHQoZ'
    'VElNRUxJTkVfU1RBVFVTX0NPTkZJUk1FRBADEhwKGFRJTUVMSU5FX1NUQVRVU19SRUpFQ1RFRB'
    'AE');

@$core.Deprecated('Use clipKindDescriptor instead')
const ClipKind$json = {
  '1': 'ClipKind',
  '2': [
    {'1': 'CLIP_KIND_UNSPECIFIED', '2': 0},
    {'1': 'CLIP_KIND_VIDEO', '2': 1},
    {'1': 'CLIP_KIND_AUDIO', '2': 2},
    {'1': 'CLIP_KIND_IMAGE', '2': 3},
    {'1': 'CLIP_KIND_PDF', '2': 4},
    {'1': 'CLIP_KIND_SUBTITLE', '2': 5},
    {'1': 'CLIP_KIND_POSE', '2': 6},
    {'1': 'CLIP_KIND_TIMESERIES', '2': 7},
    {'1': 'CLIP_KIND_POINTCLOUD', '2': 8},
    {'1': 'CLIP_KIND_FILE', '2': 9},
    {'1': 'CLIP_KIND_TAG', '2': 10},
    {'1': 'CLIP_KIND_REGION', '2': 11},
  ],
};

/// Descriptor for `ClipKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List clipKindDescriptor = $convert.base64Decode(
    'CghDbGlwS2luZBIZChVDTElQX0tJTkRfVU5TUEVDSUZJRUQQABITCg9DTElQX0tJTkRfVklERU'
    '8QARITCg9DTElQX0tJTkRfQVVESU8QAhITCg9DTElQX0tJTkRfSU1BR0UQAxIRCg1DTElQX0tJ'
    'TkRfUERGEAQSFgoSQ0xJUF9LSU5EX1NVQlRJVExFEAUSEgoOQ0xJUF9LSU5EX1BPU0UQBhIYCh'
    'RDTElQX0tJTkRfVElNRVNFUklFUxAHEhgKFENMSVBfS0lORF9QT0lOVENMT1VEEAgSEgoOQ0xJ'
    'UF9LSU5EX0ZJTEUQCRIRCg1DTElQX0tJTkRfVEFHEAoSFAoQQ0xJUF9LSU5EX1JFR0lPThAL');

@$core.Deprecated('Use labelRefDescriptor instead')
const LabelRef$json = {
  '1': 'LabelRef',
  '2': [
    {'1': 'vocab_key', '3': 1, '4': 1, '5': 9, '10': 'vocabKey'},
    {'1': 'value_id', '3': 2, '4': 1, '5': 9, '10': 'valueId'},
  ],
};

/// Descriptor for `LabelRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labelRefDescriptor = $convert.base64Decode(
    'CghMYWJlbFJlZhIbCgl2b2NhYl9rZXkYASABKAlSCHZvY2FiS2V5EhkKCHZhbHVlX2lkGAIgAS'
    'gJUgd2YWx1ZUlk');

@$core.Deprecated('Use timelineDescriptor instead')
const Timeline$json = {
  '1': 'Timeline',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.mediatag.compose.v1.TimelineStatus',
      '10': 'status'
    },
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'labels',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelRef',
      '10': 'labels'
    },
    {
      '1': 'embedded_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'embeddedAt'
    },
    {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Timeline`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timelineDescriptor = $convert.base64Decode(
    'CghUaW1lbGluZRIVCgZqb2JfaWQYASABKAlSBWpvYklkEhIKBG5hbWUYAiABKAlSBG5hbWUSOw'
    'oGc3RhdHVzGAMgASgOMiMubWVkaWF0YWcuY29tcG9zZS52MS5UaW1lbGluZVN0YXR1c1IGc3Rh'
    'dHVzEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhI1CgZsYWJlbHMYBSADKAsyHS'
    '5tZWRpYXRhZy5jb21wb3NlLnYxLkxhYmVsUmVmUgZsYWJlbHMSOwoLZW1iZWRkZWRfYXQYBiAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgplbWJlZGRlZEF0EjkKCmNyZWF0ZWRfYX'
    'QYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRl'
    'ZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use trackDescriptor instead')
const Track$json = {
  '1': 'Track',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'order', '3': 4, '4': 1, '5': 5, '10': 'order'},
    {
      '1': 'visible',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'visible',
      '17': true
    },
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
  '8': [
    {'1': '_visible'},
  ],
};

/// Descriptor for `Track`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackDescriptor = $convert.base64Decode(
    'CgVUcmFjaxIZCgh0cmFja19pZBgBIAEoCVIHdHJhY2tJZBIVCgZqb2JfaWQYAiABKAlSBWpvYk'
    'lkEhIKBG5hbWUYAyABKAlSBG5hbWUSFAoFb3JkZXIYBCABKAVSBW9yZGVyEh0KB3Zpc2libGUY'
    'BSABKAhIAFIHdmlzaWJsZYgBARI5CgpjcmVhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYByABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXRCCgoIX3Zpc2libGU=');

@$core.Deprecated('Use clipDescriptor instead')
const Clip$json = {
  '1': 'Clip',
  '2': [
    {'1': 'clip_id', '3': 1, '4': 1, '5': 9, '10': 'clipId'},
    {'1': 'track_id', '3': 2, '4': 1, '5': 9, '10': 'trackId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.mediatag.compose.v1.ClipKind',
      '10': 'kind'
    },
    {
      '1': 'timeline_start_ns',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'timelineStartNs',
      '17': true
    },
    {
      '1': 'timeline_end_ns',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'timelineEndNs',
      '17': true
    },
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.ClipSource',
      '10': 'source'
    },
    {'1': 'label_value_id', '3': 7, '4': 1, '5': 9, '10': 'labelValueId'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'provenance',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.ClipProvenance',
      '10': 'provenance'
    },
    {
      '1': 'embedded_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'embeddedAt'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
  '8': [
    {'1': '_timeline_start_ns'},
    {'1': '_timeline_end_ns'},
  ],
};

/// Descriptor for `Clip`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipDescriptor = $convert.base64Decode(
    'CgRDbGlwEhcKB2NsaXBfaWQYASABKAlSBmNsaXBJZBIZCgh0cmFja19pZBgCIAEoCVIHdHJhY2'
    'tJZBIxCgRraW5kGAMgASgOMh0ubWVkaWF0YWcuY29tcG9zZS52MS5DbGlwS2luZFIEa2luZBIv'
    'ChF0aW1lbGluZV9zdGFydF9ucxgEIAEoA0gAUg90aW1lbGluZVN0YXJ0TnOIAQESKwoPdGltZW'
    'xpbmVfZW5kX25zGAUgASgDSAFSDXRpbWVsaW5lRW5kTnOIAQESNwoGc291cmNlGAYgASgLMh8u'
    'bWVkaWF0YWcuY29tcG9zZS52MS5DbGlwU291cmNlUgZzb3VyY2USJAoObGFiZWxfdmFsdWVfaW'
    'QYByABKAlSDGxhYmVsVmFsdWVJZBIgCgtkZXNjcmlwdGlvbhgIIAEoCVILZGVzY3JpcHRpb24S'
    'QwoKcHJvdmVuYW5jZRgJIAEoCzIjLm1lZGlhdGFnLmNvbXBvc2UudjEuQ2xpcFByb3ZlbmFuY2'
    'VSCnByb3ZlbmFuY2USOwoLZW1iZWRkZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgplbWJlZGRlZEF0EjkKCmNyZWF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdEIUChJfdGltZWxpbmVfc3RhcnRfbnNCEgoQX3RpbW'
    'VsaW5lX2VuZF9ucw==');

@$core.Deprecated('Use clipSourceDescriptor instead')
const ClipSource$json = {
  '1': 'ClipSource',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'start_ns',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'startNs',
      '17': true
    },
    {'1': 'end_ns', '3': 3, '4': 1, '5': 3, '9': 1, '10': 'endNs', '17': true},
    {
      '1': 'locator',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'locator'
    },
  ],
  '8': [
    {'1': '_start_ns'},
    {'1': '_end_ns'},
  ],
};

/// Descriptor for `ClipSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipSourceDescriptor = $convert.base64Decode(
    'CgpDbGlwU291cmNlEhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEh4KCHN0YXJ0X25zGAIgAS'
    'gDSABSB3N0YXJ0TnOIAQESGgoGZW5kX25zGAMgASgDSAFSBWVuZE5ziAEBEjEKB2xvY2F0b3IY'
    'BCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugdsb2NhdG9yQgsKCV9zdGFydF9uc0IJCg'
    'dfZW5kX25z');

@$core.Deprecated('Use clipProvenanceDescriptor instead')
const ClipProvenance$json = {
  '1': 'ClipProvenance',
  '2': [
    {
      '1': 'confidence',
      '3': 1,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'confidence',
      '17': true
    },
    {'1': 'reviewed', '3': 2, '4': 1, '5': 8, '10': 'reviewed'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'tool_id', '3': 4, '4': 1, '5': 9, '10': 'toolId'},
    {'1': 'tool_version', '3': 5, '4': 1, '5': 9, '10': 'toolVersion'},
    {'1': 'input_clip_ids', '3': 6, '4': 3, '5': 9, '10': 'inputClipIds'},
  ],
  '8': [
    {'1': '_confidence'},
  ],
};

/// Descriptor for `ClipProvenance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipProvenanceDescriptor = $convert.base64Decode(
    'Cg5DbGlwUHJvdmVuYW5jZRIjCgpjb25maWRlbmNlGAEgASgBSABSCmNvbmZpZGVuY2WIAQESGg'
    'oIcmV2aWV3ZWQYAiABKAhSCHJldmlld2VkEhUKBnJ1bl9pZBgDIAEoCVIFcnVuSWQSFwoHdG9v'
    'bF9pZBgEIAEoCVIGdG9vbElkEiEKDHRvb2xfdmVyc2lvbhgFIAEoCVILdG9vbFZlcnNpb24SJA'
    'oOaW5wdXRfY2xpcF9pZHMYBiADKAlSDGlucHV0Q2xpcElkc0INCgtfY29uZmlkZW5jZQ==');

@$core.Deprecated('Use getTimelineRequestDescriptor instead')
const GetTimelineRequest$json = {
  '1': 'GetTimelineRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'pass_id', '3': 2, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'include_assets', '3': 3, '4': 1, '5': 8, '10': 'includeAssets'},
  ],
};

/// Descriptor for `GetTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineRequestDescriptor = $convert.base64Decode(
    'ChJHZXRUaW1lbGluZVJlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZBIXCgdwYXNzX2lkGA'
    'IgASgJUgZwYXNzSWQSJQoOaW5jbHVkZV9hc3NldHMYAyABKAhSDWluY2x1ZGVBc3NldHM=');

@$core.Deprecated('Use getTimelineResponseDescriptor instead')
const GetTimelineResponse$json = {
  '1': 'GetTimelineResponse',
  '2': [
    {
      '1': 'timeline',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Timeline',
      '10': 'timeline'
    },
    {
      '1': 'tracks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.compose.v1.Track',
      '10': 'tracks'
    },
    {
      '1': 'clips',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.mediatag.compose.v1.Clip',
      '10': 'clips'
    },
    {
      '1': 'assets',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'assets'
    },
    {
      '1': 'window_start_ns',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'windowStartNs',
      '17': true
    },
    {
      '1': 'window_end_ns',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'windowEndNs',
      '17': true
    },
  ],
  '8': [
    {'1': '_window_start_ns'},
    {'1': '_window_end_ns'},
  ],
};

/// Descriptor for `GetTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRUaW1lbGluZVJlc3BvbnNlEjkKCHRpbWVsaW5lGAEgASgLMh0ubWVkaWF0YWcuY29tcG'
    '9zZS52MS5UaW1lbGluZVIIdGltZWxpbmUSMgoGdHJhY2tzGAIgAygLMhoubWVkaWF0YWcuY29t'
    'cG9zZS52MS5UcmFja1IGdHJhY2tzEi8KBWNsaXBzGAMgAygLMhkubWVkaWF0YWcuY29tcG9zZS'
    '52MS5DbGlwUgVjbGlwcxIwCgZhc3NldHMYBCADKAsyGC5tZWRpYXRhZy5hc3NldC52MS5Bc3Nl'
    'dFIGYXNzZXRzEisKD3dpbmRvd19zdGFydF9ucxgFIAEoA0gAUg13aW5kb3dTdGFydE5ziAEBEi'
    'cKDXdpbmRvd19lbmRfbnMYBiABKANIAVILd2luZG93RW5kTnOIAQFCEgoQX3dpbmRvd19zdGFy'
    'dF9uc0IQCg5fd2luZG93X2VuZF9ucw==');

@$core.Deprecated('Use listTimelinesRequestDescriptor instead')
const ListTimelinesRequest$json = {
  '1': 'ListTimelinesRequest',
  '2': [
    {'1': 'project_no', '3': 1, '4': 1, '5': 9, '10': 'projectNo'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.mediatag.compose.v1.TimelineStatus',
      '10': 'status'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListTimelinesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTimelinesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0VGltZWxpbmVzUmVxdWVzdBIdCgpwcm9qZWN0X25vGAEgASgJUglwcm9qZWN0Tm8SOw'
    'oGc3RhdHVzGAIgASgOMiMubWVkaWF0YWcuY29tcG9zZS52MS5UaW1lbGluZVN0YXR1c1IGc3Rh'
    'dHVzEhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgEIAEoCVIJcG'
    'FnZVRva2Vu');

@$core.Deprecated('Use listTimelinesResponseDescriptor instead')
const ListTimelinesResponse$json = {
  '1': 'ListTimelinesResponse',
  '2': [
    {
      '1': 'timelines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.compose.v1.Timeline',
      '10': 'timelines'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListTimelinesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTimelinesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0VGltZWxpbmVzUmVzcG9uc2USOwoJdGltZWxpbmVzGAEgAygLMh0ubWVkaWF0YWcuY2'
    '9tcG9zZS52MS5UaW1lbGluZVIJdGltZWxpbmVzEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVIN'
    'bmV4dFBhZ2VUb2tlbg==');

@$core.Deprecated('Use updateTimelineRequestDescriptor instead')
const UpdateTimelineRequest$json = {
  '1': 'UpdateTimelineRequest',
  '2': [
    {
      '1': 'timeline',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Timeline',
      '10': 'timeline'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTimelineRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVUaW1lbGluZVJlcXVlc3QSOQoIdGltZWxpbmUYASABKAsyHS5tZWRpYXRhZy5jb2'
    '1wb3NlLnYxLlRpbWVsaW5lUgh0aW1lbGluZRI7Cgt1cGRhdGVfbWFzaxgCIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5GaWVsZE1hc2tSCnVwZGF0ZU1hc2s=');

@$core.Deprecated('Use updateTimelineResponseDescriptor instead')
const UpdateTimelineResponse$json = {
  '1': 'UpdateTimelineResponse',
  '2': [
    {
      '1': 'timeline',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Timeline',
      '10': 'timeline'
    },
  ],
};

/// Descriptor for `UpdateTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTimelineResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVUaW1lbGluZVJlc3BvbnNlEjkKCHRpbWVsaW5lGAEgASgLMh0ubWVkaWF0YWcuY2'
        '9tcG9zZS52MS5UaW1lbGluZVIIdGltZWxpbmU=');

@$core.Deprecated('Use changeTimelineStatusRequestDescriptor instead')
const ChangeTimelineStatusRequest$json = {
  '1': 'ChangeTimelineStatusRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {
      '1': 'from_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.mediatag.compose.v1.TimelineStatus',
      '10': 'fromStatus'
    },
    {
      '1': 'to_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.mediatag.compose.v1.TimelineStatus',
      '10': 'toStatus'
    },
  ],
};

/// Descriptor for `ChangeTimelineStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeTimelineStatusRequestDescriptor = $convert.base64Decode(
    'ChtDaGFuZ2VUaW1lbGluZVN0YXR1c1JlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZBJECg'
    'tmcm9tX3N0YXR1cxgCIAEoDjIjLm1lZGlhdGFnLmNvbXBvc2UudjEuVGltZWxpbmVTdGF0dXNS'
    'CmZyb21TdGF0dXMSQAoJdG9fc3RhdHVzGAMgASgOMiMubWVkaWF0YWcuY29tcG9zZS52MS5UaW'
    '1lbGluZVN0YXR1c1IIdG9TdGF0dXM=');

@$core.Deprecated('Use changeTimelineStatusResponseDescriptor instead')
const ChangeTimelineStatusResponse$json = {
  '1': 'ChangeTimelineStatusResponse',
  '2': [
    {
      '1': 'timeline',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Timeline',
      '10': 'timeline'
    },
  ],
};

/// Descriptor for `ChangeTimelineStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeTimelineStatusResponseDescriptor =
    $convert.base64Decode(
        'ChxDaGFuZ2VUaW1lbGluZVN0YXR1c1Jlc3BvbnNlEjkKCHRpbWVsaW5lGAEgASgLMh0ubWVkaW'
        'F0YWcuY29tcG9zZS52MS5UaW1lbGluZVIIdGltZWxpbmU=');

@$core.Deprecated('Use deleteTimelineRequestDescriptor instead')
const DeleteTimelineRequest$json = {
  '1': 'DeleteTimelineRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `DeleteTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTimelineRequestDescriptor =
    $convert.base64Decode(
        'ChVEZWxldGVUaW1lbGluZVJlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZA==');

@$core.Deprecated('Use deleteTimelineResponseDescriptor instead')
const DeleteTimelineResponse$json = {
  '1': 'DeleteTimelineResponse',
};

/// Descriptor for `DeleteTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTimelineResponseDescriptor =
    $convert.base64Decode('ChZEZWxldGVUaW1lbGluZVJlc3BvbnNl');

@$core.Deprecated('Use createTrackRequestDescriptor instead')
const CreateTrackRequest$json = {
  '1': 'CreateTrackRequest',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Track',
      '10': 'track'
    },
  ],
};

/// Descriptor for `CreateTrackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTrackRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVUcmFja1JlcXVlc3QSMAoFdHJhY2sYASABKAsyGi5tZWRpYXRhZy5jb21wb3NlLn'
    'YxLlRyYWNrUgV0cmFjaw==');

@$core.Deprecated('Use createTrackResponseDescriptor instead')
const CreateTrackResponse$json = {
  '1': 'CreateTrackResponse',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Track',
      '10': 'track'
    },
  ],
};

/// Descriptor for `CreateTrackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTrackResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVUcmFja1Jlc3BvbnNlEjAKBXRyYWNrGAEgASgLMhoubWVkaWF0YWcuY29tcG9zZS'
    '52MS5UcmFja1IFdHJhY2s=');

@$core.Deprecated('Use updateTrackRequestDescriptor instead')
const UpdateTrackRequest$json = {
  '1': 'UpdateTrackRequest',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Track',
      '10': 'track'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateTrackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTrackRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVUcmFja1JlcXVlc3QSMAoFdHJhY2sYASABKAsyGi5tZWRpYXRhZy5jb21wb3NlLn'
    'YxLlRyYWNrUgV0cmFjaxI7Cgt1cGRhdGVfbWFzaxgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5G'
    'aWVsZE1hc2tSCnVwZGF0ZU1hc2s=');

@$core.Deprecated('Use updateTrackResponseDescriptor instead')
const UpdateTrackResponse$json = {
  '1': 'UpdateTrackResponse',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Track',
      '10': 'track'
    },
  ],
};

/// Descriptor for `UpdateTrackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTrackResponseDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVUcmFja1Jlc3BvbnNlEjAKBXRyYWNrGAEgASgLMhoubWVkaWF0YWcuY29tcG9zZS'
    '52MS5UcmFja1IFdHJhY2s=');

@$core.Deprecated('Use deleteTrackRequestDescriptor instead')
const DeleteTrackRequest$json = {
  '1': 'DeleteTrackRequest',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
  ],
};

/// Descriptor for `DeleteTrackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTrackRequestDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVUcmFja1JlcXVlc3QSGQoIdHJhY2tfaWQYASABKAlSB3RyYWNrSWQ=');

@$core.Deprecated('Use deleteTrackResponseDescriptor instead')
const DeleteTrackResponse$json = {
  '1': 'DeleteTrackResponse',
};

/// Descriptor for `DeleteTrackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTrackResponseDescriptor =
    $convert.base64Decode('ChNEZWxldGVUcmFja1Jlc3BvbnNl');

@$core.Deprecated('Use createClipRequestDescriptor instead')
const CreateClipRequest$json = {
  '1': 'CreateClipRequest',
  '2': [
    {
      '1': 'clip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Clip',
      '10': 'clip'
    },
  ],
};

/// Descriptor for `CreateClipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createClipRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVDbGlwUmVxdWVzdBItCgRjbGlwGAEgASgLMhkubWVkaWF0YWcuY29tcG9zZS52MS'
    '5DbGlwUgRjbGlw');

@$core.Deprecated('Use createClipResponseDescriptor instead')
const CreateClipResponse$json = {
  '1': 'CreateClipResponse',
  '2': [
    {
      '1': 'clip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Clip',
      '10': 'clip'
    },
  ],
};

/// Descriptor for `CreateClipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createClipResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVDbGlwUmVzcG9uc2USLQoEY2xpcBgBIAEoCzIZLm1lZGlhdGFnLmNvbXBvc2Uudj'
    'EuQ2xpcFIEY2xpcA==');

@$core.Deprecated('Use updateClipRequestDescriptor instead')
const UpdateClipRequest$json = {
  '1': 'UpdateClipRequest',
  '2': [
    {
      '1': 'clip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Clip',
      '10': 'clip'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateClipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateClipRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVDbGlwUmVxdWVzdBItCgRjbGlwGAEgASgLMhkubWVkaWF0YWcuY29tcG9zZS52MS'
    '5DbGlwUgRjbGlwEjsKC3VwZGF0ZV9tYXNrGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLkZpZWxk'
    'TWFza1IKdXBkYXRlTWFzaw==');

@$core.Deprecated('Use updateClipResponseDescriptor instead')
const UpdateClipResponse$json = {
  '1': 'UpdateClipResponse',
  '2': [
    {
      '1': 'clip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.Clip',
      '10': 'clip'
    },
  ],
};

/// Descriptor for `UpdateClipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateClipResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVDbGlwUmVzcG9uc2USLQoEY2xpcBgBIAEoCzIZLm1lZGlhdGFnLmNvbXBvc2Uudj'
    'EuQ2xpcFIEY2xpcA==');

@$core.Deprecated('Use deleteClipRequestDescriptor instead')
const DeleteClipRequest$json = {
  '1': 'DeleteClipRequest',
  '2': [
    {'1': 'clip_id', '3': 1, '4': 1, '5': 9, '10': 'clipId'},
  ],
};

/// Descriptor for `DeleteClipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteClipRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVDbGlwUmVxdWVzdBIXCgdjbGlwX2lkGAEgASgJUgZjbGlwSWQ=');

@$core.Deprecated('Use deleteClipResponseDescriptor instead')
const DeleteClipResponse$json = {
  '1': 'DeleteClipResponse',
};

/// Descriptor for `DeleteClipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteClipResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVDbGlwUmVzcG9uc2U=');

@$core.Deprecated('Use labelVocabDescriptor instead')
const LabelVocab$json = {
  '1': 'LabelVocab',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'parent_vocab_key', '3': 2, '4': 1, '5': 9, '10': 'parentVocabKey'},
    {'1': 'parent_value_id', '3': 3, '4': 1, '5': 9, '10': 'parentValueId'},
    {
      '1': 'values',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelValue',
      '10': 'values'
    },
  ],
};

/// Descriptor for `LabelVocab`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labelVocabDescriptor = $convert.base64Decode(
    'CgpMYWJlbFZvY2FiEhAKA2tleRgBIAEoCVIDa2V5EigKEHBhcmVudF92b2NhYl9rZXkYAiABKA'
    'lSDnBhcmVudFZvY2FiS2V5EiYKD3BhcmVudF92YWx1ZV9pZBgDIAEoCVINcGFyZW50VmFsdWVJ'
    'ZBI3CgZ2YWx1ZXMYBCADKAsyHy5tZWRpYXRhZy5jb21wb3NlLnYxLkxhYmVsVmFsdWVSBnZhbH'
    'Vlcw==');

@$core.Deprecated('Use labelValueDescriptor instead')
const LabelValue$json = {
  '1': 'LabelValue',
  '2': [
    {'1': 'value_id', '3': 1, '4': 1, '5': 9, '10': 'valueId'},
    {'1': 'vocab_key', '3': 2, '4': 1, '5': 9, '10': 'vocabKey'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'deprecated', '3': 4, '4': 1, '5': 8, '10': 'deprecated'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `LabelValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labelValueDescriptor = $convert.base64Decode(
    'CgpMYWJlbFZhbHVlEhkKCHZhbHVlX2lkGAEgASgJUgd2YWx1ZUlkEhsKCXZvY2FiX2tleRgCIA'
    'EoCVIIdm9jYWJLZXkSEgoEbmFtZRgDIAEoCVIEbmFtZRIeCgpkZXByZWNhdGVkGAQgASgIUgpk'
    'ZXByZWNhdGVkEiAKC2Rlc2NyaXB0aW9uGAUgASgJUgtkZXNjcmlwdGlvbg==');

@$core.Deprecated('Use listLabelVocabsRequestDescriptor instead')
const ListLabelVocabsRequest$json = {
  '1': 'ListLabelVocabsRequest',
  '2': [
    {
      '1': 'include_deprecated',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'includeDeprecated'
    },
  ],
};

/// Descriptor for `ListLabelVocabsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLabelVocabsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0TGFiZWxWb2NhYnNSZXF1ZXN0Ei0KEmluY2x1ZGVfZGVwcmVjYXRlZBgBIAEoCFIRaW'
        '5jbHVkZURlcHJlY2F0ZWQ=');

@$core.Deprecated('Use listLabelVocabsResponseDescriptor instead')
const ListLabelVocabsResponse$json = {
  '1': 'ListLabelVocabsResponse',
  '2': [
    {
      '1': 'vocabs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelVocab',
      '10': 'vocabs'
    },
  ],
};

/// Descriptor for `ListLabelVocabsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLabelVocabsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0TGFiZWxWb2NhYnNSZXNwb25zZRI3CgZ2b2NhYnMYASADKAsyHy5tZWRpYXRhZy5jb2'
        '1wb3NlLnYxLkxhYmVsVm9jYWJSBnZvY2Ficw==');

@$core.Deprecated('Use createLabelVocabRequestDescriptor instead')
const CreateLabelVocabRequest$json = {
  '1': 'CreateLabelVocabRequest',
  '2': [
    {
      '1': 'vocab',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelVocab',
      '10': 'vocab'
    },
  ],
};

/// Descriptor for `CreateLabelVocabRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLabelVocabRequestDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVMYWJlbFZvY2FiUmVxdWVzdBI1CgV2b2NhYhgBIAEoCzIfLm1lZGlhdGFnLmNvbX'
        'Bvc2UudjEuTGFiZWxWb2NhYlIFdm9jYWI=');

@$core.Deprecated('Use createLabelVocabResponseDescriptor instead')
const CreateLabelVocabResponse$json = {
  '1': 'CreateLabelVocabResponse',
  '2': [
    {
      '1': 'vocab',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelVocab',
      '10': 'vocab'
    },
  ],
};

/// Descriptor for `CreateLabelVocabResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLabelVocabResponseDescriptor =
    $convert.base64Decode(
        'ChhDcmVhdGVMYWJlbFZvY2FiUmVzcG9uc2USNQoFdm9jYWIYASABKAsyHy5tZWRpYXRhZy5jb2'
        '1wb3NlLnYxLkxhYmVsVm9jYWJSBXZvY2Fi');

@$core.Deprecated('Use createLabelValueRequestDescriptor instead')
const CreateLabelValueRequest$json = {
  '1': 'CreateLabelValueRequest',
  '2': [
    {'1': 'vocab_key', '3': 1, '4': 1, '5': 9, '10': 'vocabKey'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `CreateLabelValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLabelValueRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVMYWJlbFZhbHVlUmVxdWVzdBIbCgl2b2NhYl9rZXkYASABKAlSCHZvY2FiS2V5Eh'
    'IKBG5hbWUYAiABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9u');

@$core.Deprecated('Use createLabelValueResponseDescriptor instead')
const CreateLabelValueResponse$json = {
  '1': 'CreateLabelValueResponse',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelValue',
      '10': 'value'
    },
  ],
};

/// Descriptor for `CreateLabelValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLabelValueResponseDescriptor =
    $convert.base64Decode(
        'ChhDcmVhdGVMYWJlbFZhbHVlUmVzcG9uc2USNQoFdmFsdWUYASABKAsyHy5tZWRpYXRhZy5jb2'
        '1wb3NlLnYxLkxhYmVsVmFsdWVSBXZhbHVl');

@$core.Deprecated('Use updateLabelValueRequestDescriptor instead')
const UpdateLabelValueRequest$json = {
  '1': 'UpdateLabelValueRequest',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelValue',
      '10': 'value'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateLabelValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateLabelValueRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVMYWJlbFZhbHVlUmVxdWVzdBI1CgV2YWx1ZRgBIAEoCzIfLm1lZGlhdGFnLmNvbX'
    'Bvc2UudjEuTGFiZWxWYWx1ZVIFdmFsdWUSOwoLdXBkYXRlX21hc2sYAiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuRmllbGRNYXNrUgp1cGRhdGVNYXNr');

@$core.Deprecated('Use updateLabelValueResponseDescriptor instead')
const UpdateLabelValueResponse$json = {
  '1': 'UpdateLabelValueResponse',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.compose.v1.LabelValue',
      '10': 'value'
    },
  ],
};

/// Descriptor for `UpdateLabelValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateLabelValueResponseDescriptor =
    $convert.base64Decode(
        'ChhVcGRhdGVMYWJlbFZhbHVlUmVzcG9uc2USNQoFdmFsdWUYASABKAsyHy5tZWRpYXRhZy5jb2'
        '1wb3NlLnYxLkxhYmVsVmFsdWVSBXZhbHVl');

const $core.Map<$core.String, $core.dynamic> MediaComposeServiceBase$json = {
  '1': 'MediaComposeService',
  '2': [
    {
      '1': 'GetTimeline',
      '2': '.mediatag.compose.v1.GetTimelineRequest',
      '3': '.mediatag.compose.v1.GetTimelineResponse'
    },
    {
      '1': 'ListTimelines',
      '2': '.mediatag.compose.v1.ListTimelinesRequest',
      '3': '.mediatag.compose.v1.ListTimelinesResponse'
    },
    {
      '1': 'UpdateTimeline',
      '2': '.mediatag.compose.v1.UpdateTimelineRequest',
      '3': '.mediatag.compose.v1.UpdateTimelineResponse'
    },
    {
      '1': 'ChangeTimelineStatus',
      '2': '.mediatag.compose.v1.ChangeTimelineStatusRequest',
      '3': '.mediatag.compose.v1.ChangeTimelineStatusResponse'
    },
    {
      '1': 'DeleteTimeline',
      '2': '.mediatag.compose.v1.DeleteTimelineRequest',
      '3': '.mediatag.compose.v1.DeleteTimelineResponse'
    },
    {
      '1': 'CreateTrack',
      '2': '.mediatag.compose.v1.CreateTrackRequest',
      '3': '.mediatag.compose.v1.CreateTrackResponse'
    },
    {
      '1': 'UpdateTrack',
      '2': '.mediatag.compose.v1.UpdateTrackRequest',
      '3': '.mediatag.compose.v1.UpdateTrackResponse'
    },
    {
      '1': 'DeleteTrack',
      '2': '.mediatag.compose.v1.DeleteTrackRequest',
      '3': '.mediatag.compose.v1.DeleteTrackResponse'
    },
    {
      '1': 'CreateClip',
      '2': '.mediatag.compose.v1.CreateClipRequest',
      '3': '.mediatag.compose.v1.CreateClipResponse'
    },
    {
      '1': 'UpdateClip',
      '2': '.mediatag.compose.v1.UpdateClipRequest',
      '3': '.mediatag.compose.v1.UpdateClipResponse'
    },
    {
      '1': 'DeleteClip',
      '2': '.mediatag.compose.v1.DeleteClipRequest',
      '3': '.mediatag.compose.v1.DeleteClipResponse'
    },
  ],
};

@$core.Deprecated('Use mediaComposeServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MediaComposeServiceBase$messageJson = {
  '.mediatag.compose.v1.GetTimelineRequest': GetTimelineRequest$json,
  '.mediatag.compose.v1.GetTimelineResponse': GetTimelineResponse$json,
  '.mediatag.compose.v1.Timeline': Timeline$json,
  '.mediatag.compose.v1.LabelRef': LabelRef$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.compose.v1.Track': Track$json,
  '.mediatag.compose.v1.Clip': Clip$json,
  '.mediatag.compose.v1.ClipSource': ClipSource$json,
  '.google.protobuf.Struct': $1.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $1.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $1.Value$json,
  '.google.protobuf.ListValue': $1.ListValue$json,
  '.mediatag.compose.v1.ClipProvenance': ClipProvenance$json,
  '.mediatag.asset.v1.Asset': $2.Asset$json,
  '.mediatag.asset.v1.Provenance': $2.Provenance$json,
  '.mediatag.compose.v1.ListTimelinesRequest': ListTimelinesRequest$json,
  '.mediatag.compose.v1.ListTimelinesResponse': ListTimelinesResponse$json,
  '.mediatag.compose.v1.UpdateTimelineRequest': UpdateTimelineRequest$json,
  '.google.protobuf.FieldMask': $3.FieldMask$json,
  '.mediatag.compose.v1.UpdateTimelineResponse': UpdateTimelineResponse$json,
  '.mediatag.compose.v1.ChangeTimelineStatusRequest':
      ChangeTimelineStatusRequest$json,
  '.mediatag.compose.v1.ChangeTimelineStatusResponse':
      ChangeTimelineStatusResponse$json,
  '.mediatag.compose.v1.DeleteTimelineRequest': DeleteTimelineRequest$json,
  '.mediatag.compose.v1.DeleteTimelineResponse': DeleteTimelineResponse$json,
  '.mediatag.compose.v1.CreateTrackRequest': CreateTrackRequest$json,
  '.mediatag.compose.v1.CreateTrackResponse': CreateTrackResponse$json,
  '.mediatag.compose.v1.UpdateTrackRequest': UpdateTrackRequest$json,
  '.mediatag.compose.v1.UpdateTrackResponse': UpdateTrackResponse$json,
  '.mediatag.compose.v1.DeleteTrackRequest': DeleteTrackRequest$json,
  '.mediatag.compose.v1.DeleteTrackResponse': DeleteTrackResponse$json,
  '.mediatag.compose.v1.CreateClipRequest': CreateClipRequest$json,
  '.mediatag.compose.v1.CreateClipResponse': CreateClipResponse$json,
  '.mediatag.compose.v1.UpdateClipRequest': UpdateClipRequest$json,
  '.mediatag.compose.v1.UpdateClipResponse': UpdateClipResponse$json,
  '.mediatag.compose.v1.DeleteClipRequest': DeleteClipRequest$json,
  '.mediatag.compose.v1.DeleteClipResponse': DeleteClipResponse$json,
};

/// Descriptor for `MediaComposeService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List mediaComposeServiceDescriptor = $convert.base64Decode(
    'ChNNZWRpYUNvbXBvc2VTZXJ2aWNlEmAKC0dldFRpbWVsaW5lEicubWVkaWF0YWcuY29tcG9zZS'
    '52MS5HZXRUaW1lbGluZVJlcXVlc3QaKC5tZWRpYXRhZy5jb21wb3NlLnYxLkdldFRpbWVsaW5l'
    'UmVzcG9uc2USZgoNTGlzdFRpbWVsaW5lcxIpLm1lZGlhdGFnLmNvbXBvc2UudjEuTGlzdFRpbW'
    'VsaW5lc1JlcXVlc3QaKi5tZWRpYXRhZy5jb21wb3NlLnYxLkxpc3RUaW1lbGluZXNSZXNwb25z'
    'ZRJpCg5VcGRhdGVUaW1lbGluZRIqLm1lZGlhdGFnLmNvbXBvc2UudjEuVXBkYXRlVGltZWxpbm'
    'VSZXF1ZXN0GisubWVkaWF0YWcuY29tcG9zZS52MS5VcGRhdGVUaW1lbGluZVJlc3BvbnNlEnsK'
    'FENoYW5nZVRpbWVsaW5lU3RhdHVzEjAubWVkaWF0YWcuY29tcG9zZS52MS5DaGFuZ2VUaW1lbG'
    'luZVN0YXR1c1JlcXVlc3QaMS5tZWRpYXRhZy5jb21wb3NlLnYxLkNoYW5nZVRpbWVsaW5lU3Rh'
    'dHVzUmVzcG9uc2USaQoORGVsZXRlVGltZWxpbmUSKi5tZWRpYXRhZy5jb21wb3NlLnYxLkRlbG'
    'V0ZVRpbWVsaW5lUmVxdWVzdBorLm1lZGlhdGFnLmNvbXBvc2UudjEuRGVsZXRlVGltZWxpbmVS'
    'ZXNwb25zZRJgCgtDcmVhdGVUcmFjaxInLm1lZGlhdGFnLmNvbXBvc2UudjEuQ3JlYXRlVHJhY2'
    'tSZXF1ZXN0GigubWVkaWF0YWcuY29tcG9zZS52MS5DcmVhdGVUcmFja1Jlc3BvbnNlEmAKC1Vw'
    'ZGF0ZVRyYWNrEicubWVkaWF0YWcuY29tcG9zZS52MS5VcGRhdGVUcmFja1JlcXVlc3QaKC5tZW'
    'RpYXRhZy5jb21wb3NlLnYxLlVwZGF0ZVRyYWNrUmVzcG9uc2USYAoLRGVsZXRlVHJhY2sSJy5t'
    'ZWRpYXRhZy5jb21wb3NlLnYxLkRlbGV0ZVRyYWNrUmVxdWVzdBooLm1lZGlhdGFnLmNvbXBvc2'
    'UudjEuRGVsZXRlVHJhY2tSZXNwb25zZRJdCgpDcmVhdGVDbGlwEiYubWVkaWF0YWcuY29tcG9z'
    'ZS52MS5DcmVhdGVDbGlwUmVxdWVzdBonLm1lZGlhdGFnLmNvbXBvc2UudjEuQ3JlYXRlQ2xpcF'
    'Jlc3BvbnNlEl0KClVwZGF0ZUNsaXASJi5tZWRpYXRhZy5jb21wb3NlLnYxLlVwZGF0ZUNsaXBS'
    'ZXF1ZXN0GicubWVkaWF0YWcuY29tcG9zZS52MS5VcGRhdGVDbGlwUmVzcG9uc2USXQoKRGVsZX'
    'RlQ2xpcBImLm1lZGlhdGFnLmNvbXBvc2UudjEuRGVsZXRlQ2xpcFJlcXVlc3QaJy5tZWRpYXRh'
    'Zy5jb21wb3NlLnYxLkRlbGV0ZUNsaXBSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> LabelServiceBase$json = {
  '1': 'LabelService',
  '2': [
    {
      '1': 'ListLabelVocabs',
      '2': '.mediatag.compose.v1.ListLabelVocabsRequest',
      '3': '.mediatag.compose.v1.ListLabelVocabsResponse'
    },
    {
      '1': 'CreateLabelVocab',
      '2': '.mediatag.compose.v1.CreateLabelVocabRequest',
      '3': '.mediatag.compose.v1.CreateLabelVocabResponse'
    },
    {
      '1': 'CreateLabelValue',
      '2': '.mediatag.compose.v1.CreateLabelValueRequest',
      '3': '.mediatag.compose.v1.CreateLabelValueResponse'
    },
    {
      '1': 'UpdateLabelValue',
      '2': '.mediatag.compose.v1.UpdateLabelValueRequest',
      '3': '.mediatag.compose.v1.UpdateLabelValueResponse'
    },
  ],
};

@$core.Deprecated('Use labelServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    LabelServiceBase$messageJson = {
  '.mediatag.compose.v1.ListLabelVocabsRequest': ListLabelVocabsRequest$json,
  '.mediatag.compose.v1.ListLabelVocabsResponse': ListLabelVocabsResponse$json,
  '.mediatag.compose.v1.LabelVocab': LabelVocab$json,
  '.mediatag.compose.v1.LabelValue': LabelValue$json,
  '.mediatag.compose.v1.CreateLabelVocabRequest': CreateLabelVocabRequest$json,
  '.mediatag.compose.v1.CreateLabelVocabResponse':
      CreateLabelVocabResponse$json,
  '.mediatag.compose.v1.CreateLabelValueRequest': CreateLabelValueRequest$json,
  '.mediatag.compose.v1.CreateLabelValueResponse':
      CreateLabelValueResponse$json,
  '.mediatag.compose.v1.UpdateLabelValueRequest': UpdateLabelValueRequest$json,
  '.google.protobuf.FieldMask': $3.FieldMask$json,
  '.mediatag.compose.v1.UpdateLabelValueResponse':
      UpdateLabelValueResponse$json,
};

/// Descriptor for `LabelService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List labelServiceDescriptor = $convert.base64Decode(
    'CgxMYWJlbFNlcnZpY2USbAoPTGlzdExhYmVsVm9jYWJzEisubWVkaWF0YWcuY29tcG9zZS52MS'
    '5MaXN0TGFiZWxWb2NhYnNSZXF1ZXN0GiwubWVkaWF0YWcuY29tcG9zZS52MS5MaXN0TGFiZWxW'
    'b2NhYnNSZXNwb25zZRJvChBDcmVhdGVMYWJlbFZvY2FiEiwubWVkaWF0YWcuY29tcG9zZS52MS'
    '5DcmVhdGVMYWJlbFZvY2FiUmVxdWVzdBotLm1lZGlhdGFnLmNvbXBvc2UudjEuQ3JlYXRlTGFi'
    'ZWxWb2NhYlJlc3BvbnNlEm8KEENyZWF0ZUxhYmVsVmFsdWUSLC5tZWRpYXRhZy5jb21wb3NlLn'
    'YxLkNyZWF0ZUxhYmVsVmFsdWVSZXF1ZXN0Gi0ubWVkaWF0YWcuY29tcG9zZS52MS5DcmVhdGVM'
    'YWJlbFZhbHVlUmVzcG9uc2USbwoQVXBkYXRlTGFiZWxWYWx1ZRIsLm1lZGlhdGFnLmNvbXBvc2'
    'UudjEuVXBkYXRlTGFiZWxWYWx1ZVJlcXVlc3QaLS5tZWRpYXRhZy5jb21wb3NlLnYxLlVwZGF0'
    'ZUxhYmVsVmFsdWVSZXNwb25zZQ==');
