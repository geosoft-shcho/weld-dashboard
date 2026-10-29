import '../entities/equipment.dart';
import '../entities/lookup_page.dart';

abstract class EquipmentLookupRepository {
  Future<Equipment?> getEquipment({required String equipmentId});

  Future<LookupPage<Equipment>> listEquipment({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  });

  Future<String> createEquipment({
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
  });

  Future<void> updateEquipment({
    required String equipmentId,
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  });

  Future<void> deleteEquipment({required String equipmentId});
}
