class PassJointContext {
  const PassJointContext({
    required this.commonKey,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    required this.itemName,
    this.jointNo = '',
    required this.workerName,
    this.isMaster,
    required this.equipmentName,
  });

  final String commonKey;
  final String projectNo;
  final String unitNo;
  final String itemCode;
  final String itemName;
  final String jointNo;
  final String workerName;
  final bool? isMaster;
  final String equipmentName;
}
