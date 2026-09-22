import '../entities/work_history_catalog.dart';
import '../repositories/work_history_repository.dart';

class LoadWorkHistoryMastersUseCase {
  LoadWorkHistoryMastersUseCase(this._repository);

  final WorkHistoryRepository _repository;

  Future<WorkHistoryCatalog> execute() => _repository.loadMasters();
}
