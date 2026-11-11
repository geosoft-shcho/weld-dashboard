import '../repositories/asset_lookup_repository.dart';

class DeleteAssetUseCase {
  const DeleteAssetUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<void> execute({required String assetId}) {
    return _repository.deleteAsset(assetId: assetId);
  }
}
