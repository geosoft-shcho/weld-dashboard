// This is a generated file - do not edit.
//
// Generated from mediatag/compose/v1/compose.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TimelineStatus extends $pb.ProtobufEnum {
  static const TimelineStatus TIMELINE_STATUS_UNSPECIFIED =
      TimelineStatus._(0, _omitEnumNames ? '' : 'TIMELINE_STATUS_UNSPECIFIED');
  static const TimelineStatus TIMELINE_STATUS_DRAFT =
      TimelineStatus._(1, _omitEnumNames ? '' : 'TIMELINE_STATUS_DRAFT');
  static const TimelineStatus TIMELINE_STATUS_SUGGESTED =
      TimelineStatus._(2, _omitEnumNames ? '' : 'TIMELINE_STATUS_SUGGESTED');
  static const TimelineStatus TIMELINE_STATUS_CONFIRMED =
      TimelineStatus._(3, _omitEnumNames ? '' : 'TIMELINE_STATUS_CONFIRMED');
  static const TimelineStatus TIMELINE_STATUS_REJECTED =
      TimelineStatus._(4, _omitEnumNames ? '' : 'TIMELINE_STATUS_REJECTED');

  static const $core.List<TimelineStatus> values = <TimelineStatus>[
    TIMELINE_STATUS_UNSPECIFIED,
    TIMELINE_STATUS_DRAFT,
    TIMELINE_STATUS_SUGGESTED,
    TIMELINE_STATUS_CONFIRMED,
    TIMELINE_STATUS_REJECTED,
  ];

  static final $core.List<TimelineStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TimelineStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TimelineStatus._(super.value, super.name);
}

/// Clip이 무엇을 가리키는지(화면이 어떤 렌더러로 그릴지).
class ClipKind extends $pb.ProtobufEnum {
  static const ClipKind CLIP_KIND_UNSPECIFIED =
      ClipKind._(0, _omitEnumNames ? '' : 'CLIP_KIND_UNSPECIFIED');
  static const ClipKind CLIP_KIND_VIDEO =
      ClipKind._(1, _omitEnumNames ? '' : 'CLIP_KIND_VIDEO');
  static const ClipKind CLIP_KIND_AUDIO =
      ClipKind._(2, _omitEnumNames ? '' : 'CLIP_KIND_AUDIO');
  static const ClipKind CLIP_KIND_IMAGE =
      ClipKind._(3, _omitEnumNames ? '' : 'CLIP_KIND_IMAGE');
  static const ClipKind CLIP_KIND_PDF =
      ClipKind._(4, _omitEnumNames ? '' : 'CLIP_KIND_PDF');
  static const ClipKind CLIP_KIND_SUBTITLE =
      ClipKind._(5, _omitEnumNames ? '' : 'CLIP_KIND_SUBTITLE');
  static const ClipKind CLIP_KIND_POSE =
      ClipKind._(6, _omitEnumNames ? '' : 'CLIP_KIND_POSE');
  static const ClipKind CLIP_KIND_TIMESERIES =
      ClipKind._(7, _omitEnumNames ? '' : 'CLIP_KIND_TIMESERIES');
  static const ClipKind CLIP_KIND_POINTCLOUD =
      ClipKind._(8, _omitEnumNames ? '' : 'CLIP_KIND_POINTCLOUD');
  static const ClipKind CLIP_KIND_FILE =
      ClipKind._(9, _omitEnumNames ? '' : 'CLIP_KIND_FILE');
  static const ClipKind CLIP_KIND_TAG =
      ClipKind._(10, _omitEnumNames ? '' : 'CLIP_KIND_TAG');
  static const ClipKind CLIP_KIND_REGION =
      ClipKind._(11, _omitEnumNames ? '' : 'CLIP_KIND_REGION');

  static const $core.List<ClipKind> values = <ClipKind>[
    CLIP_KIND_UNSPECIFIED,
    CLIP_KIND_VIDEO,
    CLIP_KIND_AUDIO,
    CLIP_KIND_IMAGE,
    CLIP_KIND_PDF,
    CLIP_KIND_SUBTITLE,
    CLIP_KIND_POSE,
    CLIP_KIND_TIMESERIES,
    CLIP_KIND_POINTCLOUD,
    CLIP_KIND_FILE,
    CLIP_KIND_TAG,
    CLIP_KIND_REGION,
  ];

  static final $core.List<ClipKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 11);
  static ClipKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ClipKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
