class AssetDisplayField {
  const AssetDisplayField({required this.label, required this.value});

  final String label;
  final String value;
}

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
    this.parentAssetId = '',
    this.provenanceSummary = '',
    this.displayFields = const [],
    this.propertiesJson = '',
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

  /// ListAssets(job)의 pass_ids. '0'이면 작업 공용, 빈 값이면 패스 정보 없음.
  final String attachmentPassId;
  final String parentAssetId;
  final String provenanceSummary;
  final List<AssetDisplayField> displayFields;
  final String propertiesJson;
}

class AssetLookupPage {
  const AssetLookupPage({
    required this.rows,
    required this.nextPageToken,
    this.totalCount = 0,
  });

  final List<AssetLookupRow> rows;
  final String nextPageToken;
  final int totalCount;

  bool get doesHaveMore => nextPageToken.isNotEmpty;
}

class JobPassOption {
  const JobPassOption({
    required this.passId,
    required this.passNo,
    this.startedAt,
    this.endedAt,
  });

  final String passId;
  final int passNo;
  final DateTime? startedAt;
  final DateTime? endedAt;
}

/// pass_ids에 없을 때 작업 공용을 나타내는 pass_id=0 토큰.
const String jobCommonPassToken = '0';
