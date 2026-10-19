class Equipment {
  const Equipment({
    required this.equipmentId,
    required this.equipmentName,
    required this.lineName,
    this.equipmentCode = '',
    this.description = '',
    this.isInactive = false,
    this.jobCount = 0,
  });

  final String equipmentId;
  final String equipmentName;
  final String lineName;
  final String equipmentCode;
  final String description;
  final bool isInactive;
  final int jobCount;
}
