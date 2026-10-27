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

  /// Asset 목록(페이지 · kind · 부모 · 작업 필터). 작업의 첨부 목록은 job.job_id로(pass_ids에 패스).
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

  /// 사람이 정하는 칸을 고친다(update_mask: subject, situation, recorded_at). 글은 빈 글로 보내면 지운다. 파일 · 종류는 못 고친다.
  /// recorded_at(기록 시작 시각 — 틀린 촬영 시각 · timeOrigin 바로잡기): 표준화본도 같은 만큼 옮기고, 그 자료의 자동 배치 클립 중
  /// 사람이 손대지 않은 것(옮기거나 고치거나 라벨 · 설명 · 관계를 붙이지 않은 것)을 지운 뒤 후처리를 다시 걸어 새 시각으로 놓는다
  /// (replace_run_id). 사람이 손댄 클립은 그대로 둔다. 비울 수는 없다.
  static const updateAsset = connect.Spec(
    '/$name/UpdateAsset',
    connect.StreamType.unary,
    mediatagassetv1asset.UpdateAssetRequest.new,
    mediatagassetv1asset.UpdateAssetResponse.new,
  );

  /// 행과 저장된 파일을 실제로 지운다(되돌릴 수 없음).
  /// 첨부(job_asset)·파생 부모(다른 Asset의 parent_asset_id)·성적서 원본으로 쓰이는 Asset은 FailedPrecondition.
  static const deleteAsset = connect.Spec(
    '/$name/DeleteAsset',
    connect.StreamType.unary,
    mediatagassetv1asset.DeleteAssetRequest.new,
    mediatagassetv1asset.DeleteAssetResponse.new,
  );

  /// 내용(sha256)이 같은 Asset 묶음 목록. 중복은 등록을 막지 않고 여기서 확인해 사람이 정리한다.
  /// 묶음마다 합칠 수 있는지(mergeable)를 서버가 판정한다 — 화면이 같은 조건을 따로 들고 있지 않게.
  /// 기본은 사본마다 기록 시각이 다른 묶음(예시 사본)과 정리한 묶음을 뺀다. 정리한 묶음이라도 그 뒤 새 사본이 들어오면 다시 뜬다.
  static const listDuplicateAssets = connect.Spec(
    '/$name/ListDuplicateAssets',
    connect.StreamType.unary,
    mediatagassetv1asset.ListDuplicateAssetsRequest.new,
    mediatagassetv1asset.ListDuplicateAssetsResponse.new,
  );

  /// 중복 묶음을 "그대로 둔다"고 기록한다(합치지 않음). 같은 sha256의 결정이 있으면 덮어쓴다.
  /// member_asset_ids가 지금 묶음의 사본과 다르면(그사이 새 사본이 들어왔거나 지워졌으면) FailedPrecondition — 다시 보고 결정한다.
  /// 묶음이 없으면(사본이 하나 이하) NotFound, keep_asset_id가 사본이 아니면 InvalidArgument.
  static const resolveDuplicateGroup = connect.Spec(
    '/$name/ResolveDuplicateGroup',
    connect.StreamType.unary,
    mediatagassetv1asset.ResolveDuplicateGroupRequest.new,
    mediatagassetv1asset.ResolveDuplicateGroupResponse.new,
  );

  /// 같은 내용의 사본 여럿을 하나(keep)로 합친다. 첨부·클립·파생·성적서·도구 실행 참조를 keep으로 옮기고 사본 행을 지운다.
  /// 사본의 파일도 지운다(되돌릴 수 없음). dry_run이면 바꾸지 않고 옮겨질 수만 센다.
  /// 합칠 조건(ListDuplicateAssets의 mergeable과 같은 판정)이 안 맞으면 FailedPrecondition, 없는 번호면 NotFound.
  /// 성공하면 묶음의 결정이 MERGED(기준 keep)가 된다 — 같은 내용이 또 들어오면 그 사본만 새로 뜬다.
  static const mergeAssets = connect.Spec(
    '/$name/MergeAssets',
    connect.StreamType.unary,
    mediatagassetv1asset.MergeAssetsRequest.new,
    mediatagassetv1asset.MergeAssetsResponse.new,
  );

  /// 화면 업로드(POST /assets, multipart)가 받는 자료 형식. 서버는 파일 내용으로 종류를 정한다 — 확장자는 파일 선택 창에
  /// 쓸 안내 값이다. 표에 없는 파일도 올릴 수 있고(종류 미지정으로 등록만), 실행 파일은 거절한다.
  /// 음성 추출 같은 파생 만들기는 도구다 — ToolService.StartRun(도구 "audio-extract", 대상 = 영상 Asset).
  static const listUploadFormats = connect.Spec(
    '/$name/ListUploadFormats',
    connect.StreamType.unary,
    mediatagassetv1asset.ListUploadFormatsRequest.new,
    mediatagassetv1asset.ListUploadFormatsResponse.new,
  );

  /// 첨부(job_asset) — "이 작업의 자료인가". Clip으로 놓으면 서버가 자동 첨부하므로, 이 RPC는
  /// 타임라인에 놓지 않고 작업 자료로만 둘 때(PDF 등)와 패스를 고칠 때 쓴다.
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
