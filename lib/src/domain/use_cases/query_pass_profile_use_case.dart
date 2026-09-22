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
    required String historyId,
    String passId = '',
    String masterProfileId = '',
  }) {
    final resolved = _resolveKey(
      catalog.historyItems,
      commonKey: commonKey,
      historyId: historyId,
    );
    final key = resolved.commonKey;
    if (key.isEmpty) {
      return PassProfileBoard(
        commonKey: '',
        historyId: resolved.historyId,
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
    if (series.master.isEmpty) {
      banners.add('명장 파형 없음');
    }
    if (series.beginner.isEmpty) {
      banners.add('초보자 파형 없음');
    }
    if (series.robot.isEmpty) {
      banners.add('로봇 파형 없음');
    }
    return PassProfileBoard(
      commonKey: key,
      historyId: resolved.historyId,
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

  ({String commonKey, String historyId}) _resolveKey(
    List<WorkHistoryItem> items, {
    required String commonKey,
    required String historyId,
  }) {
    if (commonKey.isNotEmpty) {
      return (commonKey: commonKey, historyId: historyId);
    }
    if (historyId.isNotEmpty) {
      for (final item in items) {
        if (item.historyId == historyId) {
          return (commonKey: item.commonKey, historyId: item.historyId);
        }
      }
    }
    // Drill-down entry requires common_key; do not auto-pick snapshot latest.
    return (commonKey: '', historyId: '');
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
      if (match == null || item.workedAt.isAfter(match.workedAt)) {
        match = item;
      }
    }
    if (match == null) {
      return PassJointContext(
        commonKey: commonKey,
        workOrderNo: '',
        title: '',
        jointNo: '',
        jointName: '',
        workerName: '',
        equipmentName: '',
      );
    }
    return PassJointContext(
      commonKey: match.commonKey,
      workOrderNo: match.workOrderNo,
      title: match.title,
      jointNo: match.jointNo,
      jointName: match.jointName,
      workerName: match.workerName,
      equipmentName: match.equipmentName,
    );
  }
}
