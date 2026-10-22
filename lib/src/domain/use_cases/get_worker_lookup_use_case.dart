import '../entities/worker.dart';
import '../repositories/worker_lookup_repository.dart';

class GetWorkerLookupUseCase {
  GetWorkerLookupUseCase(this._repository);

  final WorkerLookupRepository _repository;

  Future<Worker?> execute({required String workerId}) {
    return _repository.getWorker(workerId: workerId);
  }
}
