import '../entities/asset_lookup_row.dart';
import '../repositories/asset_lookup_repository.dart';

class ListAssetLookupPageUseCase {
  ListAssetLookupPageUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<AssetLookupPage> execute({
    required String kindCode,
    required String fileName,
    required String equipmentId,
    required bool unattachedOnly,
    required int pageSize,
    required String pageToken,
  }) {
    return _repository.listAssets(
      kindCode: kindCode,
      fileName: fileName,
      equipmentId: equipmentId,
      unattachedOnly: unattachedOnly,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}
