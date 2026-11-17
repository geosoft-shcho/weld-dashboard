// This is a generated file - do not edit.
//
// Generated from mediatag/trace/v1/trace.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/struct.pbjson.dart' as $2;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../run/v1/run.pbjson.dart' as $1;

@$core.Deprecated('Use traceStatusDescriptor instead')
const TraceStatus$json = {
  '1': 'TraceStatus',
  '2': [
    {'1': 'TRACE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TRACE_STATUS_RUNNING', '2': 1},
    {'1': 'TRACE_STATUS_DONE', '2': 2},
    {'1': 'TRACE_STATUS_FAILED', '2': 3},
  ],
};

/// Descriptor for `TraceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List traceStatusDescriptor = $convert.base64Decode(
    'CgtUcmFjZVN0YXR1cxIcChhUUkFDRV9TVEFUVVNfVU5TUEVDSUZJRUQQABIYChRUUkFDRV9TVE'
    'FUVVNfUlVOTklORxABEhUKEVRSQUNFX1NUQVRVU19ET05FEAISFwoTVFJBQ0VfU1RBVFVTX0ZB'
    'SUxFRBAD');

@$core.Deprecated('Use traceDescriptor instead')
const Trace$json = {
  '1': 'Trace',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 3, '10': 'traceId'},
    {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
    {'1': 'file_name', '3': 3, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'total_bytes', '3': 4, '4': 1, '5': 3, '10': 'totalBytes'},
    {'1': 'received_bytes', '3': 5, '4': 1, '5': 3, '10': 'receivedBytes'},
    {'1': 'asset_id', '3': 6, '4': 1, '5': 3, '10': 'assetId'},
    {'1': 'last_event', '3': 7, '4': 1, '5': 9, '10': 'lastEvent'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.mediatag.trace.v1.TraceStatus',
      '10': 'status'
    },
    {'1': 'error_code', '3': 9, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 10, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'published_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'publishedAt'
    },
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'progress_percent',
      '3': 15,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'progressPercent',
      '17': true
    },
    {
      '1': 'embed_pending_clip_ids',
      '3': 16,
      '4': 3,
      '5': 3,
      '10': 'embedPendingClipIds'
    },
    {
      '1': 'run',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.mediatag.run.v1.Run',
      '10': 'run'
    },
  ],
  '8': [
    {'1': '_progress_percent'},
  ],
  '9': [
    {'1': 14, '2': 15},
  ],
};

/// Descriptor for `Trace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceDescriptor = $convert.base64Decode(
    'CgVUcmFjZRIZCgh0cmFjZV9pZBgBIAEoA1IHdHJhY2VJZBIWCgZzb3VyY2UYAiABKAlSBnNvdX'
    'JjZRIbCglmaWxlX25hbWUYAyABKAlSCGZpbGVOYW1lEh8KC3RvdGFsX2J5dGVzGAQgASgDUgp0'
    'b3RhbEJ5dGVzEiUKDnJlY2VpdmVkX2J5dGVzGAUgASgDUg1yZWNlaXZlZEJ5dGVzEhkKCGFzc2'
    'V0X2lkGAYgASgDUgdhc3NldElkEh0KCmxhc3RfZXZlbnQYByABKAlSCWxhc3RFdmVudBI2CgZz'
    'dGF0dXMYCCABKA4yHi5tZWRpYXRhZy50cmFjZS52MS5UcmFjZVN0YXR1c1IGc3RhdHVzEh0KCm'
    'Vycm9yX2NvZGUYCSABKAlSCWVycm9yQ29kZRIjCg1lcnJvcl9tZXNzYWdlGAogASgJUgxlcnJv'
    'ck1lc3NhZ2USPQoMcHVibGlzaGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFILcHVibGlzaGVkQXQSOQoKY3JlYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJdXBkYXRlZEF0Ei4KEHByb2dyZXNzX3BlcmNlbnQYDyABKAFIAFIPcHJv'
    'Z3Jlc3NQZXJjZW50iAEBEjMKFmVtYmVkX3BlbmRpbmdfY2xpcF9pZHMYECADKANSE2VtYmVkUG'
    'VuZGluZ0NsaXBJZHMSJgoDcnVuGBEgASgLMhQubWVkaWF0YWcucnVuLnYxLlJ1blIDcnVuQhMK'
    'EV9wcm9ncmVzc19wZXJjZW50SgQIDhAP');

@$core.Deprecated('Use traceEventDescriptor instead')
const TraceEvent$json = {
  '1': 'TraceEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 3, '10': 'eventId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'run_id', '3': 4, '4': 1, '5': 3, '10': 'runId'},
    {
      '1': 'detail',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'detail'
    },
    {'1': 'error_code', '3': 6, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
  ],
};

/// Descriptor for `TraceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceEventDescriptor = $convert.base64Decode(
    'CgpUcmFjZUV2ZW50EhkKCGV2ZW50X2lkGAEgASgDUgdldmVudElkEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSFgoGc3RhdHVzGAMgASgJUgZzdGF0dXMSFQoGcnVuX2lkGAQgASgDUgVydW5JZBIvCgZk'
    'ZXRhaWwYBSABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZkZXRhaWwSHQoKZXJyb3JfY2'
    '9kZRgGIAEoCVIJZXJyb3JDb2RlEiMKDWVycm9yX21lc3NhZ2UYByABKAlSDGVycm9yTWVzc2Fn'
    'ZRIqCgJhdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAmF0');

@$core.Deprecated('Use listTracesRequestDescriptor instead')
const ListTracesRequest$json = {
  '1': 'ListTracesRequest',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.mediatag.trace.v1.TraceStatus',
      '10': 'status'
    },
    {'1': 'asset_id', '3': 2, '4': 1, '5': 3, '10': 'assetId'},
    {'1': 'trace_ids', '3': 3, '4': 3, '5': 3, '10': 'traceIds'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListTracesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTracesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0VHJhY2VzUmVxdWVzdBI2CgZzdGF0dXMYASABKA4yHi5tZWRpYXRhZy50cmFjZS52MS'
    '5UcmFjZVN0YXR1c1IGc3RhdHVzEhkKCGFzc2V0X2lkGAIgASgDUgdhc3NldElkEhsKCXRyYWNl'
    'X2lkcxgDIAMoA1IIdHJhY2VJZHMSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZRIdCgpwYW'
    'dlX3Rva2VuGAUgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use listTracesResponseDescriptor instead')
const ListTracesResponse$json = {
  '1': 'ListTracesResponse',
  '2': [
    {
      '1': 'traces',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.trace.v1.Trace',
      '10': 'traces'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListTracesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTracesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0VHJhY2VzUmVzcG9uc2USMAoGdHJhY2VzGAEgAygLMhgubWVkaWF0YWcudHJhY2Uudj'
    'EuVHJhY2VSBnRyYWNlcxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4=');

@$core.Deprecated('Use getTraceRequestDescriptor instead')
const GetTraceRequest$json = {
  '1': 'GetTraceRequest',
  '2': [
    {'1': 'trace_id', '3': 1, '4': 1, '5': 3, '10': 'traceId'},
  ],
};

/// Descriptor for `GetTraceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTraceRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRUcmFjZVJlcXVlc3QSGQoIdHJhY2VfaWQYASABKANSB3RyYWNlSWQ=');

@$core.Deprecated('Use getTraceResponseDescriptor instead')
const GetTraceResponse$json = {
  '1': 'GetTraceResponse',
  '2': [
    {
      '1': 'trace',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.trace.v1.Trace',
      '10': 'trace'
    },
    {
      '1': 'events',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.trace.v1.TraceEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `GetTraceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTraceResponseDescriptor = $convert.base64Decode(
    'ChBHZXRUcmFjZVJlc3BvbnNlEi4KBXRyYWNlGAEgASgLMhgubWVkaWF0YWcudHJhY2UudjEuVH'
    'JhY2VSBXRyYWNlEjUKBmV2ZW50cxgCIAMoCzIdLm1lZGlhdGFnLnRyYWNlLnYxLlRyYWNlRXZl'
    'bnRSBmV2ZW50cw==');

const $core.Map<$core.String, $core.dynamic> TraceServiceBase$json = {
  '1': 'TraceService',
  '2': [
    {
      '1': 'ListTraces',
      '2': '.mediatag.trace.v1.ListTracesRequest',
      '3': '.mediatag.trace.v1.ListTracesResponse'
    },
    {
      '1': 'GetTrace',
      '2': '.mediatag.trace.v1.GetTraceRequest',
      '3': '.mediatag.trace.v1.GetTraceResponse'
    },
  ],
};

@$core.Deprecated('Use traceServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TraceServiceBase$messageJson = {
  '.mediatag.trace.v1.ListTracesRequest': ListTracesRequest$json,
  '.mediatag.trace.v1.ListTracesResponse': ListTracesResponse$json,
  '.mediatag.trace.v1.Trace': Trace$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.run.v1.Run': $1.Run$json,
  '.mediatag.run.v1.RunTarget': $1.RunTarget$json,
  '.mediatag.run.v1.RunWait': $1.RunWait$json,
  '.mediatag.trace.v1.GetTraceRequest': GetTraceRequest$json,
  '.mediatag.trace.v1.GetTraceResponse': GetTraceResponse$json,
  '.mediatag.trace.v1.TraceEvent': TraceEvent$json,
  '.google.protobuf.Struct': $2.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $2.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $2.Value$json,
  '.google.protobuf.ListValue': $2.ListValue$json,
};

/// Descriptor for `TraceService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List traceServiceDescriptor = $convert.base64Decode(
    'CgxUcmFjZVNlcnZpY2USWQoKTGlzdFRyYWNlcxIkLm1lZGlhdGFnLnRyYWNlLnYxLkxpc3RUcm'
    'FjZXNSZXF1ZXN0GiUubWVkaWF0YWcudHJhY2UudjEuTGlzdFRyYWNlc1Jlc3BvbnNlElMKCEdl'
    'dFRyYWNlEiIubWVkaWF0YWcudHJhY2UudjEuR2V0VHJhY2VSZXF1ZXN0GiMubWVkaWF0YWcudH'
    'JhY2UudjEuR2V0VHJhY2VSZXNwb25zZQ==');
