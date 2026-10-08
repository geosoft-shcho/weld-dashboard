import 'package:connectrpc/connect.dart';

import '../../domain/entities/comparison_job_candidate.dart';
import '../../domain/entities/pass_joint_context.dart';
import '../../domain/entities/pass_waveform_catalog.dart';
import '../../domain/entities/pass_waveform_series.dart';
import '../../domain/entities/series_role.dart';
import '../../domain/entities/waveform_row.dart';
import '../../domain/entities/weld_pass.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/pass_waveform_repository.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemotePassWaveformRepository implements PassWaveformRepository {
  RemotePassWaveformRepository(this._mediaTag);

  static const int COMPARISON_PAGE_SIZE = 50;

  final MediaTagDataSource _mediaTag;

  @override
  Future<PassWaveformCatalog> loadCatalog({
    String commonKey = '',
    String jobId = '',
    String passId = '',
    String normalize = 'raw',
  }) async {
    if (jobId.isEmpty) {
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
      work_pb.GetJobRequest(jobId: protoId(jobId)),
    );
    if (!response.hasJob() || idText(response.job.jobId).isEmpty) {
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
          passId: idText(item.passId),
          commonKey: job.commonKey,
          passNo: item.passNo,
          passName: '',
          masterProfileId: '',
          controlWorkerId: idText(job.workerId),
          startedAt: item.hasStartedAt() ? item.startedAt.toDateTime() : null,
        ),
    ]..sort((left, right) => left.passNo.compareTo(right.passNo));
    final selectedPassId = passId.isNotEmpty
        ? passId
        : (passes.isNotEmpty ? passes.first.passId : '');
    final waveforms = await _waveformRows(
      passId: selectedPassId,
      commonKey: job.commonKey,
      workerId: idText(job.workerId),
      normalize: normalize,
    );
    final worker = response.hasWorker() ? response.worker : null;
    return PassWaveformCatalog(
      passes: passes,
      waveformRows: waveforms.rows,
      waveformNotice: waveforms.notice,
      didFallBackToRaw: waveforms.didFallBackToRaw,
      links: const [],
      qualityGroups: const [],
      historyItems: [_itemFrom(response)],
      workers: worker == null || idText(worker.workerId).isEmpty
          ? const []
          : [
              Worker(
                workerId: idText(worker.workerId),
                workerName: worker.workerName,
              ),
            ],
      context: _contextFrom(response),
    );
  }

  @override
  Future<PassWaveformSeries> loadWaveform({
    required String passId,
    required String commonKey,
    required String workerId,
    String comparisonPassId = '',
    String normalize = 'raw',
  }) async {
    final waveforms = await _waveformRows(
      passId: passId,
      commonKey: commonKey,
      workerId: workerId,
      comparisonPassId: comparisonPassId,
      normalize: normalize,
    );
    return PassWaveformSeries(
      rows: waveforms.rows,
      notice: waveforms.notice,
      didFallBackToRaw: waveforms.didFallBackToRaw,
    );
  }

  @override
  Future<ComparisonJobPage> listComparisonJobs({
    required String projectNo,
    required String itemCode,
    required String unitNo,
    required String excludeJobId,
    String pageToken = '',
  }) async {
    final response = await _mediaTag.workService.listJobs(
      work_pb.ListJobsRequest(
        projectNo: projectNo,
        itemCode: itemCode,
        unitNo: unitNo,
        masterOnly: true,
        pageSize: COMPARISON_PAGE_SIZE,
        pageToken: pageToken,
      ),
    );
    final jobs = <ComparisonJobCandidate>[];
    for (final summary in response.jobs) {
      final candidateId = idText(summary.job.jobId);
      if (candidateId.isEmpty || candidateId == excludeJobId) {
        continue;
      }
      jobs.add(
        ComparisonJobCandidate(
          jobId: candidateId,
          jobKey: summary.job.jobKey,
          workerName: summary.workerName,
          isMaster: summary.hasIsMaster() ? summary.isMaster : null,
          startedAt: summary.job.hasStartedAt()
              ? summary.job.startedAt.toDateTime().toLocal()
              : null,
          passCount: summary.passCount,
        ),
      );
    }
    return ComparisonJobPage(jobs: jobs, nextPageToken: response.nextPageToken);
  }

  @override
  Future<List<WeldPass>> loadComparisonPasses({required String jobId}) async {
    if (jobId.isEmpty) {
      throw const ComparisonJobNotFoundException();
    }
    try {
      final response = await _mediaTag.workService.getJob(
        work_pb.GetJobRequest(jobId: protoId(jobId)),
      );
      if (!response.hasJob() || idText(response.job.jobId).isEmpty) {
        throw const ComparisonJobNotFoundException();
      }
      final job = response.job;
      final passes = [
        for (final item in response.passes)
          WeldPass(
            passId: idText(item.passId),
            commonKey: job.commonKey,
            passNo: item.passNo,
            passName: '',
            masterProfileId: '',
            controlWorkerId: idText(job.workerId),
            startedAt: item.hasStartedAt() ? item.startedAt.toDateTime() : null,
          ),
      ]..sort((left, right) => left.passNo.compareTo(right.passNo));
      return passes;
    } on ConnectException {
      throw const ComparisonJobNotFoundException();
    }
  }

  Future<_WaveformLoad> _waveformRows({
    required String passId,
    required String commonKey,
    required String workerId,
    String comparisonPassId = '',
    required String normalize,
  }) async {
    if (passId.isEmpty) {
      return const _WaveformLoad(rows: []);
    }
    final askedDtw =
        _waveformNormalize(normalize) ==
        work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_DTW;
    var useDtw = askedDtw && comparisonPassId.isNotEmpty;
    var useComparisonPassId = comparisonPassId;
    var notice = '';
    var didFallBackToRaw = false;
    while (true) {
      try {
        final response = await _mediaTag.workService.getPassWaveform(
          _waveformRequest(
            passId: passId,
            comparisonPassId: useComparisonPassId,
            useDtw: useDtw,
          ),
        );
        return _WaveformLoad(
          rows: _rowsFromResponse(
            response,
            passId: passId,
            commonKey: commonKey,
            workerId: workerId,
          ),
          notice: notice,
          didFallBackToRaw: didFallBackToRaw,
        );
      } on ConnectException catch (error) {
        if (useDtw && error.code == Code.invalidArgument) {
          useDtw = false;
          didFallBackToRaw = true;
          notice = 'DTW 서버가 없어 원본 파형으로 돌아왔습니다.';
          continue;
        }
        if (useComparisonPassId.isNotEmpty && error.code == Code.notFound) {
          useComparisonPassId = '';
          useDtw = false;
          if (askedDtw) {
            didFallBackToRaw = true;
          }
          notice = '비교 패스를 찾지 못해 대상 파형만 표시합니다.';
          continue;
        }
        rethrow;
      }
    }
  }

  work_pb.GetPassWaveformRequest _waveformRequest({
    required String passId,
    required String comparisonPassId,
    required bool useDtw,
  }) {
    final request = work_pb.GetPassWaveformRequest(
      passId: protoId(passId),
      normalize: useDtw
          ? work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_DTW
          : work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_UNSPECIFIED,
    );
    final comparisonId = protoIdOrNull(comparisonPassId);
    if (comparisonId != null) {
      request.comparisonPassId = comparisonId;
    }
    return request;
  }

  List<WaveformRow> _rowsFromResponse(
    work_pb.GetPassWaveformResponse response, {
    required String passId,
    required String commonKey,
    required String workerId,
  }) {
    if (!response.hasTarget()) {
      return const [];
    }
    final targetRole = _seriesRole(response.target, isComparison: false);
    final rows = <WaveformRow>[
      ..._rowsFromWaveform(
        response.target,
        passId: passId,
        commonKey: commonKey,
        workerId: workerId,
        role: targetRole,
      ),
    ];
    if (response.hasComparison()) {
      var comparisonRole = _seriesRole(response.comparison, isComparison: true);
      if (comparisonRole == targetRole) {
        comparisonRole = targetRole == SeriesRole.master
            ? SeriesRole.beginner
            : SeriesRole.master;
      }
      rows.addAll(
        _rowsFromWaveform(
          response.comparison,
          passId: passId,
          commonKey: commonKey,
          workerId: workerId,
          role: comparisonRole,
        ),
      );
    }
    return rows;
  }

  SeriesRole _seriesRole(
    work_pb.PassWaveform waveform, {
    required bool isComparison,
  }) {
    if (waveform.hasIsMaster()) {
      return waveform.isMaster ? SeriesRole.master : SeriesRole.beginner;
    }
    return isComparison ? SeriesRole.master : SeriesRole.beginner;
  }

  List<WaveformRow> _rowsFromWaveform(
    work_pb.PassWaveform waveform, {
    required String passId,
    required String commonKey,
    required String workerId,
    required SeriesRole role,
  }) {
    final rows = <WaveformRow>[];
    for (final series in waveform.series) {
      final count = series.tOffsetNs.length;
      for (var index = 0; index < count; index++) {
        double? currentA;
        double? voltageV;
        double? speedValue;
        double? rotationSpeedRpm;
        for (final channel in series.channels) {
          final value = _channelValue(channel, index);
          switch (_channelKey(channel.name)) {
            case 'current_a':
            case '전류_a':
              currentA = value;
            case 'voltage_v':
            case '전압_v':
              voltageV = value;
            case 'wire_feed_speed_mpm':
              speedValue = value;
            case 'rotation_speed_rpm':
              rotationSpeedRpm = value;
          }
        }
        rows.add(
          WaveformRow(
            seriesId: idText(series.assetId).isEmpty
                ? (idText(waveform.passId).isEmpty
                      ? passId
                      : idText(waveform.passId))
                : idText(series.assetId),
            passId: passId,
            commonKey: commonKey,
            seriesRole: role,
            masterProfileId: '',
            workerId: workerId,
            robotId: '',
            timeMs: series.tOffsetNs[index].toInt(),
            currentA: currentA,
            voltageV: voltageV,
            speedValue: speedValue,
            rotationSpeedRpm: rotationSpeedRpm,
          ),
        );
      }
    }
    return rows;
  }

  work_pb.WaveformNormalize _waveformNormalize(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dtw':
        return work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_DTW;
      default:
        return work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_UNSPECIFIED;
    }
  }

  String _channelKey(String name) {
    final slash = name.lastIndexOf('/');
    final bare = slash < 0 ? name : name.substring(slash + 1);
    return bare.trim().toLowerCase();
  }

  double? _channelValue(work_pb.WaveformChannel channel, int index) {
    if (index < 0 || index >= channel.values.length) {
      return null;
    }
    final value = channel.values[index];
    if (value.isNaN) {
      return null;
    }
    return value;
  }

  WorkHistoryItem _itemFrom(work_pb.GetJobResponse response) {
    final job = response.job;
    final equipmentNames = [
      for (final item in response.equipment)
        if (item.equipmentName.isNotEmpty) item.equipmentName,
    ];
    return WorkHistoryItem(
      jobId: idText(job.jobId),
      jobKey: job.jobKey,
      commonKey: job.commonKey,
      projectNo: job.projectNo,
      unitNo: job.unitNo,
      itemCode: job.itemCode,
      itemName: job.itemName,
      jointNo: job.jointNo,
      workerId: idText(job.workerId),
      workerName: response.hasWorker() ? response.worker.workerName : '',
      isMaster: response.hasWorker() && response.worker.hasIsMaster()
          ? response.worker.isMaster
          : null,
      equipmentId: response.equipment.length == 1
          ? idText(response.equipment.first.equipmentId)
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
      jointNo: job.jointNo,
      workerName: response.hasWorker() ? response.worker.workerName : '',
      isMaster: response.hasWorker() && response.worker.hasIsMaster()
          ? response.worker.isMaster
          : null,
      equipmentName: equipmentNames.join(', '),
    );
  }
}

class _WaveformLoad {
  const _WaveformLoad({
    required this.rows,
    this.notice = '',
    this.didFallBackToRaw = false,
  });

  final List<WaveformRow> rows;
  final String notice;
  final bool didFallBackToRaw;
}
