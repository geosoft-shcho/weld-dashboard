enum CollectionAssetKind {
  unspecified,
  video,
  audio,
  image,
  document,
  pose,
  subtitle,
  timeseries,
  pointcloud,
  ocrJson,
  region,
}

enum DataTypeJudgeKind { unspecified, time, report }

class DataTypeCoverageRow {
  const DataTypeCoverageRow({
    required this.dataTypeId,
    required this.dataTypeName,
    required this.judge,
    required this.coveredSeconds,
    required this.expectedSeconds,
  });

  final String dataTypeId;
  final String dataTypeName;
  final DataTypeJudgeKind judge;
  final int coveredSeconds;
  final int expectedSeconds;

  double? get coverageRatio {
    if (expectedSeconds <= 0) {
      return null;
    }
    return coveredSeconds / expectedSeconds;
  }
}

class CollectionSummary {
  const CollectionSummary({
    required this.assetCount,
    required this.totalSizeBytes,
    this.firstRecordedAt,
    this.lastRecordedAt,
    this.lastCollectedAt,
    required this.jobCount,
    required this.workDurationSeconds,
    required this.jobWithoutAssetCount,
    required this.clipCount,
    required this.embeddedClipCount,
    required this.timeUnverifiedAssetCount,
    required this.weldDurationSeconds,
    required this.attachedAssetCount,
    required this.embeddedAttachedAssetCount,
    required this.commentCount,
    required this.embeddedCommentCount,
  });

  static const empty = CollectionSummary(
    assetCount: 0,
    totalSizeBytes: 0,
    jobCount: 0,
    workDurationSeconds: 0,
    jobWithoutAssetCount: 0,
    clipCount: 0,
    embeddedClipCount: 0,
    timeUnverifiedAssetCount: 0,
    weldDurationSeconds: 0,
    attachedAssetCount: 0,
    embeddedAttachedAssetCount: 0,
    commentCount: 0,
    embeddedCommentCount: 0,
  );

  final int assetCount;
  final int totalSizeBytes;
  final DateTime? firstRecordedAt;
  final DateTime? lastRecordedAt;
  final DateTime? lastCollectedAt;
  final int jobCount;
  final int workDurationSeconds;
  final int jobWithoutAssetCount;
  final int clipCount;
  final int embeddedClipCount;
  final int timeUnverifiedAssetCount;
  final int weldDurationSeconds;
  final int attachedAssetCount;
  final int embeddedAttachedAssetCount;
  final int commentCount;
  final int embeddedCommentCount;
}

/// GetCollectionSummary 한 번의 결과. 적재 건수는 parent·worker와 무관하게 전체.
class CollectionSummaryLoad {
  const CollectionSummaryLoad({
    required this.summary,
    required this.dataTypeCoverage,
    required this.runningTraceCount,
    required this.failedTraceCount,
  });

  static const empty = CollectionSummaryLoad(
    summary: CollectionSummary.empty,
    dataTypeCoverage: [],
    runningTraceCount: 0,
    failedTraceCount: 0,
  );

  final CollectionSummary summary;
  final List<DataTypeCoverageRow> dataTypeCoverage;

  /// trace_running_count — 진행 중(업로드 ~ 임베딩 대기)
  final int runningTraceCount;

  /// trace_failed_count — 실패 누적(0이면 응답에서 칸 없음)
  final int failedTraceCount;
}

class AssetCountRow {
  const AssetCountRow({
    required this.date,
    required this.kind,
    required this.assetCount,
    required this.totalSizeBytes,
  });

  final String date;
  final CollectionAssetKind kind;
  final int assetCount;
  final int totalSizeBytes;
}

enum AssetCountTimeBasis { collected, recorded }
