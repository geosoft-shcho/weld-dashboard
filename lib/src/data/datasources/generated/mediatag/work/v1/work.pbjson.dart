// This is a generated file - do not edit.
//
// Generated from mediatag/work/v1/work.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/field_mask.pbjson.dart' as $1;
import '../../../google/protobuf/struct.pbjson.dart' as $3;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../asset/v1/asset.pbjson.dart' as $2;

@$core.Deprecated('Use collectionViewDescriptor instead')
const CollectionView$json = {
  '1': 'CollectionView',
  '2': [
    {'1': 'COLLECTION_VIEW_UNSPECIFIED', '2': 0},
    {'1': 'COLLECTION_VIEW_EQUIPMENT', '2': 1},
    {'1': 'COLLECTION_VIEW_WORKER', '2': 2},
  ],
};

/// Descriptor for `CollectionView`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List collectionViewDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0aW9uVmlldxIfChtDT0xMRUNUSU9OX1ZJRVdfVU5TUEVDSUZJRUQQABIdChlDT0'
    'xMRUNUSU9OX1ZJRVdfRVFVSVBNRU5UEAESGgoWQ09MTEVDVElPTl9WSUVXX1dPUktFUhAC');

@$core.Deprecated('Use collectionLevelDescriptor instead')
const CollectionLevel$json = {
  '1': 'CollectionLevel',
  '2': [
    {'1': 'COLLECTION_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'COLLECTION_LEVEL_EQUIPMENT', '2': 1},
    {'1': 'COLLECTION_LEVEL_WORKER', '2': 2},
    {'1': 'COLLECTION_LEVEL_PROJECT', '2': 3},
    {'1': 'COLLECTION_LEVEL_JOB', '2': 4},
    {'1': 'COLLECTION_LEVEL_PASS', '2': 5},
    {'1': 'COLLECTION_LEVEL_ITEM', '2': 6},
  ],
};

/// Descriptor for `CollectionLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List collectionLevelDescriptor = $convert.base64Decode(
    'Cg9Db2xsZWN0aW9uTGV2ZWwSIAocQ09MTEVDVElPTl9MRVZFTF9VTlNQRUNJRklFRBAAEh4KGk'
    'NPTExFQ1RJT05fTEVWRUxfRVFVSVBNRU5UEAESGwoXQ09MTEVDVElPTl9MRVZFTF9XT1JLRVIQ'
    'AhIcChhDT0xMRUNUSU9OX0xFVkVMX1BST0pFQ1QQAxIYChRDT0xMRUNUSU9OX0xFVkVMX0pPQh'
    'AEEhkKFUNPTExFQ1RJT05fTEVWRUxfUEFTUxAFEhkKFUNPTExFQ1RJT05fTEVWRUxfSVRFTRAG');

@$core.Deprecated('Use timeBasisDescriptor instead')
const TimeBasis$json = {
  '1': 'TimeBasis',
  '2': [
    {'1': 'TIME_BASIS_UNSPECIFIED', '2': 0},
    {'1': 'TIME_BASIS_WORK', '2': 1},
    {'1': 'TIME_BASIS_COLLECTION', '2': 2},
  ],
};

/// Descriptor for `TimeBasis`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List timeBasisDescriptor = $convert.base64Decode(
    'CglUaW1lQmFzaXMSGgoWVElNRV9CQVNJU19VTlNQRUNJRklFRBAAEhMKD1RJTUVfQkFTSVNfV0'
    '9SSxABEhkKFVRJTUVfQkFTSVNfQ09MTEVDVElPThAC');

@$core.Deprecated('Use waveformNormalizeDescriptor instead')
const WaveformNormalize$json = {
  '1': 'WaveformNormalize',
  '2': [
    {'1': 'WAVEFORM_NORMALIZE_UNSPECIFIED', '2': 0},
    {'1': 'WAVEFORM_NORMALIZE_DTW', '2': 1},
  ],
};

/// Descriptor for `WaveformNormalize`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List waveformNormalizeDescriptor = $convert.base64Decode(
    'ChFXYXZlZm9ybU5vcm1hbGl6ZRIiCh5XQVZFRk9STV9OT1JNQUxJWkVfVU5TUEVDSUZJRUQQAB'
    'IaChZXQVZFRk9STV9OT1JNQUxJWkVfRFRXEAE=');

@$core.Deprecated('Use projectDescriptor instead')
const Project$json = {
  '1': 'Project',
  '2': [
    {'1': 'project_no', '3': 1, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'project_name', '3': 2, '4': 1, '5': 9, '10': 'projectName'},
    {'1': 'site_name', '3': 3, '4': 1, '5': 9, '10': 'siteName'},
    {'1': 'customer', '3': 4, '4': 1, '5': 9, '10': 'customer'},
    {'1': 'project_id', '3': 5, '4': 1, '5': 3, '10': 'projectId'},
  ],
};

/// Descriptor for `Project`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDescriptor = $convert.base64Decode(
    'CgdQcm9qZWN0Eh0KCnByb2plY3Rfbm8YASABKAlSCXByb2plY3RObxIhCgxwcm9qZWN0X25hbW'
    'UYAiABKAlSC3Byb2plY3ROYW1lEhsKCXNpdGVfbmFtZRgDIAEoCVIIc2l0ZU5hbWUSGgoIY3Vz'
    'dG9tZXIYBCABKAlSCGN1c3RvbWVyEh0KCnByb2plY3RfaWQYBSABKANSCXByb2plY3RJZA==');

@$core.Deprecated('Use workerDescriptor instead')
const Worker$json = {
  '1': 'Worker',
  '2': [
    {'1': 'worker_id', '3': 1, '4': 1, '5': 3, '10': 'workerId'},
    {'1': 'worker_name', '3': 2, '4': 1, '5': 9, '10': 'workerName'},
    {'1': 'team', '3': 3, '4': 1, '5': 9, '10': 'team'},
    {
      '1': 'is_master',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isMaster',
      '17': true
    },
  ],
  '8': [
    {'1': '_is_master'},
  ],
  '9': [
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `Worker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workerDescriptor = $convert.base64Decode(
    'CgZXb3JrZXISGwoJd29ya2VyX2lkGAEgASgDUgh3b3JrZXJJZBIfCgt3b3JrZXJfbmFtZRgCIA'
    'EoCVIKd29ya2VyTmFtZRISCgR0ZWFtGAMgASgJUgR0ZWFtEiAKCWlzX21hc3RlchgEIAEoCEgA'
    'Ughpc01hc3RlcogBAUIMCgpfaXNfbWFzdGVySgQIBRAG');

@$core.Deprecated('Use equipmentDescriptor instead')
const Equipment$json = {
  '1': 'Equipment',
  '2': [
    {'1': 'equipment_id', '3': 1, '4': 1, '5': 3, '10': 'equipmentId'},
    {'1': 'equipment_name', '3': 2, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'line_name', '3': 3, '4': 1, '5': 9, '10': 'lineName'},
    {'1': 'equipment_code', '3': 4, '4': 1, '5': 9, '10': 'equipmentCode'},
  ],
};

/// Descriptor for `Equipment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equipmentDescriptor = $convert.base64Decode(
    'CglFcXVpcG1lbnQSIQoMZXF1aXBtZW50X2lkGAEgASgDUgtlcXVpcG1lbnRJZBIlCg5lcXVpcG'
    '1lbnRfbmFtZRgCIAEoCVINZXF1aXBtZW50TmFtZRIbCglsaW5lX25hbWUYAyABKAlSCGxpbmVO'
    'YW1lEiUKDmVxdWlwbWVudF9jb2RlGAQgASgJUg1lcXVpcG1lbnRDb2Rl');

@$core.Deprecated('Use jobDescriptor instead')
const Job$json = {
  '1': 'Job',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 3, '10': 'jobId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'project_no', '3': 3, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'unit_no', '3': 4, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'item_code', '3': 5, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 6, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'item_no', '3': 8, '4': 1, '5': 9, '10': 'itemNo'},
    {'1': 'operation_no', '3': 9, '4': 1, '5': 9, '10': 'operationNo'},
    {'1': 'material', '3': 10, '4': 1, '5': 9, '10': 'material'},
    {
      '1': 'outer_diameter_mm',
      '3': 11,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'outerDiameterMm',
      '17': true
    },
    {
      '1': 'thickness_mm',
      '3': 12,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'thicknessMm',
      '17': true
    },
    {'1': 'worker_id', '3': 13, '4': 1, '5': 3, '10': 'workerId'},
    {
      '1': 'started_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'joint_no', '3': 16, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'job_key', '3': 17, '4': 1, '5': 9, '10': 'jobKey'},
    {'1': 'project_id', '3': 18, '4': 1, '5': 3, '10': 'projectId'},
    {'1': 'job_name', '3': 19, '4': 1, '5': 9, '10': 'jobName'},
    {'1': 'project_item_id', '3': 20, '4': 1, '5': 3, '10': 'projectItemId'},
  ],
  '8': [
    {'1': '_outer_diameter_mm'},
    {'1': '_thickness_mm'},
  ],
  '9': [
    {'1': 7, '2': 8},
  ],
};

/// Descriptor for `Job`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobDescriptor = $convert.base64Decode(
    'CgNKb2ISFQoGam9iX2lkGAEgASgDUgVqb2JJZBIdCgpjb21tb25fa2V5GAIgASgJUgljb21tb2'
    '5LZXkSHQoKcHJvamVjdF9ubxgDIAEoCVIJcHJvamVjdE5vEhcKB3VuaXRfbm8YBCABKAlSBnVu'
    'aXRObxIbCglpdGVtX2NvZGUYBSABKAlSCGl0ZW1Db2RlEhsKCWl0ZW1fbmFtZRgGIAEoCVIIaX'
    'RlbU5hbWUSFwoHaXRlbV9ubxgIIAEoCVIGaXRlbU5vEiEKDG9wZXJhdGlvbl9ubxgJIAEoCVIL'
    'b3BlcmF0aW9uTm8SGgoIbWF0ZXJpYWwYCiABKAlSCG1hdGVyaWFsEi8KEW91dGVyX2RpYW1ldG'
    'VyX21tGAsgASgBSABSD291dGVyRGlhbWV0ZXJNbYgBARImCgx0aGlja25lc3NfbW0YDCABKAFI'
    'AVILdGhpY2tuZXNzTW2IAQESGwoJd29ya2VyX2lkGA0gASgDUgh3b3JrZXJJZBI5CgpzdGFydG'
    'VkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0EjUKCGVu'
    'ZGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdBIZCghqb2'
    'ludF9ubxgQIAEoCVIHam9pbnRObxIXCgdqb2Jfa2V5GBEgASgJUgZqb2JLZXkSHQoKcHJvamVj'
    'dF9pZBgSIAEoA1IJcHJvamVjdElkEhkKCGpvYl9uYW1lGBMgASgJUgdqb2JOYW1lEiYKD3Byb2'
    'plY3RfaXRlbV9pZBgUIAEoA1INcHJvamVjdEl0ZW1JZEIUChJfb3V0ZXJfZGlhbWV0ZXJfbW1C'
    'DwoNX3RoaWNrbmVzc19tbUoECAcQCA==');

@$core.Deprecated('Use itemAssignmentDescriptor instead')
const ItemAssignment$json = {
  '1': 'ItemAssignment',
  '2': [
    {'1': 'project_item_id', '3': 1, '4': 1, '5': 3, '10': 'projectItemId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 3, '10': 'projectId'},
    {'1': 'unit_no', '3': 3, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'item_code', '3': 4, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 5, '4': 1, '5': 9, '10': 'itemName'},
  ],
};

/// Descriptor for `ItemAssignment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemAssignmentDescriptor = $convert.base64Decode(
    'Cg5JdGVtQXNzaWdubWVudBImCg9wcm9qZWN0X2l0ZW1faWQYASABKANSDXByb2plY3RJdGVtSW'
    'QSHQoKcHJvamVjdF9pZBgCIAEoA1IJcHJvamVjdElkEhcKB3VuaXRfbm8YAyABKAlSBnVuaXRO'
    'bxIbCglpdGVtX2NvZGUYBCABKAlSCGl0ZW1Db2RlEhsKCWl0ZW1fbmFtZRgFIAEoCVIIaXRlbU'
    '5hbWU=');

@$core.Deprecated('Use itemDescriptor instead')
const Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 2, '4': 1, '5': 9, '10': 'itemName'},
  ],
};

/// Descriptor for `Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDescriptor = $convert.base64Decode(
    'CgRJdGVtEhsKCWl0ZW1fY29kZRgBIAEoCVIIaXRlbUNvZGUSGwoJaXRlbV9uYW1lGAIgASgJUg'
    'hpdGVtTmFtZQ==');

@$core.Deprecated('Use createProjectItemsRequestDescriptor instead')
const CreateProjectItemsRequest$json = {
  '1': 'CreateProjectItemsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 3, '10': 'projectId'},
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ItemAssignment',
      '10': 'items'
    },
  ],
};

/// Descriptor for `CreateProjectItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectItemsRequestDescriptor = $convert.base64Decode(
    'ChlDcmVhdGVQcm9qZWN0SXRlbXNSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKANSCXByb2plY3'
    'RJZBI2CgVpdGVtcxgCIAMoCzIgLm1lZGlhdGFnLndvcmsudjEuSXRlbUFzc2lnbm1lbnRSBWl0'
    'ZW1z');

@$core.Deprecated('Use createProjectItemsResponseDescriptor instead')
const CreateProjectItemsResponse$json = {
  '1': 'CreateProjectItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ItemAssignment',
      '10': 'items'
    },
  ],
};

/// Descriptor for `CreateProjectItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectItemsResponseDescriptor =
    $convert.base64Decode(
        'ChpDcmVhdGVQcm9qZWN0SXRlbXNSZXNwb25zZRI2CgVpdGVtcxgBIAMoCzIgLm1lZGlhdGFnLn'
        'dvcmsudjEuSXRlbUFzc2lnbm1lbnRSBWl0ZW1z');

@$core.Deprecated('Use updateProjectItemRequestDescriptor instead')
const UpdateProjectItemRequest$json = {
  '1': 'UpdateProjectItemRequest',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.ItemAssignment',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UpdateProjectItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectItemRequestDescriptor =
    $convert.base64Decode(
        'ChhVcGRhdGVQcm9qZWN0SXRlbVJlcXVlc3QSNAoEaXRlbRgBIAEoCzIgLm1lZGlhdGFnLndvcm'
        'sudjEuSXRlbUFzc2lnbm1lbnRSBGl0ZW0=');

@$core.Deprecated('Use updateProjectItemResponseDescriptor instead')
const UpdateProjectItemResponse$json = {
  '1': 'UpdateProjectItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.ItemAssignment',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UpdateProjectItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectItemResponseDescriptor =
    $convert.base64Decode(
        'ChlVcGRhdGVQcm9qZWN0SXRlbVJlc3BvbnNlEjQKBGl0ZW0YASABKAsyIC5tZWRpYXRhZy53b3'
        'JrLnYxLkl0ZW1Bc3NpZ25tZW50UgRpdGVt');

@$core.Deprecated('Use listItemsRequestDescriptor instead')
const ListItemsRequest$json = {
  '1': 'ListItemsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 3, '10': 'projectId'},
  ],
};

/// Descriptor for `ListItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0SXRlbXNSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKANSCXByb2plY3RJZA==');

@$core.Deprecated('Use listItemsResponseDescriptor instead')
const ListItemsResponse$json = {
  '1': 'ListItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Item',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0SXRlbXNSZXNwb25zZRIsCgVpdGVtcxgBIAMoCzIWLm1lZGlhdGFnLndvcmsudjEuSX'
    'RlbVIFaXRlbXM=');

@$core.Deprecated('Use passDescriptor instead')
const Pass$json = {
  '1': 'Pass',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 3, '10': 'passId'},
    {'1': 'job_id', '3': 2, '4': 1, '5': 3, '10': 'jobId'},
    {'1': 'pass_no', '3': 3, '4': 1, '5': 5, '10': 'passNo'},
    {
      '1': 'started_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
};

/// Descriptor for `Pass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passDescriptor = $convert.base64Decode(
    'CgRQYXNzEhcKB3Bhc3NfaWQYASABKANSBnBhc3NJZBIVCgZqb2JfaWQYAiABKANSBWpvYklkEh'
    'cKB3Bhc3Nfbm8YAyABKAVSBnBhc3NObxI5CgpzdGFydGVkX2F0GAQgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0EjUKCGVuZGVkX2F0GAUgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdA==');

@$core.Deprecated('Use jobSummaryDescriptor instead')
const JobSummary$json = {
  '1': 'JobSummary',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Job',
      '10': 'job'
    },
    {'1': 'worker_name', '3': 2, '4': 1, '5': 9, '10': 'workerName'},
    {
      '1': 'is_master',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isMaster',
      '17': true
    },
    {'1': 'equipment_names', '3': 4, '4': 3, '5': 9, '10': 'equipmentNames'},
    {'1': 'pass_count', '3': 5, '4': 1, '5': 5, '10': 'passCount'},
    {'1': 'attachment_count', '3': 6, '4': 1, '5': 5, '10': 'attachmentCount'},
    {'1': 'has_report', '3': 7, '4': 1, '5': 8, '10': 'hasReport'},
  ],
  '8': [
    {'1': '_is_master'},
  ],
};

/// Descriptor for `JobSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobSummaryDescriptor = $convert.base64Decode(
    'CgpKb2JTdW1tYXJ5EicKA2pvYhgBIAEoCzIVLm1lZGlhdGFnLndvcmsudjEuSm9iUgNqb2ISHw'
    'oLd29ya2VyX25hbWUYAiABKAlSCndvcmtlck5hbWUSIAoJaXNfbWFzdGVyGAMgASgISABSCGlz'
    'TWFzdGVyiAEBEicKD2VxdWlwbWVudF9uYW1lcxgEIAMoCVIOZXF1aXBtZW50TmFtZXMSHQoKcG'
    'Fzc19jb3VudBgFIAEoBVIJcGFzc0NvdW50EikKEGF0dGFjaG1lbnRfY291bnQYBiABKAVSD2F0'
    'dGFjaG1lbnRDb3VudBIdCgpoYXNfcmVwb3J0GAcgASgIUgloYXNSZXBvcnRCDAoKX2lzX21hc3'
    'Rlcg==');

@$core.Deprecated('Use listProjectsRequestDescriptor instead')
const ListProjectsRequest$json = {
  '1': 'ListProjectsRequest',
};

/// Descriptor for `ListProjectsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsRequestDescriptor =
    $convert.base64Decode('ChNMaXN0UHJvamVjdHNSZXF1ZXN0');

@$core.Deprecated('Use listProjectsResponseDescriptor instead')
const ListProjectsResponse$json = {
  '1': 'ListProjectsResponse',
  '2': [
    {
      '1': 'projects',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Project',
      '10': 'projects'
    },
  ],
};

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvamVjdHNSZXNwb25zZRI1Cghwcm9qZWN0cxgBIAMoCzIZLm1lZGlhdGFnLndvcm'
    'sudjEuUHJvamVjdFIIcHJvamVjdHM=');

@$core.Deprecated('Use createProjectRequestDescriptor instead')
const CreateProjectRequest$json = {
  '1': 'CreateProjectRequest',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `CreateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVQcm9qZWN0UmVxdWVzdBIzCgdwcm9qZWN0GAEgASgLMhkubWVkaWF0YWcud29yay'
    '52MS5Qcm9qZWN0Ugdwcm9qZWN0');

@$core.Deprecated('Use createProjectResponseDescriptor instead')
const CreateProjectResponse$json = {
  '1': 'CreateProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `CreateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQcm9qZWN0UmVzcG9uc2USMwoHcHJvamVjdBgBIAEoCzIZLm1lZGlhdGFnLndvcm'
    'sudjEuUHJvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use createWorkerRequestDescriptor instead')
const CreateWorkerRequest$json = {
  '1': 'CreateWorkerRequest',
  '2': [
    {
      '1': 'worker',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'worker'
    },
  ],
};

/// Descriptor for `CreateWorkerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWorkerRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVXb3JrZXJSZXF1ZXN0EjAKBndvcmtlchgBIAEoCzIYLm1lZGlhdGFnLndvcmsudj'
    'EuV29ya2VyUgZ3b3JrZXI=');

@$core.Deprecated('Use createWorkerResponseDescriptor instead')
const CreateWorkerResponse$json = {
  '1': 'CreateWorkerResponse',
  '2': [
    {
      '1': 'worker',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'worker'
    },
  ],
};

/// Descriptor for `CreateWorkerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWorkerResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVXb3JrZXJSZXNwb25zZRIwCgZ3b3JrZXIYASABKAsyGC5tZWRpYXRhZy53b3JrLn'
    'YxLldvcmtlclIGd29ya2Vy');

@$core.Deprecated('Use updateWorkerRequestDescriptor instead')
const UpdateWorkerRequest$json = {
  '1': 'UpdateWorkerRequest',
  '2': [
    {
      '1': 'worker',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'worker'
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

/// Descriptor for `UpdateWorkerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateWorkerRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVXb3JrZXJSZXF1ZXN0EjAKBndvcmtlchgBIAEoCzIYLm1lZGlhdGFnLndvcmsudj'
    'EuV29ya2VyUgZ3b3JrZXISOwoLdXBkYXRlX21hc2sYAiABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'RmllbGRNYXNrUgp1cGRhdGVNYXNr');

@$core.Deprecated('Use updateWorkerResponseDescriptor instead')
const UpdateWorkerResponse$json = {
  '1': 'UpdateWorkerResponse',
  '2': [
    {
      '1': 'worker',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'worker'
    },
  ],
};

/// Descriptor for `UpdateWorkerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateWorkerResponseDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVXb3JrZXJSZXNwb25zZRIwCgZ3b3JrZXIYASABKAsyGC5tZWRpYXRhZy53b3JrLn'
    'YxLldvcmtlclIGd29ya2Vy');

@$core.Deprecated('Use deleteWorkerRequestDescriptor instead')
const DeleteWorkerRequest$json = {
  '1': 'DeleteWorkerRequest',
  '2': [
    {'1': 'worker_id', '3': 1, '4': 1, '5': 3, '10': 'workerId'},
  ],
};

/// Descriptor for `DeleteWorkerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWorkerRequestDescriptor =
    $convert.base64Decode(
        'ChNEZWxldGVXb3JrZXJSZXF1ZXN0EhsKCXdvcmtlcl9pZBgBIAEoA1IId29ya2VySWQ=');

@$core.Deprecated('Use deleteWorkerResponseDescriptor instead')
const DeleteWorkerResponse$json = {
  '1': 'DeleteWorkerResponse',
};

/// Descriptor for `DeleteWorkerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWorkerResponseDescriptor =
    $convert.base64Decode('ChREZWxldGVXb3JrZXJSZXNwb25zZQ==');

@$core.Deprecated('Use createEquipmentRequestDescriptor instead')
const CreateEquipmentRequest$json = {
  '1': 'CreateEquipmentRequest',
  '2': [
    {
      '1': 'equipment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
  ],
};

/// Descriptor for `CreateEquipmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createEquipmentRequestDescriptor =
    $convert.base64Decode(
        'ChZDcmVhdGVFcXVpcG1lbnRSZXF1ZXN0EjkKCWVxdWlwbWVudBgBIAEoCzIbLm1lZGlhdGFnLn'
        'dvcmsudjEuRXF1aXBtZW50UgllcXVpcG1lbnQ=');

@$core.Deprecated('Use createEquipmentResponseDescriptor instead')
const CreateEquipmentResponse$json = {
  '1': 'CreateEquipmentResponse',
  '2': [
    {
      '1': 'equipment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
  ],
};

/// Descriptor for `CreateEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createEquipmentResponseDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVFcXVpcG1lbnRSZXNwb25zZRI5CgllcXVpcG1lbnQYASABKAsyGy5tZWRpYXRhZy'
        '53b3JrLnYxLkVxdWlwbWVudFIJZXF1aXBtZW50');

@$core.Deprecated('Use updateEquipmentRequestDescriptor instead')
const UpdateEquipmentRequest$json = {
  '1': 'UpdateEquipmentRequest',
  '2': [
    {
      '1': 'equipment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
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

/// Descriptor for `UpdateEquipmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateEquipmentRequestDescriptor = $convert.base64Decode(
    'ChZVcGRhdGVFcXVpcG1lbnRSZXF1ZXN0EjkKCWVxdWlwbWVudBgBIAEoCzIbLm1lZGlhdGFnLn'
    'dvcmsudjEuRXF1aXBtZW50UgllcXVpcG1lbnQSOwoLdXBkYXRlX21hc2sYAiABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuRmllbGRNYXNrUgp1cGRhdGVNYXNr');

@$core.Deprecated('Use updateEquipmentResponseDescriptor instead')
const UpdateEquipmentResponse$json = {
  '1': 'UpdateEquipmentResponse',
  '2': [
    {
      '1': 'equipment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
  ],
};

/// Descriptor for `UpdateEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateEquipmentResponseDescriptor =
    $convert.base64Decode(
        'ChdVcGRhdGVFcXVpcG1lbnRSZXNwb25zZRI5CgllcXVpcG1lbnQYASABKAsyGy5tZWRpYXRhZy'
        '53b3JrLnYxLkVxdWlwbWVudFIJZXF1aXBtZW50');

@$core.Deprecated('Use deleteEquipmentRequestDescriptor instead')
const DeleteEquipmentRequest$json = {
  '1': 'DeleteEquipmentRequest',
  '2': [
    {'1': 'equipment_id', '3': 1, '4': 1, '5': 3, '10': 'equipmentId'},
  ],
};

/// Descriptor for `DeleteEquipmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteEquipmentRequestDescriptor =
    $convert.base64Decode(
        'ChZEZWxldGVFcXVpcG1lbnRSZXF1ZXN0EiEKDGVxdWlwbWVudF9pZBgBIAEoA1ILZXF1aXBtZW'
        '50SWQ=');

@$core.Deprecated('Use deleteEquipmentResponseDescriptor instead')
const DeleteEquipmentResponse$json = {
  '1': 'DeleteEquipmentResponse',
};

/// Descriptor for `DeleteEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteEquipmentResponseDescriptor =
    $convert.base64Decode('ChdEZWxldGVFcXVpcG1lbnRSZXNwb25zZQ==');

@$core.Deprecated('Use updateProjectRequestDescriptor instead')
const UpdateProjectRequest$json = {
  '1': 'UpdateProjectRequest',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Project',
      '10': 'project'
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

/// Descriptor for `UpdateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9qZWN0UmVxdWVzdBIzCgdwcm9qZWN0GAEgASgLMhkubWVkaWF0YWcud29yay'
    '52MS5Qcm9qZWN0Ugdwcm9qZWN0EjsKC3VwZGF0ZV9tYXNrGAIgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLkZpZWxkTWFza1IKdXBkYXRlTWFzaw==');

@$core.Deprecated('Use updateProjectResponseDescriptor instead')
const UpdateProjectResponse$json = {
  '1': 'UpdateProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `UpdateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcm9qZWN0UmVzcG9uc2USMwoHcHJvamVjdBgBIAEoCzIZLm1lZGlhdGFnLndvcm'
    'sudjEuUHJvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use deleteProjectRequestDescriptor instead')
const DeleteProjectRequest$json = {
  '1': 'DeleteProjectRequest',
  '2': [
    {'1': 'project_no', '3': 1, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 3, '10': 'projectId'},
  ],
};

/// Descriptor for `DeleteProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVQcm9qZWN0UmVxdWVzdBIdCgpwcm9qZWN0X25vGAEgASgJUglwcm9qZWN0Tm8SHQ'
    'oKcHJvamVjdF9pZBgCIAEoA1IJcHJvamVjdElk');

@$core.Deprecated('Use deleteProjectResponseDescriptor instead')
const DeleteProjectResponse$json = {
  '1': 'DeleteProjectResponse',
};

/// Descriptor for `DeleteProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectResponseDescriptor =
    $convert.base64Decode('ChVEZWxldGVQcm9qZWN0UmVzcG9uc2U=');

@$core.Deprecated('Use createJobRequestDescriptor instead')
const CreateJobRequest$json = {
  '1': 'CreateJobRequest',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Job',
      '10': 'job'
    },
    {
      '1': 'passes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'passes'
    },
  ],
};

/// Descriptor for `CreateJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createJobRequestDescriptor = $convert.base64Decode(
    'ChBDcmVhdGVKb2JSZXF1ZXN0EicKA2pvYhgBIAEoCzIVLm1lZGlhdGFnLndvcmsudjEuSm9iUg'
    'Nqb2ISLgoGcGFzc2VzGAIgAygLMhYubWVkaWF0YWcud29yay52MS5QYXNzUgZwYXNzZXM=');

@$core.Deprecated('Use createJobResponseDescriptor instead')
const CreateJobResponse$json = {
  '1': 'CreateJobResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Job',
      '10': 'job'
    },
    {
      '1': 'passes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'passes'
    },
  ],
};

/// Descriptor for `CreateJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createJobResponseDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVKb2JSZXNwb25zZRInCgNqb2IYASABKAsyFS5tZWRpYXRhZy53b3JrLnYxLkpvYl'
    'IDam9iEi4KBnBhc3NlcxgCIAMoCzIWLm1lZGlhdGFnLndvcmsudjEuUGFzc1IGcGFzc2Vz');

@$core.Deprecated('Use updateJobRequestDescriptor instead')
const UpdateJobRequest$json = {
  '1': 'UpdateJobRequest',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Job',
      '10': 'job'
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

/// Descriptor for `UpdateJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateJobRequestDescriptor = $convert.base64Decode(
    'ChBVcGRhdGVKb2JSZXF1ZXN0EicKA2pvYhgBIAEoCzIVLm1lZGlhdGFnLndvcmsudjEuSm9iUg'
    'Nqb2ISOwoLdXBkYXRlX21hc2sYAiABKAsyGi5nb29nbGUucHJvdG9idWYuRmllbGRNYXNrUgp1'
    'cGRhdGVNYXNr');

@$core.Deprecated('Use updateJobResponseDescriptor instead')
const UpdateJobResponse$json = {
  '1': 'UpdateJobResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Job',
      '10': 'job'
    },
  ],
};

/// Descriptor for `UpdateJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateJobResponseDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVKb2JSZXNwb25zZRInCgNqb2IYASABKAsyFS5tZWRpYXRhZy53b3JrLnYxLkpvYl'
    'IDam9i');

@$core.Deprecated('Use deleteJobRequestDescriptor instead')
const DeleteJobRequest$json = {
  '1': 'DeleteJobRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 3, '10': 'jobId'},
  ],
};

/// Descriptor for `DeleteJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteJobRequestDescriptor = $convert
    .base64Decode('ChBEZWxldGVKb2JSZXF1ZXN0EhUKBmpvYl9pZBgBIAEoA1IFam9iSWQ=');

@$core.Deprecated('Use deleteJobResponseDescriptor instead')
const DeleteJobResponse$json = {
  '1': 'DeleteJobResponse',
};

/// Descriptor for `DeleteJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteJobResponseDescriptor =
    $convert.base64Decode('ChFEZWxldGVKb2JSZXNwb25zZQ==');

@$core.Deprecated('Use createPassRequestDescriptor instead')
const CreatePassRequest$json = {
  '1': 'CreatePassRequest',
  '2': [
    {
      '1': 'pass',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'pass'
    },
  ],
};

/// Descriptor for `CreatePassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPassRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVQYXNzUmVxdWVzdBIqCgRwYXNzGAEgASgLMhYubWVkaWF0YWcud29yay52MS5QYX'
    'NzUgRwYXNz');

@$core.Deprecated('Use createPassResponseDescriptor instead')
const CreatePassResponse$json = {
  '1': 'CreatePassResponse',
  '2': [
    {
      '1': 'pass',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'pass'
    },
  ],
};

/// Descriptor for `CreatePassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPassResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVQYXNzUmVzcG9uc2USKgoEcGFzcxgBIAEoCzIWLm1lZGlhdGFnLndvcmsudjEuUG'
    'Fzc1IEcGFzcw==');

@$core.Deprecated('Use updatePassRequestDescriptor instead')
const UpdatePassRequest$json = {
  '1': 'UpdatePassRequest',
  '2': [
    {
      '1': 'pass',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'pass'
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

/// Descriptor for `UpdatePassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePassRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVQYXNzUmVxdWVzdBIqCgRwYXNzGAEgASgLMhYubWVkaWF0YWcud29yay52MS5QYX'
    'NzUgRwYXNzEjsKC3VwZGF0ZV9tYXNrGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLkZpZWxkTWFz'
    'a1IKdXBkYXRlTWFzaw==');

@$core.Deprecated('Use updatePassResponseDescriptor instead')
const UpdatePassResponse$json = {
  '1': 'UpdatePassResponse',
  '2': [
    {
      '1': 'pass',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'pass'
    },
  ],
};

/// Descriptor for `UpdatePassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePassResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVQYXNzUmVzcG9uc2USKgoEcGFzcxgBIAEoCzIWLm1lZGlhdGFnLndvcmsudjEuUG'
    'Fzc1IEcGFzcw==');

@$core.Deprecated('Use deletePassRequestDescriptor instead')
const DeletePassRequest$json = {
  '1': 'DeletePassRequest',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 3, '10': 'passId'},
  ],
};

/// Descriptor for `DeletePassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePassRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVQYXNzUmVxdWVzdBIXCgdwYXNzX2lkGAEgASgDUgZwYXNzSWQ=');

@$core.Deprecated('Use deletePassResponseDescriptor instead')
const DeletePassResponse$json = {
  '1': 'DeletePassResponse',
};

/// Descriptor for `DeletePassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePassResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVQYXNzUmVzcG9uc2U=');

@$core.Deprecated('Use listJobFiltersRequestDescriptor instead')
const ListJobFiltersRequest$json = {
  '1': 'ListJobFiltersRequest',
};

/// Descriptor for `ListJobFiltersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobFiltersRequestDescriptor =
    $convert.base64Decode('ChVMaXN0Sm9iRmlsdGVyc1JlcXVlc3Q=');

@$core.Deprecated('Use listJobFiltersResponseDescriptor instead')
const ListJobFiltersResponse$json = {
  '1': 'ListJobFiltersResponse',
  '2': [
    {
      '1': 'projects',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ProjectFilter',
      '10': 'projects'
    },
    {
      '1': 'workers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'workers'
    },
    {
      '1': 'equipment',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
  ],
};

/// Descriptor for `ListJobFiltersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobFiltersResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0Sm9iRmlsdGVyc1Jlc3BvbnNlEjsKCHByb2plY3RzGAEgAygLMh8ubWVkaWF0YWcud2'
    '9yay52MS5Qcm9qZWN0RmlsdGVyUghwcm9qZWN0cxIyCgd3b3JrZXJzGAIgAygLMhgubWVkaWF0'
    'YWcud29yay52MS5Xb3JrZXJSB3dvcmtlcnMSOQoJZXF1aXBtZW50GAMgAygLMhsubWVkaWF0YW'
    'cud29yay52MS5FcXVpcG1lbnRSCWVxdWlwbWVudA==');

@$core.Deprecated('Use projectFilterDescriptor instead')
const ProjectFilter$json = {
  '1': 'ProjectFilter',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Project',
      '10': 'project'
    },
    {
      '1': 'units',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ProjectUnit',
      '10': 'units'
    },
  ],
};

/// Descriptor for `ProjectFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectFilterDescriptor = $convert.base64Decode(
    'Cg1Qcm9qZWN0RmlsdGVyEjMKB3Byb2plY3QYASABKAsyGS5tZWRpYXRhZy53b3JrLnYxLlByb2'
    'plY3RSB3Byb2plY3QSMwoFdW5pdHMYAiADKAsyHS5tZWRpYXRhZy53b3JrLnYxLlByb2plY3RV'
    'bml0UgV1bml0cw==');

@$core.Deprecated('Use projectUnitDescriptor instead')
const ProjectUnit$json = {
  '1': 'ProjectUnit',
  '2': [
    {'1': 'unit_no', '3': 1, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'item_codes', '3': 2, '4': 3, '5': 9, '10': 'itemCodes'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ProjectItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ProjectUnit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectUnitDescriptor = $convert.base64Decode(
    'CgtQcm9qZWN0VW5pdBIXCgd1bml0X25vGAEgASgJUgZ1bml0Tm8SHQoKaXRlbV9jb2RlcxgCIA'
    'MoCVIJaXRlbUNvZGVzEjMKBWl0ZW1zGAMgAygLMh0ubWVkaWF0YWcud29yay52MS5Qcm9qZWN0'
    'SXRlbVIFaXRlbXM=');

@$core.Deprecated('Use projectItemDescriptor instead')
const ProjectItem$json = {
  '1': 'ProjectItem',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'joint_nos', '3': 2, '4': 3, '5': 9, '10': 'jointNos'},
    {
      '1': 'joints',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ProjectJoint',
      '10': 'joints'
    },
    {'1': 'item_name', '3': 4, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'project_item_id', '3': 5, '4': 1, '5': 3, '10': 'projectItemId'},
  ],
};

/// Descriptor for `ProjectItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectItemDescriptor = $convert.base64Decode(
    'CgtQcm9qZWN0SXRlbRIbCglpdGVtX2NvZGUYASABKAlSCGl0ZW1Db2RlEhsKCWpvaW50X25vcx'
    'gCIAMoCVIIam9pbnROb3MSNgoGam9pbnRzGAMgAygLMh4ubWVkaWF0YWcud29yay52MS5Qcm9q'
    'ZWN0Sm9pbnRSBmpvaW50cxIbCglpdGVtX25hbWUYBCABKAlSCGl0ZW1OYW1lEiYKD3Byb2plY3'
    'RfaXRlbV9pZBgFIAEoA1INcHJvamVjdEl0ZW1JZA==');

@$core.Deprecated('Use projectJointDescriptor instead')
const ProjectJoint$json = {
  '1': 'ProjectJoint',
  '2': [
    {'1': 'joint_no', '3': 1, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'pass_nos', '3': 2, '4': 3, '5': 5, '10': 'passNos'},
  ],
};

/// Descriptor for `ProjectJoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectJointDescriptor = $convert.base64Decode(
    'CgxQcm9qZWN0Sm9pbnQSGQoIam9pbnRfbm8YASABKAlSB2pvaW50Tm8SGQoIcGFzc19ub3MYAi'
    'ADKAVSB3Bhc3NOb3M=');

@$core.Deprecated('Use listWorkersRequestDescriptor instead')
const ListWorkersRequest$json = {
  '1': 'ListWorkersRequest',
};

/// Descriptor for `ListWorkersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkersRequestDescriptor =
    $convert.base64Decode('ChJMaXN0V29ya2Vyc1JlcXVlc3Q=');

@$core.Deprecated('Use listWorkersResponseDescriptor instead')
const ListWorkersResponse$json = {
  '1': 'ListWorkersResponse',
  '2': [
    {
      '1': 'workers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'workers'
    },
  ],
};

/// Descriptor for `ListWorkersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkersResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0V29ya2Vyc1Jlc3BvbnNlEjIKB3dvcmtlcnMYASADKAsyGC5tZWRpYXRhZy53b3JrLn'
    'YxLldvcmtlclIHd29ya2Vycw==');

@$core.Deprecated('Use listEquipmentRequestDescriptor instead')
const ListEquipmentRequest$json = {
  '1': 'ListEquipmentRequest',
};

/// Descriptor for `ListEquipmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentRequestDescriptor =
    $convert.base64Decode('ChRMaXN0RXF1aXBtZW50UmVxdWVzdA==');

@$core.Deprecated('Use listEquipmentResponseDescriptor instead')
const ListEquipmentResponse$json = {
  '1': 'ListEquipmentResponse',
  '2': [
    {
      '1': 'equipment',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
  ],
};

/// Descriptor for `ListEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RXF1aXBtZW50UmVzcG9uc2USOQoJZXF1aXBtZW50GAEgAygLMhsubWVkaWF0YWcud2'
    '9yay52MS5FcXVpcG1lbnRSCWVxdWlwbWVudA==');

@$core.Deprecated('Use listJobsRequestDescriptor instead')
const ListJobsRequest$json = {
  '1': 'ListJobsRequest',
  '2': [
    {'1': 'project_no', '3': 1, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'project_id', '3': 14, '4': 1, '5': 3, '10': 'projectId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'unit_no', '3': 11, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'joint_no', '3': 12, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'pass_no', '3': 13, '4': 1, '5': 5, '10': 'passNo'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 3, '10': 'workerId'},
    {'1': 'master_only', '3': 5, '4': 1, '5': 8, '10': 'masterOnly'},
    {'1': 'equipment_id', '3': 6, '4': 1, '5': 3, '10': 'equipmentId'},
    {
      '1': 'started_from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedFrom'
    },
    {
      '1': 'started_to',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedTo'
    },
    {'1': 'page_size', '3': 9, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 10, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListJobsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0Sm9ic1JlcXVlc3QSHQoKcHJvamVjdF9ubxgBIAEoCVIJcHJvamVjdE5vEh0KCnByb2'
    'plY3RfaWQYDiABKANSCXByb2plY3RJZBIdCgpjb21tb25fa2V5GAIgASgJUgljb21tb25LZXkS'
    'GwoJaXRlbV9jb2RlGAMgASgJUghpdGVtQ29kZRIXCgd1bml0X25vGAsgASgJUgZ1bml0Tm8SGQ'
    'oIam9pbnRfbm8YDCABKAlSB2pvaW50Tm8SFwoHcGFzc19ubxgNIAEoBVIGcGFzc05vEhsKCXdv'
    'cmtlcl9pZBgEIAEoA1IId29ya2VySWQSHwoLbWFzdGVyX29ubHkYBSABKAhSCm1hc3Rlck9ubH'
    'kSIQoMZXF1aXBtZW50X2lkGAYgASgDUgtlcXVpcG1lbnRJZBI9CgxzdGFydGVkX2Zyb20YByAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtzdGFydGVkRnJvbRI5CgpzdGFydGVkX3'
    'RvGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZFRvEhsKCXBhZ2Vf'
    'c2l6ZRgJIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgKIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use listJobsResponseDescriptor instead')
const ListJobsResponse$json = {
  '1': 'ListJobsResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.JobSummary',
      '10': 'jobs'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListJobsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0Sm9ic1Jlc3BvbnNlEjAKBGpvYnMYASADKAsyHC5tZWRpYXRhZy53b3JrLnYxLkpvYl'
    'N1bW1hcnlSBGpvYnMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFnZVRva2VuEh8K'
    'C3RvdGFsX2NvdW50GAMgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use getJobRequestDescriptor instead')
const GetJobRequest$json = {
  '1': 'GetJobRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 3, '10': 'jobId'},
  ],
};

/// Descriptor for `GetJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobRequestDescriptor = $convert
    .base64Decode('Cg1HZXRKb2JSZXF1ZXN0EhUKBmpvYl9pZBgBIAEoA1IFam9iSWQ=');

@$core.Deprecated('Use getJobResponseDescriptor instead')
const GetJobResponse$json = {
  '1': 'GetJobResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Job',
      '10': 'job'
    },
    {
      '1': 'passes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'passes'
    },
    {
      '1': 'worker',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'worker'
    },
    {
      '1': 'equipment',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
  ],
};

/// Descriptor for `GetJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRKb2JSZXNwb25zZRInCgNqb2IYASABKAsyFS5tZWRpYXRhZy53b3JrLnYxLkpvYlIDam'
    '9iEi4KBnBhc3NlcxgCIAMoCzIWLm1lZGlhdGFnLndvcmsudjEuUGFzc1IGcGFzc2VzEjAKBndv'
    'cmtlchgDIAEoCzIYLm1lZGlhdGFnLndvcmsudjEuV29ya2VyUgZ3b3JrZXISOQoJZXF1aXBtZW'
    '50GAQgAygLMhsubWVkaWF0YWcud29yay52MS5FcXVpcG1lbnRSCWVxdWlwbWVudA==');

@$core.Deprecated('Use collectionPathDescriptor instead')
const CollectionPath$json = {
  '1': 'CollectionPath',
  '2': [
    {
      '1': 'view',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.CollectionView',
      '10': 'view'
    },
    {
      '1': 'level',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.CollectionLevel',
      '10': 'level'
    },
    {'1': 'equipment_id', '3': 3, '4': 1, '5': 3, '10': 'equipmentId'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 3, '10': 'workerId'},
    {'1': 'project_no', '3': 5, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'job_id', '3': 6, '4': 1, '5': 3, '10': 'jobId'},
    {'1': 'pass_id', '3': 7, '4': 1, '5': 3, '10': 'passId'},
    {'1': 'common_key', '3': 8, '4': 1, '5': 9, '10': 'commonKey'},
  ],
};

/// Descriptor for `CollectionPath`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionPathDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0aW9uUGF0aBI0CgR2aWV3GAEgASgOMiAubWVkaWF0YWcud29yay52MS5Db2xsZW'
    'N0aW9uVmlld1IEdmlldxI3CgVsZXZlbBgCIAEoDjIhLm1lZGlhdGFnLndvcmsudjEuQ29sbGVj'
    'dGlvbkxldmVsUgVsZXZlbBIhCgxlcXVpcG1lbnRfaWQYAyABKANSC2VxdWlwbWVudElkEhsKCX'
    'dvcmtlcl9pZBgEIAEoA1IId29ya2VySWQSHQoKcHJvamVjdF9ubxgFIAEoCVIJcHJvamVjdE5v'
    'EhUKBmpvYl9pZBgGIAEoA1IFam9iSWQSFwoHcGFzc19pZBgHIAEoA1IGcGFzc0lkEh0KCmNvbW'
    '1vbl9rZXkYCCABKAlSCWNvbW1vbktleQ==');

@$core.Deprecated('Use listCollectionNodesRequestDescriptor instead')
const ListCollectionNodesRequest$json = {
  '1': 'ListCollectionNodesRequest',
  '2': [
    {
      '1': 'parent',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.CollectionPath',
      '10': 'parent'
    },
    {
      '1': 'start_offset_ns',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'startOffsetNs',
      '17': true
    },
    {
      '1': 'end_offset_ns',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'endOffsetNs',
      '17': true
    },
    {
      '1': 'basis',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.TimeBasis',
      '10': 'basis'
    },
  ],
  '8': [
    {'1': '_start_offset_ns'},
    {'1': '_end_offset_ns'},
  ],
};

/// Descriptor for `ListCollectionNodesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionNodesRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0Q29sbGVjdGlvbk5vZGVzUmVxdWVzdBI4CgZwYXJlbnQYASABKAsyIC5tZWRpYXRhZy'
    '53b3JrLnYxLkNvbGxlY3Rpb25QYXRoUgZwYXJlbnQSKwoPc3RhcnRfb2Zmc2V0X25zGAIgASgD'
    'SABSDXN0YXJ0T2Zmc2V0TnOIAQESJwoNZW5kX29mZnNldF9ucxgDIAEoA0gBUgtlbmRPZmZzZX'
    'ROc4gBARIxCgViYXNpcxgEIAEoDjIbLm1lZGlhdGFnLndvcmsudjEuVGltZUJhc2lzUgViYXNp'
    'c0ISChBfc3RhcnRfb2Zmc2V0X25zQhAKDl9lbmRfb2Zmc2V0X25z');

@$core.Deprecated('Use listCollectionNodesResponseDescriptor instead')
const ListCollectionNodesResponse$json = {
  '1': 'ListCollectionNodesResponse',
  '2': [
    {
      '1': 'nodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.CollectionNode',
      '10': 'nodes'
    },
  ],
};

/// Descriptor for `ListCollectionNodesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionNodesResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Q29sbGVjdGlvbk5vZGVzUmVzcG9uc2USNgoFbm9kZXMYASADKAsyIC5tZWRpYXRhZy'
        '53b3JrLnYxLkNvbGxlY3Rpb25Ob2RlUgVub2Rlcw==');

@$core.Deprecated('Use collectionNodeDescriptor instead')
const CollectionNode$json = {
  '1': 'CollectionNode',
  '2': [
    {
      '1': 'path',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.CollectionPath',
      '10': 'path'
    },
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'has_children', '3': 3, '4': 1, '5': 8, '10': 'hasChildren'},
    {
      '1': 'summary',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.CollectionSummary',
      '10': 'summary'
    },
    {
      '1': 'asset',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.mediatag.asset.v1.Asset',
      '10': 'asset'
    },
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
};

/// Descriptor for `CollectionNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionNodeDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0aW9uTm9kZRI0CgRwYXRoGAEgASgLMiAubWVkaWF0YWcud29yay52MS5Db2xsZW'
    'N0aW9uUGF0aFIEcGF0aBIUCgVsYWJlbBgCIAEoCVIFbGFiZWwSIQoMaGFzX2NoaWxkcmVuGAMg'
    'ASgIUgtoYXNDaGlsZHJlbhI9CgdzdW1tYXJ5GAQgASgLMiMubWVkaWF0YWcud29yay52MS5Db2'
    'xsZWN0aW9uU3VtbWFyeVIHc3VtbWFyeRIuCgVhc3NldBgFIAEoCzIYLm1lZGlhdGFnLmFzc2V0'
    'LnYxLkFzc2V0UgVhc3NldBI5CgpzdGFydGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIJc3RhcnRlZEF0EjUKCGVuZGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIHZW5kZWRBdA==');

@$core.Deprecated('Use collectionSummaryDescriptor instead')
const CollectionSummary$json = {
  '1': 'CollectionSummary',
  '2': [
    {'1': 'asset_count', '3': 1, '4': 1, '5': 3, '10': 'assetCount'},
    {'1': 'total_size_bytes', '3': 2, '4': 1, '5': 3, '10': 'totalSizeBytes'},
    {
      '1': 'first_recorded_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'firstRecordedAt'
    },
    {
      '1': 'last_recorded_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastRecordedAt'
    },
    {
      '1': 'last_collected_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastCollectedAt'
    },
    {'1': 'job_count', '3': 6, '4': 1, '5': 3, '10': 'jobCount'},
    {
      '1': 'work_duration_seconds',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'workDurationSeconds'
    },
  ],
};

/// Descriptor for `CollectionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionSummaryDescriptor = $convert.base64Decode(
    'ChFDb2xsZWN0aW9uU3VtbWFyeRIfCgthc3NldF9jb3VudBgBIAEoA1IKYXNzZXRDb3VudBIoCh'
    'B0b3RhbF9zaXplX2J5dGVzGAIgASgDUg50b3RhbFNpemVCeXRlcxJGChFmaXJzdF9yZWNvcmRl'
    'ZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSD2ZpcnN0UmVjb3JkZWRBdB'
    'JEChBsYXN0X3JlY29yZGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIO'
    'bGFzdFJlY29yZGVkQXQSRgoRbGFzdF9jb2xsZWN0ZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUg9sYXN0Q29sbGVjdGVkQXQSGwoJam9iX2NvdW50GAYgASgDUghqb2JD'
    'b3VudBIyChV3b3JrX2R1cmF0aW9uX3NlY29uZHMYByABKANSE3dvcmtEdXJhdGlvblNlY29uZH'
    'M=');

@$core.Deprecated('Use getPassWaveformRequestDescriptor instead')
const GetPassWaveformRequest$json = {
  '1': 'GetPassWaveformRequest',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 3, '10': 'passId'},
    {'1': 'channels', '3': 2, '4': 3, '5': 9, '10': 'channels'},
    {'1': 'max_points', '3': 3, '4': 1, '5': 5, '10': 'maxPoints'},
    {
      '1': 'comparison_pass_id',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'comparisonPassId'
    },
    {
      '1': 'normalize',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.WaveformNormalize',
      '10': 'normalize'
    },
  ],
};

/// Descriptor for `GetPassWaveformRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPassWaveformRequestDescriptor = $convert.base64Decode(
    'ChZHZXRQYXNzV2F2ZWZvcm1SZXF1ZXN0EhcKB3Bhc3NfaWQYASABKANSBnBhc3NJZBIaCghjaG'
    'FubmVscxgCIAMoCVIIY2hhbm5lbHMSHQoKbWF4X3BvaW50cxgDIAEoBVIJbWF4UG9pbnRzEiwK'
    'EmNvbXBhcmlzb25fcGFzc19pZBgEIAEoA1IQY29tcGFyaXNvblBhc3NJZBJBCglub3JtYWxpem'
    'UYBSABKA4yIy5tZWRpYXRhZy53b3JrLnYxLldhdmVmb3JtTm9ybWFsaXplUglub3JtYWxpemU=');

@$core.Deprecated('Use getPassWaveformResponseDescriptor instead')
const GetPassWaveformResponse$json = {
  '1': 'GetPassWaveformResponse',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.PassWaveform',
      '10': 'target'
    },
    {
      '1': 'comparison',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.PassWaveform',
      '10': 'comparison'
    },
  ],
};

/// Descriptor for `GetPassWaveformResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPassWaveformResponseDescriptor = $convert.base64Decode(
    'ChdHZXRQYXNzV2F2ZWZvcm1SZXNwb25zZRI2CgZ0YXJnZXQYASABKAsyHi5tZWRpYXRhZy53b3'
    'JrLnYxLlBhc3NXYXZlZm9ybVIGdGFyZ2V0Ej4KCmNvbXBhcmlzb24YAiABKAsyHi5tZWRpYXRh'
    'Zy53b3JrLnYxLlBhc3NXYXZlZm9ybVIKY29tcGFyaXNvbg==');

@$core.Deprecated('Use passWaveformDescriptor instead')
const PassWaveform$json = {
  '1': 'PassWaveform',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 3, '10': 'jobId'},
    {'1': 'pass_id', '3': 2, '4': 1, '5': 3, '10': 'passId'},
    {'1': 'pass_no', '3': 3, '4': 1, '5': 5, '10': 'passNo'},
    {'1': 'worker_name', '3': 4, '4': 1, '5': 9, '10': 'workerName'},
    {
      '1': 'is_master',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isMaster',
      '17': true
    },
    {
      '1': 'series',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.WaveformSeries',
      '10': 'series'
    },
  ],
  '8': [
    {'1': '_is_master'},
  ],
};

/// Descriptor for `PassWaveform`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passWaveformDescriptor = $convert.base64Decode(
    'CgxQYXNzV2F2ZWZvcm0SFQoGam9iX2lkGAEgASgDUgVqb2JJZBIXCgdwYXNzX2lkGAIgASgDUg'
    'ZwYXNzSWQSFwoHcGFzc19ubxgDIAEoBVIGcGFzc05vEh8KC3dvcmtlcl9uYW1lGAQgASgJUgp3'
    'b3JrZXJOYW1lEiAKCWlzX21hc3RlchgFIAEoCEgAUghpc01hc3RlcogBARI4CgZzZXJpZXMYBi'
    'ADKAsyIC5tZWRpYXRhZy53b3JrLnYxLldhdmVmb3JtU2VyaWVzUgZzZXJpZXNCDAoKX2lzX21h'
    'c3Rlcg==');

@$core.Deprecated('Use waveformSeriesDescriptor instead')
const WaveformSeries$json = {
  '1': 'WaveformSeries',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 3, '10': 'assetId'},
    {'1': 'equipment_id', '3': 2, '4': 1, '5': 3, '10': 'equipmentId'},
    {'1': 't_offset_ns', '3': 3, '4': 3, '5': 3, '10': 'tOffsetNs'},
    {
      '1': 'channels',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.WaveformChannel',
      '10': 'channels'
    },
  ],
};

/// Descriptor for `WaveformSeries`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waveformSeriesDescriptor = $convert.base64Decode(
    'Cg5XYXZlZm9ybVNlcmllcxIZCghhc3NldF9pZBgBIAEoA1IHYXNzZXRJZBIhCgxlcXVpcG1lbn'
    'RfaWQYAiABKANSC2VxdWlwbWVudElkEh4KC3Rfb2Zmc2V0X25zGAMgAygDUgl0T2Zmc2V0TnMS'
    'PQoIY2hhbm5lbHMYBCADKAsyIS5tZWRpYXRhZy53b3JrLnYxLldhdmVmb3JtQ2hhbm5lbFIIY2'
    'hhbm5lbHM=');

@$core.Deprecated('Use waveformChannelDescriptor instead')
const WaveformChannel$json = {
  '1': 'WaveformChannel',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'unit', '3': 2, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'values', '3': 3, '4': 3, '5': 1, '10': 'values'},
  ],
};

/// Descriptor for `WaveformChannel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waveformChannelDescriptor = $convert.base64Decode(
    'Cg9XYXZlZm9ybUNoYW5uZWwSEgoEbmFtZRgBIAEoCVIEbmFtZRISCgR1bml0GAIgASgJUgR1bm'
    'l0EhYKBnZhbHVlcxgDIAMoAVIGdmFsdWVz');

const $core.Map<$core.String, $core.dynamic> WorkServiceBase$json = {
  '1': 'WorkService',
  '2': [
    {
      '1': 'ListProjects',
      '2': '.mediatag.work.v1.ListProjectsRequest',
      '3': '.mediatag.work.v1.ListProjectsResponse'
    },
    {
      '1': 'CreateProject',
      '2': '.mediatag.work.v1.CreateProjectRequest',
      '3': '.mediatag.work.v1.CreateProjectResponse'
    },
    {
      '1': 'ListWorkers',
      '2': '.mediatag.work.v1.ListWorkersRequest',
      '3': '.mediatag.work.v1.ListWorkersResponse'
    },
    {
      '1': 'CreateWorker',
      '2': '.mediatag.work.v1.CreateWorkerRequest',
      '3': '.mediatag.work.v1.CreateWorkerResponse'
    },
    {
      '1': 'UpdateWorker',
      '2': '.mediatag.work.v1.UpdateWorkerRequest',
      '3': '.mediatag.work.v1.UpdateWorkerResponse'
    },
    {
      '1': 'DeleteWorker',
      '2': '.mediatag.work.v1.DeleteWorkerRequest',
      '3': '.mediatag.work.v1.DeleteWorkerResponse'
    },
    {
      '1': 'ListEquipment',
      '2': '.mediatag.work.v1.ListEquipmentRequest',
      '3': '.mediatag.work.v1.ListEquipmentResponse'
    },
    {
      '1': 'CreateEquipment',
      '2': '.mediatag.work.v1.CreateEquipmentRequest',
      '3': '.mediatag.work.v1.CreateEquipmentResponse'
    },
    {
      '1': 'UpdateEquipment',
      '2': '.mediatag.work.v1.UpdateEquipmentRequest',
      '3': '.mediatag.work.v1.UpdateEquipmentResponse'
    },
    {
      '1': 'DeleteEquipment',
      '2': '.mediatag.work.v1.DeleteEquipmentRequest',
      '3': '.mediatag.work.v1.DeleteEquipmentResponse'
    },
    {
      '1': 'CreateProjectItems',
      '2': '.mediatag.work.v1.CreateProjectItemsRequest',
      '3': '.mediatag.work.v1.CreateProjectItemsResponse'
    },
    {
      '1': 'UpdateProjectItem',
      '2': '.mediatag.work.v1.UpdateProjectItemRequest',
      '3': '.mediatag.work.v1.UpdateProjectItemResponse'
    },
    {
      '1': 'ListItems',
      '2': '.mediatag.work.v1.ListItemsRequest',
      '3': '.mediatag.work.v1.ListItemsResponse'
    },
    {
      '1': 'ListJobFilters',
      '2': '.mediatag.work.v1.ListJobFiltersRequest',
      '3': '.mediatag.work.v1.ListJobFiltersResponse'
    },
    {
      '1': 'ListJobs',
      '2': '.mediatag.work.v1.ListJobsRequest',
      '3': '.mediatag.work.v1.ListJobsResponse'
    },
    {
      '1': 'UpdateProject',
      '2': '.mediatag.work.v1.UpdateProjectRequest',
      '3': '.mediatag.work.v1.UpdateProjectResponse'
    },
    {
      '1': 'DeleteProject',
      '2': '.mediatag.work.v1.DeleteProjectRequest',
      '3': '.mediatag.work.v1.DeleteProjectResponse'
    },
    {
      '1': 'CreateJob',
      '2': '.mediatag.work.v1.CreateJobRequest',
      '3': '.mediatag.work.v1.CreateJobResponse'
    },
    {
      '1': 'UpdateJob',
      '2': '.mediatag.work.v1.UpdateJobRequest',
      '3': '.mediatag.work.v1.UpdateJobResponse'
    },
    {
      '1': 'DeleteJob',
      '2': '.mediatag.work.v1.DeleteJobRequest',
      '3': '.mediatag.work.v1.DeleteJobResponse'
    },
    {
      '1': 'CreatePass',
      '2': '.mediatag.work.v1.CreatePassRequest',
      '3': '.mediatag.work.v1.CreatePassResponse'
    },
    {
      '1': 'UpdatePass',
      '2': '.mediatag.work.v1.UpdatePassRequest',
      '3': '.mediatag.work.v1.UpdatePassResponse'
    },
    {
      '1': 'DeletePass',
      '2': '.mediatag.work.v1.DeletePassRequest',
      '3': '.mediatag.work.v1.DeletePassResponse'
    },
    {
      '1': 'GetJob',
      '2': '.mediatag.work.v1.GetJobRequest',
      '3': '.mediatag.work.v1.GetJobResponse'
    },
    {
      '1': 'ListCollectionNodes',
      '2': '.mediatag.work.v1.ListCollectionNodesRequest',
      '3': '.mediatag.work.v1.ListCollectionNodesResponse'
    },
    {
      '1': 'GetPassWaveform',
      '2': '.mediatag.work.v1.GetPassWaveformRequest',
      '3': '.mediatag.work.v1.GetPassWaveformResponse'
    },
  ],
};

@$core.Deprecated('Use workServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    WorkServiceBase$messageJson = {
  '.mediatag.work.v1.ListProjectsRequest': ListProjectsRequest$json,
  '.mediatag.work.v1.ListProjectsResponse': ListProjectsResponse$json,
  '.mediatag.work.v1.Project': Project$json,
  '.mediatag.work.v1.CreateProjectRequest': CreateProjectRequest$json,
  '.mediatag.work.v1.CreateProjectResponse': CreateProjectResponse$json,
  '.mediatag.work.v1.ListWorkersRequest': ListWorkersRequest$json,
  '.mediatag.work.v1.ListWorkersResponse': ListWorkersResponse$json,
  '.mediatag.work.v1.Worker': Worker$json,
  '.mediatag.work.v1.CreateWorkerRequest': CreateWorkerRequest$json,
  '.mediatag.work.v1.CreateWorkerResponse': CreateWorkerResponse$json,
  '.mediatag.work.v1.UpdateWorkerRequest': UpdateWorkerRequest$json,
  '.google.protobuf.FieldMask': $1.FieldMask$json,
  '.mediatag.work.v1.UpdateWorkerResponse': UpdateWorkerResponse$json,
  '.mediatag.work.v1.DeleteWorkerRequest': DeleteWorkerRequest$json,
  '.mediatag.work.v1.DeleteWorkerResponse': DeleteWorkerResponse$json,
  '.mediatag.work.v1.ListEquipmentRequest': ListEquipmentRequest$json,
  '.mediatag.work.v1.ListEquipmentResponse': ListEquipmentResponse$json,
  '.mediatag.work.v1.Equipment': Equipment$json,
  '.mediatag.work.v1.CreateEquipmentRequest': CreateEquipmentRequest$json,
  '.mediatag.work.v1.CreateEquipmentResponse': CreateEquipmentResponse$json,
  '.mediatag.work.v1.UpdateEquipmentRequest': UpdateEquipmentRequest$json,
  '.mediatag.work.v1.UpdateEquipmentResponse': UpdateEquipmentResponse$json,
  '.mediatag.work.v1.DeleteEquipmentRequest': DeleteEquipmentRequest$json,
  '.mediatag.work.v1.DeleteEquipmentResponse': DeleteEquipmentResponse$json,
  '.mediatag.work.v1.CreateProjectItemsRequest': CreateProjectItemsRequest$json,
  '.mediatag.work.v1.ItemAssignment': ItemAssignment$json,
  '.mediatag.work.v1.CreateProjectItemsResponse':
      CreateProjectItemsResponse$json,
  '.mediatag.work.v1.UpdateProjectItemRequest': UpdateProjectItemRequest$json,
  '.mediatag.work.v1.UpdateProjectItemResponse': UpdateProjectItemResponse$json,
  '.mediatag.work.v1.ListItemsRequest': ListItemsRequest$json,
  '.mediatag.work.v1.ListItemsResponse': ListItemsResponse$json,
  '.mediatag.work.v1.Item': Item$json,
  '.mediatag.work.v1.ListJobFiltersRequest': ListJobFiltersRequest$json,
  '.mediatag.work.v1.ListJobFiltersResponse': ListJobFiltersResponse$json,
  '.mediatag.work.v1.ProjectFilter': ProjectFilter$json,
  '.mediatag.work.v1.ProjectUnit': ProjectUnit$json,
  '.mediatag.work.v1.ProjectItem': ProjectItem$json,
  '.mediatag.work.v1.ProjectJoint': ProjectJoint$json,
  '.mediatag.work.v1.ListJobsRequest': ListJobsRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.work.v1.ListJobsResponse': ListJobsResponse$json,
  '.mediatag.work.v1.JobSummary': JobSummary$json,
  '.mediatag.work.v1.Job': Job$json,
  '.mediatag.work.v1.UpdateProjectRequest': UpdateProjectRequest$json,
  '.mediatag.work.v1.UpdateProjectResponse': UpdateProjectResponse$json,
  '.mediatag.work.v1.DeleteProjectRequest': DeleteProjectRequest$json,
  '.mediatag.work.v1.DeleteProjectResponse': DeleteProjectResponse$json,
  '.mediatag.work.v1.CreateJobRequest': CreateJobRequest$json,
  '.mediatag.work.v1.Pass': Pass$json,
  '.mediatag.work.v1.CreateJobResponse': CreateJobResponse$json,
  '.mediatag.work.v1.UpdateJobRequest': UpdateJobRequest$json,
  '.mediatag.work.v1.UpdateJobResponse': UpdateJobResponse$json,
  '.mediatag.work.v1.DeleteJobRequest': DeleteJobRequest$json,
  '.mediatag.work.v1.DeleteJobResponse': DeleteJobResponse$json,
  '.mediatag.work.v1.CreatePassRequest': CreatePassRequest$json,
  '.mediatag.work.v1.CreatePassResponse': CreatePassResponse$json,
  '.mediatag.work.v1.UpdatePassRequest': UpdatePassRequest$json,
  '.mediatag.work.v1.UpdatePassResponse': UpdatePassResponse$json,
  '.mediatag.work.v1.DeletePassRequest': DeletePassRequest$json,
  '.mediatag.work.v1.DeletePassResponse': DeletePassResponse$json,
  '.mediatag.work.v1.GetJobRequest': GetJobRequest$json,
  '.mediatag.work.v1.GetJobResponse': GetJobResponse$json,
  '.mediatag.work.v1.ListCollectionNodesRequest':
      ListCollectionNodesRequest$json,
  '.mediatag.work.v1.CollectionPath': CollectionPath$json,
  '.mediatag.work.v1.ListCollectionNodesResponse':
      ListCollectionNodesResponse$json,
  '.mediatag.work.v1.CollectionNode': CollectionNode$json,
  '.mediatag.work.v1.CollectionSummary': CollectionSummary$json,
  '.mediatag.asset.v1.Asset': $2.Asset$json,
  '.google.protobuf.Struct': $3.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $3.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $3.Value$json,
  '.google.protobuf.ListValue': $3.ListValue$json,
  '.mediatag.asset.v1.Provenance': $2.Provenance$json,
  '.mediatag.work.v1.GetPassWaveformRequest': GetPassWaveformRequest$json,
  '.mediatag.work.v1.GetPassWaveformResponse': GetPassWaveformResponse$json,
  '.mediatag.work.v1.PassWaveform': PassWaveform$json,
  '.mediatag.work.v1.WaveformSeries': WaveformSeries$json,
  '.mediatag.work.v1.WaveformChannel': WaveformChannel$json,
};

/// Descriptor for `WorkService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List workServiceDescriptor = $convert.base64Decode(
    'CgtXb3JrU2VydmljZRJdCgxMaXN0UHJvamVjdHMSJS5tZWRpYXRhZy53b3JrLnYxLkxpc3RQcm'
    '9qZWN0c1JlcXVlc3QaJi5tZWRpYXRhZy53b3JrLnYxLkxpc3RQcm9qZWN0c1Jlc3BvbnNlEmAK'
    'DUNyZWF0ZVByb2plY3QSJi5tZWRpYXRhZy53b3JrLnYxLkNyZWF0ZVByb2plY3RSZXF1ZXN0Gi'
    'cubWVkaWF0YWcud29yay52MS5DcmVhdGVQcm9qZWN0UmVzcG9uc2USWgoLTGlzdFdvcmtlcnMS'
    'JC5tZWRpYXRhZy53b3JrLnYxLkxpc3RXb3JrZXJzUmVxdWVzdBolLm1lZGlhdGFnLndvcmsudj'
    'EuTGlzdFdvcmtlcnNSZXNwb25zZRJdCgxDcmVhdGVXb3JrZXISJS5tZWRpYXRhZy53b3JrLnYx'
    'LkNyZWF0ZVdvcmtlclJlcXVlc3QaJi5tZWRpYXRhZy53b3JrLnYxLkNyZWF0ZVdvcmtlclJlc3'
    'BvbnNlEl0KDFVwZGF0ZVdvcmtlchIlLm1lZGlhdGFnLndvcmsudjEuVXBkYXRlV29ya2VyUmVx'
    'dWVzdBomLm1lZGlhdGFnLndvcmsudjEuVXBkYXRlV29ya2VyUmVzcG9uc2USXQoMRGVsZXRlV2'
    '9ya2VyEiUubWVkaWF0YWcud29yay52MS5EZWxldGVXb3JrZXJSZXF1ZXN0GiYubWVkaWF0YWcu'
    'd29yay52MS5EZWxldGVXb3JrZXJSZXNwb25zZRJgCg1MaXN0RXF1aXBtZW50EiYubWVkaWF0YW'
    'cud29yay52MS5MaXN0RXF1aXBtZW50UmVxdWVzdBonLm1lZGlhdGFnLndvcmsudjEuTGlzdEVx'
    'dWlwbWVudFJlc3BvbnNlEmYKD0NyZWF0ZUVxdWlwbWVudBIoLm1lZGlhdGFnLndvcmsudjEuQ3'
    'JlYXRlRXF1aXBtZW50UmVxdWVzdBopLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlRXF1aXBtZW50'
    'UmVzcG9uc2USZgoPVXBkYXRlRXF1aXBtZW50EigubWVkaWF0YWcud29yay52MS5VcGRhdGVFcX'
    'VpcG1lbnRSZXF1ZXN0GikubWVkaWF0YWcud29yay52MS5VcGRhdGVFcXVpcG1lbnRSZXNwb25z'
    'ZRJmCg9EZWxldGVFcXVpcG1lbnQSKC5tZWRpYXRhZy53b3JrLnYxLkRlbGV0ZUVxdWlwbWVudF'
    'JlcXVlc3QaKS5tZWRpYXRhZy53b3JrLnYxLkRlbGV0ZUVxdWlwbWVudFJlc3BvbnNlEm8KEkNy'
    'ZWF0ZVByb2plY3RJdGVtcxIrLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlUHJvamVjdEl0ZW1zUm'
    'VxdWVzdBosLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlUHJvamVjdEl0ZW1zUmVzcG9uc2USbAoR'
    'VXBkYXRlUHJvamVjdEl0ZW0SKi5tZWRpYXRhZy53b3JrLnYxLlVwZGF0ZVByb2plY3RJdGVtUm'
    'VxdWVzdBorLm1lZGlhdGFnLndvcmsudjEuVXBkYXRlUHJvamVjdEl0ZW1SZXNwb25zZRJUCglM'
    'aXN0SXRlbXMSIi5tZWRpYXRhZy53b3JrLnYxLkxpc3RJdGVtc1JlcXVlc3QaIy5tZWRpYXRhZy'
    '53b3JrLnYxLkxpc3RJdGVtc1Jlc3BvbnNlEmMKDkxpc3RKb2JGaWx0ZXJzEicubWVkaWF0YWcu'
    'd29yay52MS5MaXN0Sm9iRmlsdGVyc1JlcXVlc3QaKC5tZWRpYXRhZy53b3JrLnYxLkxpc3RKb2'
    'JGaWx0ZXJzUmVzcG9uc2USUQoITGlzdEpvYnMSIS5tZWRpYXRhZy53b3JrLnYxLkxpc3RKb2Jz'
    'UmVxdWVzdBoiLm1lZGlhdGFnLndvcmsudjEuTGlzdEpvYnNSZXNwb25zZRJgCg1VcGRhdGVQcm'
    '9qZWN0EiYubWVkaWF0YWcud29yay52MS5VcGRhdGVQcm9qZWN0UmVxdWVzdBonLm1lZGlhdGFn'
    'LndvcmsudjEuVXBkYXRlUHJvamVjdFJlc3BvbnNlEmAKDURlbGV0ZVByb2plY3QSJi5tZWRpYX'
    'RhZy53b3JrLnYxLkRlbGV0ZVByb2plY3RSZXF1ZXN0GicubWVkaWF0YWcud29yay52MS5EZWxl'
    'dGVQcm9qZWN0UmVzcG9uc2USVAoJQ3JlYXRlSm9iEiIubWVkaWF0YWcud29yay52MS5DcmVhdG'
    'VKb2JSZXF1ZXN0GiMubWVkaWF0YWcud29yay52MS5DcmVhdGVKb2JSZXNwb25zZRJUCglVcGRh'
    'dGVKb2ISIi5tZWRpYXRhZy53b3JrLnYxLlVwZGF0ZUpvYlJlcXVlc3QaIy5tZWRpYXRhZy53b3'
    'JrLnYxLlVwZGF0ZUpvYlJlc3BvbnNlElQKCURlbGV0ZUpvYhIiLm1lZGlhdGFnLndvcmsudjEu'
    'RGVsZXRlSm9iUmVxdWVzdBojLm1lZGlhdGFnLndvcmsudjEuRGVsZXRlSm9iUmVzcG9uc2USVw'
    'oKQ3JlYXRlUGFzcxIjLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlUGFzc1JlcXVlc3QaJC5tZWRp'
    'YXRhZy53b3JrLnYxLkNyZWF0ZVBhc3NSZXNwb25zZRJXCgpVcGRhdGVQYXNzEiMubWVkaWF0YW'
    'cud29yay52MS5VcGRhdGVQYXNzUmVxdWVzdBokLm1lZGlhdGFnLndvcmsudjEuVXBkYXRlUGFz'
    'c1Jlc3BvbnNlElcKCkRlbGV0ZVBhc3MSIy5tZWRpYXRhZy53b3JrLnYxLkRlbGV0ZVBhc3NSZX'
    'F1ZXN0GiQubWVkaWF0YWcud29yay52MS5EZWxldGVQYXNzUmVzcG9uc2USSwoGR2V0Sm9iEh8u'
    'bWVkaWF0YWcud29yay52MS5HZXRKb2JSZXF1ZXN0GiAubWVkaWF0YWcud29yay52MS5HZXRKb2'
    'JSZXNwb25zZRJyChNMaXN0Q29sbGVjdGlvbk5vZGVzEiwubWVkaWF0YWcud29yay52MS5MaXN0'
    'Q29sbGVjdGlvbk5vZGVzUmVxdWVzdBotLm1lZGlhdGFnLndvcmsudjEuTGlzdENvbGxlY3Rpb2'
    '5Ob2Rlc1Jlc3BvbnNlEmYKD0dldFBhc3NXYXZlZm9ybRIoLm1lZGlhdGFnLndvcmsudjEuR2V0'
    'UGFzc1dhdmVmb3JtUmVxdWVzdBopLm1lZGlhdGFnLndvcmsudjEuR2V0UGFzc1dhdmVmb3JtUm'
    'VzcG9uc2U=');
