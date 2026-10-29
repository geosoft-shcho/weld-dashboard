import '../entities/lookup_page.dart';
import '../entities/worker.dart';
import '../entities/worker_kind.dart';

abstract class WorkerLookupRepository {
  Future<Worker?> getWorker({required String workerId});

  Future<LookupPage<Worker>> listWorkers({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  });

  Future<String> createWorker({
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
  });

  Future<void> updateWorker({
    required String workerId,
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  });

  Future<void> deleteWorker({required String workerId});
}
