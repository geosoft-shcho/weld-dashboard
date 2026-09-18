class QualityLink {
  const QualityLink({
    required this.linkId,
    required this.commonKey,
    required this.qualityResultId,
    required this.passId,
    required this.segmentId,
    required this.startMs,
    required this.endMs,
    required this.note,
  });

  final String linkId;
  final String commonKey;
  final String qualityResultId;
  final String passId;
  final String segmentId;
  final int startMs;
  final int endMs;
  final String note;
}
