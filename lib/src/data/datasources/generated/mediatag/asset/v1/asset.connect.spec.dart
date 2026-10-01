//
//  Generated code. Do not modify.
//  source: mediatag/asset/v1/asset.proto
//

import "package:connectrpc/connect.dart" as connect;
import "asset.pb.dart" as mediatagassetv1asset;

abstract final class AssetService {
  /// Fully-qualified name of the AssetService service.
  static const name = 'mediatag.asset.v1.AssetService';

  /// 외부 source URL(fileservice://...)에서 서버가 바이트를 가져와 Asset으로 등록한다.
  /// 미구현(UNIMPLEMENTED) — 허용 주소 규칙(SSRF 방지)과 함께 업로드 경로를 설계할 때 만든다.
  static const importAssetFromSource = connect.Spec(
    '/$name/ImportAssetFromSource',
    connect.StreamType.unary,
    mediatagassetv1asset.ImportAssetFromSourceRequest.new,
    mediatagassetv1asset.ImportAssetFromSourceResponse.new,
  );

  /// Asset 목록(페이지·kind 필터). 작업별 목록은 ListJobAssets.
  static const listAssets = connect.Spec(
    '/$name/ListAssets',
    connect.StreamType.unary,
    mediatagassetv1asset.ListAssetsRequest.new,
    mediatagassetv1asset.ListAssetsResponse.new,
  );

  static const getAsset = connect.Spec(
    '/$name/GetAsset',
    connect.StreamType.unary,
    mediatagassetv1asset.GetAssetRequest.new,
    mediatagassetv1asset.GetAssetResponse.new,
  );

  /// 첨부(job_asset)·파생 부모(asset_input)·성적서 원본으로 쓰이는 Asset은 FailedPrecondition.
  static const deleteAsset = connect.Spec(
    '/$name/DeleteAsset',
    connect.StreamType.unary,
    mediatagassetv1asset.DeleteAssetRequest.new,
    mediatagassetv1asset.DeleteAssetResponse.new,
  );

  /// 내용(sha256)이 같은 Asset 묶음 목록. 중복은 등록을 막지 않고 여기서 확인해 사람이 정리한다.
  /// 음성 추출 같은 파생 만들기는 도구다 — ToolService.StartRun(도구 "audio-extract", 대상 = 영상 Asset).
  static const listDuplicateAssets = connect.Spec(
    '/$name/ListDuplicateAssets',
    connect.StreamType.unary,
    mediatagassetv1asset.ListDuplicateAssetsRequest.new,
    mediatagassetv1asset.ListDuplicateAssetsResponse.new,
  );

  /// 첨부(job_asset) — "이 작업의 자료인가". Clip으로 놓으면 서버가 자동 첨부하므로, 이 RPC는
  /// 타임라인에 놓지 않고 작업 자료로만 둘 때(PDF 등)와 패스를 고칠 때 쓴다.
  /// 작업의 첨부 목록
  static const listJobAssets = connect.Spec(
    '/$name/ListJobAssets',
    connect.StreamType.unary,
    mediatagassetv1asset.ListJobAssetsRequest.new,
    mediatagassetv1asset.ListJobAssetsResponse.new,
  );

  /// 첨부. 이미 첨부돼 있으면 pass_id만 고친다(upsert).
  /// pass_id가 다른 작업의 패스면 InvalidArgument.
  static const attachAsset = connect.Spec(
    '/$name/AttachAsset',
    connect.StreamType.unary,
    mediatagassetv1asset.AttachAssetRequest.new,
    mediatagassetv1asset.AttachAssetResponse.new,
  );

  /// Clip이나 매칭된 성적서 세트가 쓰는 첨부면 FailedPrecondition.
  static const detachAsset = connect.Spec(
    '/$name/DetachAsset',
    connect.StreamType.unary,
    mediatagassetv1asset.DetachAssetRequest.new,
    mediatagassetv1asset.DetachAssetResponse.new,
  );
}
