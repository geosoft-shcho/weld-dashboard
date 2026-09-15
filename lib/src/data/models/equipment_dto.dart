import '../../domain/entities/equipment.dart';

class EquipmentDto {
  const EquipmentDto({
    required this.equipmentId,
    required this.equipmentName,
    required this.lineName,
  });

  factory EquipmentDto.fromRow(Map<String, String> row) {
    return EquipmentDto(
      equipmentId: row['equipment_id'] ?? '',
      equipmentName: row['equipment_name'] ?? '',
      lineName: row['line_name'] ?? '',
    );
  }

  final String equipmentId;
  final String equipmentName;
  final String lineName;

  Equipment toDomain() {
    return Equipment(
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      lineName: lineName,
    );
  }
}
