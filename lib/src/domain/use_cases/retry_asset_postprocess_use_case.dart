import '../repositories/asset_upload_repository.dart';

/// 에셋 상세에서 실패한 후처리를 다시 건다(`RetryPostprocess`).
class RetryAssetPostprocessUseCase {
  const RetryAssetPostprocessUseCase(this._uploadRepository);

  final AssetUploadRepository _uploadRepository;

  Future<String> execute({required String assetId}) {
    return _uploadRepository.retryPostprocess(assetId: assetId);
  }
}
