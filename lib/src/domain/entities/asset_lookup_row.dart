class AssetLookupRow {
  const AssetLookupRow({
    required this.assetId,
    required this.kindCode,
    required this.fileName,
    required this.equipmentId,
    required this.sizeBytes,
    required this.durationNs,
    required this.isDerived,
    required this.isAttached,
    this.isUnattached = false,
    this.childCount = 0,
    this.attachmentPassId = '',
  });

  final String assetId;
  final String kindCode;
  final String fileName;
  final String equipmentId;
  final int sizeBytes;
  final int? durationNs;
  final bool isDerived;
  final bool isAttached;

  /// ListAssets(unattached_only)로 받은 행.
  final bool isUnattached;
  final int childCount;

  /// ListJobAssets의 pass_id. '0'이면 작업 공용, 빈 값이면 패스 정보 없음.
  final String attachmentPassId;
}

class AssetLookupPage {
  const AssetLookupPage({required this.rows, required this.nextPageToken});

  final List<AssetLookupRow> rows;
  final String nextPageToken;

  bool get doesHaveMore => nextPageToken.isNotEmpty;
}

class JobPassOption {
  const JobPassOption({required this.passId, required this.passNo});

  final String passId;
  final int passNo;
}

/// ListJobAssets에서 작업 공용만 볼 때 쓰는 pass_id=0 토큰.
const String jobCommonPassToken = '0';
