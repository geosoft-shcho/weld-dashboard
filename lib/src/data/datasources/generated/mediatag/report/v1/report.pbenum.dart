// This is a generated file - do not edit.
//
// Generated from mediatag/report/v1/report.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SectionKind extends $pb.ProtobufEnum {
  static const SectionKind SECTION_KIND_UNSPECIFIED =
      SectionKind._(0, _omitEnumNames ? '' : 'SECTION_KIND_UNSPECIFIED');
  static const SectionKind SECTION_KIND_FITUP =
      SectionKind._(1, _omitEnumNames ? '' : 'SECTION_KIND_FITUP');
  static const SectionKind SECTION_KIND_WELDING =
      SectionKind._(2, _omitEnumNames ? '' : 'SECTION_KIND_WELDING');
  static const SectionKind SECTION_KIND_DIMENSIONAL =
      SectionKind._(3, _omitEnumNames ? '' : 'SECTION_KIND_DIMENSIONAL');
  static const SectionKind SECTION_KIND_PRESSURE =
      SectionKind._(4, _omitEnumNames ? '' : 'SECTION_KIND_PRESSURE');
  static const SectionKind SECTION_KIND_NDT =
      SectionKind._(5, _omitEnumNames ? '' : 'SECTION_KIND_NDT');
  static const SectionKind SECTION_KIND_APPROVALS =
      SectionKind._(6, _omitEnumNames ? '' : 'SECTION_KIND_APPROVALS');

  static const $core.List<SectionKind> values = <SectionKind>[
    SECTION_KIND_UNSPECIFIED,
    SECTION_KIND_FITUP,
    SECTION_KIND_WELDING,
    SECTION_KIND_DIMENSIONAL,
    SECTION_KIND_PRESSURE,
    SECTION_KIND_NDT,
    SECTION_KIND_APPROVALS,
  ];

  static final $core.List<SectionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static SectionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SectionKind._(super.value, super.name);
}

class ReviewReason extends $pb.ProtobufEnum {
  static const ReviewReason REVIEW_REASON_UNSPECIFIED =
      ReviewReason._(0, _omitEnumNames ? '' : 'REVIEW_REASON_UNSPECIFIED');
  static const ReviewReason REVIEW_REASON_LOW_CONFIDENCE =
      ReviewReason._(1, _omitEnumNames ? '' : 'REVIEW_REASON_LOW_CONFIDENCE');
  static const ReviewReason REVIEW_REASON_VLM_RECHECKED =
      ReviewReason._(2, _omitEnumNames ? '' : 'REVIEW_REASON_VLM_RECHECKED');
  static const ReviewReason REVIEW_REASON_SNAPPED =
      ReviewReason._(3, _omitEnumNames ? '' : 'REVIEW_REASON_SNAPPED');
  static const ReviewReason REVIEW_REASON_UNREADABLE =
      ReviewReason._(4, _omitEnumNames ? '' : 'REVIEW_REASON_UNREADABLE');

  static const $core.List<ReviewReason> values = <ReviewReason>[
    REVIEW_REASON_UNSPECIFIED,
    REVIEW_REASON_LOW_CONFIDENCE,
    REVIEW_REASON_VLM_RECHECKED,
    REVIEW_REASON_SNAPPED,
    REVIEW_REASON_UNREADABLE,
  ];

  static final $core.List<ReviewReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReviewReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReviewReason._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
