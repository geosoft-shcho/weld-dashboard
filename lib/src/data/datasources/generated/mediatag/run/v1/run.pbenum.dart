// This is a generated file - do not edit.
//
// Generated from mediatag/run/v1/run.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RunTrigger extends $pb.ProtobufEnum {
  static const RunTrigger RUN_TRIGGER_UNSPECIFIED =
      RunTrigger._(0, _omitEnumNames ? '' : 'RUN_TRIGGER_UNSPECIFIED');
  static const RunTrigger RUN_TRIGGER_MANUAL =
      RunTrigger._(1, _omitEnumNames ? '' : 'RUN_TRIGGER_MANUAL');
  static const RunTrigger RUN_TRIGGER_AUTO_TAGGING =
      RunTrigger._(2, _omitEnumNames ? '' : 'RUN_TRIGGER_AUTO_TAGGING');
  static const RunTrigger RUN_TRIGGER_ASSET_UPLOADED =
      RunTrigger._(3, _omitEnumNames ? '' : 'RUN_TRIGGER_ASSET_UPLOADED');

  static const $core.List<RunTrigger> values = <RunTrigger>[
    RUN_TRIGGER_UNSPECIFIED,
    RUN_TRIGGER_MANUAL,
    RUN_TRIGGER_AUTO_TAGGING,
    RUN_TRIGGER_ASSET_UPLOADED,
  ];

  static final $core.List<RunTrigger?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RunTrigger? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RunTrigger._(super.value, super.name);
}

class RunStatus extends $pb.ProtobufEnum {
  static const RunStatus RUN_STATUS_UNSPECIFIED =
      RunStatus._(0, _omitEnumNames ? '' : 'RUN_STATUS_UNSPECIFIED');
  static const RunStatus RUN_STATUS_QUEUED =
      RunStatus._(1, _omitEnumNames ? '' : 'RUN_STATUS_QUEUED');
  static const RunStatus RUN_STATUS_RUNNING =
      RunStatus._(2, _omitEnumNames ? '' : 'RUN_STATUS_RUNNING');
  static const RunStatus RUN_STATUS_SUCCEEDED =
      RunStatus._(3, _omitEnumNames ? '' : 'RUN_STATUS_SUCCEEDED');
  static const RunStatus RUN_STATUS_FAILED =
      RunStatus._(4, _omitEnumNames ? '' : 'RUN_STATUS_FAILED');
  static const RunStatus RUN_STATUS_CANCELED =
      RunStatus._(5, _omitEnumNames ? '' : 'RUN_STATUS_CANCELED');

  static const $core.List<RunStatus> values = <RunStatus>[
    RUN_STATUS_UNSPECIFIED,
    RUN_STATUS_QUEUED,
    RUN_STATUS_RUNNING,
    RUN_STATUS_SUCCEEDED,
    RUN_STATUS_FAILED,
    RUN_STATUS_CANCELED,
  ];

  static final $core.List<RunStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static RunStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RunStatus._(super.value, super.name);
}

class WaitReason extends $pb.ProtobufEnum {
  static const WaitReason WAIT_REASON_UNSPECIFIED =
      WaitReason._(0, _omitEnumNames ? '' : 'WAIT_REASON_UNSPECIFIED');
  static const WaitReason WAIT_REASON_QUEUE_AHEAD =
      WaitReason._(1, _omitEnumNames ? '' : 'WAIT_REASON_QUEUE_AHEAD');
  static const WaitReason WAIT_REASON_WORKERS_BUSY =
      WaitReason._(2, _omitEnumNames ? '' : 'WAIT_REASON_WORKERS_BUSY');
  static const WaitReason WAIT_REASON_RETRY =
      WaitReason._(3, _omitEnumNames ? '' : 'WAIT_REASON_RETRY');
  static const WaitReason WAIT_REASON_DISPATCH_OFF =
      WaitReason._(4, _omitEnumNames ? '' : 'WAIT_REASON_DISPATCH_OFF');

  static const $core.List<WaitReason> values = <WaitReason>[
    WAIT_REASON_UNSPECIFIED,
    WAIT_REASON_QUEUE_AHEAD,
    WAIT_REASON_WORKERS_BUSY,
    WAIT_REASON_RETRY,
    WAIT_REASON_DISPATCH_OFF,
  ];

  static final $core.List<WaitReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static WaitReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WaitReason._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
