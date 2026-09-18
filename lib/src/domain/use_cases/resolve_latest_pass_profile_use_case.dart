import '../entities/latest_pass_profile_target.dart';
import '../entities/pass_waveform_catalog.dart';
import '../entities/work_history_item.dart';

class ResolveLatestPassProfileUseCase {
  LatestPassProfileTarget? execute({
    required PassWaveformCatalog catalog,
    required DateTime snapshotAt,
  }) {
    final keysWithPasses = {
      for (final pass in catalog.passes) pass.commonKey,
    };
    final candidates = [
      for (final item in catalog.historyItems)
        if (_isOnOrBeforeSnapshot(item, snapshotAt) &&
            keysWithPasses.contains(item.commonKey))
          item,
    ];
    _sortLatestFirst(candidates);
    if (candidates.isEmpty) {
      return null;
    }
    final item = candidates.first;
    return LatestPassProfileTarget(
      commonKey: item.commonKey,
      historyId: item.historyId,
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
