// This is a generated file - do not edit.
//
// Generated from mediatag/asset/v1/asset.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/struct.pbjson.dart' as $0;
import '../../../google/protobuf/timestamp.pbjson.dart' as $1;

@$core.Deprecated('Use assetKindDescriptor instead')
const AssetKind$json = {
  '1': 'AssetKind',
  '2': [
    {'1': 'ASSET_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_KIND_VIDEO', '2': 1},
    {'1': 'ASSET_KIND_AUDIO', '2': 2},
    {'1': 'ASSET_KIND_IMAGE', '2': 3},
    {'1': 'ASSET_KIND_DOCUMENT', '2': 4},
    {'1': 'ASSET_KIND_POSE', '2': 5},
    {'1': 'ASSET_KIND_SUBTITLE', '2': 6},
    {'1': 'ASSET_KIND_TIMESERIES', '2': 7},
    {'1': 'ASSET_KIND_POINTCLOUD', '2': 8},
    {'1': 'ASSET_KIND_OCR_JSON', '2': 9},
    {'1': 'ASSET_KIND_REGION', '2': 10},
  ],
};

/// Descriptor for `AssetKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetKindDescriptor = $convert.base64Decode(
    'CglBc3NldEtpbmQSGgoWQVNTRVRfS0lORF9VTlNQRUNJRklFRBAAEhQKEEFTU0VUX0tJTkRfVk'
    'lERU8QARIUChBBU1NFVF9LSU5EX0FVRElPEAISFAoQQVNTRVRfS0lORF9JTUFHRRADEhcKE0FT'
    'U0VUX0tJTkRfRE9DVU1FTlQQBBITCg9BU1NFVF9LSU5EX1BPU0UQBRIXChNBU1NFVF9LSU5EX1'
    'NVQlRJVExFEAYSGQoVQVNTRVRfS0lORF9USU1FU0VSSUVTEAcSGQoVQVNTRVRfS0lORF9QT0lO'
    'VENMT1VEEAgSFwoTQVNTRVRfS0lORF9PQ1JfSlNPThAJEhUKEUFTU0VUX0tJTkRfUkVHSU9OEA'
    'o=');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.mediatag.asset.v1.AssetKind',
      '10': 'kind'
    },
    {'1': 'file_name', '3': 3, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'sha256', '3': 4, '4': 1, '5': 9, '10': 'sha256'},
    {'1': 'mime_type', '3': 5, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 6, '4': 1, '5': 3, '10': 'sizeBytes'},
    {
      '1': 'properties',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'properties'
    },
    {'1': 'equipment_id', '3': 8, '4': 1, '5': 9, '10': 'equipmentId'},
    {
      '1': 'collected_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {
      '1': 'recorded_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {
      '1': 'duration_ns',
      '3': 14,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'durationNs',
      '17': true
    },
    {
      '1': 'provenance',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.mediatag.asset.v1.Provenance',
      '10': 'provenance'
    },
    {'1': 'content_url', '3': 12, '4': 1, '5': 9, '10': 'contentUrl'},
    {'1': 'source_path', '3': 13, '4': 1, '5': 9, '10': 'sourcePath'},
  ],
  '8': [
    {'1': '_duration_ns'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIwCgRraW5kGAIgASgOMhwubWVkaW'
    'F0YWcuYXNzZXQudjEuQXNzZXRLaW5kUgRraW5kEhsKCWZpbGVfbmFtZRgDIAEoCVIIZmlsZU5h'
    'bWUSFgoGc2hhMjU2GAQgASgJUgZzaGEyNTYSGwoJbWltZV90eXBlGAUgASgJUghtaW1lVHlwZR'
    'IdCgpzaXplX2J5dGVzGAYgASgDUglzaXplQnl0ZXMSNwoKcHJvcGVydGllcxgHIAEoCzIXLmdv'
    'b2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCnByb3BlcnRpZXMSIQoMZXF1aXBtZW50X2lkGAggASgJUg'
    'tlcXVpcG1lbnRJZBI9Cgxjb2xsZWN0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgtjb2xsZWN0ZWRBdBI7CgtyZWNvcmRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSJAoLZHVyYXRpb25fbnMYDiABKANIAFIKZHVyYXRp'
    'b25Oc4gBARI9Cgpwcm92ZW5hbmNlGAsgASgLMh0ubWVkaWF0YWcuYXNzZXQudjEuUHJvdmVuYW'
    '5jZVIKcHJvdmVuYW5jZRIfCgtjb250ZW50X3VybBgMIAEoCVIKY29udGVudFVybBIfCgtzb3Vy'
    'Y2VfcGF0aBgNIAEoCVIKc291cmNlUGF0aEIOCgxfZHVyYXRpb25fbnM=');

@$core.Deprecated('Use provenanceDescriptor instead')
const Provenance$json = {
  '1': 'Provenance',
  '2': [
    {'1': 'operation', '3': 1, '4': 1, '5': 9, '10': 'operation'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'tool_id', '3': 3, '4': 1, '5': 9, '10': 'toolId'},
    {'1': 'tool_version', '3': 4, '4': 1, '5': 9, '10': 'toolVersion'},
    {'1': 'input_asset_ids', '3': 5, '4': 3, '5': 9, '10': 'inputAssetIds'},
    {
      '1': 'parameters',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'parameters'
    },
  ],
};

/// Descriptor for `Provenance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provenanceDescriptor = $convert.base64Decode(
    'CgpQcm92ZW5hbmNlEhwKCW9wZXJhdGlvbhgBIAEoCVIJb3BlcmF0aW9uEhUKBnJ1bl9pZBgCIA'
    'EoCVIFcnVuSWQSFwoHdG9vbF9pZBgDIAEoCVIGdG9vbElkEiEKDHRvb2xfdmVyc2lvbhgEIAEo'
    'CVILdG9vbFZlcnNpb24SJgoPaW5wdXRfYXNzZXRfaWRzGAUgAygJUg1pbnB1dEFzc2V0SWRzEj'
    'cKCnBhcmFtZXRlcnMYBiABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgpwYXJhbWV0ZXJz');

@$core.Deprecated('Use importAssetFromSourceRequestDescriptor instead')
const ImportAssetFromSourceRequest$json = {
  '1': 'ImportAssetFromSourceRequest',
  '2': [
    {'1': 'source_url', '3': 1, '4': 1, '5': 9, '10': 'sourceUrl'},
  ],
};

/// Descriptor for `ImportAssetFromSourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importAssetFromSourceRequestDescriptor =
    $convert.base64Decode(
        'ChxJbXBvcnRBc3NldEZyb21Tb3VyY2VSZXF1ZXN0Eh0KCnNvdXJjZV91cmwYASABKAlSCXNvdX'
        'JjZVVybA==');

@$core.Deprecated('Use importAssetFromSourceResponseDescriptor instead')
const ImportAssetFromSourceResponse$json = {
  '1': 'ImportAssetFromSourceResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `ImportAssetFromSourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importAssetFromSourceResponseDescriptor =
    $convert.base64Decode(
        'Ch1JbXBvcnRBc3NldEZyb21Tb3VyY2VSZXNwb25zZRIuCgVhc3NldBgBIAEoCzIYLm1lZGlhdG'
        'FnLmFzc2V0LnYxLkFzc2V0UgVhc3NldA==');

@$core.Deprecated('Use listAssetsRequestDescriptor instead')
const ListAssetsRequest$json = {
  '1': 'ListAssetsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.mediatag.asset.v1.AssetKind',
      '10': 'kind'
    },
  ],
};

/// Descriptor for `ListAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QXNzZXRzUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaXplEh0KCnBhZ2'
    'VfdG9rZW4YAiABKAlSCXBhZ2VUb2tlbhIwCgRraW5kGAMgASgOMhwubWVkaWF0YWcuYXNzZXQu'
    'djEuQXNzZXRLaW5kUgRraW5k');

@$core.Deprecated('Use listAssetsResponseDescriptor instead')
const ListAssetsResponse$json = {
  '1': 'ListAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'assets'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QXNzZXRzUmVzcG9uc2USMAoGYXNzZXRzGAEgAygLMhgubWVkaWF0YWcuYXNzZXQudj'
    'EuQXNzZXRSBmFzc2V0cxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4=');

@$core.Deprecated('Use getAssetRequestDescriptor instead')
const GetAssetRequest$json = {
  '1': 'GetAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `GetAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRBc3NldFJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use getAssetResponseDescriptor instead')
const GetAssetResponse$json = {
  '1': 'GetAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `GetAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetResponseDescriptor = $convert.base64Decode(
    'ChBHZXRBc3NldFJlc3BvbnNlEi4KBWFzc2V0GAEgASgLMhgubWVkaWF0YWcuYXNzZXQudjEuQX'
    'NzZXRSBWFzc2V0');

@$core.Deprecated('Use deleteAssetRequestDescriptor instead')
const DeleteAssetRequest$json = {
  '1': 'DeleteAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `DeleteAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAssetRequestDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVBc3NldFJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use deleteAssetResponseDescriptor instead')
const DeleteAssetResponse$json = {
  '1': 'DeleteAssetResponse',
};

/// Descriptor for `DeleteAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAssetResponseDescriptor =
    $convert.base64Decode('ChNEZWxldGVBc3NldFJlc3BvbnNl');

@$core.Deprecated('Use listDuplicateAssetsRequestDescriptor instead')
const ListDuplicateAssetsRequest$json = {
  '1': 'ListDuplicateAssetsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListDuplicateAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDuplicateAssetsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RHVwbGljYXRlQXNzZXRzUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaX'
        'plEh0KCnBhZ2VfdG9rZW4YAiABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use listDuplicateAssetsResponseDescriptor instead')
const ListDuplicateAssetsResponse$json = {
  '1': 'ListDuplicateAssetsResponse',
  '2': [
    {
      '1': 'groups',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.asset.v1.DuplicateGroup',
      '10': 'groups'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListDuplicateAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDuplicateAssetsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0RHVwbGljYXRlQXNzZXRzUmVzcG9uc2USOQoGZ3JvdXBzGAEgAygLMiEubWVkaWF0YW'
        'cuYXNzZXQudjEuRHVwbGljYXRlR3JvdXBSBmdyb3VwcxImCg9uZXh0X3BhZ2VfdG9rZW4YAiAB'
        'KAlSDW5leHRQYWdlVG9rZW4=');

@$core.Deprecated('Use duplicateGroupDescriptor instead')
const DuplicateGroup$json = {
  '1': 'DuplicateGroup',
  '2': [
    {'1': 'sha256', '3': 1, '4': 1, '5': 9, '10': 'sha256'},
    {
      '1': 'assets',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `DuplicateGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateGroupDescriptor = $convert.base64Decode(
    'Cg5EdXBsaWNhdGVHcm91cBIWCgZzaGEyNTYYASABKAlSBnNoYTI1NhIwCgZhc3NldHMYAiADKA'
    'syGC5tZWRpYXRhZy5hc3NldC52MS5Bc3NldFIGYXNzZXRz');

@$core.Deprecated('Use jobAssetDescriptor instead')
const JobAsset$json = {
  '1': 'JobAsset',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'asset'
    },
    {'1': 'pass_id', '3': 2, '4': 1, '5': 9, '10': 'passId'},
  ],
};

/// Descriptor for `JobAsset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobAssetDescriptor = $convert.base64Decode(
    'CghKb2JBc3NldBIuCgVhc3NldBgBIAEoCzIYLm1lZGlhdGFnLmFzc2V0LnYxLkFzc2V0UgVhc3'
    'NldBIXCgdwYXNzX2lkGAIgASgJUgZwYXNzSWQ=');

@$core.Deprecated('Use listJobAssetsRequestDescriptor instead')
const ListJobAssetsRequest$json = {
  '1': 'ListJobAssetsRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {
      '1': 'pass_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'passId',
      '17': true
    },
  ],
  '8': [
    {'1': '_pass_id'},
  ],
};

/// Descriptor for `ListJobAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobAssetsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0Sm9iQXNzZXRzUmVxdWVzdBIVCgZqb2JfaWQYASABKAlSBWpvYklkEhwKB3Bhc3NfaW'
    'QYAiABKAlIAFIGcGFzc0lkiAEBQgoKCF9wYXNzX2lk');

@$core.Deprecated('Use listJobAssetsResponseDescriptor instead')
const ListJobAssetsResponse$json = {
  '1': 'ListJobAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.asset.v1.JobAsset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `ListJobAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobAssetsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0Sm9iQXNzZXRzUmVzcG9uc2USMwoGYXNzZXRzGAEgAygLMhsubWVkaWF0YWcuYXNzZX'
    'QudjEuSm9iQXNzZXRSBmFzc2V0cw==');

@$core.Deprecated('Use attachAssetRequestDescriptor instead')
const AttachAssetRequest$json = {
  '1': 'AttachAssetRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'pass_id', '3': 3, '4': 1, '5': 9, '10': 'passId'},
  ],
};

/// Descriptor for `AttachAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachAssetRequestDescriptor = $convert.base64Decode(
    'ChJBdHRhY2hBc3NldFJlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZBIZCghhc3NldF9pZB'
    'gCIAEoCVIHYXNzZXRJZBIXCgdwYXNzX2lkGAMgASgJUgZwYXNzSWQ=');

@$core.Deprecated('Use attachAssetResponseDescriptor instead')
const AttachAssetResponse$json = {
  '1': 'AttachAssetResponse',
  '2': [
    {
      '1': 'attachment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.asset.v1.JobAsset',
      '10': 'attachment'
    },
  ],
};

/// Descriptor for `AttachAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachAssetResponseDescriptor = $convert.base64Decode(
    'ChNBdHRhY2hBc3NldFJlc3BvbnNlEjsKCmF0dGFjaG1lbnQYASABKAsyGy5tZWRpYXRhZy5hc3'
    'NldC52MS5Kb2JBc3NldFIKYXR0YWNobWVudA==');

@$core.Deprecated('Use detachAssetRequestDescriptor instead')
const DetachAssetRequest$json = {
  '1': 'DetachAssetRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `DetachAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detachAssetRequestDescriptor = $convert.base64Decode(
    'ChJEZXRhY2hBc3NldFJlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZBIZCghhc3NldF9pZB'
    'gCIAEoCVIHYXNzZXRJZA==');

@$core.Deprecated('Use detachAssetResponseDescriptor instead')
const DetachAssetResponse$json = {
  '1': 'DetachAssetResponse',
};

/// Descriptor for `DetachAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detachAssetResponseDescriptor =
    $convert.base64Decode('ChNEZXRhY2hBc3NldFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> AssetServiceBase$json = {
  '1': 'AssetService',
  '2': [
    {
      '1': 'ImportAssetFromSource',
      '2': '.mediatag.asset.v1.ImportAssetFromSourceRequest',
      '3': '.mediatag.asset.v1.ImportAssetFromSourceResponse'
    },
    {
      '1': 'ListAssets',
      '2': '.mediatag.asset.v1.ListAssetsRequest',
      '3': '.mediatag.asset.v1.ListAssetsResponse'
    },
    {
      '1': 'GetAsset',
      '2': '.mediatag.asset.v1.GetAssetRequest',
      '3': '.mediatag.asset.v1.GetAssetResponse'
    },
    {
      '1': 'DeleteAsset',
      '2': '.mediatag.asset.v1.DeleteAssetRequest',
      '3': '.mediatag.asset.v1.DeleteAssetResponse'
    },
    {
      '1': 'ListDuplicateAssets',
      '2': '.mediatag.asset.v1.ListDuplicateAssetsRequest',
      '3': '.mediatag.asset.v1.ListDuplicateAssetsResponse'
    },
    {
      '1': 'ListJobAssets',
      '2': '.mediatag.asset.v1.ListJobAssetsRequest',
      '3': '.mediatag.asset.v1.ListJobAssetsResponse'
    },
    {
      '1': 'AttachAsset',
      '2': '.mediatag.asset.v1.AttachAssetRequest',
      '3': '.mediatag.asset.v1.AttachAssetResponse'
    },
    {
      '1': 'DetachAsset',
      '2': '.mediatag.asset.v1.DetachAssetRequest',
      '3': '.mediatag.asset.v1.DetachAssetResponse'
    },
  ],
};

@$core.Deprecated('Use assetServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AssetServiceBase$messageJson = {
  '.mediatag.asset.v1.ImportAssetFromSourceRequest':
      ImportAssetFromSourceRequest$json,
  '.mediatag.asset.v1.ImportAssetFromSourceResponse':
      ImportAssetFromSourceResponse$json,
  '.mediatag.asset.v1.Asset': Asset$json,
  '.google.protobuf.Struct': $0.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $0.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $0.Value$json,
  '.google.protobuf.ListValue': $0.ListValue$json,
  '.google.protobuf.Timestamp': $1.Timestamp$json,
  '.mediatag.asset.v1.Provenance': Provenance$json,
  '.mediatag.asset.v1.ListAssetsRequest': ListAssetsRequest$json,
  '.mediatag.asset.v1.ListAssetsResponse': ListAssetsResponse$json,
  '.mediatag.asset.v1.GetAssetRequest': GetAssetRequest$json,
  '.mediatag.asset.v1.GetAssetResponse': GetAssetResponse$json,
  '.mediatag.asset.v1.DeleteAssetRequest': DeleteAssetRequest$json,
  '.mediatag.asset.v1.DeleteAssetResponse': DeleteAssetResponse$json,
  '.mediatag.asset.v1.ListDuplicateAssetsRequest':
      ListDuplicateAssetsRequest$json,
  '.mediatag.asset.v1.ListDuplicateAssetsResponse':
      ListDuplicateAssetsResponse$json,
  '.mediatag.asset.v1.DuplicateGroup': DuplicateGroup$json,
  '.mediatag.asset.v1.ListJobAssetsRequest': ListJobAssetsRequest$json,
  '.mediatag.asset.v1.ListJobAssetsResponse': ListJobAssetsResponse$json,
  '.mediatag.asset.v1.JobAsset': JobAsset$json,
  '.mediatag.asset.v1.AttachAssetRequest': AttachAssetRequest$json,
  '.mediatag.asset.v1.AttachAssetResponse': AttachAssetResponse$json,
  '.mediatag.asset.v1.DetachAssetRequest': DetachAssetRequest$json,
  '.mediatag.asset.v1.DetachAssetResponse': DetachAssetResponse$json,
};

/// Descriptor for `AssetService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List assetServiceDescriptor = $convert.base64Decode(
    'CgxBc3NldFNlcnZpY2USegoVSW1wb3J0QXNzZXRGcm9tU291cmNlEi8ubWVkaWF0YWcuYXNzZX'
    'QudjEuSW1wb3J0QXNzZXRGcm9tU291cmNlUmVxdWVzdBowLm1lZGlhdGFnLmFzc2V0LnYxLklt'
    'cG9ydEFzc2V0RnJvbVNvdXJjZVJlc3BvbnNlElkKCkxpc3RBc3NldHMSJC5tZWRpYXRhZy5hc3'
    'NldC52MS5MaXN0QXNzZXRzUmVxdWVzdBolLm1lZGlhdGFnLmFzc2V0LnYxLkxpc3RBc3NldHNS'
    'ZXNwb25zZRJTCghHZXRBc3NldBIiLm1lZGlhdGFnLmFzc2V0LnYxLkdldEFzc2V0UmVxdWVzdB'
    'ojLm1lZGlhdGFnLmFzc2V0LnYxLkdldEFzc2V0UmVzcG9uc2USXAoLRGVsZXRlQXNzZXQSJS5t'
    'ZWRpYXRhZy5hc3NldC52MS5EZWxldGVBc3NldFJlcXVlc3QaJi5tZWRpYXRhZy5hc3NldC52MS'
    '5EZWxldGVBc3NldFJlc3BvbnNlEnQKE0xpc3REdXBsaWNhdGVBc3NldHMSLS5tZWRpYXRhZy5h'
    'c3NldC52MS5MaXN0RHVwbGljYXRlQXNzZXRzUmVxdWVzdBouLm1lZGlhdGFnLmFzc2V0LnYxLk'
    'xpc3REdXBsaWNhdGVBc3NldHNSZXNwb25zZRJiCg1MaXN0Sm9iQXNzZXRzEicubWVkaWF0YWcu'
    'YXNzZXQudjEuTGlzdEpvYkFzc2V0c1JlcXVlc3QaKC5tZWRpYXRhZy5hc3NldC52MS5MaXN0Sm'
    '9iQXNzZXRzUmVzcG9uc2USXAoLQXR0YWNoQXNzZXQSJS5tZWRpYXRhZy5hc3NldC52MS5BdHRh'
    'Y2hBc3NldFJlcXVlc3QaJi5tZWRpYXRhZy5hc3NldC52MS5BdHRhY2hBc3NldFJlc3BvbnNlEl'
    'wKC0RldGFjaEFzc2V0EiUubWVkaWF0YWcuYXNzZXQudjEuRGV0YWNoQXNzZXRSZXF1ZXN0GiYu'
    'bWVkaWF0YWcuYXNzZXQudjEuRGV0YWNoQXNzZXRSZXNwb25zZQ==');
