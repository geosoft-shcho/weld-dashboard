class PassProfileArgs {
  const PassProfileArgs({
    required this.commonKey,
    required this.jobId,
    this.passId = '',
  });

  final String commonKey;
  final String jobId;
  final String passId;
}
