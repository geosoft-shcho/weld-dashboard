import '../entities/job_detail.dart';

abstract class JobAdminRepository {
  Future<JobDetail> getJobDetail({required String jobId});

  /// 바뀐 칸만 update_mask로 보내고, 저장된 상세를 돌려준다.
  Future<JobDetail> updateJob({
    required JobDetail original,
    required JobEditDraft draft,
  });

  /// 성적서 세트 지정. [reportSetId]가 비거나 '0'이면 풀기(본인 세트).
  Future<JobDetail> updateJobReportSet({
    required String jobId,
    required String reportSetId,
  });

  Future<void> deleteJob({required String jobId});

  Future<void> createPass({
    required String jobId,
    required PassEditDraft draft,
  });

  Future<void> updatePass({
    required JobPassDetail original,
    required PassEditDraft draft,
  });

  Future<void> deletePass({required String passId});

  /// 이미 붙어 있으면 패스만 바뀐다(upsert). passId가 비면 작업 공용.
  Future<void> attachAsset({
    required String jobId,
    required String assetId,
    required String passId,
  });

  Future<void> detachAsset({required String jobId, required String assetId});
}
