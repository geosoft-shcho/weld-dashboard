import '../repositories/equipment_lookup_repository.dart';

class CreateEquipmentUseCase {
  const CreateEquipmentUseCase(this._repository);

  final EquipmentLookupRepository _repository;

  Future<String> execute({
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
  }) {
    return _repository.createEquipment(
      equipmentName: equipmentName,
      equipmentCode: equipmentCode,
      description: description,
      isInactive: isInactive,
    );
  }
}
