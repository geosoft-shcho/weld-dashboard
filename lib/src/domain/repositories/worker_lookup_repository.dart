import '../entities/lookup_page.dart';
import '../entities/worker.dart';

abstract class WorkerLookupRepository {
  Future<LookupPage<Worker>> listWorkers({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  });
}
