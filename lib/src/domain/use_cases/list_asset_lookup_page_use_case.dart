import '../entities/asset_lookup_row.dart';
import '../repositories/asset_lookup_repository.dart';

class ListAssetLookupPageUseCase {
  ListAssetLookupPageUseCase(this._repository);

  final AssetLookupRepository _repository;

  Future<AssetLookupPage> execute({
    required String kindCode,
    required String query,
    required String equipmentId,
    required bool unattachedOnly,
    String jobId = '',
    String projectId = '',
    String projectItemId = '',
    String workerId = '',
    String unitNo = '',
    String itemCode = '',
    String jointNo = '',
    int passNo = 0,
    bool sharedOnly = false,
    DateTime? startedFrom,
    DateTime? startedTo,
    required int pageSize,
    required String pageToken,
  }) {
    return _repository.listAssets(
      kindCode: kindCode,
      query: query,
      equipmentId: equipmentId,
      unattachedOnly: unattachedOnly,
      jobId: jobId,
      projectId: projectId,
      projectItemId: projectItemId,
      workerId: workerId,
      unitNo: unitNo,
      itemCode: itemCode,
      jointNo: jointNo,
      passNo: passNo,
      sharedOnly: sharedOnly,
      startedFrom: startedFrom,
      startedTo: startedTo,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}
