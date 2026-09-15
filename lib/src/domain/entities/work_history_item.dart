class WorkHistoryItem {
  const WorkHistoryItem({
    required this.historyId,
    required this.commonKey,
    required this.workOrderId,
    required this.workOrderNo,
    required this.title,
    required this.jointId,
    required this.jointNo,
    required this.jointName,
    required this.workerId,
    required this.workerName,
    required this.equipmentId,
    required this.equipmentName,
    required this.workedAt,
    required this.passCount,
    required this.attachmentCount,
  });

  final String historyId;
  final String commonKey;
  final String workOrderId;
  final String workOrderNo;
  final String title;
  final String jointId;
  final String jointNo;
  final String jointName;
  final String workerId;
  final String workerName;
  final String equipmentId;
  final String equipmentName;
  final DateTime workedAt;
  final int passCount;
  final int attachmentCount;

  bool get doesHaveAttachments => attachmentCount > 0;
}
