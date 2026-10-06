class WorkHistoryRecordDto {
  const WorkHistoryRecordDto({
    required this.jobId,
    required this.commonKey,
    required this.workOrderId,
    required this.jointId,
    required this.workerId,
    required this.equipmentId,
    required this.workedAt,
  });

  factory WorkHistoryRecordDto.fromRow(Map<String, String> row) {
    return WorkHistoryRecordDto(
      jobId: row['history_id'] ?? '',
      commonKey: row['common_key'] ?? '',
      workOrderId: row['work_order_id'] ?? '',
      jointId: row['joint_id'] ?? '',
      workerId: row['worker_id'] ?? '',
      equipmentId: row['equipment_id'] ?? '',
      workedAt: DateTime.parse(row['worked_at'] ?? ''),
    );
  }

  final String jobId;
  final String commonKey;
  final String workOrderId;
  final String jointId;
  final String workerId;
  final String equipmentId;
  final DateTime workedAt;
}
