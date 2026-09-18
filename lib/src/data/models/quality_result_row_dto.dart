import '../../domain/entities/quality_result_group.dart';
import '../../domain/entities/quality_result_item.dart';

class QualityResultRowDto {
  const QualityResultRowDto({
    required this.qualityResultId,
    required this.paperDocNo,
    required this.commonKey,
    required this.passId,
    required this.segmentId,
    required this.inspectedAt,
    required this.inspectorName,
    required this.judgement,
    required this.issueSummary,
    required this.itemName,
    required this.itemResult,
    required this.itemNote,
    required this.scanFile,
    required this.scanPages,
  });

  factory QualityResultRowDto.fromRow(Map<String, String> row) {
    return QualityResultRowDto(
      qualityResultId: row['quality_result_id'] ?? '',
      paperDocNo: row['paper_doc_no'] ?? '',
      commonKey: row['common_key'] ?? '',
      passId: row['pass_id'] ?? '',
      segmentId: row['segment_id'] ?? '',
      inspectedAt: row['inspected_at'] ?? '',
      inspectorName: row['inspector_name'] ?? '',
      judgement: row['judgement'] ?? '',
      issueSummary: row['issue_summary'] ?? '',
      itemName: row['item_name'] ?? '',
      itemResult: row['item_result'] ?? '',
      itemNote: row['item_note'] ?? '',
      scanFile: row['scan_file'] ?? '',
      scanPages: int.tryParse(row['scan_pages'] ?? '') ?? 0,
    );
  }

  final String qualityResultId;
  final String paperDocNo;
  final String commonKey;
  final String passId;
  final String segmentId;
  final String inspectedAt;
  final String inspectorName;
  final String judgement;
  final String issueSummary;
  final String itemName;
  final String itemResult;
  final String itemNote;
  final String scanFile;
  final int scanPages;

  QualityResultItem toItem() {
    return QualityResultItem(
      itemName: itemName,
      itemResult: itemResult,
      itemNote: itemNote,
    );
  }

  QualityResultGroup toGroupSeed(List<QualityResultItem> items) {
    return QualityResultGroup(
      qualityResultId: qualityResultId,
      paperDocNo: paperDocNo,
      commonKey: commonKey,
      passId: passId,
      segmentId: segmentId,
      inspectedAt: inspectedAt,
      inspectorName: inspectorName,
      judgement: judgement,
      issueSummary: issueSummary,
      scanFile: scanFile,
      scanPages: scanPages,
      items: items,
    );
  }
}
