import '../entities/pass_waveform_catalog.dart';
import '../repositories/pass_waveform_repository.dart';

class LoadPassWaveformCatalogUseCase {
  LoadPassWaveformCatalogUseCase(this._repository);

  final PassWaveformRepository _repository;

  Future<PassWaveformCatalog> execute() {
    return _repository.loadCatalog();
  }
}
