import '../../domain/entities/pass_joint_context.dart';
import '../../domain/entities/pass_waveform_catalog.dart';
import '../../domain/entities/series_role.dart';
import '../../domain/entities/waveform_row.dart';
import '../../domain/entities/weld_pass.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/pass_waveform_repository.dart';
import '../datasources/generated/dashboard_service.pb.dart' as pb;
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/dashboard_service_data_source.dart';
import '../datasources/remote/media_tag_data_source.dart';

class RemotePassWaveformRepository implements PassWaveformRepository {
  RemotePassWaveformRepository(this._source, this._mediaTag);

  final DashboardServiceDataSource _source;
  final MediaTagDataSource _mediaTag;

  @override
  Future<PassWaveformCatalog> loadCatalog({
    String commonKey = '',
    String historyId = '',
    String passId = '',
    String normalize = 'raw',
  }) async {
    if (historyId.isEmpty) {
      return const PassWaveformCatalog(
        passes: [],
        waveformRows: [],
        links: [],
        qualityGroups: [],
        historyItems: [],
        workers: [],
      );
    }
    final response = await _mediaTag.workService.getJob(
      work_pb.GetJobRequest(jobId: historyId),
    );
    if (!response.hasJob() || response.job.jobId.isEmpty) {
      return const PassWaveformCatalog(
        passes: [],
        waveformRows: [],
        links: [],
        qualityGroups: [],
        historyItems: [],
        workers: [],
      );
    }
    final job = response.job;
    final passes = [
      for (final item in response.passes)
        WeldPass(
          passId: item.passId,
          commonKey: job.commonKey,
          passNo: item.passNo,
          passName: '',
          masterProfileId: '',
          controlWorkerId: job.workerId,
        ),
    ]..sort((left, right) => left.passNo.compareTo(right.passNo));
    final selectedPassId = passId.isNotEmpty
        ? passId
        : (passes.isNotEmpty ? passes.first.passId : '');
    final waveforms = await _waveformRows(
      passId: selectedPassId,
      commonKey: job.commonKey,
      normalize: normalize,
    );
    final worker = response.hasWorker() ? response.worker : null;
    return PassWaveformCatalog(
      passes: passes,
      waveformRows: waveforms,
      links: const [],
      qualityGroups: const [],
      historyItems: [_itemFrom(response)],
      workers: worker == null || worker.workerId.isEmpty
          ? const []
          : [Worker(workerId: worker.workerId, workerName: worker.workerName)],
      context: _contextFrom(response),
    );
  }

  Future<List<WaveformRow>> _waveformRows({
    required String passId,
    required String commonKey,
    required String normalize,
  }) async {
    if (passId.isEmpty) {
      return const [];
    }
    final pb.GetPassWaveformResponse waveform;
    try {
      waveform = await _source.client.getPassWaveform(
        pb.GetPassWaveformRequest(passId: passId, normalize: normalize),
      );
    } catch (_) {
      return const [];
    }
    final rows = <WaveformRow>[];
    final seriesKey = waveform.commonKey.isEmpty
        ? commonKey
        : waveform.commonKey;
    for (final series in waveform.series) {
      final role = SeriesRole.fromCsv(series.role);
      if (role == null) {
        continue;
      }
      for (final point in series.points) {
        rows.add(
          WaveformRow(
            seriesId: '${passId}_${series.role}',
            passId: passId,
            commonKey: seriesKey,
            seriesRole: role,
            masterProfileId: series.masterProfileId,
            workerId: series.workerId,
            robotId: series.robotId,
            timeMs: point.t,
            currentA: point.hasCurrentA() ? point.currentA : null,
            voltageV: point.hasVoltageV() ? point.voltageV : null,
            speedValue: point.hasWireFeedSpeedMpm()
                ? point.wireFeedSpeedMpm
                : null,
            rotationSpeedRpm: point.hasRotationSpeedRpm()
                ? point.rotationSpeedRpm
                : null,
          ),
        );
      }
    }
    return rows;
  }

  WorkHistoryItem _itemFrom(work_pb.GetJobResponse response) {
    final job = response.job;
    final equipmentNames = [
      for (final item in response.equipment)
        if (item.equipmentName.isNotEmpty) item.equipmentName,
    ];
    return WorkHistoryItem(
      historyId: job.jobId,
      commonKey: job.commonKey,
      projectNo: job.projectNo,
      unitNo: job.unitNo,
      itemCode: job.itemCode,
      itemName: job.itemName,
      workerId: job.workerId,
      workerName: response.hasWorker() ? response.worker.workerName : '',
      equipmentId: response.equipment.length == 1
          ? response.equipment.first.equipmentId
          : '',
      equipmentName: equipmentNames.join(', '),
      workedAt: job.hasStartedAt()
          ? job.startedAt.toDateTime().toLocal()
          : null,
      passCount: response.passes.length,
      attachmentCount: 0,
    );
  }

  PassJointContext _contextFrom(work_pb.GetJobResponse response) {
    final job = response.job;
    final equipmentNames = [
      for (final item in response.equipment)
        if (item.equipmentName.isNotEmpty) item.equipmentName,
    ];
    return PassJointContext(
      commonKey: job.commonKey,
      projectNo: job.projectNo,
      unitNo: job.unitNo,
      itemCode: job.itemCode,
      itemName: job.itemName,
      workerName: response.hasWorker() ? response.worker.workerName : '',
      equipmentName: equipmentNames.join(', '),
    );
  }
}
