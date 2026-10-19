import '../entities/equipment.dart';

abstract class EquipmentLookupRepository {
  Future<List<Equipment>> listEquipment();
}
