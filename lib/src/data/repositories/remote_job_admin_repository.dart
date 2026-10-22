import '../../domain/entities/job_detail.dart';
import '../../domain/repositories/job_admin_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemoteJobAdminRepository implements JobAdminRepository {
  RemoteJobAdminRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<JobDetail> getJobDetail({required String jobId}) async {
    final response = await _mediaTag.workService.getJob(
      work_pb.GetJobRequest(jobId: protoId(jobId)),
    );
    final job = response.job;
    final attachments = await _mediaTag.assetService.listAssets(
      asset_pb.ListAssetsRequest(pageSize: 1)
        ..job = asset_pb.AssetJobFilter(jobId: protoId(jobId)),
    );
    return JobDetail(
      jobId: idText(job.jobId),
      jobKey: job.jobKey,
      commonKey: job.commonKey,
      projectId: idText(job.projectId),
      projectNo: job.projectNo,
      unitNo: job.unitNo,
      itemCode: job.itemCode,
      itemName: job.itemName,
      jointNo: job.jointNo,
      jobName: job.jobName,
      itemNo: job.itemNo,
      operationNo: job.operationNo,
      material: job.material,
      outerDiameterMm: job.hasOuterDiameterMm() ? job.outerDiameterMm : null,
      thicknessMm: job.hasThicknessMm() ? job.thicknessMm : null,
      workerId: idText(job.workerId),
      workerName: response.hasWorker() ? response.worker.workerName : '',
      startedAt: job.hasStartedAt()
          ? job.startedAt.toDateTime().toLocal()
          : null,
      endedAt: job.hasEndedAt() ? job.endedAt.toDateTime().toLocal() : null,
      hasReport: false,
      attachmentCount: attachments.totalCount,
      passes: [
        for (final pass in response.passes)
          JobPassDetail(
            passId: idText(pass.passId),
            passNo: pass.passNo,
            kind: _passKindFrom(pass.passType),
            startedAt: pass.hasStartedAt()
                ? pass.startedAt.toDateTime().toLocal()
                : null,
            endedAt: pass.hasEndedAt()
                ? pass.endedAt.toDateTime().toLocal()
                : null,
          ),
      ],
    );
  }

  @override
  Future<JobDetail> updateJob({
    required JobDetail original,
    required JobEditDraft draft,
  }) async {
    final job = work_pb.Job(
      jobId: protoId(original.jobId),
      projectNo: draft.projectNo,
      unitNo: draft.unitNo,
      itemCode: draft.itemCode,
      jointNo: draft.jointNo,
      jobName: draft.jobName,
      itemNo: draft.itemNo,
      operationNo: draft.operationNo,
      material: draft.material,
    );
    final projectId = protoIdOrNull(draft.projectId);
    if (projectId != null) job.projectId = projectId;
    final workerId = protoIdOrNull(draft.workerId);
    if (workerId != null) job.workerId = workerId;
    if (draft.outerDiameterMm != null) {
      job.outerDiameterMm = draft.outerDiameterMm!;
    }
    if (draft.thicknessMm != null) job.thicknessMm = draft.thicknessMm!;
    if (draft.startedAt != null) {
      job.startedAt = Timestamp.fromDateTime(draft.startedAt!);
    }
    if (draft.endedAt != null) {
      job.endedAt = Timestamp.fromDateTime(draft.endedAt!);
    }
    await _mediaTag.workService.updateJob(
      work_pb.UpdateJobRequest(
        job: job,
        updateMask: FieldMask(paths: draft.changedFields(original)),
      ),
    );
    return getJobDetail(jobId: original.jobId);
  }

  @override
  Future<void> deleteJob({required String jobId}) async {
    await _mediaTag.workService.deleteJob(
      work_pb.DeleteJobRequest(jobId: protoId(jobId)),
    );
  }

  @override
  Future<void> createPass({
    required String jobId,
    required PassEditDraft draft,
  }) async {
    final pass = work_pb.Pass(
      jobId: protoId(jobId),
      passNo: draft.passNo,
      passType: _passKindTo(draft.kind),
    );
    if (draft.startedAt != null) {
      pass.startedAt = Timestamp.fromDateTime(draft.startedAt!);
    }
    if (draft.endedAt != null) {
      pass.endedAt = Timestamp.fromDateTime(draft.endedAt!);
    }
    await _mediaTag.workService.createPass(
      work_pb.CreatePassRequest(pass: pass),
    );
  }

  @override
  Future<void> updatePass({
    required JobPassDetail original,
    required PassEditDraft draft,
  }) async {
    final pass = work_pb.Pass(
      passId: protoId(original.passId),
      passNo: draft.passNo,
      passType: _passKindTo(draft.kind),
    );
    if (draft.startedAt != null) {
      pass.startedAt = Timestamp.fromDateTime(draft.startedAt!);
    }
    if (draft.endedAt != null) {
      pass.endedAt = Timestamp.fromDateTime(draft.endedAt!);
    }
    await _mediaTag.workService.updatePass(
      work_pb.UpdatePassRequest(
        pass: pass,
        updateMask: FieldMask(paths: draft.changedFields(original)),
      ),
    );
  }

  @override
  Future<void> deletePass({required String passId}) async {
    await _mediaTag.workService.deletePass(
      work_pb.DeletePassRequest(passId: protoId(passId)),
    );
  }

  @override
  Future<void> attachAsset({
    required String jobId,
    required String assetId,
    required String passId,
  }) async {
    await _mediaTag.assetService.attachAsset(
      asset_pb.AttachAssetRequest(
        jobId: protoId(jobId),
        assetId: protoId(assetId),
        passId: protoId(passId),
      ),
    );
  }

  @override
  Future<void> detachAsset({
    required String jobId,
    required String assetId,
  }) async {
    await _mediaTag.assetService.detachAsset(
      asset_pb.DetachAssetRequest(
        jobId: protoId(jobId),
        assetId: protoId(assetId),
      ),
    );
  }

  PassKind _passKindFrom(work_pb.PassType type) {
    switch (type) {
      case work_pb.PassType.PASS_TYPE_ROOT:
        return PassKind.root;
      case work_pb.PassType.PASS_TYPE_HOT:
        return PassKind.hot;
      case work_pb.PassType.PASS_TYPE_FILL:
        return PassKind.fill;
      case work_pb.PassType.PASS_TYPE_CAP:
        return PassKind.cap;
      default:
        return PassKind.unknown;
    }
  }

  work_pb.PassType _passKindTo(PassKind kind) {
    switch (kind) {
      case PassKind.root:
        return work_pb.PassType.PASS_TYPE_ROOT;
      case PassKind.hot:
        return work_pb.PassType.PASS_TYPE_HOT;
      case PassKind.fill:
        return work_pb.PassType.PASS_TYPE_FILL;
      case PassKind.cap:
        return work_pb.PassType.PASS_TYPE_CAP;
      case PassKind.unknown:
        return work_pb.PassType.PASS_TYPE_UNSPECIFIED;
    }
  }
}
