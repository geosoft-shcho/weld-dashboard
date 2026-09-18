import '../entities/latest_quality_issue_target.dart';
import '../entities/pass_waveform_catalog.dart';
import '../entities/quality_link.dart';
import '../entities/work_history_item.dart';

class ResolveLatestQualityIssueUseCase {
  LatestQualityIssueTarget? execute({
    required PassWaveformCatalog catalog,
    required DateTime snapshotAt,
  }) {
    final linksByCommonKey = <String, List<QualityLink>>{};
    for (final link in catalog.links) {
      linksByCommonKey.putIfAbsent(link.commonKey, () => []).add(link);
    }
    final candidates = [
      for (final item in catalog.historyItems)
        if (_isOnOrBeforeSnapshot(item, snapshotAt) &&
            (linksByCommonKey[item.commonKey]?.isNotEmpty ?? false))
          item,
    ];
    _sortLatestFirst(candidates);
    if (candidates.isEmpty) {
      return null;
    }
    final item = candidates.first;
    final links = linksByCommonKey[item.commonKey]!;
    final link = links.first;
    return LatestQualityIssueTarget(
      commonKey: item.commonKey,
      historyId: item.historyId,
      passId: link.passId,
      linkId: link.linkId,
    );
  }

  bool _isOnOrBeforeSnapshot(WorkHistoryItem item, DateTime snapshotAt) {
    return !item.workedAt.isAfter(snapshotAt);
  }

  void _sortLatestFirst(List<WorkHistoryItem> items) {
    items.sort((left, right) {
      final byTime = right.workedAt.compareTo(left.workedAt);
      if (byTime != 0) {
        return byTime;
      }
      return left.historyId.compareTo(right.historyId);
    });
  }
}
