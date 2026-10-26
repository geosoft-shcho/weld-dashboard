import '../repositories/asset_lookup_repository.dart';

class UpdateAssetUseCase {
  const UpdateAssetUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<void> execute({
    required String assetId,
    required String subject,
    required String situation,
    required List<String> changedFields,
  }) {
    if (changedFields.isEmpty) {
      throw ArgumentError('바뀐 칸이 없습니다.');
    }
    return _repository.updateAsset(
      assetId: assetId,
      subject: subject,
      situation: situation,
      changedFields: changedFields,
    );
  }
}
