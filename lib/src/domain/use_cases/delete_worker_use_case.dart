import '../repositories/worker_lookup_repository.dart';

class DeleteWorkerUseCase {
  const DeleteWorkerUseCase(this._repository);

  final WorkerLookupRepository _repository;

  Future<void> execute({required String workerId}) {
    return _repository.deleteWorker(workerId: workerId);
  }
}
