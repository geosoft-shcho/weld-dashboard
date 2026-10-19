import '../entities/asset_lookup_row.dart';
import '../repositories/asset_lookup_repository.dart';

class ListJobPassesUseCase {
  ListJobPassesUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<List<JobPassOption>> execute({required String jobId}) {
    return _repository.listJobPasses(jobId: jobId);
  }
}
