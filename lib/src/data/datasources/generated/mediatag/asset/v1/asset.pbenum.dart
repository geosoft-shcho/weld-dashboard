// This is a generated file - do not edit.
//
// Generated from mediatag/asset/v1/asset.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// 소비(렌더링) 방식 기준 분류. 엔티티.md §6.1 + ocr_json. DB CHECK와 같은 목록.
class AssetKind extends $pb.ProtobufEnum {
  static const AssetKind ASSET_KIND_UNSPECIFIED =
      AssetKind._(0, _omitEnumNames ? '' : 'ASSET_KIND_UNSPECIFIED');
  static const AssetKind ASSET_KIND_VIDEO =
      AssetKind._(1, _omitEnumNames ? '' : 'ASSET_KIND_VIDEO');
  static const AssetKind ASSET_KIND_AUDIO =
      AssetKind._(2, _omitEnumNames ? '' : 'ASSET_KIND_AUDIO');
  static const AssetKind ASSET_KIND_IMAGE =
      AssetKind._(3, _omitEnumNames ? '' : 'ASSET_KIND_IMAGE');
  static const AssetKind ASSET_KIND_DOCUMENT =
      AssetKind._(4, _omitEnumNames ? '' : 'ASSET_KIND_DOCUMENT');
  static const AssetKind ASSET_KIND_POSE =
      AssetKind._(5, _omitEnumNames ? '' : 'ASSET_KIND_POSE');
  static const AssetKind ASSET_KIND_SUBTITLE =
      AssetKind._(6, _omitEnumNames ? '' : 'ASSET_KIND_SUBTITLE');
  static const AssetKind ASSET_KIND_TIMESERIES =
      AssetKind._(7, _omitEnumNames ? '' : 'ASSET_KIND_TIMESERIES');
  static const AssetKind ASSET_KIND_POINTCLOUD =
      AssetKind._(8, _omitEnumNames ? '' : 'ASSET_KIND_POINTCLOUD');
  static const AssetKind ASSET_KIND_OCR_JSON =
      AssetKind._(9, _omitEnumNames ? '' : 'ASSET_KIND_OCR_JSON');
  static const AssetKind ASSET_KIND_REGION =
      AssetKind._(10, _omitEnumNames ? '' : 'ASSET_KIND_REGION');

  static const $core.List<AssetKind> values = <AssetKind>[
    ASSET_KIND_UNSPECIFIED,
    ASSET_KIND_VIDEO,
    ASSET_KIND_AUDIO,
    ASSET_KIND_IMAGE,
    ASSET_KIND_DOCUMENT,
    ASSET_KIND_POSE,
    ASSET_KIND_SUBTITLE,
    ASSET_KIND_TIMESERIES,
    ASSET_KIND_POINTCLOUD,
    ASSET_KIND_OCR_JSON,
    ASSET_KIND_REGION,
  ];

  static final $core.List<AssetKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static AssetKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
