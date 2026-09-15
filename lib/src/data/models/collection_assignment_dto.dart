import '../../domain/entities/collection_assignment.dart';

class CollectionAssignmentDto {
  const CollectionAssignmentDto({
    required this.assignmentId,
    required this.equipmentId,
    required this.projectId,
    required this.workerId,
    required this.assignedFrom,
    required this.assignedTo,
  });

  factory CollectionAssignmentDto.fromRow(Map<String, String> row) {
    return CollectionAssignmentDto(
      assignmentId: row['assignment_id'] ?? '',
      equipmentId: row['equipment_id'] ?? '',
      projectId: row['project_id'] ?? '',
      workerId: row['worker_id'] ?? '',
      assignedFrom: DateTime.parse(row['assigned_from'] ?? ''),
      assignedTo: DateTime.parse(row['assigned_to'] ?? ''),
    );
  }

  final String assignmentId;
  final String equipmentId;
  final String projectId;
  final String workerId;
  final DateTime assignedFrom;
  final DateTime assignedTo;

  CollectionAssignment toDomain() {
    return CollectionAssignment(
      assignmentId: assignmentId,
      equipmentId: equipmentId,
      projectId: projectId,
      workerId: workerId,
      assignedFrom: assignedFrom,
      assignedTo: assignedTo,
    );
  }
}
