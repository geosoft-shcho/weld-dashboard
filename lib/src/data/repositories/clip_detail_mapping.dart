import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import '../../domain/entities/job_timeline.dart';
import '../datasources/generated/google/protobuf/struct.pb.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart';
import '../datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import 'proto_id.dart';

const _dash = '—';
const _none = '없음';

compose_pb.GetClipRequest buildGetClipRequest(String clipId) {
  return compose_pb.GetClipRequest(
    clipId: protoId(clipId),
    includeAssets: true,
    includeTarget: true,
  );
}

ClipDetail clipDetailFromResponse(
  compose_pb.GetClipResponse response, {
  String Function(String contentUrl) resolveContentUrl = _sameUrl,
}) {
  if (!response.hasClip()) {
    return ClipDetail.empty;
  }
  final clip = response.clip;
  final provenance = clip.hasProvenance() ? clip.provenance : null;
  final fields = <ClipField>[];
  void add(String label, String value) {
    fields.add(ClipField(label: label, value: value));
  }

  add('clipId', _id(clip.clipId));
  add('trackId', _id(clip.trackId));
  add('kind', _enumLabel(clip.kind.name));
  add('timelineStartNs', _ns(clip.hasTimelineStartNs(), clip.timelineStartNs));
  add('timelineEndNs', _ns(clip.hasTimelineEndNs(), clip.timelineEndNs));
  if (clip.hasSource()) {
    final source = clip.source;
    add('source.assetId', _id(source.assetId));
    add('source.startNs', _ns(source.hasStartNs(), source.startNs));
    add('source.endNs', _ns(source.hasEndNs(), source.endNs));
    add('source.locator', _struct(source.hasLocator(), source.locator));
  } else {
    add('source.assetId', _dash);
    add('source.startNs', _dash);
    add('source.endNs', _dash);
    add('source.locator', _dash);
  }
  add('labelValueId', _id(clip.labelValueId));
  add('description', _text(clip.description));
  if (provenance != null) {
    add(
      'provenance.confidence',
      provenance.hasConfidence() ? '${provenance.confidence}' : _dash,
    );
    add('provenance.reviewed', provenance.reviewed ? '예' : '아니오');
    add('provenance.runId', _id(provenance.runId));
    add('provenance.toolId', _id(provenance.toolId));
    add('provenance.toolVersion', _text(provenance.toolVersion));
    add('provenance.targetKind', _enumLabel(provenance.targetKind.name));
    add('provenance.targetId', _targetId(provenance));
  } else {
    add('provenance.confidence', _dash);
    add('provenance.reviewed', _dash);
    add('provenance.runId', _dash);
    add('provenance.toolId', _dash);
    add('provenance.toolVersion', _dash);
    add('provenance.targetKind', _dash);
    add('provenance.targetId', _dash);
  }
  add('embeddedAt', _time(clip.hasEmbeddedAt(), clip.embeddedAt));
  add('createdAt', _time(clip.hasCreatedAt(), clip.createdAt));
  add('updatedAt', _time(clip.hasUpdatedAt(), clip.updatedAt));
  final isRelation = clip.kind == compose_pb.ClipKind.CLIP_KIND_RELATION;
  if (isRelation && clip.hasRelation()) {
    add('relation.fromClipId', _id(clip.relation.fromClipId));
    add('relation.toClipId', _id(clip.relation.toClipId));
  } else {
    add('relation.fromClipId', _dash);
    add('relation.toClipId', _dash);
  }

  final hasAsset = response.hasAsset() && response.asset.assetId != Int64.ZERO;
  if (!hasAsset) {
    add('asset', '가리키는 파일 없음');
  } else {
    final asset = response.asset;
    add('asset.assetId', _id(asset.assetId));
    add('asset.kind', _enumLabel(asset.kind.name));
    add('asset.fileName', _text(asset.fileName));
    add('asset.sha256', _text(asset.sha256));
    add('asset.mimeType', _text(asset.mimeType));
    add('asset.sizeBytes', asset.sizeBytes.toString());
    add('asset.properties', _struct(asset.hasProperties(), asset.properties));
    add('asset.equipmentId', _id(asset.equipmentId));
    add('asset.collectedAt', _time(asset.hasCollectedAt(), asset.collectedAt));
    add('asset.recordedAt', _time(asset.hasRecordedAt(), asset.recordedAt));
    add('asset.durationNs', _ns(asset.hasDurationNs(), asset.durationNs));
    if (asset.hasProvenance()) {
      final provenance = asset.provenance;
      add('asset.provenance.operation', _text(provenance.operation));
      add('asset.provenance.runId', _id(provenance.runId));
      add('asset.provenance.toolId', _id(provenance.toolId));
      add('asset.provenance.toolVersion', _text(provenance.toolVersion));
      add(
        'asset.provenance.parameters',
        _struct(provenance.hasParameters(), provenance.parameters),
      );
      add('asset.provenance.parentAssetId', _id(provenance.parentAssetId));
    } else {
      add('asset.provenance.operation', _dash);
      add('asset.provenance.runId', _dash);
      add('asset.provenance.toolId', _dash);
      add('asset.provenance.toolVersion', _dash);
      add('asset.provenance.parameters', _dash);
      add('asset.provenance.parentAssetId', _dash);
    }
    add('asset.contentUrl', _text(asset.contentUrl));
    add('asset.childCount', '${asset.childCount}');
  }

  final hasTargetClip =
      response.hasTargetClip() && response.targetClip.clipId != Int64.ZERO;
  if (hasTargetClip) {
    final target = response.targetClip;
    add('targetClip.clipId', _id(target.clipId));
    add('targetClip.kind', _enumLabel(target.kind.name));
    add(
      'targetClip.timelineStartNs',
      _ns(target.hasTimelineStartNs(), target.timelineStartNs),
    );
    add(
      'targetClip.timelineEndNs',
      _ns(target.hasTimelineEndNs(), target.timelineEndNs),
    );
  } else {
    add('targetClip', _none);
  }

  final hasTargetAsset =
      response.hasTargetAsset() && response.targetAsset.assetId != Int64.ZERO;
  if (hasTargetAsset) {
    final target = response.targetAsset;
    add('targetAsset.assetId', _id(target.assetId));
    add('targetAsset.kind', _enumLabel(target.kind.name));
    add('targetAsset.fileName', _text(target.fileName));
    add('targetAsset.contentUrl', _text(target.contentUrl));
  } else {
    add('targetAsset', _none);
  }

  return ClipDetail(
    clipId: clip.clipId.toString(),
    fields: fields,
    hasAsset: hasAsset,
    isVideo: clip.kind == compose_pb.ClipKind.CLIP_KIND_VIDEO,
    isPose: clip.kind == compose_pb.ClipKind.CLIP_KIND_POSE,
    timelineStartNs: clip.hasTimelineStartNs()
        ? clip.timelineStartNs.toString()
        : '',
    timelineEndNs: clip.hasTimelineEndNs() ? clip.timelineEndNs.toString() : '',
    sourceStartNs: clip.hasSource() && clip.source.hasStartNs()
        ? clip.source.startNs.toString()
        : '',
    sourceEndNs: clip.hasSource() && clip.source.hasEndNs()
        ? clip.source.endNs.toString()
        : '',
    assetId: hasAsset ? response.asset.assetId.toString() : '',
    assetFileName: hasAsset ? response.asset.fileName : '',
    assetContentUrl: hasAsset && response.asset.contentUrl.isNotEmpty
        ? resolveContentUrl(response.asset.contentUrl)
        : '',
    targetKind: provenance == null
        ? ClipTargetKind.unspecified
        : _targetKindFrom(provenance.targetKind),
    targetId: provenance == null || provenance.targetId == Int64.ZERO
        ? ''
        : provenance.targetId.toString(),
    hasTargetClip: hasTargetClip,
    targetClipId: hasTargetClip ? response.targetClip.clipId.toString() : '',
    targetClipKind: hasTargetClip
        ? _enumLabel(response.targetClip.kind.name)
        : '',
    targetTimelineStartNs:
        hasTargetClip && response.targetClip.hasTimelineStartNs()
        ? response.targetClip.timelineStartNs.toString()
        : '',
    targetTimelineEndNs: hasTargetClip && response.targetClip.hasTimelineEndNs()
        ? response.targetClip.timelineEndNs.toString()
        : '',
    hasTargetAsset: hasTargetAsset,
    targetAssetId: hasTargetAsset
        ? response.targetAsset.assetId.toString()
        : '',
    targetAssetFileName: hasTargetAsset ? response.targetAsset.fileName : '',
    targetAssetContentUrl:
        hasTargetAsset && response.targetAsset.contentUrl.isNotEmpty
        ? resolveContentUrl(response.targetAsset.contentUrl)
        : '',
    channelNames: hasAsset
        ? channelNamesFromProperties(response.asset.properties)
        : const [],
  );
}

ClipTargetKind _targetKindFrom(compose_pb.ClipTargetKind kind) {
  if (kind == compose_pb.ClipTargetKind.CLIP_TARGET_KIND_CLIP) {
    return ClipTargetKind.clip;
  }
  if (kind == compose_pb.ClipTargetKind.CLIP_TARGET_KIND_ASSET) {
    return ClipTargetKind.asset;
  }
  return ClipTargetKind.unspecified;
}

String _sameUrl(String contentUrl) => contentUrl;

List<String> channelNamesFromProperties(Struct properties) {
  final value = properties.fields['channels'];
  if (value == null || !value.hasListValue()) {
    return const [];
  }
  return [
    for (final item in value.listValue.values)
      if (item.hasStringValue() && item.stringValue.trim().isNotEmpty)
        item.stringValue.trim(),
  ];
}

String _id(Int64 id) => id == Int64.ZERO ? _none : id.toString();

String _ns(bool present, Int64 value) => present ? value.toString() : _dash;

String _text(String value) => value.isEmpty ? _dash : value;

String _enumLabel(String name) {
  const prefixes = ['CLIP_TARGET_KIND_', 'CLIP_KIND_', 'ASSET_KIND_'];
  for (final prefix in prefixes) {
    if (!name.startsWith(prefix)) {
      continue;
    }
    final rest = name.substring(prefix.length);
    return rest == 'UNSPECIFIED' ? '미지정' : rest;
  }
  return name;
}

String _targetId(compose_pb.ClipProvenance provenance) {
  if (provenance.targetId == Int64.ZERO) {
    return _none;
  }
  final id = provenance.targetId.toString();
  if (provenance.targetKind ==
      compose_pb.ClipTargetKind.CLIP_TARGET_KIND_CLIP) {
    return '클립 $id';
  }
  if (provenance.targetKind ==
      compose_pb.ClipTargetKind.CLIP_TARGET_KIND_ASSET) {
    return '파일 $id';
  }
  return id;
}

String _time(bool present, Timestamp value) {
  if (!present) {
    return _dash;
  }
  return value.toDateTime().toLocal().toIso8601String();
}

String _struct(bool present, Struct value) {
  if (!present || value.fields.isEmpty) {
    return _dash;
  }
  return jsonEncode(value.toProto3Json());
}
