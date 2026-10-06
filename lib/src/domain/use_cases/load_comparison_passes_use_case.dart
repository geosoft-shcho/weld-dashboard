import '../entities/weld_pass.dart';
import '../repositories/pass_waveform_repository.dart';

class LoadComparisonPassesUseCase {
  LoadComparisonPassesUseCase(this._repository);

  final PassWaveformRepository _repository;

  Future<List<WeldPass>> execute({required String jobId}) {
    return _repository.loadComparisonPasses(jobId: jobId);
  }
}
