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

import '../../../google/protobuf/field_mask.pbjson.dart' as $0;

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

@$core.Deprecated('Use toolDescriptor instead')
const Tool$json = {
  '1': 'Tool',
  '2': [
    {'1': 'tool_id', '3': 1, '4': 1, '5': 3, '10': 'toolId'},
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
    {'1': 'description', '3': 12, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `Tool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolDescriptor = $convert.base64Decode(
    'CgRUb29sEhcKB3Rvb2xfaWQYASABKANSBnRvb2xJZBISCgRuYW1lGAIgASgJUgRuYW1lEhoKCG'
    'VuZHBvaW50GAMgASgJUghlbmRwb2ludBIqChFyZW1vdGVfbW9kZWxfbmFtZRgEIAEoCVIPcmVt'
    'b3RlTW9kZWxOYW1lEiEKDHRvb2xfdmVyc2lvbhgFIAEoCVILdG9vbFZlcnNpb24SNwoHcGF0dG'
    'VybhgGIAEoDjIdLm1lZGlhdGFnLnRvb2wudjEuVG9vbFBhdHRlcm5SB3BhdHRlcm4SIQoMcGF5'
    'bG9hZF9raW5kGAcgASgJUgtwYXlsb2FkS2luZBJQChVzdXBwb3J0ZWRfaW5wdXRfa2luZHMYCC'
    'ADKA4yHC5tZWRpYXRhZy5hc3NldC52MS5Bc3NldEtpbmRSE3N1cHBvcnRlZElucHV0S2luZHMS'
    'LgoEdW5pdBgJIAEoDjIaLm1lZGlhdGFnLnRvb2wudjEuVG9vbFVuaXRSBHVuaXQSOgoIZGlzcG'
    'F0Y2gYCiABKA4yHi5tZWRpYXRhZy50b29sLnYxLlRvb2xEaXNwYXRjaFIIZGlzcGF0Y2gSGAoH'
    'ZW5hYmxlZBgLIAEoCFIHZW5hYmxlZBIgCgtkZXNjcmlwdGlvbhgMIAEoCVILZGVzY3JpcHRpb2'
    '4=');

@$core.Deprecated('Use listToolsRequestDescriptor instead')
const ListToolsRequest$json = {
  '1': 'ListToolsRequest',
  '2': [
    {'1': 'include_disabled', '3': 1, '4': 1, '5': 8, '10': 'includeDisabled'},
  ],
};

/// Descriptor for `ListToolsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listToolsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VG9vbHNSZXF1ZXN0EikKEGluY2x1ZGVfZGlzYWJsZWQYASABKAhSD2luY2x1ZGVEaX'
    'NhYmxlZA==');

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

/// Descriptor for `UpdateToolRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateToolRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVUb29sUmVxdWVzdBIqCgR0b29sGAEgASgLMhYubWVkaWF0YWcudG9vbC52MS5Ub2'
    '9sUgR0b29sEjsKC3VwZGF0ZV9tYXNrGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLkZpZWxkTWFz'
    'a1IKdXBkYXRlTWFzaw==');

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
    {'1': 'tool_id', '3': 1, '4': 1, '5': 3, '10': 'toolId'},
  ],
};

/// Descriptor for `DeleteToolRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteToolRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVUb29sUmVxdWVzdBIXCgd0b29sX2lkGAEgASgDUgZ0b29sSWQ=');

@$core.Deprecated('Use deleteToolResponseDescriptor instead')
const DeleteToolResponse$json = {
  '1': 'DeleteToolResponse',
};

/// Descriptor for `DeleteToolResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteToolResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVUb29sUmVzcG9uc2U=');

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
  '.google.protobuf.FieldMask': $0.FieldMask$json,
  '.mediatag.tool.v1.UpdateToolResponse': UpdateToolResponse$json,
  '.mediatag.tool.v1.DeleteToolRequest': DeleteToolRequest$json,
  '.mediatag.tool.v1.DeleteToolResponse': DeleteToolResponse$json,
};

/// Descriptor for `ToolService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List toolServiceDescriptor = $convert.base64Decode(
    'CgtUb29sU2VydmljZRJUCglMaXN0VG9vbHMSIi5tZWRpYXRhZy50b29sLnYxLkxpc3RUb29sc1'
    'JlcXVlc3QaIy5tZWRpYXRhZy50b29sLnYxLkxpc3RUb29sc1Jlc3BvbnNlElcKCkNyZWF0ZVRv'
    'b2wSIy5tZWRpYXRhZy50b29sLnYxLkNyZWF0ZVRvb2xSZXF1ZXN0GiQubWVkaWF0YWcudG9vbC'
    '52MS5DcmVhdGVUb29sUmVzcG9uc2USVwoKVXBkYXRlVG9vbBIjLm1lZGlhdGFnLnRvb2wudjEu'
    'VXBkYXRlVG9vbFJlcXVlc3QaJC5tZWRpYXRhZy50b29sLnYxLlVwZGF0ZVRvb2xSZXNwb25zZR'
    'JXCgpEZWxldGVUb29sEiMubWVkaWF0YWcudG9vbC52MS5EZWxldGVUb29sUmVxdWVzdBokLm1l'
    'ZGlhdGFnLnRvb2wudjEuRGVsZXRlVG9vbFJlc3BvbnNl');
