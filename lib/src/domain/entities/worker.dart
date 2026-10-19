import 'worker_kind.dart';

class Worker {
  const Worker({
    required this.workerId,
    required this.workerName,
    this.workerKind = WorkerKind.unknown,
    this.employeeNo = '',
    this.description = '',
    this.isInactive = false,
    this.jobCount = 0,
  });

  final String workerId;
  final String workerName;
  final WorkerKind workerKind;
  final String employeeNo;
  final String description;
  final bool isInactive;
  final int jobCount;
}
