import '../entities/equipment.dart';
import '../repositories/equipment_lookup_repository.dart';

class GetEquipmentLookupUseCase {
  GetEquipmentLookupUseCase(this._repository);

  final EquipmentLookupRepository _repository;

  Future<Equipment?> execute({required String equipmentId}) {
    return _repository.getEquipment(equipmentId: equipmentId);
  }
}
