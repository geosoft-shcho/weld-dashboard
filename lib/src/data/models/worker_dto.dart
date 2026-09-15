import '../../domain/entities/worker.dart';

class WorkerDto {
  const WorkerDto({required this.workerId, required this.workerName});

  factory WorkerDto.fromRow(Map<String, String> row) {
    return WorkerDto(
      workerId: row['worker_id'] ?? '',
      workerName: row['worker_name'] ?? '',
    );
  }

  final String workerId;
  final String workerName;

  Worker toDomain() {
    return Worker(workerId: workerId, workerName: workerName);
  }
}
