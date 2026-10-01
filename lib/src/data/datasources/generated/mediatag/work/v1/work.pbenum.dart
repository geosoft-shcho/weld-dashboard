// This is a generated file - do not edit.
//
// Generated from mediatag/work/v1/work.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CollectionView extends $pb.ProtobufEnum {
  static const CollectionView COLLECTION_VIEW_UNSPECIFIED =
      CollectionView._(0, _omitEnumNames ? '' : 'COLLECTION_VIEW_UNSPECIFIED');
  static const CollectionView COLLECTION_VIEW_EQUIPMENT =
      CollectionView._(1, _omitEnumNames ? '' : 'COLLECTION_VIEW_EQUIPMENT');
  static const CollectionView COLLECTION_VIEW_WORKER =
      CollectionView._(2, _omitEnumNames ? '' : 'COLLECTION_VIEW_WORKER');

  static const $core.List<CollectionView> values = <CollectionView>[
    COLLECTION_VIEW_UNSPECIFIED,
    COLLECTION_VIEW_EQUIPMENT,
    COLLECTION_VIEW_WORKER,
  ];

  static final $core.List<CollectionView?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CollectionView? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CollectionView._(super.value, super.name);
}

/// 노드가 어느 단계인가. UNSPECIFIED = 루트(첫 단계 목록을 달라는 뜻).
class CollectionLevel extends $pb.ProtobufEnum {
  static const CollectionLevel COLLECTION_LEVEL_UNSPECIFIED = CollectionLevel._(
      0, _omitEnumNames ? '' : 'COLLECTION_LEVEL_UNSPECIFIED');
  static const CollectionLevel COLLECTION_LEVEL_EQUIPMENT =
      CollectionLevel._(1, _omitEnumNames ? '' : 'COLLECTION_LEVEL_EQUIPMENT');
  static const CollectionLevel COLLECTION_LEVEL_WORKER =
      CollectionLevel._(2, _omitEnumNames ? '' : 'COLLECTION_LEVEL_WORKER');
  static const CollectionLevel COLLECTION_LEVEL_PROJECT =
      CollectionLevel._(3, _omitEnumNames ? '' : 'COLLECTION_LEVEL_PROJECT');
  static const CollectionLevel COLLECTION_LEVEL_JOB =
      CollectionLevel._(4, _omitEnumNames ? '' : 'COLLECTION_LEVEL_JOB');
  static const CollectionLevel COLLECTION_LEVEL_PASS =
      CollectionLevel._(5, _omitEnumNames ? '' : 'COLLECTION_LEVEL_PASS');

  static const $core.List<CollectionLevel> values = <CollectionLevel>[
    COLLECTION_LEVEL_UNSPECIFIED,
    COLLECTION_LEVEL_EQUIPMENT,
    COLLECTION_LEVEL_WORKER,
    COLLECTION_LEVEL_PROJECT,
    COLLECTION_LEVEL_JOB,
    COLLECTION_LEVEL_PASS,
  ];

  static final $core.List<CollectionLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CollectionLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CollectionLevel._(super.value, super.name);
}

class TimeBasis extends $pb.ProtobufEnum {
  static const TimeBasis TIME_BASIS_UNSPECIFIED =
      TimeBasis._(0, _omitEnumNames ? '' : 'TIME_BASIS_UNSPECIFIED');

  /// 작업 구간: 작업·패스는 자기 시작~종료, 위 단계(공사·장비·작업자)는 그 아래 작업들의 처음 시작~마지막 종료,
  /// 파일은 속한 패스(없으면 작업)의 구간
  static const TimeBasis TIME_BASIS_WORK =
      TimeBasis._(1, _omitEnumNames ? '' : 'TIME_BASIS_WORK');

  /// 수집 구간: 그 아래 파일들의 처음 기록 시작(recorded_at)~마지막 기록 끝(recorded_at + duration_ns), 파일은 자기 구간
  static const TimeBasis TIME_BASIS_COLLECTION =
      TimeBasis._(2, _omitEnumNames ? '' : 'TIME_BASIS_COLLECTION');

  static const $core.List<TimeBasis> values = <TimeBasis>[
    TIME_BASIS_UNSPECIFIED,
    TIME_BASIS_WORK,
    TIME_BASIS_COLLECTION,
  ];

  static final $core.List<TimeBasis?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TimeBasis? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TimeBasis._(super.value, super.name);
}

class WaveformNormalize extends $pb.ProtobufEnum {
  static const WaveformNormalize WAVEFORM_NORMALIZE_UNSPECIFIED =
      WaveformNormalize._(
          0, _omitEnumNames ? '' : 'WAVEFORM_NORMALIZE_UNSPECIFIED');

  /// 비교 파형을 대상 파형의 시간축에 DTW로 맞춘다(DTW 서버 호출, 저장 안 함 — 채널마다 따로 맞춤). 비교 패스가 있을 때만 쓰인다.
  /// 대상·비교 모두 시리즈 하나로 온다(파일들을 한 격자로 모은 것, asset_id 없음). 대상은 그대로이고 비교가 대상의
  /// 시간축에 맞춰져, 두 시리즈는 시각·길이가 같다. 정렬은 원본 간격(30fps)으로 하고 max_points로 줄이는 것은 맞춘 뒤다.
  /// 용접 채널 current_a·voltage_v·wire_feed_speed_mpm·rotation_speed_rpm은 항상 들어 있고, 그 밖의 채널(IMU
  /// 자이로 등)은 channels에 적은 것만 맞춰 준다(두 패스에 다 있는 채널만 온다) — 이름은 "장비ID/채널"(장비가 있는 파일) 또는 채널 이름 그대로.
  static const WaveformNormalize WAVEFORM_NORMALIZE_DTW =
      WaveformNormalize._(1, _omitEnumNames ? '' : 'WAVEFORM_NORMALIZE_DTW');

  static const $core.List<WaveformNormalize> values = <WaveformNormalize>[
    WAVEFORM_NORMALIZE_UNSPECIFIED,
    WAVEFORM_NORMALIZE_DTW,
  ];

  static final $core.List<WaveformNormalize?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static WaveformNormalize? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WaveformNormalize._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
