// This is a generated file - do not edit.
//
// Generated from mediatag/tool/v1/tool.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use toolPatternDescriptor instead')
const ToolPattern$json = {
  '1': 'ToolPattern',
  '2': [
    {'1': 'TOOL_PATTERN_UNSPECIFIED', '2': 0},
    {'1': 'TOOL_PATTERN_PUSH', '2': 1},
    {'1': 'TOOL_PATTERN_PULL', '2': 2},
  ],
};

/// Descriptor for `ToolPattern`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List toolPatternDescriptor = $convert.base64Decode(
    'CgtUb29sUGF0dGVybhIcChhUT09MX1BBVFRFUk5fVU5TUEVDSUZJRUQQABIVChFUT09MX1BBVF'
    'RFUk5fUFVTSBABEhUKEVRPT0xfUEFUVEVSTl9QVUxMEAI=');

@$core.Deprecated('Use toolUnitDescriptor instead')
const ToolUnit$json = {
  '1': 'ToolUnit',
  '2': [
    {'1': 'TOOL_UNIT_UNSPECIFIED', '2': 0},
    {'1': 'TOOL_UNIT_FRAME', '2': 1},
    {'1': 'TOOL_UNIT_SECOND', '2': 2},
  ],
};

/// Descriptor for `ToolUnit`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List toolUnitDescriptor = $convert.base64Decode(
    'CghUb29sVW5pdBIZChVUT09MX1VOSVRfVU5TUEVDSUZJRUQQABITCg9UT09MX1VOSVRfRlJBTU'
    'UQARIUChBUT09MX1VOSVRfU0VDT05EEAI=');

@$core.Deprecated('Use toolDispatchDescriptor instead')
const ToolDispatch$json = {
  '1': 'ToolDispatch',
  '2': [
    {'1': 'TOOL_DISPATCH_UNSPECIFIED', '2': 0},
    {'1': 'TOOL_DISPATCH_MANDATORY', '2': 1},
    {'1': 'TOOL_DISPATCH_ON_DEMAND', '2': 2},
  ],
};

/// Descriptor for `ToolDispatch`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List toolDispatchDescriptor = $convert.base64Decode(
    'CgxUb29sRGlzcGF0Y2gSHQoZVE9PTF9ESVNQQVRDSF9VTlNQRUNJRklFRBAAEhsKF1RPT0xfRE'
    'lTUEFUQ0hfTUFOREFUT1JZEAESGwoXVE9PTF9ESVNQQVRDSF9PTl9ERU1BTkQQAg==');

@$core.Deprecated('Use runTriggerDescriptor instead')
const RunTrigger$json = {
  '1': 'RunTrigger',
  '2': [
    {'1': 'RUN_TRIGGER_UNSPECIFIED', '2': 0},
    {'1': 'RUN_TRIGGER_MANUAL', '2': 1},
    {'1': 'RUN_TRIGGER_AUTO_TAGGING', '2': 2},
    {'1': 'RUN_TRIGGER_ASSET_UPLOADED', '2': 3},
  ],
};

/// Descriptor for `RunTrigger`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List runTriggerDescriptor = $convert.base64Decode(
    'CgpSdW5UcmlnZ2VyEhsKF1JVTl9UUklHR0VSX1VOU1BFQ0lGSUVEEAASFgoSUlVOX1RSSUdHRV'
    'JfTUFOVUFMEAESHAoYUlVOX1RSSUdHRVJfQVVUT19UQUdHSU5HEAISHgoaUlVOX1RSSUdHRVJf'
    'QVNTRVRfVVBMT0FERUQQAw==');

@$core.Deprecated('Use runStatusDescriptor instead')
const RunStatus$json = {
  '1': 'RunStatus',
  '2': [
    {'1': 'RUN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RUN_STATUS_QUEUED', '2': 1},
    {'1': 'RUN_STATUS_RUNNING', '2': 2},
    {'1': 'RUN_STATUS_SUCCEEDED', '2': 3},
    {'1': 'RUN_STATUS_FAILED', '2': 4},
    {'1': 'RUN_STATUS_CANCELED', '2': 5},
  ],
};

/// Descriptor for `RunStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List runStatusDescriptor = $convert.base64Decode(
    'CglSdW5TdGF0dXMSGgoWUlVOX1NUQVRVU19VTlNQRUNJRklFRBAAEhUKEVJVTl9TVEFUVVNfUV'
    'VFVUVEEAESFgoSUlVOX1NUQVRVU19SVU5OSU5HEAISGAoUUlVOX1NUQVRVU19TVUNDRUVERUQQ'
    'AxIVChFSVU5fU1RBVFVTX0ZBSUxFRBAEEhcKE1JVTl9TVEFUVVNfQ0FOQ0VMRUQQBQ==');

@$core.Deprecated('Use toolDescriptor instead')
const Tool$json = {
  '1': 'Tool',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 9, '10': 'toolId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
    {'1': 'remote_model_name', '3': 4, '4': 1, '5': 9, '10': 'remoteModelName'},
    {'1': 'tool_version', '3': 5, '4': 1, '5': 9, '10': 'toolVersion'},
    {
      '1': 'pattern',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.mediatag.tool.v1.ToolPattern',
      '10': 'pattern'
    },
    {'1': 'payload_kind', '3': 7, '4': 1, '5': 9, '10': 'payloadKind'},
    {
      '1': 'supported_input_kinds',
      '3': 8,
      '4': 3,
      '5': 14,
      '6': '.mediatag.asset.v1.AssetKind',
      '10': 'supportedInputKinds'
    },
    {
      '1': 'unit',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.mediatag.tool.v1.ToolUnit',
      '10': 'unit'
    },
    {
      '1': 'dispatch',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.mediatag.tool.v1.ToolDispatch',
      '10': 'dispatch'
    },
    {'1': 'enabled', '3': 11, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `Tool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolDescriptor = $convert.base64Decode(
    'CgRUb29sEhcKB3Rvb2xfaWQYASABKAlSBnRvb2xJZBISCgRuYW1lGAIgASgJUgRuYW1lEhoKCG'
    'VuZHBvaW50GAMgASgJUghlbmRwb2ludBIqChFyZW1vdGVfbW9kZWxfbmFtZRgEIAEoCVIPcmVt'
    'b3RlTW9kZWxOYW1lEiEKDHRvb2xfdmVyc2lvbhgFIAEoCVILdG9vbFZlcnNpb24SNwoHcGF0dG'
    'VybhgGIAEoDjIdLm1lZGlhdGFnLnRvb2wudjEuVG9vbFBhdHRlcm5SB3BhdHRlcm4SIQoMcGF5'
    'bG9hZF9raW5kGAcgASgJUgtwYXlsb2FkS2luZBJQChVzdXBwb3J0ZWRfaW5wdXRfa2luZHMYCC'
    'ADKA4yHC5tZWRpYXRhZy5hc3NldC52MS5Bc3NldEtpbmRSE3N1cHBvcnRlZElucHV0S2luZHMS'
    'LgoEdW5pdBgJIAEoDjIaLm1lZGlhdGFnLnRvb2wudjEuVG9vbFVuaXRSBHVuaXQSOgoIZGlzcG'
    'F0Y2gYCiABKA4yHi5tZWRpYXRhZy50b29sLnYxLlRvb2xEaXNwYXRjaFIIZGlzcGF0Y2gSGAoH'
    'ZW5hYmxlZBgLIAEoCFIHZW5hYmxlZA==');

@$core.Deprecated('Use toolRunDescriptor instead')
const ToolRun$json = {
  '1': 'ToolRun',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'tool_id', '3': 2, '4': 1, '5': 9, '10': 'toolId'},
    {
      '1': 'trigger',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.mediatag.tool.v1.RunTrigger',
      '10': 'trigger'
    },
    {'1': 'target_id', '3': 4, '4': 1, '5': 9, '10': 'targetId'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.mediatag.tool.v1.RunStatus',
      '10': 'status'
    },
    {'1': 'external_job_id', '3': 6, '4': 1, '5': 9, '10': 'externalJobId'},
    {'1': 'error_code', '3': 7, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 8, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'queue_position', '3': 11, '4': 1, '5': 5, '10': 'queuePosition'},
    {'1': 'queue_length', '3': 12, '4': 1, '5': 5, '10': 'queueLength'},
    {'1': 'progress_percent', '3': 13, '4': 1, '5': 1, '10': 'progressPercent'},
    {
      '1': 'estimated_remaining_seconds',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'estimatedRemainingSeconds'
    },
    {'1': 'attempt_count', '3': 15, '4': 1, '5': 5, '10': 'attemptCount'},
    {'1': 'output_asset_ids', '3': 16, '4': 3, '5': 9, '10': 'outputAssetIds'},
  ],
};

/// Descriptor for `ToolRun`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolRunDescriptor = $convert.base64Decode(
    'CgdUb29sUnVuEhUKBnJ1bl9pZBgBIAEoCVIFcnVuSWQSFwoHdG9vbF9pZBgCIAEoCVIGdG9vbE'
    'lkEjYKB3RyaWdnZXIYAyABKA4yHC5tZWRpYXRhZy50b29sLnYxLlJ1blRyaWdnZXJSB3RyaWdn'
    'ZXISGwoJdGFyZ2V0X2lkGAQgASgJUgh0YXJnZXRJZBIzCgZzdGF0dXMYBSABKA4yGy5tZWRpYX'
    'RhZy50b29sLnYxLlJ1blN0YXR1c1IGc3RhdHVzEiYKD2V4dGVybmFsX2pvYl9pZBgGIAEoCVIN'
    'ZXh0ZXJuYWxKb2JJZBIdCgplcnJvcl9jb2RlGAcgASgJUgllcnJvckNvZGUSIwoNZXJyb3JfbW'
    'Vzc2FnZRgIIAEoCVIMZXJyb3JNZXNzYWdlEjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgKIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBIlCg5xdWV1ZV9wb3NpdGlvbhgLIAEo'
    'BVINcXVldWVQb3NpdGlvbhIhCgxxdWV1ZV9sZW5ndGgYDCABKAVSC3F1ZXVlTGVuZ3RoEikKEH'
    'Byb2dyZXNzX3BlcmNlbnQYDSABKAFSD3Byb2dyZXNzUGVyY2VudBI+Chtlc3RpbWF0ZWRfcmVt'
    'YWluaW5nX3NlY29uZHMYDiABKAVSGWVzdGltYXRlZFJlbWFpbmluZ1NlY29uZHMSIwoNYXR0ZW'
    '1wdF9jb3VudBgPIAEoBVIMYXR0ZW1wdENvdW50EigKEG91dHB1dF9hc3NldF9pZHMYECADKAlS'
    'Dm91dHB1dEFzc2V0SWRz');

@$core.Deprecated('Use listToolsRequestDescriptor instead')
const ListToolsRequest$json = {
  '1': 'ListToolsRequest',
};

/// Descriptor for `ListToolsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listToolsRequestDescriptor =
    $convert.base64Decode('ChBMaXN0VG9vbHNSZXF1ZXN0');

@$core.Deprecated('Use listToolsResponseDescriptor instead')
const ListToolsResponse$json = {
  '1': 'ListToolsResponse',
  '2': [
    {
      '1': 'tools',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.tool.v1.Tool',
      '10': 'tools'
    },
  ],
};

/// Descriptor for `ListToolsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listToolsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VG9vbHNSZXNwb25zZRIsCgV0b29scxgBIAMoCzIWLm1lZGlhdGFnLnRvb2wudjEuVG'
    '9vbFIFdG9vbHM=');

@$core.Deprecated('Use createToolRequestDescriptor instead')
const CreateToolRequest$json = {
  '1': 'CreateToolRequest',
  '2': [
    {
      '1': 'tool',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.Tool',
      '10': 'tool'
    },
  ],
};

/// Descriptor for `CreateToolRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createToolRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVUb29sUmVxdWVzdBIqCgR0b29sGAEgASgLMhYubWVkaWF0YWcudG9vbC52MS5Ub2'
    '9sUgR0b29s');

@$core.Deprecated('Use createToolResponseDescriptor instead')
const CreateToolResponse$json = {
  '1': 'CreateToolResponse',
  '2': [
    {
      '1': 'tool',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.Tool',
      '10': 'tool'
    },
  ],
};

/// Descriptor for `CreateToolResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createToolResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVUb29sUmVzcG9uc2USKgoEdG9vbBgBIAEoCzIWLm1lZGlhdGFnLnRvb2wudjEuVG'
    '9vbFIEdG9vbA==');

@$core.Deprecated('Use updateToolRequestDescriptor instead')
const UpdateToolRequest$json = {
  '1': 'UpdateToolRequest',
  '2': [
    {
      '1': 'tool',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.Tool',
      '10': 'tool'
    },
  ],
};

/// Descriptor for `UpdateToolRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateToolRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVUb29sUmVxdWVzdBIqCgR0b29sGAEgASgLMhYubWVkaWF0YWcudG9vbC52MS5Ub2'
    '9sUgR0b29s');

@$core.Deprecated('Use updateToolResponseDescriptor instead')
const UpdateToolResponse$json = {
  '1': 'UpdateToolResponse',
  '2': [
    {
      '1': 'tool',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.Tool',
      '10': 'tool'
    },
  ],
};

/// Descriptor for `UpdateToolResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateToolResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVUb29sUmVzcG9uc2USKgoEdG9vbBgBIAEoCzIWLm1lZGlhdGFnLnRvb2wudjEuVG'
    '9vbFIEdG9vbA==');

@$core.Deprecated('Use deleteToolRequestDescriptor instead')
const DeleteToolRequest$json = {
  '1': 'DeleteToolRequest',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 9, '10': 'toolId'},
  ],
};

/// Descriptor for `DeleteToolRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteToolRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVUb29sUmVxdWVzdBIXCgd0b29sX2lkGAEgASgJUgZ0b29sSWQ=');

@$core.Deprecated('Use deleteToolResponseDescriptor instead')
const DeleteToolResponse$json = {
  '1': 'DeleteToolResponse',
};

/// Descriptor for `DeleteToolResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteToolResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVUb29sUmVzcG9uc2U=');

@$core.Deprecated('Use startRunRequestDescriptor instead')
const StartRunRequest$json = {
  '1': 'StartRunRequest',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 9, '10': 'toolId'},
    {
      '1': 'trigger',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.mediatag.tool.v1.RunTrigger',
      '10': 'trigger'
    },
    {'1': 'target_id', '3': 3, '4': 1, '5': 9, '10': 'targetId'},
  ],
};

/// Descriptor for `StartRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRunRequestDescriptor = $convert.base64Decode(
    'Cg9TdGFydFJ1blJlcXVlc3QSFwoHdG9vbF9pZBgBIAEoCVIGdG9vbElkEjYKB3RyaWdnZXIYAi'
    'ABKA4yHC5tZWRpYXRhZy50b29sLnYxLlJ1blRyaWdnZXJSB3RyaWdnZXISGwoJdGFyZ2V0X2lk'
    'GAMgASgJUgh0YXJnZXRJZA==');

@$core.Deprecated('Use startRunResponseDescriptor instead')
const StartRunResponse$json = {
  '1': 'StartRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.ToolRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `StartRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRunResponseDescriptor = $convert.base64Decode(
    'ChBTdGFydFJ1blJlc3BvbnNlEisKA3J1bhgBIAEoCzIZLm1lZGlhdGFnLnRvb2wudjEuVG9vbF'
    'J1blIDcnVu');

@$core.Deprecated('Use getRunRequestDescriptor instead')
const GetRunRequest$json = {
  '1': 'GetRunRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'wait_for_terminal', '3': 2, '4': 1, '5': 8, '10': 'waitForTerminal'},
    {
      '1': 'wait_timeout_seconds',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'waitTimeoutSeconds'
    },
  ],
};

/// Descriptor for `GetRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRunRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRSdW5SZXF1ZXN0EhUKBnJ1bl9pZBgBIAEoCVIFcnVuSWQSKgoRd2FpdF9mb3JfdGVybW'
    'luYWwYAiABKAhSD3dhaXRGb3JUZXJtaW5hbBIwChR3YWl0X3RpbWVvdXRfc2Vjb25kcxgDIAEo'
    'BVISd2FpdFRpbWVvdXRTZWNvbmRz');

@$core.Deprecated('Use getRunResponseDescriptor instead')
const GetRunResponse$json = {
  '1': 'GetRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.ToolRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `GetRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRunResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRSdW5SZXNwb25zZRIrCgNydW4YASABKAsyGS5tZWRpYXRhZy50b29sLnYxLlRvb2xSdW'
    '5SA3J1bg==');

@$core.Deprecated('Use listRunsRequestDescriptor instead')
const ListRunsRequest$json = {
  '1': 'ListRunsRequest',
  '2': [
    {'1': 'target_id', '3': 1, '4': 1, '5': 9, '10': 'targetId'},
  ],
};

/// Descriptor for `ListRunsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRunsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0UnVuc1JlcXVlc3QSGwoJdGFyZ2V0X2lkGAEgASgJUgh0YXJnZXRJZA==');

@$core.Deprecated('Use listRunsResponseDescriptor instead')
const ListRunsResponse$json = {
  '1': 'ListRunsResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.tool.v1.ToolRun',
      '10': 'runs'
    },
  ],
};

/// Descriptor for `ListRunsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRunsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0UnVuc1Jlc3BvbnNlEi0KBHJ1bnMYASADKAsyGS5tZWRpYXRhZy50b29sLnYxLlRvb2'
    'xSdW5SBHJ1bnM=');

@$core.Deprecated('Use cancelRunRequestDescriptor instead')
const CancelRunRequest$json = {
  '1': 'CancelRunRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
  ],
};

/// Descriptor for `CancelRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRunRequestDescriptor = $convert
    .base64Decode('ChBDYW5jZWxSdW5SZXF1ZXN0EhUKBnJ1bl9pZBgBIAEoCVIFcnVuSWQ=');

@$core.Deprecated('Use cancelRunResponseDescriptor instead')
const CancelRunResponse$json = {
  '1': 'CancelRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.tool.v1.ToolRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `CancelRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRunResponseDescriptor = $convert.base64Decode(
    'ChFDYW5jZWxSdW5SZXNwb25zZRIrCgNydW4YASABKAsyGS5tZWRpYXRhZy50b29sLnYxLlRvb2'
    'xSdW5SA3J1bg==');

const $core.Map<$core.String, $core.dynamic> ToolServiceBase$json = {
  '1': 'ToolService',
  '2': [
    {
      '1': 'ListTools',
      '2': '.mediatag.tool.v1.ListToolsRequest',
      '3': '.mediatag.tool.v1.ListToolsResponse'
    },
    {
      '1': 'CreateTool',
      '2': '.mediatag.tool.v1.CreateToolRequest',
      '3': '.mediatag.tool.v1.CreateToolResponse'
    },
    {
      '1': 'UpdateTool',
      '2': '.mediatag.tool.v1.UpdateToolRequest',
      '3': '.mediatag.tool.v1.UpdateToolResponse'
    },
    {
      '1': 'DeleteTool',
      '2': '.mediatag.tool.v1.DeleteToolRequest',
      '3': '.mediatag.tool.v1.DeleteToolResponse'
    },
    {
      '1': 'StartRun',
      '2': '.mediatag.tool.v1.StartRunRequest',
      '3': '.mediatag.tool.v1.StartRunResponse'
    },
    {
      '1': 'GetRun',
      '2': '.mediatag.tool.v1.GetRunRequest',
      '3': '.mediatag.tool.v1.GetRunResponse'
    },
    {
      '1': 'ListRuns',
      '2': '.mediatag.tool.v1.ListRunsRequest',
      '3': '.mediatag.tool.v1.ListRunsResponse'
    },
    {
      '1': 'CancelRun',
      '2': '.mediatag.tool.v1.CancelRunRequest',
      '3': '.mediatag.tool.v1.CancelRunResponse'
    },
  ],
};

@$core.Deprecated('Use toolServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ToolServiceBase$messageJson = {
  '.mediatag.tool.v1.ListToolsRequest': ListToolsRequest$json,
  '.mediatag.tool.v1.ListToolsResponse': ListToolsResponse$json,
  '.mediatag.tool.v1.Tool': Tool$json,
  '.mediatag.tool.v1.CreateToolRequest': CreateToolRequest$json,
  '.mediatag.tool.v1.CreateToolResponse': CreateToolResponse$json,
  '.mediatag.tool.v1.UpdateToolRequest': UpdateToolRequest$json,
  '.mediatag.tool.v1.UpdateToolResponse': UpdateToolResponse$json,
  '.mediatag.tool.v1.DeleteToolRequest': DeleteToolRequest$json,
  '.mediatag.tool.v1.DeleteToolResponse': DeleteToolResponse$json,
  '.mediatag.tool.v1.StartRunRequest': StartRunRequest$json,
  '.mediatag.tool.v1.StartRunResponse': StartRunResponse$json,
  '.mediatag.tool.v1.ToolRun': ToolRun$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.tool.v1.GetRunRequest': GetRunRequest$json,
  '.mediatag.tool.v1.GetRunResponse': GetRunResponse$json,
  '.mediatag.tool.v1.ListRunsRequest': ListRunsRequest$json,
  '.mediatag.tool.v1.ListRunsResponse': ListRunsResponse$json,
  '.mediatag.tool.v1.CancelRunRequest': CancelRunRequest$json,
  '.mediatag.tool.v1.CancelRunResponse': CancelRunResponse$json,
};

/// Descriptor for `ToolService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List toolServiceDescriptor = $convert.base64Decode(
    'CgtUb29sU2VydmljZRJUCglMaXN0VG9vbHMSIi5tZWRpYXRhZy50b29sLnYxLkxpc3RUb29sc1'
    'JlcXVlc3QaIy5tZWRpYXRhZy50b29sLnYxLkxpc3RUb29sc1Jlc3BvbnNlElcKCkNyZWF0ZVRv'
    'b2wSIy5tZWRpYXRhZy50b29sLnYxLkNyZWF0ZVRvb2xSZXF1ZXN0GiQubWVkaWF0YWcudG9vbC'
    '52MS5DcmVhdGVUb29sUmVzcG9uc2USVwoKVXBkYXRlVG9vbBIjLm1lZGlhdGFnLnRvb2wudjEu'
    'VXBkYXRlVG9vbFJlcXVlc3QaJC5tZWRpYXRhZy50b29sLnYxLlVwZGF0ZVRvb2xSZXNwb25zZR'
    'JXCgpEZWxldGVUb29sEiMubWVkaWF0YWcudG9vbC52MS5EZWxldGVUb29sUmVxdWVzdBokLm1l'
    'ZGlhdGFnLnRvb2wudjEuRGVsZXRlVG9vbFJlc3BvbnNlElEKCFN0YXJ0UnVuEiEubWVkaWF0YW'
    'cudG9vbC52MS5TdGFydFJ1blJlcXVlc3QaIi5tZWRpYXRhZy50b29sLnYxLlN0YXJ0UnVuUmVz'
    'cG9uc2USSwoGR2V0UnVuEh8ubWVkaWF0YWcudG9vbC52MS5HZXRSdW5SZXF1ZXN0GiAubWVkaW'
    'F0YWcudG9vbC52MS5HZXRSdW5SZXNwb25zZRJRCghMaXN0UnVucxIhLm1lZGlhdGFnLnRvb2wu'
    'djEuTGlzdFJ1bnNSZXF1ZXN0GiIubWVkaWF0YWcudG9vbC52MS5MaXN0UnVuc1Jlc3BvbnNlEl'
    'QKCUNhbmNlbFJ1bhIiLm1lZGlhdGFnLnRvb2wudjEuQ2FuY2VsUnVuUmVxdWVzdBojLm1lZGlh'
    'dGFnLnRvb2wudjEuQ2FuY2VsUnVuUmVzcG9uc2U=');
