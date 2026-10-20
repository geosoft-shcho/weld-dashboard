import '../entities/asset_upload.dart';
import '../repositories/asset_upload_repository.dart';

class ListUploadFormatsUseCase {
  const ListUploadFormatsUseCase(this._repository);

  final AssetUploadRepository _repository;

  Future<AssetUploadFormats> execute() => _repository.listUploadFormats();
}
