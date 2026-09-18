class WeldPass {
  const WeldPass({
    required this.passId,
    required this.commonKey,
    required this.passNo,
    required this.passName,
    required this.masterProfileId,
    required this.controlWorkerId,
  });

  final String passId;
  final String commonKey;
  final int passNo;
  final String passName;
  final String masterProfileId;
  final String controlWorkerId;
}
