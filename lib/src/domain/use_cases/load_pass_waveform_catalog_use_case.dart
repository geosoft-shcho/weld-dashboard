import '../entities/pass_waveform_catalog.dart';
import '../repositories/pass_waveform_repository.dart';

class LoadPassWaveformCatalogUseCase {
  LoadPassWaveformCatalogUseCase(this._repository);

  final PassWaveformRepository _repository;

  Future<PassWaveformCatalog> execute({
    String commonKey = '',
    String jobId = '',
    String passId = '',
    String normalize = 'raw',
  }) {
    return _repository.loadCatalog(
      commonKey: commonKey,
      jobId: jobId,
      passId: passId,
      normalize: normalize,
    );
  }
}
