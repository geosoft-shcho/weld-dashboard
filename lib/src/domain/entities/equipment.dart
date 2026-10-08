class Equipment {
  const Equipment({
    required this.equipmentId,
    required this.equipmentName,
    required this.lineName,
    this.equipmentCode = '',
  });

  final String equipmentId;
  final String equipmentName;
  final String lineName;
  final String equipmentCode;
}
