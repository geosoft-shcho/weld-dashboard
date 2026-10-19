import '../entities/equipment.dart';
import '../repositories/equipment_lookup_repository.dart';

class ListEquipmentLookupUseCase {
  ListEquipmentLookupUseCase(this._repository);

  final EquipmentLookupRepository _repository;

  Future<List<Equipment>> execute() => _repository.listEquipment();
}
