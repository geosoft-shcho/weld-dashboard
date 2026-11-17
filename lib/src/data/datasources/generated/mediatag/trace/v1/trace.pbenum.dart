// This is a generated file - do not edit.
//
// Generated from mediatag/trace/v1/trace.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TraceStatus extends $pb.ProtobufEnum {
  static const TraceStatus TRACE_STATUS_UNSPECIFIED =
      TraceStatus._(0, _omitEnumNames ? '' : 'TRACE_STATUS_UNSPECIFIED');
  static const TraceStatus TRACE_STATUS_RUNNING =
      TraceStatus._(1, _omitEnumNames ? '' : 'TRACE_STATUS_RUNNING');
  static const TraceStatus TRACE_STATUS_DONE =
      TraceStatus._(2, _omitEnumNames ? '' : 'TRACE_STATUS_DONE');
  static const TraceStatus TRACE_STATUS_FAILED =
      TraceStatus._(3, _omitEnumNames ? '' : 'TRACE_STATUS_FAILED');

  static const $core.List<TraceStatus> values = <TraceStatus>[
    TRACE_STATUS_UNSPECIFIED,
    TRACE_STATUS_RUNNING,
    TRACE_STATUS_DONE,
    TRACE_STATUS_FAILED,
  ];

  static final $core.List<TraceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TraceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TraceStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
