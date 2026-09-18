import 'quality_result_item.dart';

class QualityResultGroup {
  const QualityResultGroup({
    required this.qualityResultId,
    required this.paperDocNo,
    required this.commonKey,
    required this.passId,
    required this.segmentId,
    required this.inspectedAt,
    required this.inspectorName,
    required this.judgement,
    required this.issueSummary,
    required this.scanFile,
    required this.scanPages,
    required this.items,
  });

  final String qualityResultId;
  final String paperDocNo;
  final String commonKey;
  final String passId;
  final String segmentId;
  final String inspectedAt;
  final String inspectorName;
  final String judgement;
  final String issueSummary;
  final String scanFile;
  final int scanPages;
  final List<QualityResultItem> items;

  bool get doesHaveScanFile => scanFile.trim().isNotEmpty;
}
