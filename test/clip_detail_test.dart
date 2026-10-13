import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/google/protobuf/struct.pb.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/asset/v1/asset.pb.dart'
    as asset_pb;
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import 'package:weld_dashboard/src/data/repositories/clip_detail_mapping.dart';

void main() {
  test('GetClip asks for the clip and its asset', () {
    final request = buildGetClipRequest('17226');
    expect(request.clipId.toString(), '17226');
    expect(request.includeAssets, isTrue);
  });

  test('clip and asset fields stay on the detail', () {
    final locator = Struct()
      ..fields['page'] = (Value()..numberValue = 2);
    final response = compose_pb.GetClipResponse(
      clip: compose_pb.Clip(
        clipId: Int64(17226),
        trackId: Int64(4),
        kind: compose_pb.ClipKind.CLIP_KIND_VIDEO,
        timelineStartNs: Int64.ZERO,
        timelineEndNs: Int64.parseInt('390083999999'),
        source: compose_pb.ClipSource(
          assetId: Int64(9),
          startNs: Int64(7009000000),
          locator: locator,
        ),
        labelValueId: Int64(3),
        description: '메모',
        provenance: compose_pb.ClipProvenance(
          confidence: 0.8,
          reviewed: true,
          runId: Int64(96),
          toolId: Int64(6),
          toolVersion: '1.0.0',
          targetKind: compose_pb.ClipTargetKind.CLIP_TARGET_KIND_CLIP,
          targetId: Int64(9247),
        ),
      ),
      asset: asset_pb.Asset(
        assetId: Int64(9),
        kind: asset_pb.AssetKind.ASSET_KIND_VIDEO,
        fileName: 'take.mp4',
        sha256: 'abc',
        mimeType: 'video/mp4',
        sizeBytes: Int64(12),
        contentUrl: '/files/take.mp4',
        sourcePath: '/secret/take.mp4',
        childCount: 1,
        provenance: asset_pb.Provenance(
          operation: 'stt',
          parentAssetId: Int64(8),
        ),
      ),
    );

    final detail = clipDetailFromResponse(response);
    expect(detail.hasAsset, isTrue);
    expect(detail.isVideo, isTrue);
    expect(detail.timelineStartNs, '0');
    expect(detail.timelineEndNs, '390083999999');
    expect(detail.valueOf('clipId'), '17226');
    expect(detail.valueOf('kind'), 'VIDEO');
    expect(detail.valueOf('timelineStartNs'), '0');
    expect(detail.valueOf('source.assetId'), '9');
    expect(detail.valueOf('source.startNs'), '7009000000');
    expect(detail.valueOf('source.locator'), contains('"page":2'));
    expect(detail.valueOf('provenance.targetKind'), 'CLIP');
    expect(detail.valueOf('provenance.targetId'), '클립 9247');
    expect(detail.valueOf('provenance.reviewed'), '예');
    expect(detail.valueOf('relation.fromClipId'), '—');
    expect(detail.valueOf('asset.fileName'), 'take.mp4');
    expect(detail.valueOf('asset.kind'), 'VIDEO');
    expect(detail.valueOf('asset.contentUrl'), '/files/take.mp4');
    expect(detail.valueOf('asset.childCount'), '1');
    expect(detail.valueOf('asset.provenance.operation'), 'stt');
    expect(detail.valueOf('asset.provenance.parentAssetId'), '8');
    expect(
      detail.fields.any((field) => field.label.contains('sourcePath')),
      isFalse,
    );
    expect(
      detail.fields.any((field) => field.value.contains('/secret/')),
      isFalse,
    );
  });

  test('a tag clip has no asset', () {
    final detail = clipDetailFromResponse(
      compose_pb.GetClipResponse(
        clip: compose_pb.Clip(
          clipId: Int64(11),
          kind: compose_pb.ClipKind.CLIP_KIND_TAG,
          labelValueId: Int64(5),
        ),
      ),
    );
    expect(detail.hasAsset, isFalse);
    expect(detail.isVideo, isFalse);
    expect(detail.valueOf('kind'), 'TAG');
    expect(detail.valueOf('source.assetId'), '—');
    expect(detail.valueOf('provenance.targetKind'), '—');
    expect(detail.valueOf('asset'), '가리키는 파일 없음');
  });

  test('an asset target id is the file number', () {
    final detail = clipDetailFromResponse(
      compose_pb.GetClipResponse(
        clip: compose_pb.Clip(
          clipId: Int64(12),
          kind: compose_pb.ClipKind.CLIP_KIND_RELATION,
          relation: compose_pb.ClipRelation(
            fromClipId: Int64(1),
            toClipId: Int64(2),
          ),
          provenance: compose_pb.ClipProvenance(
            targetKind: compose_pb.ClipTargetKind.CLIP_TARGET_KIND_ASSET,
            targetId: Int64(44),
          ),
        ),
      ),
    );
    expect(detail.valueOf('kind'), 'RELATION');
    expect(detail.valueOf('relation.fromClipId'), '1');
    expect(detail.valueOf('relation.toClipId'), '2');
    expect(detail.valueOf('provenance.targetKind'), 'ASSET');
    expect(detail.valueOf('provenance.targetId'), '파일 44');
    expect(detail.valueOf('asset'), '가리키는 파일 없음');
  });
}
