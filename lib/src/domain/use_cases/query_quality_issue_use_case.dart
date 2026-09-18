import '../entities/pass_joint_context.dart';
import '../entities/pass_waveform_catalog.dart';
import '../entities/quality_issue_board.dart';
import '../entities/quality_link.dart';
import '../entities/quality_result_group.dart';
import '../entities/weld_pass.dart';
import '../entities/waveform_series_bundle.dart';
import '../entities/work_history_item.dart';

class QueryQualityIssueUseCase {
  QualityIssueBoard execute({
    required PassWaveformCatalog catalog,
    required String commonKey,
    required String historyId,
    String passId = '',
    String linkId = '',
  }) {
    final resolved = _resolveKey(
      catalog.historyItems,
      commonKey: commonKey,
      historyId: historyId,
    );
    final key = resolved.commonKey;
    if (key.isEmpty) {
      return QualityIssueBoard(
        commonKey: '',
        historyId: resolved.historyId,
        context: null,
        passes: const [],
        selectedPass: null,
        groups: const [],
        selectedGroup: null,
        links: const [],
        allLinks: const [],
        selectedLink: null,
        series: const WaveformSeriesBundle(
          masterProfileId: '',
          master: [],
          beginner: [],
          robot: [],
        ),
      );
    }
    final passes = [
      for (final pass in catalog.passes)
        if (pass.commonKey == key) pass,
    ]..sort((a, b) => a.passNo.compareTo(b.passNo));
    final allLinks = [
      for (final link in catalog.links)
        if (link.commonKey == key) link,
    ];
    final allGroups = [
      for (final group in catalog.qualityGroups)
        if (group.commonKey == key) group,
    ];
    var usePassId = passId;
    if (linkId.isNotEmpty) {
      for (final link in allLinks) {
        if (link.linkId == linkId) {
          usePassId = link.passId;
          break;
        }
      }
    }
    if (usePassId.isEmpty) {
      usePassId = allLinks.isNotEmpty
          ? allLinks.first.passId
          : (allGroups.isNotEmpty
                ? allGroups.first.passId
                : (passes.isNotEmpty ? passes.first.passId : ''));
    }
    final selectedPass = _selectedPass(passes, usePassId);
    final selectedPassId = selectedPass?.passId ?? usePassId;
    final links = [
      for (final link in allLinks)
        if (link.passId == selectedPassId) link,
    ];
    final groups = [
      for (final group in allGroups)
        if (group.passId == selectedPassId) group,
    ];
    QualityLink? selectedLink;
    if (linkId.isNotEmpty) {
      for (final link in allLinks) {
        if (link.linkId == linkId) {
          selectedLink = link;
          break;
        }
      }
    }
    if (selectedLink == null && links.isNotEmpty) {
      selectedLink = links.first;
    }
    QualityResultGroup? selectedGroup;
    if (groups.isNotEmpty) {
      selectedGroup = groups.first;
      final qualityResultId = selectedLink?.qualityResultId ?? '';
      if (qualityResultId.isNotEmpty) {
        for (final group in groups) {
          if (group.qualityResultId == qualityResultId) {
            selectedGroup = group;
            break;
          }
        }
      }
    }
    final masters = WaveformSeriesBundle.mastersForPass(
      catalog.waveformRows,
      selectedPassId,
    );
    final masterId = selectedPass?.masterProfileId.isNotEmpty == true
        ? selectedPass!.masterProfileId
        : (masters.isEmpty ? '' : masters.first);
    final series = WaveformSeriesBundle.fromRows(
      rows: catalog.waveformRows,
      passId: selectedPassId,
      masterProfileId: masterId,
    );
    return QualityIssueBoard(
      commonKey: key,
      historyId: resolved.historyId,
      context: _contextFor(catalog.historyItems, key),
      passes: passes,
      selectedPass: selectedPass,
      groups: groups,
      selectedGroup: selectedGroup,
      links: links,
      allLinks: allLinks,
      selectedLink: selectedLink,
      series: series,
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
