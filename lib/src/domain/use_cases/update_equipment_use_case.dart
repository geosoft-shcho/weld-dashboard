import '../repositories/equipment_lookup_repository.dart';

class UpdateEquipmentUseCase {
  const UpdateEquipmentUseCase(this._repository);

  final EquipmentLookupRepository _repository;

  Future<void> execute({
    required String equipmentId,
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  }) {
    return _repository.updateEquipment(
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      equipmentCode: equipmentCode,
      description: description,
      isInactive: isInactive,
      changedFields: changedFields,
    );
  }
}
