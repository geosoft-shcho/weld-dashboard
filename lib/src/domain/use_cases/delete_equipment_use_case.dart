import '../repositories/equipment_lookup_repository.dart';

class DeleteEquipmentUseCase {
  const DeleteEquipmentUseCase(this._repository);

  final EquipmentLookupRepository _repository;

  Future<void> execute({required String equipmentId}) {
    return _repository.deleteEquipment(equipmentId: equipmentId);
  }
}
