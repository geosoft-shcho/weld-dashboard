import '../entities/pass_waveform_series.dart';
import '../repositories/pass_waveform_repository.dart';

class LoadPassWaveformUseCase {
  LoadPassWaveformUseCase(this._repository);

  final PassWaveformRepository _repository;

  Future<PassWaveformSeries> execute({
    required String passId,
    required String commonKey,
    required String workerId,
    String comparisonPassId = '',
    String normalize = 'raw',
  }) {
    return _repository.loadWaveform(
      passId: passId,
      commonKey: commonKey,
      workerId: workerId,
      comparisonPassId: comparisonPassId,
      normalize: normalize,
    );
  }
}
