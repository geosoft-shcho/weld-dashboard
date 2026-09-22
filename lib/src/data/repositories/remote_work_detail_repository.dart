import '../../domain/entities/work_attachment.dart';
import '../../domain/entities/work_attachment_type.dart';
import '../../domain/entities/work_detail_catalog.dart';
import '../../domain/repositories/work_detail_repository.dart';
import '../datasources/generated/dashboard_service.pb.dart' as pb;
import '../datasources/remote/dashboard_service_data_source.dart';
import 'remote_work_history_repository.dart';

class RemoteWorkDetailRepository implements WorkDetailRepository {
  RemoteWorkDetailRepository(this._source);

  final DashboardServiceDataSource _source;

  @override
  Future<WorkDetailCatalog> loadCatalog({String historyId = ''}) async {
    final histories = await _source.client.listWorkHistory(
      pb.ListWorkHistoryRequest(historyId: historyId),
    );
    final response = await _source.client.listWorkAttachments(
      pb.ListWorkAttachmentsRequest(),
    );
    final attachments = <WorkAttachment>[];
    for (final item in response.items) {
      final type = WorkAttachmentType.fromCsv(item.fileType);
      if (type == null) continue;
      attachments.add(
        WorkAttachment(
          attachmentId: item.attachmentId,
          historyId: item.historyId,
          fileType: type,
          fileName: item.fileName,
          note: item.note,
          content: item.fileUrl.isEmpty
              ? item.content
              : _source.resolveFileUrl(item.fileUrl),
        ),
      );
    }
    return WorkDetailCatalog(
      items: [for (final item in histories.items) workHistoryItemFrom(item)],
      attachments: attachments,
    );
  }
}
