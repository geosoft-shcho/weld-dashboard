import '../../domain/entities/quality_link.dart';

class QualityLinkDto {
  const QualityLinkDto({
    required this.linkId,
    required this.commonKey,
    required this.qualityResultId,
    required this.passId,
    required this.segmentId,
    required this.startMs,
    required this.endMs,
    required this.note,
  });

  factory QualityLinkDto.fromRow(Map<String, String> row) {
    return QualityLinkDto(
      linkId: row['link_id'] ?? '',
      commonKey: row['common_key'] ?? '',
      qualityResultId: row['quality_result_id'] ?? '',
      passId: row['pass_id'] ?? '',
      segmentId: row['segment_id'] ?? '',
      startMs: int.tryParse(row['segment_start_ms'] ?? '') ?? 0,
      endMs: int.tryParse(row['segment_end_ms'] ?? '') ?? 0,
      note: row['note'] ?? '',
    );
  }

  final String linkId;
  final String commonKey;
  final String qualityResultId;
  final String passId;
  final String segmentId;
  final int startMs;
  final int endMs;
  final String note;

  QualityLink? toDomain() {
    if (linkId.isEmpty || commonKey.isEmpty) {
      return null;
    }
    return QualityLink(
      linkId: linkId,
      commonKey: commonKey,
      qualityResultId: qualityResultId,
      passId: passId,
      segmentId: segmentId,
      startMs: startMs,
      endMs: endMs,
      note: note,
    );
  }
}
