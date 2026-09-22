import '../entities/pass_waveform_catalog.dart';

abstract class PassWaveformRepository {
  Future<PassWaveformCatalog> loadCatalog({
    String commonKey = '',
    String historyId = '',
    String passId = '',
    String normalize = 'raw',
  });
}
