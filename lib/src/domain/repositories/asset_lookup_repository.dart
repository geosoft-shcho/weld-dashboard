import '../entities/asset_lookup_row.dart';

abstract class AssetLookupRepository {
  Future<AssetLookupPage> listAssets({
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
  });

  Future<List<JobPassOption>> listJobPasses({required String jobId});

  Future<AssetLookupRow?> getAsset({required String assetId});

  /// 응답의 replace_run_id(없으면 빈 문자열). recorded_at 고치면 GetRun으로 기다린다.
  Future<String> updateAsset({
    required String assetId,
    required String subject,
    required String situation,
    DateTime? recordedAt,
    required List<String> changedFields,
  });

  Future<String> readContent({required String url});
}
