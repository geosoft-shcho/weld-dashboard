import '../entities/lookup_page.dart';
import '../entities/worker.dart';
import '../repositories/worker_lookup_repository.dart';

class ListWorkerLookupUseCase {
  ListWorkerLookupUseCase(this._repository);

  final WorkerLookupRepository _repository;

  static const int defaultPageSize = 50;

  Future<LookupPage<Worker>> execute({
    bool includeInactive = false,
    String query = '',
    String pageToken = '',
    int pageSize = defaultPageSize,
  }) {
    return _repository.listWorkers(
      includeInactive: includeInactive,
      query: query,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}
