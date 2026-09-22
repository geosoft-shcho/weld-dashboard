// This is a generated file - do not edit.
//
// Generated from dashboard_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

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
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.Equipment',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListEquipmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RXF1aXBtZW50UmVzcG9uc2USMwoFaXRlbXMYASADKAsyHS50YWNpdC5kYXNoYm9hcm'
    'QudjEuRXF1aXBtZW50UgVpdGVtcw==');

@$core.Deprecated('Use projectDescriptor instead')
const Project$json = {
  '1': 'Project',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'project_name', '3': 2, '4': 1, '5': 9, '10': 'projectName'},
    {'1': 'site_name', '3': 3, '4': 1, '5': 9, '10': 'siteName'},
  ],
};

/// Descriptor for `Project`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDescriptor = $convert.base64Decode(
    'CgdQcm9qZWN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIhCgxwcm9qZWN0X25hbW'
    'UYAiABKAlSC3Byb2plY3ROYW1lEhsKCXNpdGVfbmFtZRgDIAEoCVIIc2l0ZU5hbWU=');

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
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.Project',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvamVjdHNSZXNwb25zZRIxCgVpdGVtcxgBIAMoCzIbLnRhY2l0LmRhc2hib2FyZC'
    '52MS5Qcm9qZWN0UgVpdGVtcw==');

@$core.Deprecated('Use collectionAssignmentDescriptor instead')
const CollectionAssignment$json = {
  '1': 'CollectionAssignment',
  '2': [
    {'1': 'assignment_id', '3': 1, '4': 1, '5': 9, '10': 'assignmentId'},
    {'1': 'equipment_id', '3': 2, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'work_order_id', '3': 4, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'worker_id', '3': 5, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'assigned_from', '3': 6, '4': 1, '5': 9, '10': 'assignedFrom'},
    {'1': 'assigned_to', '3': 7, '4': 1, '5': 9, '10': 'assignedTo'},
    {'1': 'note', '3': 8, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CollectionAssignment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionAssignmentDescriptor = $convert.base64Decode(
    'ChRDb2xsZWN0aW9uQXNzaWdubWVudBIjCg1hc3NpZ25tZW50X2lkGAEgASgJUgxhc3NpZ25tZW'
    '50SWQSIQoMZXF1aXBtZW50X2lkGAIgASgJUgtlcXVpcG1lbnRJZBIdCgpwcm9qZWN0X2lkGAMg'
    'ASgJUglwcm9qZWN0SWQSIgoNd29ya19vcmRlcl9pZBgEIAEoCVILd29ya09yZGVySWQSGwoJd2'
    '9ya2VyX2lkGAUgASgJUgh3b3JrZXJJZBIjCg1hc3NpZ25lZF9mcm9tGAYgASgJUgxhc3NpZ25l'
    'ZEZyb20SHwoLYXNzaWduZWRfdG8YByABKAlSCmFzc2lnbmVkVG8SEgoEbm90ZRgIIAEoCVIEbm'
    '90ZQ==');

@$core.Deprecated('Use listCollectionAssignmentsRequestDescriptor instead')
const ListCollectionAssignmentsRequest$json = {
  '1': 'ListCollectionAssignmentsRequest',
};

/// Descriptor for `ListCollectionAssignmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionAssignmentsRequestDescriptor =
    $convert.base64Decode('CiBMaXN0Q29sbGVjdGlvbkFzc2lnbm1lbnRzUmVxdWVzdA==');

@$core.Deprecated('Use listCollectionAssignmentsResponseDescriptor instead')
const ListCollectionAssignmentsResponse$json = {
  '1': 'ListCollectionAssignmentsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.CollectionAssignment',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListCollectionAssignmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionAssignmentsResponseDescriptor =
    $convert.base64Decode(
        'CiFMaXN0Q29sbGVjdGlvbkFzc2lnbm1lbnRzUmVzcG9uc2USPgoFaXRlbXMYASADKAsyKC50YW'
        'NpdC5kYXNoYm9hcmQudjEuQ29sbGVjdGlvbkFzc2lnbm1lbnRSBWl0ZW1z');

@$core.Deprecated('Use assignmentFilterDescriptor instead')
const AssignmentFilter$json = {
  '1': 'AssignmentFilter',
  '2': [
    {'1': 'project_ids', '3': 1, '4': 3, '5': 9, '10': 'projectIds'},
    {'1': 'worker_ids', '3': 2, '4': 3, '5': 9, '10': 'workerIds'},
    {'1': 'unassigned', '3': 3, '4': 1, '5': 8, '10': 'unassigned'},
  ],
};

/// Descriptor for `AssignmentFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignmentFilterDescriptor = $convert.base64Decode(
    'ChBBc3NpZ25tZW50RmlsdGVyEh8KC3Byb2plY3RfaWRzGAEgAygJUgpwcm9qZWN0SWRzEh0KCn'
    'dvcmtlcl9pZHMYAiADKAlSCXdvcmtlcklkcxIeCgp1bmFzc2lnbmVkGAMgASgIUgp1bmFzc2ln'
    'bmVk');

@$core.Deprecated('Use collectionEventDescriptor instead')
const CollectionEvent$json = {
  '1': 'CollectionEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'equipment_id', '3': 2, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'event_at', '3': 3, '4': 1, '5': 9, '10': 'eventAt'},
    {
      '1': 'duration_sec',
      '3': 4,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'durationSec',
      '17': true
    },
    {
      '1': 'connection_status',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'connectionStatus'
    },
    {
      '1': 'received_count',
      '3': 6,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'receivedCount',
      '17': true
    },
    {'1': 'window_label', '3': 7, '4': 1, '5': 9, '10': 'windowLabel'},
    {
      '1': 'loss_rate_pct',
      '3': 8,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'lossRatePct',
      '17': true
    },
    {'1': 'time_sync_status', '3': 9, '4': 1, '5': 9, '10': 'timeSyncStatus'},
    {
      '1': 'clock_offset_ms',
      '3': 10,
      '4': 1,
      '5': 5,
      '9': 3,
      '10': 'clockOffsetMs',
      '17': true
    },
    {'1': 'note', '3': 11, '4': 1, '5': 9, '10': 'note'},
    {'1': 'equipment_name', '3': 12, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'line_name', '3': 13, '4': 1, '5': 9, '10': 'lineName'},
  ],
  '8': [
    {'1': '_duration_sec'},
    {'1': '_received_count'},
    {'1': '_loss_rate_pct'},
    {'1': '_clock_offset_ms'},
  ],
};

/// Descriptor for `CollectionEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionEventDescriptor = $convert.base64Decode(
    'Cg9Db2xsZWN0aW9uRXZlbnQSGQoIZXZlbnRfaWQYASABKAlSB2V2ZW50SWQSIQoMZXF1aXBtZW'
    '50X2lkGAIgASgJUgtlcXVpcG1lbnRJZBIZCghldmVudF9hdBgDIAEoCVIHZXZlbnRBdBImCgxk'
    'dXJhdGlvbl9zZWMYBCABKAVIAFILZHVyYXRpb25TZWOIAQESKwoRY29ubmVjdGlvbl9zdGF0dX'
    'MYBSABKAlSEGNvbm5lY3Rpb25TdGF0dXMSKgoOcmVjZWl2ZWRfY291bnQYBiABKAVIAVINcmVj'
    'ZWl2ZWRDb3VudIgBARIhCgx3aW5kb3dfbGFiZWwYByABKAlSC3dpbmRvd0xhYmVsEicKDWxvc3'
    'NfcmF0ZV9wY3QYCCABKAFIAlILbG9zc1JhdGVQY3SIAQESKAoQdGltZV9zeW5jX3N0YXR1cxgJ'
    'IAEoCVIOdGltZVN5bmNTdGF0dXMSKwoPY2xvY2tfb2Zmc2V0X21zGAogASgFSANSDWNsb2NrT2'
    'Zmc2V0TXOIAQESEgoEbm90ZRgLIAEoCVIEbm90ZRIlCg5lcXVpcG1lbnRfbmFtZRgMIAEoCVIN'
    'ZXF1aXBtZW50TmFtZRIbCglsaW5lX25hbWUYDSABKAlSCGxpbmVOYW1lQg8KDV9kdXJhdGlvbl'
    '9zZWNCEQoPX3JlY2VpdmVkX2NvdW50QhAKDl9sb3NzX3JhdGVfcGN0QhIKEF9jbG9ja19vZmZz'
    'ZXRfbXM=');

@$core.Deprecated('Use listCollectionEventsRequestDescriptor instead')
const ListCollectionEventsRequest$json = {
  '1': 'ListCollectionEventsRequest',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'equipment_ids', '3': 2, '4': 3, '5': 9, '10': 'equipmentIds'},
    {
      '1': 'connection_statuses',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'connectionStatuses'
    },
    {'1': 'lines', '3': 4, '4': 3, '5': 9, '10': 'lines'},
    {
      '1': 'assignment',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.tacit.dashboard.v1.AssignmentFilter',
      '10': 'assignment'
    },
    {'1': 'from', '3': 6, '4': 1, '5': 9, '10': 'from'},
    {'1': 'to', '3': 7, '4': 1, '5': 9, '10': 'to'},
  ],
};

/// Descriptor for `ListCollectionEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionEventsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0Q29sbGVjdGlvbkV2ZW50c1JlcXVlc3QSEgoEZGF0ZRgBIAEoCVIEZGF0ZRIjCg1lcX'
    'VpcG1lbnRfaWRzGAIgAygJUgxlcXVpcG1lbnRJZHMSLwoTY29ubmVjdGlvbl9zdGF0dXNlcxgD'
    'IAMoCVISY29ubmVjdGlvblN0YXR1c2VzEhQKBWxpbmVzGAQgAygJUgVsaW5lcxJECgphc3NpZ2'
    '5tZW50GAUgASgLMiQudGFjaXQuZGFzaGJvYXJkLnYxLkFzc2lnbm1lbnRGaWx0ZXJSCmFzc2ln'
    'bm1lbnQSEgoEZnJvbRgGIAEoCVIEZnJvbRIOCgJ0bxgHIAEoCVICdG8=');

@$core.Deprecated('Use listCollectionEventsResponseDescriptor instead')
const ListCollectionEventsResponse$json = {
  '1': 'ListCollectionEventsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.CollectionEvent',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListCollectionEventsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionEventsResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0Q29sbGVjdGlvbkV2ZW50c1Jlc3BvbnNlEjkKBWl0ZW1zGAEgAygLMiMudGFjaXQuZG'
        'FzaGJvYXJkLnYxLkNvbGxlY3Rpb25FdmVudFIFaXRlbXM=');

@$core.Deprecated('Use equipmentStatusRowDescriptor instead')
const EquipmentStatusRow$json = {
  '1': 'EquipmentStatusRow',
  '2': [
    {'1': 'equipment_id', '3': 1, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'equipment_name', '3': 2, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'line_name', '3': 3, '4': 1, '5': 9, '10': 'lineName'},
    {'1': 'snapshot_at', '3': 4, '4': 1, '5': 9, '10': 'snapshotAt'},
    {
      '1': 'connection_status',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'connectionStatus'
    },
    {
      '1': 'received_count',
      '3': 6,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'receivedCount',
      '17': true
    },
    {'1': 'window_label', '3': 7, '4': 1, '5': 9, '10': 'windowLabel'},
    {
      '1': 'loss_rate_pct',
      '3': 8,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'lossRatePct',
      '17': true
    },
    {'1': 'time_sync_status', '3': 9, '4': 1, '5': 9, '10': 'timeSyncStatus'},
    {
      '1': 'clock_offset_ms',
      '3': 10,
      '4': 1,
      '5': 5,
      '9': 2,
      '10': 'clockOffsetMs',
      '17': true
    },
    {'1': 'last_received_at', '3': 11, '4': 1, '5': 9, '10': 'lastReceivedAt'},
  ],
  '8': [
    {'1': '_received_count'},
    {'1': '_loss_rate_pct'},
    {'1': '_clock_offset_ms'},
  ],
};

/// Descriptor for `EquipmentStatusRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equipmentStatusRowDescriptor = $convert.base64Decode(
    'ChJFcXVpcG1lbnRTdGF0dXNSb3cSIQoMZXF1aXBtZW50X2lkGAEgASgJUgtlcXVpcG1lbnRJZB'
    'IlCg5lcXVpcG1lbnRfbmFtZRgCIAEoCVINZXF1aXBtZW50TmFtZRIbCglsaW5lX25hbWUYAyAB'
    'KAlSCGxpbmVOYW1lEh8KC3NuYXBzaG90X2F0GAQgASgJUgpzbmFwc2hvdEF0EisKEWNvbm5lY3'
    'Rpb25fc3RhdHVzGAUgASgJUhBjb25uZWN0aW9uU3RhdHVzEioKDnJlY2VpdmVkX2NvdW50GAYg'
    'ASgFSABSDXJlY2VpdmVkQ291bnSIAQESIQoMd2luZG93X2xhYmVsGAcgASgJUgt3aW5kb3dMYW'
    'JlbBInCg1sb3NzX3JhdGVfcGN0GAggASgBSAFSC2xvc3NSYXRlUGN0iAEBEigKEHRpbWVfc3lu'
    'Y19zdGF0dXMYCSABKAlSDnRpbWVTeW5jU3RhdHVzEisKD2Nsb2NrX29mZnNldF9tcxgKIAEoBU'
    'gCUg1jbG9ja09mZnNldE1ziAEBEigKEGxhc3RfcmVjZWl2ZWRfYXQYCyABKAlSDmxhc3RSZWNl'
    'aXZlZEF0QhEKD19yZWNlaXZlZF9jb3VudEIQCg5fbG9zc19yYXRlX3BjdEISChBfY2xvY2tfb2'
    'Zmc2V0X21z');

@$core.Deprecated('Use listEquipmentStatusRequestDescriptor instead')
const ListEquipmentStatusRequest$json = {
  '1': 'ListEquipmentStatusRequest',
  '2': [
    {'1': 'equipment_ids', '3': 1, '4': 3, '5': 9, '10': 'equipmentIds'},
    {
      '1': 'connection_statuses',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'connectionStatuses'
    },
    {'1': 'lines', '3': 3, '4': 3, '5': 9, '10': 'lines'},
    {
      '1': 'assignment',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.tacit.dashboard.v1.AssignmentFilter',
      '10': 'assignment'
    },
    {'1': 'date', '3': 5, '4': 1, '5': 9, '10': 'date'},
  ],
};

/// Descriptor for `ListEquipmentStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentStatusRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0RXF1aXBtZW50U3RhdHVzUmVxdWVzdBIjCg1lcXVpcG1lbnRfaWRzGAEgAygJUgxlcX'
    'VpcG1lbnRJZHMSLwoTY29ubmVjdGlvbl9zdGF0dXNlcxgCIAMoCVISY29ubmVjdGlvblN0YXR1'
    'c2VzEhQKBWxpbmVzGAMgAygJUgVsaW5lcxJECgphc3NpZ25tZW50GAQgASgLMiQudGFjaXQuZG'
    'FzaGJvYXJkLnYxLkFzc2lnbm1lbnRGaWx0ZXJSCmFzc2lnbm1lbnQSEgoEZGF0ZRgFIAEoCVIE'
    'ZGF0ZQ==');

@$core.Deprecated('Use listEquipmentStatusResponseDescriptor instead')
const ListEquipmentStatusResponse$json = {
  '1': 'ListEquipmentStatusResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.EquipmentStatusRow',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListEquipmentStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEquipmentStatusResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0RXF1aXBtZW50U3RhdHVzUmVzcG9uc2USPAoFaXRlbXMYASADKAsyJi50YWNpdC5kYX'
        'NoYm9hcmQudjEuRXF1aXBtZW50U3RhdHVzUm93UgVpdGVtcw==');

@$core.Deprecated('Use workOrderDescriptor instead')
const WorkOrder$json = {
  '1': 'WorkOrder',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'work_order_no', '3': 2, '4': 1, '5': 9, '10': 'workOrderNo'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'planned_date', '3': 5, '4': 1, '5': 9, '10': 'plannedDate'},
    {'1': 'status', '3': 6, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `WorkOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workOrderDescriptor = $convert.base64Decode(
    'CglXb3JrT3JkZXISIgoNd29ya19vcmRlcl9pZBgBIAEoCVILd29ya09yZGVySWQSIgoNd29ya1'
    '9vcmRlcl9ubxgCIAEoCVILd29ya09yZGVyTm8SHQoKcHJvamVjdF9pZBgDIAEoCVIJcHJvamVj'
    'dElkEhQKBXRpdGxlGAQgASgJUgV0aXRsZRIhCgxwbGFubmVkX2RhdGUYBSABKAlSC3BsYW5uZW'
    'REYXRlEhYKBnN0YXR1cxgGIAEoCVIGc3RhdHVz');

@$core.Deprecated('Use listWorkOrdersRequestDescriptor instead')
const ListWorkOrdersRequest$json = {
  '1': 'ListWorkOrdersRequest',
};

/// Descriptor for `ListWorkOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkOrdersRequestDescriptor =
    $convert.base64Decode('ChVMaXN0V29ya09yZGVyc1JlcXVlc3Q=');

@$core.Deprecated('Use listWorkOrdersResponseDescriptor instead')
const ListWorkOrdersResponse$json = {
  '1': 'ListWorkOrdersResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.WorkOrder',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListWorkOrdersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkOrdersResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0V29ya09yZGVyc1Jlc3BvbnNlEjMKBWl0ZW1zGAEgAygLMh0udGFjaXQuZGFzaGJvYX'
        'JkLnYxLldvcmtPcmRlclIFaXRlbXM=');

@$core.Deprecated('Use jointDescriptor instead')
const Joint$json = {
  '1': 'Joint',
  '2': [
    {'1': 'joint_id', '3': 1, '4': 1, '5': 9, '10': 'jointId'},
    {'1': 'joint_no', '3': 2, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'work_order_id', '3': 4, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'location', '3': 5, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `Joint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jointDescriptor = $convert.base64Decode(
    'CgVKb2ludBIZCghqb2ludF9pZBgBIAEoCVIHam9pbnRJZBIZCghqb2ludF9ubxgCIAEoCVIHam'
    '9pbnRObxISCgRuYW1lGAMgASgJUgRuYW1lEiIKDXdvcmtfb3JkZXJfaWQYBCABKAlSC3dvcmtP'
    'cmRlcklkEhoKCGxvY2F0aW9uGAUgASgJUghsb2NhdGlvbg==');

@$core.Deprecated('Use listJointsRequestDescriptor instead')
const ListJointsRequest$json = {
  '1': 'ListJointsRequest',
};

/// Descriptor for `ListJointsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJointsRequestDescriptor =
    $convert.base64Decode('ChFMaXN0Sm9pbnRzUmVxdWVzdA==');

@$core.Deprecated('Use listJointsResponseDescriptor instead')
const ListJointsResponse$json = {
  '1': 'ListJointsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.Joint',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListJointsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJointsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0Sm9pbnRzUmVzcG9uc2USLwoFaXRlbXMYASADKAsyGS50YWNpdC5kYXNoYm9hcmQudj'
    'EuSm9pbnRSBWl0ZW1z');

@$core.Deprecated('Use workerDescriptor instead')
const Worker$json = {
  '1': 'Worker',
  '2': [
    {'1': 'worker_id', '3': 1, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'worker_name', '3': 2, '4': 1, '5': 9, '10': 'workerName'},
    {'1': 'team', '3': 3, '4': 1, '5': 9, '10': 'team'},
    {'1': 'is_master', '3': 4, '4': 1, '5': 8, '10': 'isMaster'},
  ],
};

/// Descriptor for `Worker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workerDescriptor = $convert.base64Decode(
    'CgZXb3JrZXISGwoJd29ya2VyX2lkGAEgASgJUgh3b3JrZXJJZBIfCgt3b3JrZXJfbmFtZRgCIA'
    'EoCVIKd29ya2VyTmFtZRISCgR0ZWFtGAMgASgJUgR0ZWFtEhsKCWlzX21hc3RlchgEIAEoCFII'
    'aXNNYXN0ZXI=');

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
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.Worker',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListWorkersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkersResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0V29ya2Vyc1Jlc3BvbnNlEjAKBWl0ZW1zGAEgAygLMhoudGFjaXQuZGFzaGJvYXJkLn'
    'YxLldvcmtlclIFaXRlbXM=');

@$core.Deprecated('Use workHistoryDescriptor instead')
const WorkHistory$json = {
  '1': 'WorkHistory',
  '2': [
    {'1': 'history_id', '3': 1, '4': 1, '5': 9, '10': 'historyId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'work_order_id', '3': 3, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'joint_id', '3': 4, '4': 1, '5': 9, '10': 'jointId'},
    {'1': 'worker_id', '3': 5, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'equipment_id', '3': 6, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'worked_at', '3': 7, '4': 1, '5': 9, '10': 'workedAt'},
    {'1': 'work_order_no', '3': 8, '4': 1, '5': 9, '10': 'workOrderNo'},
    {'1': 'title', '3': 9, '4': 1, '5': 9, '10': 'title'},
    {'1': 'joint_no', '3': 10, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'joint_name', '3': 11, '4': 1, '5': 9, '10': 'jointName'},
    {'1': 'worker_name', '3': 12, '4': 1, '5': 9, '10': 'workerName'},
    {'1': 'equipment_name', '3': 13, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'pass_count', '3': 14, '4': 1, '5': 5, '10': 'passCount'},
    {'1': 'attachment_count', '3': 15, '4': 1, '5': 5, '10': 'attachmentCount'},
  ],
};

/// Descriptor for `WorkHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workHistoryDescriptor = $convert.base64Decode(
    'CgtXb3JrSGlzdG9yeRIdCgpoaXN0b3J5X2lkGAEgASgJUgloaXN0b3J5SWQSHQoKY29tbW9uX2'
    'tleRgCIAEoCVIJY29tbW9uS2V5EiIKDXdvcmtfb3JkZXJfaWQYAyABKAlSC3dvcmtPcmRlcklk'
    'EhkKCGpvaW50X2lkGAQgASgJUgdqb2ludElkEhsKCXdvcmtlcl9pZBgFIAEoCVIId29ya2VySW'
    'QSIQoMZXF1aXBtZW50X2lkGAYgASgJUgtlcXVpcG1lbnRJZBIbCgl3b3JrZWRfYXQYByABKAlS'
    'CHdvcmtlZEF0EiIKDXdvcmtfb3JkZXJfbm8YCCABKAlSC3dvcmtPcmRlck5vEhQKBXRpdGxlGA'
    'kgASgJUgV0aXRsZRIZCghqb2ludF9ubxgKIAEoCVIHam9pbnRObxIdCgpqb2ludF9uYW1lGAsg'
    'ASgJUglqb2ludE5hbWUSHwoLd29ya2VyX25hbWUYDCABKAlSCndvcmtlck5hbWUSJQoOZXF1aX'
    'BtZW50X25hbWUYDSABKAlSDWVxdWlwbWVudE5hbWUSHQoKcGFzc19jb3VudBgOIAEoBVIJcGFz'
    'c0NvdW50EikKEGF0dGFjaG1lbnRfY291bnQYDyABKAVSD2F0dGFjaG1lbnRDb3VudA==');

@$core.Deprecated('Use listWorkHistoryRequestDescriptor instead')
const ListWorkHistoryRequest$json = {
  '1': 'ListWorkHistoryRequest',
  '2': [
    {'1': 'common_key', '3': 1, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'work_order_id', '3': 2, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'joint_id', '3': 3, '4': 1, '5': 9, '10': 'jointId'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'equipment_id', '3': 5, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'from', '3': 6, '4': 1, '5': 9, '10': 'from'},
    {'1': 'to', '3': 7, '4': 1, '5': 9, '10': 'to'},
    {'1': 'history_id', '3': 8, '4': 1, '5': 9, '10': 'historyId'},
    {'1': 'limit', '3': 9, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 10, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListWorkHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkHistoryRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0V29ya0hpc3RvcnlSZXF1ZXN0Eh0KCmNvbW1vbl9rZXkYASABKAlSCWNvbW1vbktleR'
    'IiCg13b3JrX29yZGVyX2lkGAIgASgJUgt3b3JrT3JkZXJJZBIZCghqb2ludF9pZBgDIAEoCVIH'
    'am9pbnRJZBIbCgl3b3JrZXJfaWQYBCABKAlSCHdvcmtlcklkEiEKDGVxdWlwbWVudF9pZBgFIA'
    'EoCVILZXF1aXBtZW50SWQSEgoEZnJvbRgGIAEoCVIEZnJvbRIOCgJ0bxgHIAEoCVICdG8SHQoK'
    'aGlzdG9yeV9pZBgIIAEoCVIJaGlzdG9yeUlkEhQKBWxpbWl0GAkgASgFUgVsaW1pdBIWCgZvZm'
    'ZzZXQYCiABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listWorkHistoryResponseDescriptor instead')
const ListWorkHistoryResponse$json = {
  '1': 'ListWorkHistoryResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.WorkHistory',
      '10': 'items'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListWorkHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkHistoryResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0V29ya0hpc3RvcnlSZXNwb25zZRI1CgVpdGVtcxgBIAMoCzIfLnRhY2l0LmRhc2hib2'
    'FyZC52MS5Xb3JrSGlzdG9yeVIFaXRlbXMSHwoLdG90YWxfY291bnQYAiABKAVSCnRvdGFsQ291'
    'bnQ=');

@$core.Deprecated('Use workAttachmentDescriptor instead')
const WorkAttachment$json = {
  '1': 'WorkAttachment',
  '2': [
    {'1': 'attachment_id', '3': 1, '4': 1, '5': 9, '10': 'attachmentId'},
    {'1': 'history_id', '3': 2, '4': 1, '5': 9, '10': 'historyId'},
    {'1': 'file_type', '3': 3, '4': 1, '5': 9, '10': 'fileType'},
    {'1': 'file_name', '3': 4, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
    {'1': 'content', '3': 6, '4': 1, '5': 9, '10': 'content'},
    {'1': 'file_url', '3': 7, '4': 1, '5': 9, '10': 'fileUrl'},
  ],
};

/// Descriptor for `WorkAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workAttachmentDescriptor = $convert.base64Decode(
    'Cg5Xb3JrQXR0YWNobWVudBIjCg1hdHRhY2htZW50X2lkGAEgASgJUgxhdHRhY2htZW50SWQSHQ'
    'oKaGlzdG9yeV9pZBgCIAEoCVIJaGlzdG9yeUlkEhsKCWZpbGVfdHlwZRgDIAEoCVIIZmlsZVR5'
    'cGUSGwoJZmlsZV9uYW1lGAQgASgJUghmaWxlTmFtZRISCgRub3RlGAUgASgJUgRub3RlEhgKB2'
    'NvbnRlbnQYBiABKAlSB2NvbnRlbnQSGQoIZmlsZV91cmwYByABKAlSB2ZpbGVVcmw=');

@$core.Deprecated('Use listWorkAttachmentsRequestDescriptor instead')
const ListWorkAttachmentsRequest$json = {
  '1': 'ListWorkAttachmentsRequest',
};

/// Descriptor for `ListWorkAttachmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkAttachmentsRequestDescriptor =
    $convert.base64Decode('ChpMaXN0V29ya0F0dGFjaG1lbnRzUmVxdWVzdA==');

@$core.Deprecated('Use listWorkAttachmentsResponseDescriptor instead')
const ListWorkAttachmentsResponse$json = {
  '1': 'ListWorkAttachmentsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.WorkAttachment',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListWorkAttachmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkAttachmentsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0V29ya0F0dGFjaG1lbnRzUmVzcG9uc2USOAoFaXRlbXMYASADKAsyIi50YWNpdC5kYX'
        'NoYm9hcmQudjEuV29ya0F0dGFjaG1lbnRSBWl0ZW1z');

@$core.Deprecated('Use passDescriptor instead')
const Pass$json = {
  '1': 'Pass',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {
      '1': 'pass_no',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'passNo',
      '17': true
    },
    {'1': 'pass_name', '3': 4, '4': 1, '5': 9, '10': 'passName'},
    {'1': 'master_profile_id', '3': 5, '4': 1, '5': 9, '10': 'masterProfileId'},
    {'1': 'control_worker_id', '3': 6, '4': 1, '5': 9, '10': 'controlWorkerId'},
  ],
  '8': [
    {'1': '_pass_no'},
  ],
};

/// Descriptor for `Pass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passDescriptor = $convert.base64Decode(
    'CgRQYXNzEhcKB3Bhc3NfaWQYASABKAlSBnBhc3NJZBIdCgpjb21tb25fa2V5GAIgASgJUgljb2'
    '1tb25LZXkSHAoHcGFzc19ubxgDIAEoBUgAUgZwYXNzTm+IAQESGwoJcGFzc19uYW1lGAQgASgJ'
    'UghwYXNzTmFtZRIqChFtYXN0ZXJfcHJvZmlsZV9pZBgFIAEoCVIPbWFzdGVyUHJvZmlsZUlkEi'
    'oKEWNvbnRyb2xfd29ya2VyX2lkGAYgASgJUg9jb250cm9sV29ya2VySWRCCgoIX3Bhc3Nfbm8=');

@$core.Deprecated('Use listPassesRequestDescriptor instead')
const ListPassesRequest$json = {
  '1': 'ListPassesRequest',
  '2': [
    {'1': 'common_key', '3': 1, '4': 1, '5': 9, '10': 'commonKey'},
  ],
};

/// Descriptor for `ListPassesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPassesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0UGFzc2VzUmVxdWVzdBIdCgpjb21tb25fa2V5GAEgASgJUgljb21tb25LZXk=');

@$core.Deprecated('Use listPassesResponseDescriptor instead')
const ListPassesResponse$json = {
  '1': 'ListPassesResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.Pass',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListPassesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPassesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0UGFzc2VzUmVzcG9uc2USLgoFaXRlbXMYASADKAsyGC50YWNpdC5kYXNoYm9hcmQudj'
    'EuUGFzc1IFaXRlbXM=');

@$core.Deprecated('Use waveformPointDescriptor instead')
const WaveformPoint$json = {
  '1': 'WaveformPoint',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'series_id', '3': 2, '4': 1, '5': 9, '10': 'seriesId'},
    {'1': 'pass_id', '3': 3, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'common_key', '3': 4, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'series_role', '3': 5, '4': 1, '5': 9, '10': 'seriesRole'},
    {'1': 'master_profile_id', '3': 6, '4': 1, '5': 9, '10': 'masterProfileId'},
    {'1': 'worker_id', '3': 7, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'robot_id', '3': 8, '4': 1, '5': 9, '10': 'robotId'},
    {'1': 'time_ms', '3': 9, '4': 1, '5': 5, '10': 'timeMs'},
    {
      '1': 'current_a',
      '3': 10,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'currentA',
      '17': true
    },
    {
      '1': 'voltage_v',
      '3': 11,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'voltageV',
      '17': true
    },
    {
      '1': 'wire_feed_speed_mpm',
      '3': 12,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'wireFeedSpeedMpm',
      '17': true
    },
    {
      '1': 'rotation_speed_rpm',
      '3': 13,
      '4': 1,
      '5': 1,
      '9': 3,
      '10': 'rotationSpeedRpm',
      '17': true
    },
  ],
  '8': [
    {'1': '_current_a'},
    {'1': '_voltage_v'},
    {'1': '_wire_feed_speed_mpm'},
    {'1': '_rotation_speed_rpm'},
  ],
};

/// Descriptor for `WaveformPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waveformPointDescriptor = $convert.base64Decode(
    'Cg1XYXZlZm9ybVBvaW50Eg4KAmlkGAEgASgDUgJpZBIbCglzZXJpZXNfaWQYAiABKAlSCHNlcm'
    'llc0lkEhcKB3Bhc3NfaWQYAyABKAlSBnBhc3NJZBIdCgpjb21tb25fa2V5GAQgASgJUgljb21t'
    'b25LZXkSHwoLc2VyaWVzX3JvbGUYBSABKAlSCnNlcmllc1JvbGUSKgoRbWFzdGVyX3Byb2ZpbG'
    'VfaWQYBiABKAlSD21hc3RlclByb2ZpbGVJZBIbCgl3b3JrZXJfaWQYByABKAlSCHdvcmtlcklk'
    'EhkKCHJvYm90X2lkGAggASgJUgdyb2JvdElkEhcKB3RpbWVfbXMYCSABKAVSBnRpbWVNcxIgCg'
    'ljdXJyZW50X2EYCiABKAFIAFIIY3VycmVudEGIAQESIAoJdm9sdGFnZV92GAsgASgBSAFSCHZv'
    'bHRhZ2VWiAEBEjIKE3dpcmVfZmVlZF9zcGVlZF9tcG0YDCABKAFIAlIQd2lyZUZlZWRTcGVlZE'
    '1wbYgBARIxChJyb3RhdGlvbl9zcGVlZF9ycG0YDSABKAFIA1IQcm90YXRpb25TcGVlZFJwbYgB'
    'AUIMCgpfY3VycmVudF9hQgwKCl92b2x0YWdlX3ZCFgoUX3dpcmVfZmVlZF9zcGVlZF9tcG1CFQ'
    'oTX3JvdGF0aW9uX3NwZWVkX3JwbQ==');

@$core.Deprecated('Use listWaveformSeriesRequestDescriptor instead')
const ListWaveformSeriesRequest$json = {
  '1': 'ListWaveformSeriesRequest',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 9, '10': 'passId'},
  ],
};

/// Descriptor for `ListWaveformSeriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWaveformSeriesRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0V2F2ZWZvcm1TZXJpZXNSZXF1ZXN0EhcKB3Bhc3NfaWQYASABKAlSBnBhc3NJZA==');

@$core.Deprecated('Use listWaveformSeriesResponseDescriptor instead')
const ListWaveformSeriesResponse$json = {
  '1': 'ListWaveformSeriesResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.WaveformPoint',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListWaveformSeriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWaveformSeriesResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0V2F2ZWZvcm1TZXJpZXNSZXNwb25zZRI3CgVpdGVtcxgBIAMoCzIhLnRhY2l0LmRhc2'
        'hib2FyZC52MS5XYXZlZm9ybVBvaW50UgVpdGVtcw==');

@$core.Deprecated('Use passWaveformPointDescriptor instead')
const PassWaveformPoint$json = {
  '1': 'PassWaveformPoint',
  '2': [
    {'1': 't', '3': 1, '4': 1, '5': 5, '10': 't'},
    {
      '1': 'current_a',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'currentA',
      '17': true
    },
    {
      '1': 'voltage_v',
      '3': 3,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'voltageV',
      '17': true
    },
    {
      '1': 'wire_feed_speed_mpm',
      '3': 4,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'wireFeedSpeedMpm',
      '17': true
    },
    {
      '1': 'rotation_speed_rpm',
      '3': 5,
      '4': 1,
      '5': 1,
      '9': 3,
      '10': 'rotationSpeedRpm',
      '17': true
    },
  ],
  '8': [
    {'1': '_current_a'},
    {'1': '_voltage_v'},
    {'1': '_wire_feed_speed_mpm'},
    {'1': '_rotation_speed_rpm'},
  ],
};

/// Descriptor for `PassWaveformPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passWaveformPointDescriptor = $convert.base64Decode(
    'ChFQYXNzV2F2ZWZvcm1Qb2ludBIMCgF0GAEgASgFUgF0EiAKCWN1cnJlbnRfYRgCIAEoAUgAUg'
    'hjdXJyZW50QYgBARIgCgl2b2x0YWdlX3YYAyABKAFIAVIIdm9sdGFnZVaIAQESMgoTd2lyZV9m'
    'ZWVkX3NwZWVkX21wbRgEIAEoAUgCUhB3aXJlRmVlZFNwZWVkTXBtiAEBEjEKEnJvdGF0aW9uX3'
    'NwZWVkX3JwbRgFIAEoAUgDUhByb3RhdGlvblNwZWVkUnBtiAEBQgwKCl9jdXJyZW50X2FCDAoK'
    'X3ZvbHRhZ2VfdkIWChRfd2lyZV9mZWVkX3NwZWVkX21wbUIVChNfcm90YXRpb25fc3BlZWRfcn'
    'Bt');

@$core.Deprecated('Use passWaveformSeriesDescriptor instead')
const PassWaveformSeries$json = {
  '1': 'PassWaveformSeries',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'master_profile_id', '3': 3, '4': 1, '5': 9, '10': 'masterProfileId'},
    {'1': 'worker_id', '3': 4, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'robot_id', '3': 5, '4': 1, '5': 9, '10': 'robotId'},
    {
      '1': 'points',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.PassWaveformPoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `PassWaveformSeries`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passWaveformSeriesDescriptor = $convert.base64Decode(
    'ChJQYXNzV2F2ZWZvcm1TZXJpZXMSEgoEcm9sZRgBIAEoCVIEcm9sZRIhCgxkaXNwbGF5X25hbW'
    'UYAiABKAlSC2Rpc3BsYXlOYW1lEioKEW1hc3Rlcl9wcm9maWxlX2lkGAMgASgJUg9tYXN0ZXJQ'
    'cm9maWxlSWQSGwoJd29ya2VyX2lkGAQgASgJUgh3b3JrZXJJZBIZCghyb2JvdF9pZBgFIAEoCV'
    'IHcm9ib3RJZBI9CgZwb2ludHMYBiADKAsyJS50YWNpdC5kYXNoYm9hcmQudjEuUGFzc1dhdmVm'
    'b3JtUG9pbnRSBnBvaW50cw==');

@$core.Deprecated('Use getPassWaveformRequestDescriptor instead')
const GetPassWaveformRequest$json = {
  '1': 'GetPassWaveformRequest',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'normalize', '3': 2, '4': 1, '5': 9, '10': 'normalize'},
    {'1': 'roles', '3': 3, '4': 3, '5': 9, '10': 'roles'},
  ],
};

/// Descriptor for `GetPassWaveformRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPassWaveformRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRQYXNzV2F2ZWZvcm1SZXF1ZXN0EhcKB3Bhc3NfaWQYASABKAlSBnBhc3NJZBIcCglub3'
        'JtYWxpemUYAiABKAlSCW5vcm1hbGl6ZRIUCgVyb2xlcxgDIAMoCVIFcm9sZXM=');

@$core.Deprecated('Use getPassWaveformResponseDescriptor instead')
const GetPassWaveformResponse$json = {
  '1': 'GetPassWaveformResponse',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'pass_name', '3': 3, '4': 1, '5': 9, '10': 'passName'},
    {'1': 'normalize', '3': 4, '4': 1, '5': 9, '10': 'normalize'},
    {
      '1': 'series',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.PassWaveformSeries',
      '10': 'series'
    },
  ],
};

/// Descriptor for `GetPassWaveformResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPassWaveformResponseDescriptor = $convert.base64Decode(
    'ChdHZXRQYXNzV2F2ZWZvcm1SZXNwb25zZRIXCgdwYXNzX2lkGAEgASgJUgZwYXNzSWQSHQoKY2'
    '9tbW9uX2tleRgCIAEoCVIJY29tbW9uS2V5EhsKCXBhc3NfbmFtZRgDIAEoCVIIcGFzc05hbWUS'
    'HAoJbm9ybWFsaXplGAQgASgJUglub3JtYWxpemUSPgoGc2VyaWVzGAUgAygLMiYudGFjaXQuZG'
    'FzaGJvYXJkLnYxLlBhc3NXYXZlZm9ybVNlcmllc1IGc2VyaWVz');

@$core.Deprecated('Use qualityResultDescriptor instead')
const QualityResult$json = {
  '1': 'QualityResult',
  '2': [
    {'1': 'quality_result_id', '3': 1, '4': 1, '5': 9, '10': 'qualityResultId'},
    {'1': 'paper_doc_no', '3': 2, '4': 1, '5': 9, '10': 'paperDocNo'},
    {'1': 'common_key', '3': 3, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'pass_id', '3': 4, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'segment_id', '3': 5, '4': 1, '5': 9, '10': 'segmentId'},
    {'1': 'inspected_at', '3': 6, '4': 1, '5': 9, '10': 'inspectedAt'},
    {'1': 'inspector_name', '3': 7, '4': 1, '5': 9, '10': 'inspectorName'},
    {'1': 'judgement', '3': 8, '4': 1, '5': 9, '10': 'judgement'},
    {'1': 'issue_summary', '3': 9, '4': 1, '5': 9, '10': 'issueSummary'},
    {'1': 'item_name', '3': 10, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'item_result', '3': 11, '4': 1, '5': 9, '10': 'itemResult'},
    {'1': 'item_note', '3': 12, '4': 1, '5': 9, '10': 'itemNote'},
    {
      '1': 'media',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.QualityMedia',
      '10': 'media'
    },
  ],
};

/// Descriptor for `QualityResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityResultDescriptor = $convert.base64Decode(
    'Cg1RdWFsaXR5UmVzdWx0EioKEXF1YWxpdHlfcmVzdWx0X2lkGAEgASgJUg9xdWFsaXR5UmVzdW'
    'x0SWQSIAoMcGFwZXJfZG9jX25vGAIgASgJUgpwYXBlckRvY05vEh0KCmNvbW1vbl9rZXkYAyAB'
    'KAlSCWNvbW1vbktleRIXCgdwYXNzX2lkGAQgASgJUgZwYXNzSWQSHQoKc2VnbWVudF9pZBgFIA'
    'EoCVIJc2VnbWVudElkEiEKDGluc3BlY3RlZF9hdBgGIAEoCVILaW5zcGVjdGVkQXQSJQoOaW5z'
    'cGVjdG9yX25hbWUYByABKAlSDWluc3BlY3Rvck5hbWUSHAoJanVkZ2VtZW50GAggASgJUglqdW'
    'RnZW1lbnQSIwoNaXNzdWVfc3VtbWFyeRgJIAEoCVIMaXNzdWVTdW1tYXJ5EhsKCWl0ZW1fbmFt'
    'ZRgKIAEoCVIIaXRlbU5hbWUSHwoLaXRlbV9yZXN1bHQYCyABKAlSCml0ZW1SZXN1bHQSGwoJaX'
    'RlbV9ub3RlGAwgASgJUghpdGVtTm90ZRI2CgVtZWRpYRgNIAMoCzIgLnRhY2l0LmRhc2hib2Fy'
    'ZC52MS5RdWFsaXR5TWVkaWFSBW1lZGlh');

@$core.Deprecated('Use qualityMediaDescriptor instead')
const QualityMedia$json = {
  '1': 'QualityMedia',
  '2': [
    {'1': 'media_type', '3': 1, '4': 1, '5': 9, '10': 'mediaType'},
    {'1': 'file_path', '3': 2, '4': 1, '5': 9, '10': 'filePath'},
    {
      '1': 'page_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'pageCount',
      '17': true
    },
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
  ],
  '8': [
    {'1': '_page_count'},
  ],
};

/// Descriptor for `QualityMedia`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityMediaDescriptor = $convert.base64Decode(
    'CgxRdWFsaXR5TWVkaWESHQoKbWVkaWFfdHlwZRgBIAEoCVIJbWVkaWFUeXBlEhsKCWZpbGVfcG'
    'F0aBgCIAEoCVIIZmlsZVBhdGgSIgoKcGFnZV9jb3VudBgDIAEoBUgAUglwYWdlQ291bnSIAQES'
    'EAoDdXJsGAQgASgJUgN1cmxCDQoLX3BhZ2VfY291bnQ=');

@$core.Deprecated('Use listQualityResultsRequestDescriptor instead')
const ListQualityResultsRequest$json = {
  '1': 'ListQualityResultsRequest',
  '2': [
    {'1': 'common_key', '3': 1, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'pass_id', '3': 2, '4': 1, '5': 9, '10': 'passId'},
  ],
};

/// Descriptor for `ListQualityResultsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQualityResultsRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0UXVhbGl0eVJlc3VsdHNSZXF1ZXN0Eh0KCmNvbW1vbl9rZXkYASABKAlSCWNvbW1vbk'
        'tleRIXCgdwYXNzX2lkGAIgASgJUgZwYXNzSWQ=');

@$core.Deprecated('Use listQualityResultsResponseDescriptor instead')
const ListQualityResultsResponse$json = {
  '1': 'ListQualityResultsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.QualityResult',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListQualityResultsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQualityResultsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0UXVhbGl0eVJlc3VsdHNSZXNwb25zZRI3CgVpdGVtcxgBIAMoCzIhLnRhY2l0LmRhc2'
        'hib2FyZC52MS5RdWFsaXR5UmVzdWx0UgVpdGVtcw==');

@$core.Deprecated('Use qualityLinkDescriptor instead')
const QualityLink$json = {
  '1': 'QualityLink',
  '2': [
    {'1': 'link_id', '3': 1, '4': 1, '5': 9, '10': 'linkId'},
    {'1': 'common_key', '3': 2, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'quality_result_id', '3': 3, '4': 1, '5': 9, '10': 'qualityResultId'},
    {'1': 'pass_id', '3': 4, '4': 1, '5': 9, '10': 'passId'},
    {'1': 'segment_id', '3': 5, '4': 1, '5': 9, '10': 'segmentId'},
    {
      '1': 'segment_start_ms',
      '3': 6,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'segmentStartMs',
      '17': true
    },
    {
      '1': 'segment_end_ms',
      '3': 7,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'segmentEndMs',
      '17': true
    },
    {'1': 'note', '3': 8, '4': 1, '5': 9, '10': 'note'},
  ],
  '8': [
    {'1': '_segment_start_ms'},
    {'1': '_segment_end_ms'},
  ],
};

/// Descriptor for `QualityLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityLinkDescriptor = $convert.base64Decode(
    'CgtRdWFsaXR5TGluaxIXCgdsaW5rX2lkGAEgASgJUgZsaW5rSWQSHQoKY29tbW9uX2tleRgCIA'
    'EoCVIJY29tbW9uS2V5EioKEXF1YWxpdHlfcmVzdWx0X2lkGAMgASgJUg9xdWFsaXR5UmVzdWx0'
    'SWQSFwoHcGFzc19pZBgEIAEoCVIGcGFzc0lkEh0KCnNlZ21lbnRfaWQYBSABKAlSCXNlZ21lbn'
    'RJZBItChBzZWdtZW50X3N0YXJ0X21zGAYgASgFSABSDnNlZ21lbnRTdGFydE1ziAEBEikKDnNl'
    'Z21lbnRfZW5kX21zGAcgASgFSAFSDHNlZ21lbnRFbmRNc4gBARISCgRub3RlGAggASgJUgRub3'
    'RlQhMKEV9zZWdtZW50X3N0YXJ0X21zQhEKD19zZWdtZW50X2VuZF9tcw==');

@$core.Deprecated('Use listQualityLinksRequestDescriptor instead')
const ListQualityLinksRequest$json = {
  '1': 'ListQualityLinksRequest',
  '2': [
    {'1': 'common_key', '3': 1, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'pass_id', '3': 2, '4': 1, '5': 9, '10': 'passId'},
  ],
};

/// Descriptor for `ListQualityLinksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQualityLinksRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UXVhbGl0eUxpbmtzUmVxdWVzdBIdCgpjb21tb25fa2V5GAEgASgJUgljb21tb25LZX'
        'kSFwoHcGFzc19pZBgCIAEoCVIGcGFzc0lk');

@$core.Deprecated('Use listQualityLinksResponseDescriptor instead')
const ListQualityLinksResponse$json = {
  '1': 'ListQualityLinksResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.tacit.dashboard.v1.QualityLink',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListQualityLinksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQualityLinksResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0UXVhbGl0eUxpbmtzUmVzcG9uc2USNQoFaXRlbXMYASADKAsyHy50YWNpdC5kYXNoYm'
        '9hcmQudjEuUXVhbGl0eUxpbmtSBWl0ZW1z');

@$core.Deprecated('Use contextDescriptor instead')
const Context$json = {
  '1': 'Context',
  '2': [
    {'1': 'common_key', '3': 1, '4': 1, '5': 9, '10': 'commonKey'},
    {'1': 'work_order_id', '3': 2, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'work_order_no', '3': 3, '4': 1, '5': 9, '10': 'workOrderNo'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'joint_id', '3': 5, '4': 1, '5': 9, '10': 'jointId'},
    {'1': 'joint_no', '3': 6, '4': 1, '5': 9, '10': 'jointNo'},
    {'1': 'joint_name', '3': 7, '4': 1, '5': 9, '10': 'jointName'},
    {'1': 'worker_id', '3': 8, '4': 1, '5': 9, '10': 'workerId'},
    {'1': 'worker_name', '3': 9, '4': 1, '5': 9, '10': 'workerName'},
    {'1': 'equipment_id', '3': 10, '4': 1, '5': 9, '10': 'equipmentId'},
    {'1': 'equipment_name', '3': 11, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'worked_at', '3': 12, '4': 1, '5': 9, '10': 'workedAt'},
  ],
};

/// Descriptor for `Context`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contextDescriptor = $convert.base64Decode(
    'CgdDb250ZXh0Eh0KCmNvbW1vbl9rZXkYASABKAlSCWNvbW1vbktleRIiCg13b3JrX29yZGVyX2'
    'lkGAIgASgJUgt3b3JrT3JkZXJJZBIiCg13b3JrX29yZGVyX25vGAMgASgJUgt3b3JrT3JkZXJO'
    'bxIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSGQoIam9pbnRfaWQYBSABKAlSB2pvaW50SWQSGQoIam'
    '9pbnRfbm8YBiABKAlSB2pvaW50Tm8SHQoKam9pbnRfbmFtZRgHIAEoCVIJam9pbnROYW1lEhsK'
    'CXdvcmtlcl9pZBgIIAEoCVIId29ya2VySWQSHwoLd29ya2VyX25hbWUYCSABKAlSCndvcmtlck'
    '5hbWUSIQoMZXF1aXBtZW50X2lkGAogASgJUgtlcXVpcG1lbnRJZBIlCg5lcXVpcG1lbnRfbmFt'
    'ZRgLIAEoCVINZXF1aXBtZW50TmFtZRIbCgl3b3JrZWRfYXQYDCABKAlSCHdvcmtlZEF0');

@$core.Deprecated('Use getContextRequestDescriptor instead')
const GetContextRequest$json = {
  '1': 'GetContextRequest',
  '2': [
    {'1': 'common_key', '3': 1, '4': 1, '5': 9, '10': 'commonKey'},
  ],
};

/// Descriptor for `GetContextRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getContextRequestDescriptor = $convert.base64Decode(
    'ChFHZXRDb250ZXh0UmVxdWVzdBIdCgpjb21tb25fa2V5GAEgASgJUgljb21tb25LZXk=');

@$core.Deprecated('Use getContextResponseDescriptor instead')
const GetContextResponse$json = {
  '1': 'GetContextResponse',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.tacit.dashboard.v1.Context',
      '10': 'context'
    },
  ],
};

/// Descriptor for `GetContextResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getContextResponseDescriptor = $convert.base64Decode(
    'ChJHZXRDb250ZXh0UmVzcG9uc2USNQoHY29udGV4dBgBIAEoCzIbLnRhY2l0LmRhc2hib2FyZC'
    '52MS5Db250ZXh0Ugdjb250ZXh0');

const $core.Map<$core.String, $core.dynamic> DashboardServiceBase$json = {
  '1': 'DashboardService',
  '2': [
    {
      '1': 'ListEquipment',
      '2': '.tacit.dashboard.v1.ListEquipmentRequest',
      '3': '.tacit.dashboard.v1.ListEquipmentResponse'
    },
    {
      '1': 'ListProjects',
      '2': '.tacit.dashboard.v1.ListProjectsRequest',
      '3': '.tacit.dashboard.v1.ListProjectsResponse'
    },
    {
      '1': 'ListCollectionAssignments',
      '2': '.tacit.dashboard.v1.ListCollectionAssignmentsRequest',
      '3': '.tacit.dashboard.v1.ListCollectionAssignmentsResponse'
    },
    {
      '1': 'ListCollectionEvents',
      '2': '.tacit.dashboard.v1.ListCollectionEventsRequest',
      '3': '.tacit.dashboard.v1.ListCollectionEventsResponse'
    },
    {
      '1': 'ListEquipmentStatus',
      '2': '.tacit.dashboard.v1.ListEquipmentStatusRequest',
      '3': '.tacit.dashboard.v1.ListEquipmentStatusResponse'
    },
    {
      '1': 'ListWorkOrders',
      '2': '.tacit.dashboard.v1.ListWorkOrdersRequest',
      '3': '.tacit.dashboard.v1.ListWorkOrdersResponse'
    },
    {
      '1': 'ListJoints',
      '2': '.tacit.dashboard.v1.ListJointsRequest',
      '3': '.tacit.dashboard.v1.ListJointsResponse'
    },
    {
      '1': 'ListWorkers',
      '2': '.tacit.dashboard.v1.ListWorkersRequest',
      '3': '.tacit.dashboard.v1.ListWorkersResponse'
    },
    {
      '1': 'ListWorkHistory',
      '2': '.tacit.dashboard.v1.ListWorkHistoryRequest',
      '3': '.tacit.dashboard.v1.ListWorkHistoryResponse'
    },
    {
      '1': 'ListWorkAttachments',
      '2': '.tacit.dashboard.v1.ListWorkAttachmentsRequest',
      '3': '.tacit.dashboard.v1.ListWorkAttachmentsResponse'
    },
    {
      '1': 'ListPasses',
      '2': '.tacit.dashboard.v1.ListPassesRequest',
      '3': '.tacit.dashboard.v1.ListPassesResponse'
    },
    {
      '1': 'ListWaveformSeries',
      '2': '.tacit.dashboard.v1.ListWaveformSeriesRequest',
      '3': '.tacit.dashboard.v1.ListWaveformSeriesResponse'
    },
    {
      '1': 'GetPassWaveform',
      '2': '.tacit.dashboard.v1.GetPassWaveformRequest',
      '3': '.tacit.dashboard.v1.GetPassWaveformResponse'
    },
    {
      '1': 'ListQualityResults',
      '2': '.tacit.dashboard.v1.ListQualityResultsRequest',
      '3': '.tacit.dashboard.v1.ListQualityResultsResponse'
    },
    {
      '1': 'ListQualityLinks',
      '2': '.tacit.dashboard.v1.ListQualityLinksRequest',
      '3': '.tacit.dashboard.v1.ListQualityLinksResponse'
    },
    {
      '1': 'GetContext',
      '2': '.tacit.dashboard.v1.GetContextRequest',
      '3': '.tacit.dashboard.v1.GetContextResponse'
    },
  ],
};

@$core.Deprecated('Use dashboardServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DashboardServiceBase$messageJson = {
  '.tacit.dashboard.v1.ListEquipmentRequest': ListEquipmentRequest$json,
  '.tacit.dashboard.v1.ListEquipmentResponse': ListEquipmentResponse$json,
  '.tacit.dashboard.v1.Equipment': Equipment$json,
  '.tacit.dashboard.v1.ListProjectsRequest': ListProjectsRequest$json,
  '.tacit.dashboard.v1.ListProjectsResponse': ListProjectsResponse$json,
  '.tacit.dashboard.v1.Project': Project$json,
  '.tacit.dashboard.v1.ListCollectionAssignmentsRequest':
      ListCollectionAssignmentsRequest$json,
  '.tacit.dashboard.v1.ListCollectionAssignmentsResponse':
      ListCollectionAssignmentsResponse$json,
  '.tacit.dashboard.v1.CollectionAssignment': CollectionAssignment$json,
  '.tacit.dashboard.v1.ListCollectionEventsRequest':
      ListCollectionEventsRequest$json,
  '.tacit.dashboard.v1.AssignmentFilter': AssignmentFilter$json,
  '.tacit.dashboard.v1.ListCollectionEventsResponse':
      ListCollectionEventsResponse$json,
  '.tacit.dashboard.v1.CollectionEvent': CollectionEvent$json,
  '.tacit.dashboard.v1.ListEquipmentStatusRequest':
      ListEquipmentStatusRequest$json,
  '.tacit.dashboard.v1.ListEquipmentStatusResponse':
      ListEquipmentStatusResponse$json,
  '.tacit.dashboard.v1.EquipmentStatusRow': EquipmentStatusRow$json,
  '.tacit.dashboard.v1.ListWorkOrdersRequest': ListWorkOrdersRequest$json,
  '.tacit.dashboard.v1.ListWorkOrdersResponse': ListWorkOrdersResponse$json,
  '.tacit.dashboard.v1.WorkOrder': WorkOrder$json,
  '.tacit.dashboard.v1.ListJointsRequest': ListJointsRequest$json,
  '.tacit.dashboard.v1.ListJointsResponse': ListJointsResponse$json,
  '.tacit.dashboard.v1.Joint': Joint$json,
  '.tacit.dashboard.v1.ListWorkersRequest': ListWorkersRequest$json,
  '.tacit.dashboard.v1.ListWorkersResponse': ListWorkersResponse$json,
  '.tacit.dashboard.v1.Worker': Worker$json,
  '.tacit.dashboard.v1.ListWorkHistoryRequest': ListWorkHistoryRequest$json,
  '.tacit.dashboard.v1.ListWorkHistoryResponse': ListWorkHistoryResponse$json,
  '.tacit.dashboard.v1.WorkHistory': WorkHistory$json,
  '.tacit.dashboard.v1.ListWorkAttachmentsRequest':
      ListWorkAttachmentsRequest$json,
  '.tacit.dashboard.v1.ListWorkAttachmentsResponse':
      ListWorkAttachmentsResponse$json,
  '.tacit.dashboard.v1.WorkAttachment': WorkAttachment$json,
  '.tacit.dashboard.v1.ListPassesRequest': ListPassesRequest$json,
  '.tacit.dashboard.v1.ListPassesResponse': ListPassesResponse$json,
  '.tacit.dashboard.v1.Pass': Pass$json,
  '.tacit.dashboard.v1.ListWaveformSeriesRequest':
      ListWaveformSeriesRequest$json,
  '.tacit.dashboard.v1.ListWaveformSeriesResponse':
      ListWaveformSeriesResponse$json,
  '.tacit.dashboard.v1.WaveformPoint': WaveformPoint$json,
  '.tacit.dashboard.v1.GetPassWaveformRequest': GetPassWaveformRequest$json,
  '.tacit.dashboard.v1.GetPassWaveformResponse': GetPassWaveformResponse$json,
  '.tacit.dashboard.v1.PassWaveformSeries': PassWaveformSeries$json,
  '.tacit.dashboard.v1.PassWaveformPoint': PassWaveformPoint$json,
  '.tacit.dashboard.v1.ListQualityResultsRequest':
      ListQualityResultsRequest$json,
  '.tacit.dashboard.v1.ListQualityResultsResponse':
      ListQualityResultsResponse$json,
  '.tacit.dashboard.v1.QualityResult': QualityResult$json,
  '.tacit.dashboard.v1.QualityMedia': QualityMedia$json,
  '.tacit.dashboard.v1.ListQualityLinksRequest': ListQualityLinksRequest$json,
  '.tacit.dashboard.v1.ListQualityLinksResponse': ListQualityLinksResponse$json,
  '.tacit.dashboard.v1.QualityLink': QualityLink$json,
  '.tacit.dashboard.v1.GetContextRequest': GetContextRequest$json,
  '.tacit.dashboard.v1.GetContextResponse': GetContextResponse$json,
  '.tacit.dashboard.v1.Context': Context$json,
};

/// Descriptor for `DashboardService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List dashboardServiceDescriptor = $convert.base64Decode(
    'ChBEYXNoYm9hcmRTZXJ2aWNlEmQKDUxpc3RFcXVpcG1lbnQSKC50YWNpdC5kYXNoYm9hcmQudj'
    'EuTGlzdEVxdWlwbWVudFJlcXVlc3QaKS50YWNpdC5kYXNoYm9hcmQudjEuTGlzdEVxdWlwbWVu'
    'dFJlc3BvbnNlEmEKDExpc3RQcm9qZWN0cxInLnRhY2l0LmRhc2hib2FyZC52MS5MaXN0UHJvam'
    'VjdHNSZXF1ZXN0GigudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RQcm9qZWN0c1Jlc3BvbnNlEogB'
    'ChlMaXN0Q29sbGVjdGlvbkFzc2lnbm1lbnRzEjQudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RDb2'
    'xsZWN0aW9uQXNzaWdubWVudHNSZXF1ZXN0GjUudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RDb2xs'
    'ZWN0aW9uQXNzaWdubWVudHNSZXNwb25zZRJ5ChRMaXN0Q29sbGVjdGlvbkV2ZW50cxIvLnRhY2'
    'l0LmRhc2hib2FyZC52MS5MaXN0Q29sbGVjdGlvbkV2ZW50c1JlcXVlc3QaMC50YWNpdC5kYXNo'
    'Ym9hcmQudjEuTGlzdENvbGxlY3Rpb25FdmVudHNSZXNwb25zZRJ2ChNMaXN0RXF1aXBtZW50U3'
    'RhdHVzEi4udGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RFcXVpcG1lbnRTdGF0dXNSZXF1ZXN0Gi8u'
    'dGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RFcXVpcG1lbnRTdGF0dXNSZXNwb25zZRJnCg5MaXN0V2'
    '9ya09yZGVycxIpLnRhY2l0LmRhc2hib2FyZC52MS5MaXN0V29ya09yZGVyc1JlcXVlc3QaKi50'
    'YWNpdC5kYXNoYm9hcmQudjEuTGlzdFdvcmtPcmRlcnNSZXNwb25zZRJbCgpMaXN0Sm9pbnRzEi'
    'UudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RKb2ludHNSZXF1ZXN0GiYudGFjaXQuZGFzaGJvYXJk'
    'LnYxLkxpc3RKb2ludHNSZXNwb25zZRJeCgtMaXN0V29ya2VycxImLnRhY2l0LmRhc2hib2FyZC'
    '52MS5MaXN0V29ya2Vyc1JlcXVlc3QaJy50YWNpdC5kYXNoYm9hcmQudjEuTGlzdFdvcmtlcnNS'
    'ZXNwb25zZRJqCg9MaXN0V29ya0hpc3RvcnkSKi50YWNpdC5kYXNoYm9hcmQudjEuTGlzdFdvcm'
    'tIaXN0b3J5UmVxdWVzdBorLnRhY2l0LmRhc2hib2FyZC52MS5MaXN0V29ya0hpc3RvcnlSZXNw'
    'b25zZRJ2ChNMaXN0V29ya0F0dGFjaG1lbnRzEi4udGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RXb3'
    'JrQXR0YWNobWVudHNSZXF1ZXN0Gi8udGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RXb3JrQXR0YWNo'
    'bWVudHNSZXNwb25zZRJbCgpMaXN0UGFzc2VzEiUudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RQYX'
    'NzZXNSZXF1ZXN0GiYudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RQYXNzZXNSZXNwb25zZRJzChJM'
    'aXN0V2F2ZWZvcm1TZXJpZXMSLS50YWNpdC5kYXNoYm9hcmQudjEuTGlzdFdhdmVmb3JtU2VyaW'
    'VzUmVxdWVzdBouLnRhY2l0LmRhc2hib2FyZC52MS5MaXN0V2F2ZWZvcm1TZXJpZXNSZXNwb25z'
    'ZRJqCg9HZXRQYXNzV2F2ZWZvcm0SKi50YWNpdC5kYXNoYm9hcmQudjEuR2V0UGFzc1dhdmVmb3'
    'JtUmVxdWVzdBorLnRhY2l0LmRhc2hib2FyZC52MS5HZXRQYXNzV2F2ZWZvcm1SZXNwb25zZRJz'
    'ChJMaXN0UXVhbGl0eVJlc3VsdHMSLS50YWNpdC5kYXNoYm9hcmQudjEuTGlzdFF1YWxpdHlSZX'
    'N1bHRzUmVxdWVzdBouLnRhY2l0LmRhc2hib2FyZC52MS5MaXN0UXVhbGl0eVJlc3VsdHNSZXNw'
    'b25zZRJtChBMaXN0UXVhbGl0eUxpbmtzEisudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RRdWFsaX'
    'R5TGlua3NSZXF1ZXN0GiwudGFjaXQuZGFzaGJvYXJkLnYxLkxpc3RRdWFsaXR5TGlua3NSZXNw'
    'b25zZRJbCgpHZXRDb250ZXh0EiUudGFjaXQuZGFzaGJvYXJkLnYxLkdldENvbnRleHRSZXF1ZX'
    'N0GiYudGFjaXQuZGFzaGJvYXJkLnYxLkdldENvbnRleHRSZXNwb25zZQ==');
