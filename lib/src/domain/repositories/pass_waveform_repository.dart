import '../entities/comparison_job_candidate.dart';
import '../entities/pass_waveform_catalog.dart';
import '../entities/pass_waveform_series.dart';
import '../entities/weld_pass.dart';

abstract class PassWaveformRepository {
  Future<PassWaveformCatalog> loadCatalog({
    String commonKey = '',
    String jobId = '',
    String passId = '',
    String normalize = 'raw',
  });

  Future<PassWaveformSeries> loadWaveform({
    required String passId,
    required String commonKey,
    required String workerId,
    String comparisonPassId = '',
    String normalize = 'raw',
  });

  Future<ComparisonJobPage> listComparisonJobs({
    required String projectNo,
    required String itemCode,
    required String unitNo,
    required String excludeJobId,
    String pageToken = '',
  });

  Future<List<WeldPass>> loadComparisonPasses({required String jobId});
}
