import '../entities/job_detail.dart';
import '../repositories/job_admin_repository.dart';

class JobAdminUseCase {
  const JobAdminUseCase(this._repository);

  final JobAdminRepository _repository;

  Future<JobDetail> getJobDetail({required String jobId}) {
    return _repository.getJobDetail(jobId: jobId);
  }

  Future<JobDetail> updateJob({
    required JobDetail original,
    required JobEditDraft draft,
  }) {
    if (draft.changedFields(original).isEmpty) return Future.value(original);
    return _repository.updateJob(original: original, draft: draft);
  }

  Future<void> deleteJob({required String jobId}) {
    return _repository.deleteJob(jobId: jobId);
  }

  Future<void> createPass({
    required String jobId,
    required PassEditDraft draft,
  }) {
    return _repository.createPass(jobId: jobId, draft: draft);
  }

  Future<void> updatePass({
    required JobPassDetail original,
    required PassEditDraft draft,
  }) {
    if (draft.changedFields(original).isEmpty) return Future.value();
    return _repository.updatePass(original: original, draft: draft);
  }

  Future<void> deletePass({required String passId}) {
    return _repository.deletePass(passId: passId);
  }

  Future<void> attachAsset({
    required String jobId,
    required String assetId,
    required String passId,
  }) {
    return _repository.attachAsset(
      jobId: jobId,
      assetId: assetId,
      passId: passId,
    );
  }

  Future<void> detachAsset({required String jobId, required String assetId}) {
    return _repository.detachAsset(jobId: jobId, assetId: assetId);
  }
}
