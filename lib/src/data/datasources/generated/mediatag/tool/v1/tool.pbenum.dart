// This is a generated file - do not edit.
//
// Generated from mediatag/tool/v1/tool.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ToolPattern extends $pb.ProtobufEnum {
  static const ToolPattern TOOL_PATTERN_UNSPECIFIED =
      ToolPattern._(0, _omitEnumNames ? '' : 'TOOL_PATTERN_UNSPECIFIED');
  static const ToolPattern TOOL_PATTERN_PUSH =
      ToolPattern._(1, _omitEnumNames ? '' : 'TOOL_PATTERN_PUSH');
  static const ToolPattern TOOL_PATTERN_PULL =
      ToolPattern._(2, _omitEnumNames ? '' : 'TOOL_PATTERN_PULL');

  static const $core.List<ToolPattern> values = <ToolPattern>[
    TOOL_PATTERN_UNSPECIFIED,
    TOOL_PATTERN_PUSH,
    TOOL_PATTERN_PULL,
  ];

  static final $core.List<ToolPattern?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ToolPattern? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ToolPattern._(super.value, super.name);
}

class ToolUnit extends $pb.ProtobufEnum {
  static const ToolUnit TOOL_UNIT_UNSPECIFIED =
      ToolUnit._(0, _omitEnumNames ? '' : 'TOOL_UNIT_UNSPECIFIED');
  static const ToolUnit TOOL_UNIT_FRAME =
      ToolUnit._(1, _omitEnumNames ? '' : 'TOOL_UNIT_FRAME');
  static const ToolUnit TOOL_UNIT_SECOND =
      ToolUnit._(2, _omitEnumNames ? '' : 'TOOL_UNIT_SECOND');

  static const $core.List<ToolUnit> values = <ToolUnit>[
    TOOL_UNIT_UNSPECIFIED,
    TOOL_UNIT_FRAME,
    TOOL_UNIT_SECOND,
  ];

  static final $core.List<ToolUnit?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ToolUnit? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ToolUnit._(super.value, super.name);
}

class ToolDispatch extends $pb.ProtobufEnum {
  static const ToolDispatch TOOL_DISPATCH_UNSPECIFIED =
      ToolDispatch._(0, _omitEnumNames ? '' : 'TOOL_DISPATCH_UNSPECIFIED');
  static const ToolDispatch TOOL_DISPATCH_MANDATORY =
      ToolDispatch._(1, _omitEnumNames ? '' : 'TOOL_DISPATCH_MANDATORY');
  static const ToolDispatch TOOL_DISPATCH_ON_DEMAND =
      ToolDispatch._(2, _omitEnumNames ? '' : 'TOOL_DISPATCH_ON_DEMAND');

  static const $core.List<ToolDispatch> values = <ToolDispatch>[
    TOOL_DISPATCH_UNSPECIFIED,
    TOOL_DISPATCH_MANDATORY,
    TOOL_DISPATCH_ON_DEMAND,
  ];

  static final $core.List<ToolDispatch?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ToolDispatch? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ToolDispatch._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
