class LatestQualityIssueTarget {
  const LatestQualityIssueTarget({
    required this.commonKey,
    required this.jobId,
    this.passId = '',
    this.linkId = '',
  });

  final String commonKey;
  final String jobId;
  final String passId;
  final String linkId;
}
