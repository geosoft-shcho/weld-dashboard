import '../entities/asset_lookup_row.dart';
import '../repositories/asset_lookup_repository.dart';

class ListJobAssetLookupUseCase {
  ListJobAssetLookupUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<List<AssetLookupRow>> execute({
    required String jobId,
    required String passId,
  }) {
    return _repository.listJobAssets(jobId: jobId, passId: passId);
  }
}
