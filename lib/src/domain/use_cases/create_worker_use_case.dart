import '../entities/worker_kind.dart';
import '../repositories/worker_lookup_repository.dart';

class CreateWorkerUseCase {
  const CreateWorkerUseCase(this._repository);

  final WorkerLookupRepository _repository;

  Future<String> execute({
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
  }) {
    return _repository.createWorker(
      workerName: workerName,
      workerKind: workerKind,
      employeeNo: employeeNo,
      description: description,
      isInactive: isInactive,
    );
  }
}
