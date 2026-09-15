import '../../domain/entities/work_attachment.dart';
import '../../domain/entities/work_detail_catalog.dart';
import '../../domain/repositories/work_detail_repository.dart';
import '../../domain/repositories/work_history_repository.dart';
import '../datasources/local/csv_asset_data_source.dart';
import '../models/work_attachment_dto.dart';

class WorkDetailRepositoryImpl implements WorkDetailRepository {
  WorkDetailRepositoryImpl({
    required WorkHistoryRepository workHistoryRepository,
    required CsvAssetDataSource csvAssetDataSource,
  }) : _workHistoryRepository = workHistoryRepository,
       _csvAssetDataSource = csvAssetDataSource;

  final WorkHistoryRepository _workHistoryRepository;
  final CsvAssetDataSource _csvAssetDataSource;

  @override
  Future<WorkDetailCatalog> loadCatalog() async {
    final history = await _workHistoryRepository.loadCatalog();
    final rows = await _csvAssetDataSource.loadWorkAttachmentRows();
    final attachments = <WorkAttachment>[];
    for (final row in rows) {
      final attachment = WorkAttachmentDto.fromRow(row).toDomain();
      if (attachment != null) {
        attachments.add(attachment);
      }
    }
    return WorkDetailCatalog(items: history.items, attachments: attachments);
  }
}
