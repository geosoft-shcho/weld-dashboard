import '../../domain/entities/work_attachment.dart';
import '../../domain/entities/work_attachment_type.dart';
import '../../domain/entities/work_detail_catalog.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/repositories/work_detail_repository.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pb.dart' as asset_pb;
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';

class RemoteWorkDetailRepository implements WorkDetailRepository {
  RemoteWorkDetailRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    if (jobId.isEmpty) {
      return const WorkDetailCatalog(items: [], attachments: []);
    }
    final response = await _mediaTag.workService.getJob(
      work_pb.GetJobRequest(jobId: jobId),
    );
    if (!response.hasJob() || response.job.jobId.isEmpty) {
      return const WorkDetailCatalog(items: [], attachments: []);
    }
    final attachments = await listAttachments(jobId: jobId);
    return WorkDetailCatalog(
      items: [_itemFrom(response, attachmentCount: attachments.length)],
      attachments: attachments,
    );
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    if (jobId.isEmpty) {
      return const [];
    }
    final response = await _mediaTag.assetService.listJobAssets(
      asset_pb.ListJobAssetsRequest(jobId: jobId),
    );
    final attachments = <WorkAttachment>[];
    for (final item in response.assets) {
      final asset = item.asset;
      final type = _typeOf(asset);
      if (type == null || asset.assetId.isEmpty) {
        continue;
      }
      attachments.add(
        WorkAttachment(
          attachmentId: asset.assetId,
          jobId: jobId,
          fileType: type,
          fileName: asset.fileName,
          note: '',
          content: _mediaTag.resolveContentUrl(asset.contentUrl),
        ),
      );
    }
    return attachments;
  }

  WorkHistoryItem _itemFrom(
    work_pb.GetJobResponse response, {
    required int attachmentCount,
  }) {
    final job = response.job;
    final equipmentNames = [
      for (final item in response.equipment)
        if (item.equipmentName.isNotEmpty) item.equipmentName,
    ];
    return WorkHistoryItem(
      jobId: job.jobId,
      commonKey: job.commonKey,
      projectNo: job.projectNo,
      unitNo: job.unitNo,
      itemCode: job.itemCode,
      itemName: job.itemName,
      jointNo: job.jointNo,
      workerId: job.workerId,
      workerName: response.hasWorker() ? response.worker.workerName : '',
      equipmentId: response.equipment.length == 1
          ? response.equipment.first.equipmentId
          : '',
      equipmentName: equipmentNames.join(', '),
      workedAt: job.hasStartedAt()
          ? job.startedAt.toDateTime().toLocal()
          : null,
      passCount: response.passes.length,
      attachmentCount: attachmentCount,
    );
  }

  WorkAttachmentType? _typeOf(asset_pb.Asset asset) {
    switch (asset.kind) {
      case asset_pb.AssetKind.ASSET_KIND_IMAGE:
        return WorkAttachmentType.image;
      case asset_pb.AssetKind.ASSET_KIND_VIDEO:
        return WorkAttachmentType.video;
      case asset_pb.AssetKind.ASSET_KIND_AUDIO:
        return WorkAttachmentType.audio;
      case asset_pb.AssetKind.ASSET_KIND_DOCUMENT:
        return WorkAttachmentType.fromFileName(asset.fileName) ??
            WorkAttachmentType.pdf;
      case asset_pb.AssetKind.ASSET_KIND_TIMESERIES:
      case asset_pb.AssetKind.ASSET_KIND_SUBTITLE:
      case asset_pb.AssetKind.ASSET_KIND_OCR_JSON:
        return WorkAttachmentType.fromFileName(asset.fileName) ??
            WorkAttachmentType.text;
      default:
        return WorkAttachmentType.fromFileName(asset.fileName);
    }
  }
}
