import '../entities/worker_kind.dart';
import '../repositories/worker_lookup_repository.dart';

class UpdateWorkerUseCase {
  const UpdateWorkerUseCase(this._repository);

  final WorkerLookupRepository _repository;

  Future<void> execute({
    required String workerId,
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  }) {
    return _repository.updateWorker(
      workerId: workerId,
      workerName: workerName,
      workerKind: workerKind,
      employeeNo: employeeNo,
      description: description,
      isInactive: isInactive,
      changedFields: changedFields,
    );
  }
}
