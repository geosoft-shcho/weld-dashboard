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

@$core.Deprecated('Use workerTypeDescriptor instead')
const WorkerType$json = {
  '1': 'WorkerType',
  '2': [
    {'1': 'WORKER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'WORKER_TYPE_MASTER', '2': 1},
    {'1': 'WORKER_TYPE_GENERAL', '2': 2},
    {'1': 'WORKER_TYPE_ROBOT', '2': 3},
  ],
};

/// Descriptor for `WorkerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workerTypeDescriptor = $convert.base64Decode(
    'CgpXb3JrZXJUeXBlEhsKF1dPUktFUl9UWVBFX1VOU1BFQ0lGSUVEEAASFgoSV09SS0VSX1RZUE'
    'VfTUFTVEVSEAESFwoTV09SS0VSX1RZUEVfR0VORVJBTBACEhUKEVdPUktFUl9UWVBFX1JPQk9U'
    'EAM=');

@$core.Deprecated('Use passTypeDescriptor instead')
const PassType$json = {
  '1': 'PassType',
  '2': [
    {'1': 'PASS_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PASS_TYPE_ROOT', '2': 1},
    {'1': 'PASS_TYPE_HOT', '2': 2},
    {'1': 'PASS_TYPE_FILL', '2': 3},
    {'1': 'PASS_TYPE_CAP', '2': 4},
  ],
};

/// Descriptor for `PassType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passTypeDescriptor = $convert.base64Decode(
    'CghQYXNzVHlwZRIZChVQQVNTX1RZUEVfVU5TUEVDSUZJRUQQABISCg5QQVNTX1RZUEVfUk9PVB'
    'ABEhEKDVBBU1NfVFlQRV9IT1QQAhISCg5QQVNTX1RZUEVfRklMTBADEhEKDVBBU1NfVFlQRV9D'
    'QVAQBA==');

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
    {'1': 'COLLECTION_LEVEL_ITEM', '2': 6},
  ],
  '4': [
    {'1': 5, '2': 5},
  ],
  '5': ['COLLECTION_LEVEL_PASS'],
};

/// Descriptor for `CollectionLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List collectionLevelDescriptor = $convert.base64Decode(
    'Cg9Db2xsZWN0aW9uTGV2ZWwSIAocQ09MTEVDVElPTl9MRVZFTF9VTlNQRUNJRklFRBAAEh4KGk'
    'NPTExFQ1RJT05fTEVWRUxfRVFVSVBNRU5UEAESGwoXQ09MTEVDVElPTl9MRVZFTF9XT1JLRVIQ'
    'AhIcChhDT0xMRUNUSU9OX0xFVkVMX1BST0pFQ1QQAxIYChRDT0xMRUNUSU9OX0xFVkVMX0pPQh'
    'AEEhkKFUNPTExFQ1RJT05fTEVWRUxfSVRFTRAGIgQIBRAFKhVDT0xMRUNUSU9OX0xFVkVMX1BB'
    'U1M=');

@$core.Deprecated('Use segmentUnitDescriptor instead')
const SegmentUnit$json = {
  '1': 'SegmentUnit',
  '2': [
    {'1': 'SEGMENT_UNIT_UNSPECIFIED', '2': 0},
    {'1': 'SEGMENT_UNIT_JOB', '2': 1},
    {'1': 'SEGMENT_UNIT_PASS', '2': 2},
  ],
};

/// Descriptor for `SegmentUnit`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List segmentUnitDescriptor = $convert.base64Decode(
    'CgtTZWdtZW50VW5pdBIcChhTRUdNRU5UX1VOSVRfVU5TUEVDSUZJRUQQABIUChBTRUdNRU5UX1'
    'VOSVRfSk9CEAESFQoRU0VHTUVOVF9VTklUX1BBU1MQAg==');

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
    {'1': 'employee_no', '3': 6, '4': 1, '5': 9, '10': 'employeeNo'},
    {'1': 'description', '3': 7, '4': 1, '5': 9, '10': 'description'},
    {'1': 'inactive', '3': 8, '4': 1, '5': 8, '10': 'inactive'},
    {
      '1': 'worker_type',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.WorkerType',
      '10': 'workerType'
    },
  ],
  '9': [
    {'1': 3, '2': 4},
    {'1': 4, '2': 5},
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `Worker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workerDescriptor = $convert.base64Decode(
    'CgZXb3JrZXISGwoJd29ya2VyX2lkGAEgASgDUgh3b3JrZXJJZBIfCgt3b3JrZXJfbmFtZRgCIA'
    'EoCVIKd29ya2VyTmFtZRIfCgtlbXBsb3llZV9ubxgGIAEoCVIKZW1wbG95ZWVObxIgCgtkZXNj'
    'cmlwdGlvbhgHIAEoCVILZGVzY3JpcHRpb24SGgoIaW5hY3RpdmUYCCABKAhSCGluYWN0aXZlEj'
    '0KC3dvcmtlcl90eXBlGAkgASgOMhwubWVkaWF0YWcud29yay52MS5Xb3JrZXJUeXBlUgp3b3Jr'
    'ZXJUeXBlSgQIAxAESgQIBBAFSgQIBRAG');

@$core.Deprecated('Use equipmentDescriptor instead')
const Equipment$json = {
  '1': 'Equipment',
  '2': [
    {'1': 'equipment_id', '3': 1, '4': 1, '5': 3, '10': 'equipmentId'},
    {'1': 'equipment_name', '3': 2, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'equipment_code', '3': 4, '4': 1, '5': 9, '10': 'equipmentCode'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'inactive', '3': 6, '4': 1, '5': 8, '10': 'inactive'},
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `Equipment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equipmentDescriptor = $convert.base64Decode(
    'CglFcXVpcG1lbnQSIQoMZXF1aXBtZW50X2lkGAEgASgDUgtlcXVpcG1lbnRJZBIlCg5lcXVpcG'
    '1lbnRfbmFtZRgCIAEoCVINZXF1aXBtZW50TmFtZRIlCg5lcXVpcG1lbnRfY29kZRgEIAEoCVIN'
    'ZXF1aXBtZW50Q29kZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SGgoIaW5hY3'
    'RpdmUYBiABKAhSCGluYWN0aXZlSgQIAxAE');

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

@$core.Deprecated('Use deleteProjectItemRequestDescriptor instead')
const DeleteProjectItemRequest$json = {
  '1': 'DeleteProjectItemRequest',
  '2': [
    {'1': 'project_item_id', '3': 1, '4': 1, '5': 3, '10': 'projectItemId'},
  ],
};

/// Descriptor for `DeleteProjectItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectItemRequestDescriptor =
    $convert.base64Decode(
        'ChhEZWxldGVQcm9qZWN0SXRlbVJlcXVlc3QSJgoPcHJvamVjdF9pdGVtX2lkGAEgASgDUg1wcm'
        '9qZWN0SXRlbUlk');

@$core.Deprecated('Use deleteProjectItemResponseDescriptor instead')
const DeleteProjectItemResponse$json = {
  '1': 'DeleteProjectItemResponse',
};

/// Descriptor for `DeleteProjectItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectItemResponseDescriptor =
    $convert.base64Decode('ChlEZWxldGVQcm9qZWN0SXRlbVJlc3BvbnNl');

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
    {
      '1': 'pass_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.PassType',
      '10': 'passType'
    },
  ],
};

/// Descriptor for `Pass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passDescriptor = $convert.base64Decode(
    'CgRQYXNzEhcKB3Bhc3NfaWQYASABKANSBnBhc3NJZBIVCgZqb2JfaWQYAiABKANSBWpvYklkEh'
    'cKB3Bhc3Nfbm8YAyABKAVSBnBhc3NObxI5CgpzdGFydGVkX2F0GAQgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0EjUKCGVuZGVkX2F0GAUgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdBI3CglwYXNzX3R5cGUYBiABKA4yGi5tZWRpYXRh'
    'Zy53b3JrLnYxLlBhc3NUeXBlUghwYXNzVHlwZQ==');

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
      '1': 'worker_type',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.WorkerType',
      '10': 'workerType'
    },
    {'1': 'equipment_names', '3': 4, '4': 3, '5': 9, '10': 'equipmentNames'},
    {'1': 'pass_count', '3': 5, '4': 1, '5': 5, '10': 'passCount'},
    {'1': 'attachment_count', '3': 6, '4': 1, '5': 5, '10': 'attachmentCount'},
    {'1': 'has_report', '3': 7, '4': 1, '5': 8, '10': 'hasReport'},
    {
      '1': 'passes',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.Pass',
      '10': 'passes'
    },
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `JobSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobSummaryDescriptor = $convert.base64Decode(
    'CgpKb2JTdW1tYXJ5EicKA2pvYhgBIAEoCzIVLm1lZGlhdGFnLndvcmsudjEuSm9iUgNqb2ISHw'
    'oLd29ya2VyX25hbWUYAiABKAlSCndvcmtlck5hbWUSPQoLd29ya2VyX3R5cGUYCCABKA4yHC5t'
    'ZWRpYXRhZy53b3JrLnYxLldvcmtlclR5cGVSCndvcmtlclR5cGUSJwoPZXF1aXBtZW50X25hbW'
    'VzGAQgAygJUg5lcXVpcG1lbnROYW1lcxIdCgpwYXNzX2NvdW50GAUgASgFUglwYXNzQ291bnQS'
    'KQoQYXR0YWNobWVudF9jb3VudBgGIAEoBVIPYXR0YWNobWVudENvdW50Eh0KCmhhc19yZXBvcn'
    'QYByABKAhSCWhhc1JlcG9ydBIuCgZwYXNzZXMYCSADKAsyFi5tZWRpYXRhZy53b3JrLnYxLlBh'
    'c3NSBnBhc3Nlc0oECAMQBA==');

@$core.Deprecated('Use listProjectsRequestDescriptor instead')
const ListProjectsRequest$json = {
  '1': 'ListProjectsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListProjectsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UHJvamVjdHNSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRIbCglwYWdlX3Npem'
    'UYAiABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YAyABKAlSCXBhZ2VUb2tlbg==');

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
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
    {
      '1': 'project_details',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ProjectFilter',
      '10': 'projectDetails'
    },
  ],
};

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvamVjdHNSZXNwb25zZRI1Cghwcm9qZWN0cxgBIAMoCzIZLm1lZGlhdGFnLndvcm'
    'sudjEuUHJvamVjdFIIcHJvamVjdHMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFn'
    'ZVRva2VuEh8KC3RvdGFsX2NvdW50GAMgASgFUgp0b3RhbENvdW50EkgKD3Byb2plY3RfZGV0YW'
    'lscxgEIAMoCzIfLm1lZGlhdGFnLndvcmsudjEuUHJvamVjdEZpbHRlclIOcHJvamVjdERldGFp'
    'bHM=');

@$core.Deprecated('Use getProjectRequestDescriptor instead')
const GetProjectRequest$json = {
  '1': 'GetProjectRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 3, '10': 'projectId'},
  ],
};

/// Descriptor for `GetProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9qZWN0UmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgDUglwcm9qZWN0SWQ=');

@$core.Deprecated('Use getProjectResponseDescriptor instead')
const GetProjectResponse$json = {
  '1': 'GetProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.ProjectFilter',
      '10': 'project'
    },
  ],
};

/// Descriptor for `GetProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9qZWN0UmVzcG9uc2USOQoHcHJvamVjdBgBIAEoCzIfLm1lZGlhdGFnLndvcmsudj'
    'EuUHJvamVjdEZpbHRlclIHcHJvamVjdA==');

@$core.Deprecated('Use getWorkerRequestDescriptor instead')
const GetWorkerRequest$json = {
  '1': 'GetWorkerRequest',
  '2': [
    {'1': 'worker_id', '3': 1, '4': 1, '5': 3, '10': 'workerId'},
  ],
};

/// Descriptor for `GetWorkerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorkerRequestDescriptor = $convert.base64Decode(
    'ChBHZXRXb3JrZXJSZXF1ZXN0EhsKCXdvcmtlcl9pZBgBIAEoA1IId29ya2VySWQ=');

@$core.Deprecated('Use getWorkerResponseDescriptor instead')
const GetWorkerResponse$json = {
  '1': 'GetWorkerResponse',
  '2': [
    {
      '1': 'worker',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Worker',
      '10': 'worker'
    },
    {'1': 'job_count', '3': 2, '4': 1, '5': 5, '10': 'jobCount'},
  ],
};

/// Descriptor for `GetWorkerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorkerResponseDescriptor = $convert.base64Decode(
    'ChFHZXRXb3JrZXJSZXNwb25zZRIwCgZ3b3JrZXIYASABKAsyGC5tZWRpYXRhZy53b3JrLnYxLl'
    'dvcmtlclIGd29ya2VyEhsKCWpvYl9jb3VudBgCIAEoBVIIam9iQ291bnQ=');

@$core.Deprecated('Use getEquipmentRequestDescriptor instead')
const GetEquipmentRequest$json = {
  '1': 'GetEquipmentRequest',
  '2': [
    {'1': 'equipment_id', '3': 1, '4': 1, '5': 3, '10': 'equipmentId'},
  ],
};

/// Descriptor for `GetEquipmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEquipmentRequestDescriptor = $convert.base64Decode(
    'ChNHZXRFcXVpcG1lbnRSZXF1ZXN0EiEKDGVxdWlwbWVudF9pZBgBIAEoA1ILZXF1aXBtZW50SW'
    'Q=');

@$core.Deprecated('Use getEquipmentResponseDescriptor instead')
const GetEquipmentResponse$json = {
  '1': 'GetEquipmentResponse',
  '2': [
    {
      '1': 'equipment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.work.v1.Equipment',
      '10': 'equipment'
    },
    {'1': 'job_count', '3': 2, '4': 1, '5': 5, '10': 'jobCount'},
    {'1': 'asset_count', '3': 3, '4': 1, '5': 5, '10': 'assetCount'},
  ],
};

/// Descriptor for `GetEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEquipmentResponseDescriptor = $convert.base64Decode(
    'ChRHZXRFcXVpcG1lbnRSZXNwb25zZRI5CgllcXVpcG1lbnQYASABKAsyGy5tZWRpYXRhZy53b3'
    'JrLnYxLkVxdWlwbWVudFIJZXF1aXBtZW50EhsKCWpvYl9jb3VudBgCIAEoBVIIam9iQ291bnQS'
    'HwoLYXNzZXRfY291bnQYAyABKAVSCmFzc2V0Q291bnQ=');

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
    {
      '1': 'worker_job_counts',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ListJobFiltersResponse.WorkerJobCountsEntry',
      '10': 'workerJobCounts'
    },
    {
      '1': 'equipment_job_counts',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ListJobFiltersResponse.EquipmentJobCountsEntry',
      '10': 'equipmentJobCounts'
    },
    {
      '1': 'equipment_asset_counts',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ListJobFiltersResponse.EquipmentAssetCountsEntry',
      '10': 'equipmentAssetCounts'
    },
  ],
  '3': [
    ListJobFiltersResponse_WorkerJobCountsEntry$json,
    ListJobFiltersResponse_EquipmentJobCountsEntry$json,
    ListJobFiltersResponse_EquipmentAssetCountsEntry$json
  ],
};

@$core.Deprecated('Use listJobFiltersResponseDescriptor instead')
const ListJobFiltersResponse_WorkerJobCountsEntry$json = {
  '1': 'WorkerJobCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use listJobFiltersResponseDescriptor instead')
const ListJobFiltersResponse_EquipmentJobCountsEntry$json = {
  '1': 'EquipmentJobCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use listJobFiltersResponseDescriptor instead')
const ListJobFiltersResponse_EquipmentAssetCountsEntry$json = {
  '1': 'EquipmentAssetCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListJobFiltersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobFiltersResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0Sm9iRmlsdGVyc1Jlc3BvbnNlEjsKCHByb2plY3RzGAEgAygLMh8ubWVkaWF0YWcud2'
    '9yay52MS5Qcm9qZWN0RmlsdGVyUghwcm9qZWN0cxIyCgd3b3JrZXJzGAIgAygLMhgubWVkaWF0'
    'YWcud29yay52MS5Xb3JrZXJSB3dvcmtlcnMSOQoJZXF1aXBtZW50GAMgAygLMhsubWVkaWF0YW'
    'cud29yay52MS5FcXVpcG1lbnRSCWVxdWlwbWVudBJpChF3b3JrZXJfam9iX2NvdW50cxgEIAMo'
    'CzI9Lm1lZGlhdGFnLndvcmsudjEuTGlzdEpvYkZpbHRlcnNSZXNwb25zZS5Xb3JrZXJKb2JDb3'
    'VudHNFbnRyeVIPd29ya2VySm9iQ291bnRzEnIKFGVxdWlwbWVudF9qb2JfY291bnRzGAUgAygL'
    'MkAubWVkaWF0YWcud29yay52MS5MaXN0Sm9iRmlsdGVyc1Jlc3BvbnNlLkVxdWlwbWVudEpvYk'
    'NvdW50c0VudHJ5UhJlcXVpcG1lbnRKb2JDb3VudHMSeAoWZXF1aXBtZW50X2Fzc2V0X2NvdW50'
    'cxgGIAMoCzJCLm1lZGlhdGFnLndvcmsudjEuTGlzdEpvYkZpbHRlcnNSZXNwb25zZS5FcXVpcG'
    '1lbnRBc3NldENvdW50c0VudHJ5UhRlcXVpcG1lbnRBc3NldENvdW50cxpCChRXb3JrZXJKb2JD'
    'b3VudHNFbnRyeRIQCgNrZXkYASABKANSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgBGk'
    'UKF0VxdWlwbWVudEpvYkNvdW50c0VudHJ5EhAKA2tleRgBIAEoA1IDa2V5EhQKBXZhbHVlGAIg'
    'ASgFUgV2YWx1ZToCOAEaRwoZRXF1aXBtZW50QXNzZXRDb3VudHNFbnRyeRIQCgNrZXkYASABKA'
    'NSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgB');

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
    {'1': 'job_count', '3': 3, '4': 1, '5': 5, '10': 'jobCount'},
  ],
};

/// Descriptor for `ProjectFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectFilterDescriptor = $convert.base64Decode(
    'Cg1Qcm9qZWN0RmlsdGVyEjMKB3Byb2plY3QYASABKAsyGS5tZWRpYXRhZy53b3JrLnYxLlByb2'
    'plY3RSB3Byb2plY3QSMwoFdW5pdHMYAiADKAsyHS5tZWRpYXRhZy53b3JrLnYxLlByb2plY3RV'
    'bml0UgV1bml0cxIbCglqb2JfY291bnQYAyABKAVSCGpvYkNvdW50');

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
  '2': [
    {'1': 'include_inactive', '3': 1, '4': 1, '5': 8, '10': 'includeInactive'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListWorkersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkersRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0V29ya2Vyc1JlcXVlc3QSKQoQaW5jbHVkZV9pbmFjdGl2ZRgBIAEoCFIPaW5jbHVkZU'
    'luYWN0aXZlEhQKBXF1ZXJ5GAIgASgJUgVxdWVyeRIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VT'
    'aXplEh0KCnBhZ2VfdG9rZW4YBCABKAlSCXBhZ2VUb2tlbg==');

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
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
    {
      '1': 'job_counts',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ListWorkersResponse.JobCountsEntry',
      '10': 'jobCounts'
    },
  ],
  '3': [ListWorkersResponse_JobCountsEntry$json],
};

@$core.Deprecated('Use listWorkersResponseDescriptor instead')
const ListWorkersResponse_JobCountsEntry$json = {
  '1': 'JobCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListWorkersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkersResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0V29ya2Vyc1Jlc3BvbnNlEjIKB3dvcmtlcnMYASADKAsyGC5tZWRpYXRhZy53b3JrLn'
    'YxLldvcmtlclIHd29ya2VycxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9r'
    'ZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bnQSUwoKam9iX2NvdW50cxgEIAMoCz'
    'I0Lm1lZGlhdGFnLndvcmsudjEuTGlzdFdvcmtlcnNSZXNwb25zZS5Kb2JDb3VudHNFbnRyeVIJ'
    'am9iQ291bnRzGjwKDkpvYkNvdW50c0VudHJ5EhAKA2tleRgBIAEoA1IDa2V5EhQKBXZhbHVlGA'
    'IgASgFUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use listEquipmentRequestDescriptor instead')
const ListEquipmentRequest$json = {
  '1': 'ListEquipmentRequest',
  '2': [
    {'1': 'include_inactive', '3': 1, '4': 1, '5': 8, '10': 'includeInactive'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListEquipmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RXF1aXBtZW50UmVxdWVzdBIpChBpbmNsdWRlX2luYWN0aXZlGAEgASgIUg9pbmNsdW'
    'RlSW5hY3RpdmUSFAoFcXVlcnkYAiABKAlSBXF1ZXJ5EhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFn'
    'ZVNpemUSHQoKcGFnZV90b2tlbhgEIAEoCVIJcGFnZVRva2Vu');

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
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
    {
      '1': 'job_counts',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ListEquipmentResponse.JobCountsEntry',
      '10': 'jobCounts'
    },
    {
      '1': 'asset_counts',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.ListEquipmentResponse.AssetCountsEntry',
      '10': 'assetCounts'
    },
  ],
  '3': [
    ListEquipmentResponse_JobCountsEntry$json,
    ListEquipmentResponse_AssetCountsEntry$json
  ],
};

@$core.Deprecated('Use listEquipmentResponseDescriptor instead')
const ListEquipmentResponse_JobCountsEntry$json = {
  '1': 'JobCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use listEquipmentResponseDescriptor instead')
const ListEquipmentResponse_AssetCountsEntry$json = {
  '1': 'AssetCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RXF1aXBtZW50UmVzcG9uc2USOQoJZXF1aXBtZW50GAEgAygLMhsubWVkaWF0YWcud2'
    '9yay52MS5FcXVpcG1lbnRSCWVxdWlwbWVudBImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5l'
    'eHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bnQSVQoKam9iX2NvdW'
    '50cxgEIAMoCzI2Lm1lZGlhdGFnLndvcmsudjEuTGlzdEVxdWlwbWVudFJlc3BvbnNlLkpvYkNv'
    'dW50c0VudHJ5Uglqb2JDb3VudHMSWwoMYXNzZXRfY291bnRzGAUgAygLMjgubWVkaWF0YWcud2'
    '9yay52MS5MaXN0RXF1aXBtZW50UmVzcG9uc2UuQXNzZXRDb3VudHNFbnRyeVILYXNzZXRDb3Vu'
    'dHMaPAoOSm9iQ291bnRzRW50cnkSEAoDa2V5GAEgASgDUgNrZXkSFAoFdmFsdWUYAiABKAVSBX'
    'ZhbHVlOgI4ARo+ChBBc3NldENvdW50c0VudHJ5EhAKA2tleRgBIAEoA1IDa2V5EhQKBXZhbHVl'
    'GAIgASgFUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use listJobsRequestDescriptor instead')
const ListJobsRequest$json = {
  '1': 'ListJobsRequest',
  '2': [
    {'1': 'project_no', '3': 1, '4': 1, '5': 9, '10': 'projectNo'},
    {'1': 'project_id', '3': 14, '4': 1, '5': 3, '10': 'projectId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'project_item_id', '3': 17, '4': 1, '5': 3, '10': 'projectItemId'},
    {'1': 'unit_no', '3': 11, '4': 1, '5': 9, '10': 'unitNo'},
    {'1': 'joint_no', '3': 12, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'pass_no', '3': 13, '4': 1, '5': 5, '10': 'passNo'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 3, '10': 'workerId'},
    {
      '1': 'worker_type',
      '3': 16,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.WorkerType',
      '10': 'workerType'
    },
    {'1': 'equipment_id', '3': 6, '4': 1, '5': 3, '10': 'equipmentId'},
    {'1': 'asset_id', '3': 15, '4': 1, '5': 3, '10': 'assetId'},
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
  '9': [
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `ListJobsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0Sm9ic1JlcXVlc3QSHQoKcHJvamVjdF9ubxgBIAEoCVIJcHJvamVjdE5vEh0KCnByb2'
    'plY3RfaWQYDiABKANSCXByb2plY3RJZBIdCgpjb21tb25fa2V5GAIgASgJUgljb21tb25LZXkS'
    'GwoJaXRlbV9jb2RlGAMgASgJUghpdGVtQ29kZRImCg9wcm9qZWN0X2l0ZW1faWQYESABKANSDX'
    'Byb2plY3RJdGVtSWQSFwoHdW5pdF9ubxgLIAEoCVIGdW5pdE5vEhkKCGpvaW50X25vGAwgASgJ'
    'Ugdqb2ludE5vEhcKB3Bhc3Nfbm8YDSABKAVSBnBhc3NObxIbCgl3b3JrZXJfaWQYBCABKANSCH'
    'dvcmtlcklkEj0KC3dvcmtlcl90eXBlGBAgASgOMhwubWVkaWF0YWcud29yay52MS5Xb3JrZXJU'
    'eXBlUgp3b3JrZXJUeXBlEiEKDGVxdWlwbWVudF9pZBgGIAEoA1ILZXF1aXBtZW50SWQSGQoIYX'
    'NzZXRfaWQYDyABKANSB2Fzc2V0SWQSPQoMc3RhcnRlZF9mcm9tGAcgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFILc3RhcnRlZEZyb20SOQoKc3RhcnRlZF90bxgIIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRUbxIbCglwYWdlX3NpemUYCSABKAVSCHBh'
    'Z2VTaXplEh0KCnBhZ2VfdG9rZW4YCiABKAlSCXBhZ2VUb2tlbkoECAUQBg==');

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
    {
      '1': 'segment_unit',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.SegmentUnit',
      '10': 'segmentUnit'
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
    'cxJACgxzZWdtZW50X3VuaXQYBSABKA4yHS5tZWRpYXRhZy53b3JrLnYxLlNlZ21lbnRVbml0Ug'
    'tzZWdtZW50VW5pdEISChBfc3RhcnRfb2Zmc2V0X25zQhAKDl9lbmRfb2Zmc2V0X25z');

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
    {
      '1': 'segments',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.mediatag.work.v1.TimeRange',
      '10': 'segments'
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
    'LlRpbWVzdGFtcFIHZW5kZWRBdBI3CghzZWdtZW50cxgIIAMoCzIbLm1lZGlhdGFnLndvcmsudj'
    'EuVGltZVJhbmdlUghzZWdtZW50cw==');

@$core.Deprecated('Use timeRangeDescriptor instead')
const TimeRange$json = {
  '1': 'TimeRange',
  '2': [
    {
      '1': 'started_at',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
};

/// Descriptor for `TimeRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeRangeDescriptor = $convert.base64Decode(
    'CglUaW1lUmFuZ2USOQoKc3RhcnRlZF9hdBgBIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSCXN0YXJ0ZWRBdBI1CghlbmRlZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSB2VuZGVkQXQ=');

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
      '1': 'worker_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.mediatag.work.v1.WorkerType',
      '10': 'workerType'
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
  '9': [
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `PassWaveform`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passWaveformDescriptor = $convert.base64Decode(
    'CgxQYXNzV2F2ZWZvcm0SFQoGam9iX2lkGAEgASgDUgVqb2JJZBIXCgdwYXNzX2lkGAIgASgDUg'
    'ZwYXNzSWQSFwoHcGFzc19ubxgDIAEoBVIGcGFzc05vEh8KC3dvcmtlcl9uYW1lGAQgASgJUgp3'
    'b3JrZXJOYW1lEj0KC3dvcmtlcl90eXBlGAcgASgOMhwubWVkaWF0YWcud29yay52MS5Xb3JrZX'
    'JUeXBlUgp3b3JrZXJUeXBlEjgKBnNlcmllcxgGIAMoCzIgLm1lZGlhdGFnLndvcmsudjEuV2F2'
    'ZWZvcm1TZXJpZXNSBnNlcmllc0oECAUQBg==');

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
      '1': 'GetProject',
      '2': '.mediatag.work.v1.GetProjectRequest',
      '3': '.mediatag.work.v1.GetProjectResponse'
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
      '1': 'GetWorker',
      '2': '.mediatag.work.v1.GetWorkerRequest',
      '3': '.mediatag.work.v1.GetWorkerResponse'
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
      '1': 'GetEquipment',
      '2': '.mediatag.work.v1.GetEquipmentRequest',
      '3': '.mediatag.work.v1.GetEquipmentResponse'
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
      '1': 'DeleteProjectItem',
      '2': '.mediatag.work.v1.DeleteProjectItemRequest',
      '3': '.mediatag.work.v1.DeleteProjectItemResponse'
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
  '.mediatag.work.v1.ProjectFilter': ProjectFilter$json,
  '.mediatag.work.v1.ProjectUnit': ProjectUnit$json,
  '.mediatag.work.v1.ProjectItem': ProjectItem$json,
  '.mediatag.work.v1.ProjectJoint': ProjectJoint$json,
  '.mediatag.work.v1.GetProjectRequest': GetProjectRequest$json,
  '.mediatag.work.v1.GetProjectResponse': GetProjectResponse$json,
  '.mediatag.work.v1.CreateProjectRequest': CreateProjectRequest$json,
  '.mediatag.work.v1.CreateProjectResponse': CreateProjectResponse$json,
  '.mediatag.work.v1.ListWorkersRequest': ListWorkersRequest$json,
  '.mediatag.work.v1.ListWorkersResponse': ListWorkersResponse$json,
  '.mediatag.work.v1.Worker': Worker$json,
  '.mediatag.work.v1.ListWorkersResponse.JobCountsEntry':
      ListWorkersResponse_JobCountsEntry$json,
  '.mediatag.work.v1.GetWorkerRequest': GetWorkerRequest$json,
  '.mediatag.work.v1.GetWorkerResponse': GetWorkerResponse$json,
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
  '.mediatag.work.v1.ListEquipmentResponse.JobCountsEntry':
      ListEquipmentResponse_JobCountsEntry$json,
  '.mediatag.work.v1.ListEquipmentResponse.AssetCountsEntry':
      ListEquipmentResponse_AssetCountsEntry$json,
  '.mediatag.work.v1.GetEquipmentRequest': GetEquipmentRequest$json,
  '.mediatag.work.v1.GetEquipmentResponse': GetEquipmentResponse$json,
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
  '.mediatag.work.v1.DeleteProjectItemRequest': DeleteProjectItemRequest$json,
  '.mediatag.work.v1.DeleteProjectItemResponse': DeleteProjectItemResponse$json,
  '.mediatag.work.v1.ListItemsRequest': ListItemsRequest$json,
  '.mediatag.work.v1.ListItemsResponse': ListItemsResponse$json,
  '.mediatag.work.v1.Item': Item$json,
  '.mediatag.work.v1.ListJobFiltersRequest': ListJobFiltersRequest$json,
  '.mediatag.work.v1.ListJobFiltersResponse': ListJobFiltersResponse$json,
  '.mediatag.work.v1.ListJobFiltersResponse.WorkerJobCountsEntry':
      ListJobFiltersResponse_WorkerJobCountsEntry$json,
  '.mediatag.work.v1.ListJobFiltersResponse.EquipmentJobCountsEntry':
      ListJobFiltersResponse_EquipmentJobCountsEntry$json,
  '.mediatag.work.v1.ListJobFiltersResponse.EquipmentAssetCountsEntry':
      ListJobFiltersResponse_EquipmentAssetCountsEntry$json,
  '.mediatag.work.v1.ListJobsRequest': ListJobsRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.work.v1.ListJobsResponse': ListJobsResponse$json,
  '.mediatag.work.v1.JobSummary': JobSummary$json,
  '.mediatag.work.v1.Job': Job$json,
  '.mediatag.work.v1.Pass': Pass$json,
  '.mediatag.work.v1.UpdateProjectRequest': UpdateProjectRequest$json,
  '.mediatag.work.v1.UpdateProjectResponse': UpdateProjectResponse$json,
  '.mediatag.work.v1.DeleteProjectRequest': DeleteProjectRequest$json,
  '.mediatag.work.v1.DeleteProjectResponse': DeleteProjectResponse$json,
  '.mediatag.work.v1.CreateJobRequest': CreateJobRequest$json,
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
  '.mediatag.asset.v1.DisplayField': $2.DisplayField$json,
  '.mediatag.work.v1.TimeRange': TimeRange$json,
  '.mediatag.work.v1.GetPassWaveformRequest': GetPassWaveformRequest$json,
  '.mediatag.work.v1.GetPassWaveformResponse': GetPassWaveformResponse$json,
  '.mediatag.work.v1.PassWaveform': PassWaveform$json,
  '.mediatag.work.v1.WaveformSeries': WaveformSeries$json,
  '.mediatag.work.v1.WaveformChannel': WaveformChannel$json,
};

/// Descriptor for `WorkService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List workServiceDescriptor = $convert.base64Decode(
    'CgtXb3JrU2VydmljZRJdCgxMaXN0UHJvamVjdHMSJS5tZWRpYXRhZy53b3JrLnYxLkxpc3RQcm'
    '9qZWN0c1JlcXVlc3QaJi5tZWRpYXRhZy53b3JrLnYxLkxpc3RQcm9qZWN0c1Jlc3BvbnNlElcK'
    'CkdldFByb2plY3QSIy5tZWRpYXRhZy53b3JrLnYxLkdldFByb2plY3RSZXF1ZXN0GiQubWVkaW'
    'F0YWcud29yay52MS5HZXRQcm9qZWN0UmVzcG9uc2USYAoNQ3JlYXRlUHJvamVjdBImLm1lZGlh'
    'dGFnLndvcmsudjEuQ3JlYXRlUHJvamVjdFJlcXVlc3QaJy5tZWRpYXRhZy53b3JrLnYxLkNyZW'
    'F0ZVByb2plY3RSZXNwb25zZRJaCgtMaXN0V29ya2VycxIkLm1lZGlhdGFnLndvcmsudjEuTGlz'
    'dFdvcmtlcnNSZXF1ZXN0GiUubWVkaWF0YWcud29yay52MS5MaXN0V29ya2Vyc1Jlc3BvbnNlEl'
    'QKCUdldFdvcmtlchIiLm1lZGlhdGFnLndvcmsudjEuR2V0V29ya2VyUmVxdWVzdBojLm1lZGlh'
    'dGFnLndvcmsudjEuR2V0V29ya2VyUmVzcG9uc2USXQoMQ3JlYXRlV29ya2VyEiUubWVkaWF0YW'
    'cud29yay52MS5DcmVhdGVXb3JrZXJSZXF1ZXN0GiYubWVkaWF0YWcud29yay52MS5DcmVhdGVX'
    'b3JrZXJSZXNwb25zZRJdCgxVcGRhdGVXb3JrZXISJS5tZWRpYXRhZy53b3JrLnYxLlVwZGF0ZV'
    'dvcmtlclJlcXVlc3QaJi5tZWRpYXRhZy53b3JrLnYxLlVwZGF0ZVdvcmtlclJlc3BvbnNlEl0K'
    'DERlbGV0ZVdvcmtlchIlLm1lZGlhdGFnLndvcmsudjEuRGVsZXRlV29ya2VyUmVxdWVzdBomLm'
    '1lZGlhdGFnLndvcmsudjEuRGVsZXRlV29ya2VyUmVzcG9uc2USYAoNTGlzdEVxdWlwbWVudBIm'
    'Lm1lZGlhdGFnLndvcmsudjEuTGlzdEVxdWlwbWVudFJlcXVlc3QaJy5tZWRpYXRhZy53b3JrLn'
    'YxLkxpc3RFcXVpcG1lbnRSZXNwb25zZRJdCgxHZXRFcXVpcG1lbnQSJS5tZWRpYXRhZy53b3Jr'
    'LnYxLkdldEVxdWlwbWVudFJlcXVlc3QaJi5tZWRpYXRhZy53b3JrLnYxLkdldEVxdWlwbWVudF'
    'Jlc3BvbnNlEmYKD0NyZWF0ZUVxdWlwbWVudBIoLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlRXF1'
    'aXBtZW50UmVxdWVzdBopLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlRXF1aXBtZW50UmVzcG9uc2'
    'USZgoPVXBkYXRlRXF1aXBtZW50EigubWVkaWF0YWcud29yay52MS5VcGRhdGVFcXVpcG1lbnRS'
    'ZXF1ZXN0GikubWVkaWF0YWcud29yay52MS5VcGRhdGVFcXVpcG1lbnRSZXNwb25zZRJmCg9EZW'
    'xldGVFcXVpcG1lbnQSKC5tZWRpYXRhZy53b3JrLnYxLkRlbGV0ZUVxdWlwbWVudFJlcXVlc3Qa'
    'KS5tZWRpYXRhZy53b3JrLnYxLkRlbGV0ZUVxdWlwbWVudFJlc3BvbnNlEm8KEkNyZWF0ZVByb2'
    'plY3RJdGVtcxIrLm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlUHJvamVjdEl0ZW1zUmVxdWVzdBos'
    'Lm1lZGlhdGFnLndvcmsudjEuQ3JlYXRlUHJvamVjdEl0ZW1zUmVzcG9uc2USbAoRVXBkYXRlUH'
    'JvamVjdEl0ZW0SKi5tZWRpYXRhZy53b3JrLnYxLlVwZGF0ZVByb2plY3RJdGVtUmVxdWVzdBor'
    'Lm1lZGlhdGFnLndvcmsudjEuVXBkYXRlUHJvamVjdEl0ZW1SZXNwb25zZRJsChFEZWxldGVQcm'
    '9qZWN0SXRlbRIqLm1lZGlhdGFnLndvcmsudjEuRGVsZXRlUHJvamVjdEl0ZW1SZXF1ZXN0Gisu'
    'bWVkaWF0YWcud29yay52MS5EZWxldGVQcm9qZWN0SXRlbVJlc3BvbnNlElQKCUxpc3RJdGVtcx'
    'IiLm1lZGlhdGFnLndvcmsudjEuTGlzdEl0ZW1zUmVxdWVzdBojLm1lZGlhdGFnLndvcmsudjEu'
    'TGlzdEl0ZW1zUmVzcG9uc2USYwoOTGlzdEpvYkZpbHRlcnMSJy5tZWRpYXRhZy53b3JrLnYxLk'
    'xpc3RKb2JGaWx0ZXJzUmVxdWVzdBooLm1lZGlhdGFnLndvcmsudjEuTGlzdEpvYkZpbHRlcnNS'
    'ZXNwb25zZRJRCghMaXN0Sm9icxIhLm1lZGlhdGFnLndvcmsudjEuTGlzdEpvYnNSZXF1ZXN0Gi'
    'IubWVkaWF0YWcud29yay52MS5MaXN0Sm9ic1Jlc3BvbnNlEmAKDVVwZGF0ZVByb2plY3QSJi5t'
    'ZWRpYXRhZy53b3JrLnYxLlVwZGF0ZVByb2plY3RSZXF1ZXN0GicubWVkaWF0YWcud29yay52MS'
    '5VcGRhdGVQcm9qZWN0UmVzcG9uc2USYAoNRGVsZXRlUHJvamVjdBImLm1lZGlhdGFnLndvcmsu'
    'djEuRGVsZXRlUHJvamVjdFJlcXVlc3QaJy5tZWRpYXRhZy53b3JrLnYxLkRlbGV0ZVByb2plY3'
    'RSZXNwb25zZRJUCglDcmVhdGVKb2ISIi5tZWRpYXRhZy53b3JrLnYxLkNyZWF0ZUpvYlJlcXVl'
    'c3QaIy5tZWRpYXRhZy53b3JrLnYxLkNyZWF0ZUpvYlJlc3BvbnNlElQKCVVwZGF0ZUpvYhIiLm'
    '1lZGlhdGFnLndvcmsudjEuVXBkYXRlSm9iUmVxdWVzdBojLm1lZGlhdGFnLndvcmsudjEuVXBk'
    'YXRlSm9iUmVzcG9uc2USVAoJRGVsZXRlSm9iEiIubWVkaWF0YWcud29yay52MS5EZWxldGVKb2'
    'JSZXF1ZXN0GiMubWVkaWF0YWcud29yay52MS5EZWxldGVKb2JSZXNwb25zZRJXCgpDcmVhdGVQ'
    'YXNzEiMubWVkaWF0YWcud29yay52MS5DcmVhdGVQYXNzUmVxdWVzdBokLm1lZGlhdGFnLndvcm'
    'sudjEuQ3JlYXRlUGFzc1Jlc3BvbnNlElcKClVwZGF0ZVBhc3MSIy5tZWRpYXRhZy53b3JrLnYx'
    'LlVwZGF0ZVBhc3NSZXF1ZXN0GiQubWVkaWF0YWcud29yay52MS5VcGRhdGVQYXNzUmVzcG9uc2'
    'USVwoKRGVsZXRlUGFzcxIjLm1lZGlhdGFnLndvcmsudjEuRGVsZXRlUGFzc1JlcXVlc3QaJC5t'
    'ZWRpYXRhZy53b3JrLnYxLkRlbGV0ZVBhc3NSZXNwb25zZRJLCgZHZXRKb2ISHy5tZWRpYXRhZy'
    '53b3JrLnYxLkdldEpvYlJlcXVlc3QaIC5tZWRpYXRhZy53b3JrLnYxLkdldEpvYlJlc3BvbnNl'
    'EnIKE0xpc3RDb2xsZWN0aW9uTm9kZXMSLC5tZWRpYXRhZy53b3JrLnYxLkxpc3RDb2xsZWN0aW'
    '9uTm9kZXNSZXF1ZXN0Gi0ubWVkaWF0YWcud29yay52MS5MaXN0Q29sbGVjdGlvbk5vZGVzUmVz'
    'cG9uc2USZgoPR2V0UGFzc1dhdmVmb3JtEigubWVkaWF0YWcud29yay52MS5HZXRQYXNzV2F2ZW'
    'Zvcm1SZXF1ZXN0GikubWVkaWF0YWcud29yay52MS5HZXRQYXNzV2F2ZWZvcm1SZXNwb25zZQ==');
