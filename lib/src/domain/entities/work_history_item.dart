class WorkHistoryItem {
  const WorkHistoryItem({
    required this.historyId,
    required this.commonKey,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    required this.itemName,
    required this.workerId,
    required this.workerName,
    required this.equipmentId,
    required this.equipmentName,
    required this.workedAt,
    required this.passCount,
    required this.attachmentCount,
  });

  /// 화면 진입 식별자. 값은 `job_id`다.
  final String historyId;
  final String commonKey;
  final String projectNo;
  final String unitNo;
  final String itemCode;
  final String itemName;
  final String workerId;
  final String workerName;
  final String equipmentId;
  final String equipmentName;
  final DateTime? workedAt;
  final int passCount;
  final int attachmentCount;

  bool get doesHaveAttachments => attachmentCount > 0;
}
