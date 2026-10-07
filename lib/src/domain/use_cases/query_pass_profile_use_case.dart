import '../entities/channel_compare_stats.dart';
import '../entities/pass_joint_context.dart';
import '../entities/pass_profile_board.dart';
import '../entities/pass_waveform_catalog.dart';
import '../entities/weld_pass.dart';
import '../entities/waveform_series_bundle.dart';
import '../entities/work_history_item.dart';

class QueryPassProfileUseCase {
  PassProfileBoard execute({
    required PassWaveformCatalog catalog,
    required String commonKey,
    required String jobId,
    String passId = '',
    String masterProfileId = '',
  }) {
    final resolved = _resolveKey(
      catalog.historyItems,
      commonKey: commonKey,
      jobId: jobId,
    );
    final key = resolved.commonKey;
    if (key.isEmpty) {
      return PassProfileBoard(
        commonKey: '',
        jobId: resolved.jobId,
        context: null,
        passes: const [],
        selectedPass: null,
        mastersForPass: const [],
        selectedMasterProfileId: '',
        series: const WaveformSeriesBundle(
          masterProfileId: '',
          master: [],
          beginner: [],
          robot: [],
        ),
        links: const [],
        compareStats: ChannelCompareStats.fromSeries(
          const WaveformSeriesBundle(
            masterProfileId: '',
            master: [],
            beginner: [],
            robot: [],
          ),
        ),
        banners: const [],
      );
    }
    final passes = [
      for (final pass in catalog.passes)
        if (pass.commonKey == key) pass,
    ]..sort((a, b) => a.passNo.compareTo(b.passNo));
    final selectedPass = _selectedPass(passes, passId);
    final selectedPassId = selectedPass?.passId ?? '';
    final masters = WaveformSeriesBundle.mastersForPass(
      catalog.waveformRows,
      selectedPassId,
    );
    final useMaster = masterProfileId.isNotEmpty
        ? masterProfileId
        : (selectedPass?.masterProfileId.isNotEmpty == true
              ? selectedPass!.masterProfileId
              : (masters.isEmpty ? '' : masters.first));
    final series = WaveformSeriesBundle.fromRows(
      rows: catalog.waveformRows,
      passId: selectedPassId,
      masterProfileId: useMaster,
    );
    final links = [
      for (final link in catalog.links)
        if (link.commonKey == key && link.passId == selectedPassId) link,
    ];
    final banners = <String>[];
    if (catalog.waveformNotice.isNotEmpty) {
      banners.add(catalog.waveformNotice);
    }
    if (series.master.isEmpty) {
      banners.add('명장 파형 없음');
    }
    if (series.beginner.isEmpty) {
      banners.add('작업자 파형 없음');
    }
    if (series.robot.isEmpty) {
      banners.add('로봇 파형 없음');
    }
    return PassProfileBoard(
      commonKey: key,
      jobId: resolved.jobId,
      context: catalog.context ?? _contextFor(catalog.historyItems, key),
      passes: passes,
      selectedPass: selectedPass,
      mastersForPass: masters,
      selectedMasterProfileId: series.masterProfileId,
      series: series,
      links: links,
      compareStats: ChannelCompareStats.fromSeries(series),
      banners: banners,
    );
  }

  ({String commonKey, String jobId}) _resolveKey(
    List<WorkHistoryItem> items, {
    required String commonKey,
    required String jobId,
  }) {
    if (commonKey.isNotEmpty) {
      return (commonKey: commonKey, jobId: jobId);
    }
    if (jobId.isNotEmpty) {
      for (final item in items) {
        if (item.jobId == jobId) {
          return (commonKey: item.commonKey, jobId: item.jobId);
        }
      }
    }
    // Drill-down entry requires common_key; do not auto-pick snapshot latest.
    return (commonKey: '', jobId: '');
  }

  WeldPass? _selectedPass(List<WeldPass> passes, String passId) {
    if (passes.isEmpty) {
      return null;
    }
    if (passId.isNotEmpty) {
      for (final pass in passes) {
        if (pass.passId == passId) {
          return pass;
        }
      }
    }
    return passes.first;
  }

  PassJointContext? _contextFor(List<WorkHistoryItem> items, String commonKey) {
    WorkHistoryItem? match;
    for (final item in items) {
      if (item.commonKey != commonKey) {
        continue;
      }
      if (match == null || _isLater(item, match)) {
        match = item;
      }
    }
    if (match == null) {
      return PassJointContext(
        commonKey: commonKey,
        projectNo: '',
        unitNo: '',
        itemCode: '',
        itemName: '',
        jointNo: '',
        workerName: '',
        equipmentName: '',
      );
    }
    return PassJointContext(
      commonKey: match.commonKey,
      projectNo: match.projectNo,
      unitNo: match.unitNo,
      itemCode: match.itemCode,
      itemName: match.itemName,
      jointNo: match.jointNo,
      workerName: match.workerName,
      isMaster: match.isMaster,
      equipmentName: match.equipmentName,
    );
  }

  bool _isLater(WorkHistoryItem item, WorkHistoryItem match) {
    final workedAt = item.workedAt;
    if (workedAt == null) {
      return false;
    }
    final matchedAt = match.workedAt;
    if (matchedAt == null) {
      return true;
    }
    return workedAt.isAfter(matchedAt);
  }
}
