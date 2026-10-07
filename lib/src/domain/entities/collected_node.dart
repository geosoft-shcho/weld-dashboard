enum CollectedNodeView { equipment, worker }

enum CollectedTimeBasis { work, collection }

enum CollectedNodeLevel {
  unspecified,
  equipment,
  worker,
  project,
  item,
  job,
  pass,
}

class CollectedNodePath {
  const CollectedNodePath({
    required this.view,
    required this.level,
    required this.equipmentId,
    required this.workerId,
    required this.projectNo,
    this.commonKey = '',
    required this.jobId,
    required this.passId,
  });

  factory CollectedNodePath.root(CollectedNodeView view) {
    return CollectedNodePath(
      view: view,
      level: CollectedNodeLevel.unspecified,
      equipmentId: '',
      workerId: '',
      projectNo: '',
      commonKey: '',
      jobId: '',
      passId: '',
    );
  }

  final CollectedNodeView view;
  final CollectedNodeLevel level;
  final String equipmentId;
  final String workerId;
  final String projectNo;
  final String commonKey;
  final String jobId;
  final String passId;

  String get key =>
      '${view.name}|${level.name}|$equipmentId|$workerId|$projectNo|$commonKey|$jobId|$passId';

  @override
  bool operator ==(Object other) {
    return other is CollectedNodePath &&
        other.view == view &&
        other.level == level &&
        other.equipmentId == equipmentId &&
        other.workerId == workerId &&
        other.projectNo == projectNo &&
        other.commonKey == commonKey &&
        other.jobId == jobId &&
        other.passId == passId;
  }

  @override
  int get hashCode => Object.hash(
    view,
    level,
    equipmentId,
    workerId,
    projectNo,
    commonKey,
    jobId,
    passId,
  );
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

  String get nodeKey => '${path.key}|$label|$contentUrl';
}
