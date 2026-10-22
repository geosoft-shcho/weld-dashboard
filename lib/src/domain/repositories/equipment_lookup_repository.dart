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
}
