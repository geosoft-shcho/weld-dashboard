import 'package:connectrpc/connect.dart';

import '../../domain/entities/pass_joint_context.dart';
import '../../domain/entities/pass_waveform_catalog.dart';
import '../../domain/entities/series_role.dart';
import '../../domain/entities/waveform_row.dart';
import '../../domain/entities/weld_pass.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/pass_waveform_repository.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';

class RemotePassWaveformRepository implements PassWaveformRepository {
  RemotePassWaveformRepository(this._mediaTag);

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
      job: job,
      passes: response.passes,
      passId: selectedPassId,
      commonKey: job.commonKey,
      workerId: job.workerId,
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
      workers: worker == null || worker.workerId.isEmpty
          ? const []
          : [Worker(workerId: worker.workerId, workerName: worker.workerName)],
      context: _contextFrom(response),
    );
  }

  Future<_WaveformLoad> _waveformRows({
    required work_pb.Job job,
    required List<work_pb.Pass> passes,
    required String passId,
    required String commonKey,
    required String workerId,
    required String normalize,
  }) async {
    if (passId.isEmpty) {
      return const _WaveformLoad(rows: []);
    }
    final comparisonPassId = await _comparisonPassId(
      job: job,
      passes: passes,
      passId: passId,
    );
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
    return work_pb.GetPassWaveformRequest(
      passId: passId,
      comparisonPassId: comparisonPassId,
      normalize: useDtw
          ? work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_DTW
          : work_pb.WaveformNormalize.WAVEFORM_NORMALIZE_UNSPECIFIED,
    );
  }

  Future<String> _comparisonPassId({
    required work_pb.Job job,
    required List<work_pb.Pass> passes,
    required String passId,
  }) async {
    work_pb.Pass? selected;
    for (final pass in passes) {
      if (pass.passId == passId) {
        selected = pass;
        break;
      }
    }
    if (selected == null) {
      return '';
    }
    final work_pb.ListJobsResponse listed;
    try {
      listed = await _mediaTag.workService.listJobs(
        work_pb.ListJobsRequest(
          projectNo: job.projectNo,
          itemCode: job.itemCode,
          unitNo: job.unitNo,
          masterOnly: true,
          pageSize: 50,
        ),
      );
    } on ConnectException {
      return '';
    }
    String masterJobId = '';
    for (final summary in listed.jobs) {
      final candidate = summary.job.jobId;
      if (candidate.isNotEmpty && candidate != job.jobId) {
        masterJobId = candidate;
        break;
      }
    }
    if (masterJobId.isEmpty) {
      return '';
    }
    final work_pb.GetJobResponse masterJob;
    try {
      masterJob = await _mediaTag.workService.getJob(
        work_pb.GetJobRequest(jobId: masterJobId),
      );
    } on ConnectException {
      return '';
    }
    return _pairedPassId(passes, selected, masterJob.passes);
  }

  String _pairedPassId(
    List<work_pb.Pass> targetPasses,
    work_pb.Pass selected,
    List<work_pb.Pass> comparisonPasses,
  ) {
    if (comparisonPasses.isEmpty) {
      return '';
    }
    final targets = [...targetPasses]
      ..sort((left, right) => left.passNo.compareTo(right.passNo));
    final comparisons = [...comparisonPasses]
      ..sort((left, right) => left.passNo.compareTo(right.passNo));
    final index = targets.indexWhere((pass) => pass.passId == selected.passId);
    if (index <= 0) {
      return comparisons.first.passId;
    }
    if (index == targets.length - 1) {
      return comparisons.last.passId;
    }
    for (final pass in comparisons) {
      if (pass.passNo == selected.passNo) {
        return pass.passId;
      }
    }
    return '';
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
            seriesId: series.assetId.isEmpty
                ? (waveform.passId.isEmpty ? passId : waveform.passId)
                : series.assetId,
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
