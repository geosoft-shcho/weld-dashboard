enum CollectedNodeView { project }

enum CollectedTimeBasis { work, collection }

enum CollectedNodeLevel { unspecified, project, item, job }

enum CollectedSegmentUnit { job, pass }

enum CollectedTimeWarningCode {
  unspecified,
  passNotOverlapped,
  recordedOutsideJob,
}

class CollectedTimeWarning {
  const CollectedTimeWarning({
    required this.code,
    required this.passId,
    required this.assetId,
  });

  final CollectedTimeWarningCode code;
  final String passId;
  final String assetId;
}

class CollectedTimeRange {
  const CollectedTimeRange({
    required this.startedAt,
    required this.endedAt,
    this.jobId = '',
    this.passId = '',
    this.isEstimated = false,
  });

  final DateTime? startedAt;
  final DateTime? endedAt;
  final String jobId;
  final String passId;
  final bool isEstimated;
}

class CollectedNodePath {
  const CollectedNodePath({
    required this.view,
    required this.level,
    required this.projectNo,
    this.commonKey = '',
    required this.jobId,
    required this.passId,
  });

  factory CollectedNodePath.root([
    CollectedNodeView view = CollectedNodeView.project,
  ]) {
    return CollectedNodePath(
      view: view,
      level: CollectedNodeLevel.unspecified,
      projectNo: '',
      commonKey: '',
      jobId: '',
      passId: '',
    );
  }

  final CollectedNodeView view;
  final CollectedNodeLevel level;
  final String projectNo;
  final String commonKey;
  final String jobId;
  final String passId;

  String get key =>
      '${view.name}|${level.name}|$projectNo|$commonKey|$jobId|$passId';

  @override
  bool operator ==(Object other) {
    return other is CollectedNodePath &&
        other.view == view &&
        other.level == level &&
        other.projectNo == projectNo &&
        other.commonKey == commonKey &&
        other.jobId == jobId &&
        other.passId == passId;
  }

  @override
  int get hashCode =>
      Object.hash(view, level, projectNo, commonKey, jobId, passId);
}

class CollectedNode {
  const CollectedNode({
    required this.path,
    required this.label,
    required this.hasChildren,
    required this.assetCount,
    required this.totalSizeBytes,
    required this.firstRecordedAt,
    required this.lastRecordedAt,
    required this.lastCollectedAt,
    required this.jobCount,
    required this.workDurationSeconds,
    required this.startedAt,
    required this.endedAt,
    required this.contentUrl,
    this.assetId = '',
    this.segments = const [],
    this.warnings = const [],
  });

  final CollectedNodePath path;
  final String label;
  final bool hasChildren;
  final int? assetCount;
  final int? totalSizeBytes;
  final DateTime? firstRecordedAt;
  final DateTime? lastRecordedAt;
  final DateTime? lastCollectedAt;
  final int? jobCount;
  final int? workDurationSeconds;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String contentUrl;
  final String assetId;
  final List<CollectedTimeRange> segments;
  final List<CollectedTimeWarning> warnings;

  bool get isAssetNode => assetId.isNotEmpty || contentUrl.isNotEmpty;

  bool get doesHaveTimeWarning => warnings.isNotEmpty;

  String get nodeKey => '${path.key}|$label|$contentUrl|$assetId';
}
