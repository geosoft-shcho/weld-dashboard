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

import '../../../google/protobuf/struct.pbjson.dart' as $2;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../asset/v1/asset.pbjson.dart' as $1;

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
  ],
};

/// Descriptor for `CollectionLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List collectionLevelDescriptor = $convert.base64Decode(
    'Cg9Db2xsZWN0aW9uTGV2ZWwSIAocQ09MTEVDVElPTl9MRVZFTF9VTlNQRUNJRklFRBAAEh4KGk'
    'NPTExFQ1RJT05fTEVWRUxfRVFVSVBNRU5UEAESGwoXQ09MTEVDVElPTl9MRVZFTF9XT1JLRVIQ'
    'AhIcChhDT0xMRUNUSU9OX0xFVkVMX1BST0pFQ1QQAxIYChRDT0xMRUNUSU9OX0xFVkVMX0pPQh'
    'AEEhkKFUNPTExFQ1RJT05fTEVWRUxfUEFTUxAF');

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
  ],
};

/// Descriptor for `Project`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDescriptor = $convert.base64Decode(
    'CgdQcm9qZWN0Eh0KCnByb2plY3Rfbm8YASABKAlSCXByb2plY3RObxIhCgxwcm9qZWN0X25hbW'
    'UYAiABKAlSC3Byb2plY3ROYW1lEhsKCXNpdGVfbmFtZRgDIAEoCVIIc2l0ZU5hbWUSGgoIY3Vz'
    'dG9tZXIYBCABKAlSCGN1c3RvbWVy');

@$core.Deprecated('Use workerDescriptor instead')
const Worker$json = {
  '1': 'Worker',
  '2': [
    {'1': 'worker_id', '3': 1, '4': 1, '5': 9, '10': 'workerId'},
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
};

/// Descriptor for `Worker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workerDescriptor = $convert.base64Decode(
    'CgZXb3JrZXISGwoJd29ya2VyX2lkGAEgASgJUgh3b3JrZXJJZBIfCgt3b3JrZXJfbmFtZRgCIA'
    'EoCVIKd29ya2VyTmFtZRISCgR0ZWFtGAMgASgJUgR0ZWFtEiAKCWlzX21hc3RlchgEIAEoCEgA'
    'Ughpc01hc3RlcogBAUIMCgpfaXNfbWFzdGVy');

@$core.Deprecated('Use equipmentDescriptor instead')
const Equipment$json = {
  '1': 'Equipment',
  '2': [
    {'1': 'equipment_id', '3': 1, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'equipment_name', '3': 2, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'line_name', '3': 3, '4': 1, '5': 9, '10': 'lineName'},
  ],
};

/// Descriptor for `Equipment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equipmentDescriptor = $convert.base64Decode(
    'CglFcXVpcG1lbnQSIQoMZXF1aXBtZW50X2lkGAEgASgJUgtlcXVpcG1lbnRJZBIlCg5lcXVpcG'
    '1lbnRfbmFtZRgCIAEoCVINZXF1aXBtZW50TmFtZRIbCglsaW5lX25hbWUYAyABKAlSCGxpbmVO'
    'YW1l');

@$core.Deprecated('Use jobDescriptor instead')
const Job$json = {
  '1': 'Job',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'project_no', '3': 3, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'unit_no', '3': 4, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'item_code', '3': 5, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 6, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'item_abbr', '3': 7, '4': 1, '5': 9, '10': 'itemAbbr'},
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
    {'1': 'worker_id', '3': 13, '4': 1, '5': 9, '10': 'workerId'},
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
  ],
  '8': [
    {'1': '_outer_diameter_mm'},
    {'1': '_thickness_mm'},
  ],
};

/// Descriptor for `Job`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobDescriptor = $convert.base64Decode(
    'CgNKb2ISFQoGam9iX2lkGAEgASgJUgVqb2JJZBIdCgpjb21tb25fa2V5GAIgASgJUgljb21tb2'
    '5LZXkSHQoKcHJvamVjdF9ubxgDIAEoCVIJcHJvamVjdE5vEhcKB3VuaXRfbm8YBCABKAlSBnVu'
    'aXRObxIbCglpdGVtX2NvZGUYBSABKAlSCGl0ZW1Db2RlEhsKCWl0ZW1fbmFtZRgGIAEoCVIIaX'
    'RlbU5hbWUSGwoJaXRlbV9hYmJyGAcgASgJUghpdGVtQWJichIXCgdpdGVtX25vGAggASgJUgZp'
    'dGVtTm8SIQoMb3BlcmF0aW9uX25vGAkgASgJUgtvcGVyYXRpb25ObxIaCghtYXRlcmlhbBgKIA'
    'EoCVIIbWF0ZXJpYWwSLwoRb3V0ZXJfZGlhbWV0ZXJfbW0YCyABKAFIAFIPb3V0ZXJEaWFtZXRl'
    'ck1tiAEBEiYKDHRoaWNrbmVzc19tbRgMIAEoAUgBUgt0aGlja25lc3NNbYgBARIbCgl3b3JrZX'
    'JfaWQYDSABKAlSCHdvcmtlcklkEjkKCnN0YXJ0ZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUglzdGFydGVkQXQSNQoIZW5kZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgdlbmRlZEF0QhQKEl9vdXRlcl9kaWFtZXRlcl9tbUIPCg1fdGhpY2tu'
    'ZXNzX21t');

@$core.Deprecated('Use passDescriptor instead')
const Pass$json = {
  '1': 'Pass',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
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
    'CgRQYXNzEhcKB3Bhc3NfaWQYASABKAlSBnBhc3NJZBIVCgZqb2JfaWQYAiABKAlSBWpvYklkEh'
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
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'master_only', '3': 5, '4': 1, '5': 8, '10': 'masterOnly'},
    {'1': 'equipment_id', '3': 6, '4': 1, '5': 9, '10': 'equipmentId'},
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
    'Cg9MaXN0Sm9ic1JlcXVlc3QSHQoKcHJvamVjdF9ubxgBIAEoCVIJcHJvamVjdE5vEh0KCmNvbW'
    '1vbl9rZXkYAiABKAlSCWNvbW1vbktleRIbCglpdGVtX2NvZGUYAyABKAlSCGl0ZW1Db2RlEhsK'
    'CXdvcmtlcl9pZBgEIAEoCVIId29ya2VySWQSHwoLbWFzdGVyX29ubHkYBSABKAhSCm1hc3Rlck'
    '9ubHkSIQoMZXF1aXBtZW50X2lkGAYgASgJUgtlcXVpcG1lbnRJZBI9CgxzdGFydGVkX2Zyb20Y'
    'ByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtzdGFydGVkRnJvbRI5CgpzdGFydG'
    'VkX3RvGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZFRvEhsKCXBh'
    'Z2Vfc2l6ZRgJIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgKIAEoCVIJcGFnZVRva2Vu');

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
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `GetJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobRequestDescriptor = $convert
    .base64Decode('Cg1HZXRKb2JSZXF1ZXN0EhUKBmpvYl9pZBgBIAEoCVIFam9iSWQ=');

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
    {'1': 'equipment_id', '3': 3, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'project_no', '3': 5, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'job_id', '3': 6, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'pass_id', '3': 7, '4': 1, '5': 9, '10': 'passId'},
  ],
};

/// Descriptor for `CollectionPath`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionPathDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0aW9uUGF0aBI0CgR2aWV3GAEgASgOMiAubWVkaWF0YWcud29yay52MS5Db2xsZW'
    'N0aW9uVmlld1IEdmlldxI3CgVsZXZlbBgCIAEoDjIhLm1lZGlhdGFnLndvcmsudjEuQ29sbGVj'
    'dGlvbkxldmVsUgVsZXZlbBIhCgxlcXVpcG1lbnRfaWQYAyABKAlSC2VxdWlwbWVudElkEhsKCX'
    'dvcmtlcl9pZBgEIAEoCVIId29ya2VySWQSHQoKcHJvamVjdF9ubxgFIAEoCVIJcHJvamVjdE5v'
    'EhUKBmpvYl9pZBgGIAEoCVIFam9iSWQSFwoHcGFzc19pZBgHIAEoCVIGcGFzc0lk');

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
    {'1': 'pass_id', '3': 1, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'channels', '3': 2, '4': 3, '5': 9, '10': 'channels'},
    {'1': 'max_points', '3': 3, '4': 1, '5': 5, '10': 'maxPoints'},
    {
      '1': 'comparison_pass_id',
      '3': 4,
      '4': 1,
      '5': 9,
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
    'ChZHZXRQYXNzV2F2ZWZvcm1SZXF1ZXN0EhcKB3Bhc3NfaWQYASABKAlSBnBhc3NJZBIaCghjaG'
    'FubmVscxgCIAMoCVIIY2hhbm5lbHMSHQoKbWF4X3BvaW50cxgDIAEoBVIJbWF4UG9pbnRzEiwK'
    'EmNvbXBhcmlzb25fcGFzc19pZBgEIAEoCVIQY29tcGFyaXNvblBhc3NJZBJBCglub3JtYWxpem'
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
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'pass_id', '3': 2, '4': 1, '5': 9, '10': 'passId'},
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
    'CgxQYXNzV2F2ZWZvcm0SFQoGam9iX2lkGAEgASgJUgVqb2JJZBIXCgdwYXNzX2lkGAIgASgJUg'
    'ZwYXNzSWQSFwoHcGFzc19ubxgDIAEoBVIGcGFzc05vEh8KC3dvcmtlcl9uYW1lGAQgASgJUgp3'
    'b3JrZXJOYW1lEiAKCWlzX21hc3RlchgFIAEoCEgAUghpc01hc3RlcogBARI4CgZzZXJpZXMYBi'
    'ADKAsyIC5tZWRpYXRhZy53b3JrLnYxLldhdmVmb3JtU2VyaWVzUgZzZXJpZXNCDAoKX2lzX21h'
    'c3Rlcg==');

@$core.Deprecated('Use waveformSeriesDescriptor instead')
const WaveformSeries$json = {
  '1': 'WaveformSeries',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'equipment_id', '3': 2, '4': 1, '5': 9, '10': 'equipmentId'},
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
    'Cg5XYXZlZm9ybVNlcmllcxIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIhCgxlcXVpcG1lbn'
    'RfaWQYAiABKAlSC2VxdWlwbWVudElkEh4KC3Rfb2Zmc2V0X25zGAMgAygDUgl0T2Zmc2V0TnMS'
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
      '1': 'ListWorkers',
      '2': '.mediatag.work.v1.ListWorkersRequest',
      '3': '.mediatag.work.v1.ListWorkersResponse'
    },
    {
      '1': 'ListEquipment',
      '2': '.mediatag.work.v1.ListEquipmentRequest',
      '3': '.mediatag.work.v1.ListEquipmentResponse'
    },
    {
      '1': 'ListJobs',
      '2': '.mediatag.work.v1.ListJobsRequest',
      '3': '.mediatag.work.v1.ListJobsResponse'
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
  '.mediatag.work.v1.ListWorkersRequest': ListWorkersRequest$json,
  '.mediatag.work.v1.ListWorkersResponse': ListWorkersResponse$json,
  '.mediatag.work.v1.Worker': Worker$json,
  '.mediatag.work.v1.ListEquipmentRequest': ListEquipmentRequest$json,
  '.mediatag.work.v1.ListEquipmentResponse': ListEquipmentResponse$json,
  '.mediatag.work.v1.Equipment': Equipment$json,
  '.mediatag.work.v1.ListJobsRequest': ListJobsRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.work.v1.ListJobsResponse': ListJobsResponse$json,
  '.mediatag.work.v1.JobSummary': JobSummary$json,
  '.mediatag.work.v1.Job': Job$json,
  '.mediatag.work.v1.GetJobRequest': GetJobRequest$json,
  '.mediatag.work.v1.GetJobResponse': GetJobResponse$json,
  '.mediatag.work.v1.Pass': Pass$json,
  '.mediatag.work.v1.ListCollectionNodesRequest':
      ListCollectionNodesRequest$json,
  '.mediatag.work.v1.CollectionPath': CollectionPath$json,
  '.mediatag.work.v1.ListCollectionNodesResponse':
      ListCollectionNodesResponse$json,
  '.mediatag.work.v1.CollectionNode': CollectionNode$json,
  '.mediatag.work.v1.CollectionSummary': CollectionSummary$json,
  '.mediatag.asset.v1.Asset': $1.Asset$json,
  '.google.protobuf.Struct': $2.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $2.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $2.Value$json,
  '.google.protobuf.ListValue': $2.ListValue$json,
  '.mediatag.asset.v1.Provenance': $1.Provenance$json,
  '.mediatag.work.v1.GetPassWaveformRequest': GetPassWaveformRequest$json,
  '.mediatag.work.v1.GetPassWaveformResponse': GetPassWaveformResponse$json,
  '.mediatag.work.v1.PassWaveform': PassWaveform$json,
  '.mediatag.work.v1.WaveformSeries': WaveformSeries$json,
  '.mediatag.work.v1.WaveformChannel': WaveformChannel$json,
};

/// Descriptor for `WorkService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List workServiceDescriptor = $convert.base64Decode(
    'CgtXb3JrU2VydmljZRJdCgxMaXN0UHJvamVjdHMSJS5tZWRpYXRhZy53b3JrLnYxLkxpc3RQcm'
    '9qZWN0c1JlcXVlc3QaJi5tZWRpYXRhZy53b3JrLnYxLkxpc3RQcm9qZWN0c1Jlc3BvbnNlEloK'
    'C0xpc3RXb3JrZXJzEiQubWVkaWF0YWcud29yay52MS5MaXN0V29ya2Vyc1JlcXVlc3QaJS5tZW'
    'RpYXRhZy53b3JrLnYxLkxpc3RXb3JrZXJzUmVzcG9uc2USYAoNTGlzdEVxdWlwbWVudBImLm1l'
    'ZGlhdGFnLndvcmsudjEuTGlzdEVxdWlwbWVudFJlcXVlc3QaJy5tZWRpYXRhZy53b3JrLnYxLk'
    'xpc3RFcXVpcG1lbnRSZXNwb25zZRJRCghMaXN0Sm9icxIhLm1lZGlhdGFnLndvcmsudjEuTGlz'
    'dEpvYnNSZXF1ZXN0GiIubWVkaWF0YWcud29yay52MS5MaXN0Sm9ic1Jlc3BvbnNlEksKBkdldE'
    'pvYhIfLm1lZGlhdGFnLndvcmsudjEuR2V0Sm9iUmVxdWVzdBogLm1lZGlhdGFnLndvcmsudjEu'
    'R2V0Sm9iUmVzcG9uc2UScgoTTGlzdENvbGxlY3Rpb25Ob2RlcxIsLm1lZGlhdGFnLndvcmsudj'
    'EuTGlzdENvbGxlY3Rpb25Ob2Rlc1JlcXVlc3QaLS5tZWRpYXRhZy53b3JrLnYxLkxpc3RDb2xs'
    'ZWN0aW9uTm9kZXNSZXNwb25zZRJmCg9HZXRQYXNzV2F2ZWZvcm0SKC5tZWRpYXRhZy53b3JrLn'
    'YxLkdldFBhc3NXYXZlZm9ybVJlcXVlc3QaKS5tZWRpYXRhZy53b3JrLnYxLkdldFBhc3NXYXZl'
    'Zm9ybVJlc3BvbnNl');
