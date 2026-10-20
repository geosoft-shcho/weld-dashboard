import '../entities/asset_lookup_row.dart';
import '../repositories/asset_lookup_repository.dart';

class GetAssetLookupUseCase {
  GetAssetLookupUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<AssetLookupRow?> execute({required String assetId}) {
    return _repository.getAsset(assetId: assetId);
  }
}
