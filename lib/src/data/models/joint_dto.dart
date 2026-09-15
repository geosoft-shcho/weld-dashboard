import '../../domain/entities/joint.dart';

class JointDto {
  const JointDto({
    required this.jointId,
    required this.jointNo,
    required this.jointName,
    required this.workOrderId,
  });

  factory JointDto.fromRow(Map<String, String> row) {
    return JointDto(
      jointId: row['joint_id'] ?? '',
      jointNo: row['joint_no'] ?? '',
      jointName: row['name'] ?? '',
      workOrderId: row['work_order_id'] ?? '',
    );
  }

  final String jointId;
  final String jointNo;
  final String jointName;
  final String workOrderId;

  Joint toDomain() {
    return Joint(
      jointId: jointId,
      jointNo: jointNo,
      jointName: jointName,
      workOrderId: workOrderId,
    );
  }
}
