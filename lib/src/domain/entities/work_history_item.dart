class WorkHistoryItem {
  const WorkHistoryItem({
    required this.jobId,
    required this.commonKey,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    required this.itemName,
    this.jointNo = '',
    this.hasReport = false,
    required this.workerId,
    required this.workerName,
    this.isMaster,
    required this.equipmentId,
    required this.equipmentName,
    required this.workedAt,
    required this.passCount,
    required this.attachmentCount,
  });

  final String jobId;
  final String commonKey;
  final String projectNo;
  final String unitNo;
  final String itemCode;
  final String itemName;
  final String jointNo;
  final bool hasReport;
  final String workerId;
  final String workerName;
  final bool? isMaster;
  final String equipmentId;
  final String equipmentName;
  final DateTime? workedAt;
  final int passCount;
  final int attachmentCount;

  bool get doesHaveAttachments => attachmentCount > 0;
}
