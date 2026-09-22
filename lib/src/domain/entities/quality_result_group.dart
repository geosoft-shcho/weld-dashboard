import 'quality_result_item.dart';
import 'quality_media.dart';
import 'quality_media_tab.dart';

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
    required this.videoFile,
    required this.items,
    this.media = const [],
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
  final String videoFile;
  final List<QualityResultItem> items;
  final List<QualityMedia> media;

  bool get doesHaveScanFile =>
      scanFile.trim().isNotEmpty ||
      media.any(
        (item) => item.type == QualityMediaTab.pdf && item.url.isNotEmpty,
      );
  bool get doesHaveVideoFile =>
      videoFile.trim().isNotEmpty ||
      media.any(
        (item) => item.type == QualityMediaTab.video && item.url.isNotEmpty,
      );
}
