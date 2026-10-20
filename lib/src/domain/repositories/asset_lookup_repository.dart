import '../entities/asset_lookup_row.dart';

abstract class AssetLookupRepository {
  Future<AssetLookupPage> listAssets({
    required String kindCode,
    required String query,
    required String equipmentId,
    required bool unattachedOnly,
    required int pageSize,
    required String pageToken,
  });

  Future<List<AssetLookupRow>> listJobAssets({
    required String jobId,
    required String passId,
  });

  Future<List<JobPassOption>> listJobPasses({required String jobId});

  Future<AssetLookupRow?> getAsset({required String assetId});
}
