class QualityIssueArgs {
  const QualityIssueArgs({
    required this.commonKey,
    required this.historyId,
    this.passId = '',
    this.linkId = '',
  });

  final String commonKey;
  final String historyId;
  final String passId;
  final String linkId;
}
