class PassProfileArgs {
  const PassProfileArgs({
    required this.commonKey,
    required this.historyId,
    this.passId = '',
  });

  final String commonKey;
  final String historyId;
  final String passId;
}
