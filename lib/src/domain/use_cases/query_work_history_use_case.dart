import '../entities/work_history_board.dart';
import '../entities/work_history_catalog.dart';
import '../entities/work_history_item.dart';
import '../entities/work_history_query.dart';

class QueryWorkHistoryUseCase {
  /// 필터·정렬된 전체 매칭 행. 정렬은 started_at 내림차순, job_id 내림차순.
  List<WorkHistoryItem> matchedItems({
    required WorkHistoryCatalog catalog,
    required WorkHistoryQuery query,
  }) {
    if (query.doesHaveInvalidDateRange) {
      return const [];
    }
    final filtered = [
      for (final item in catalog.items)
        if (_doesMatch(item, query)) item,
    ];
    filtered.sort((left, right) {
      final leftAt = left.workedAt;
      final rightAt = right.workedAt;
      if (leftAt == null && rightAt == null) {
        return right.jobId.compareTo(left.jobId);
      }
      if (leftAt == null) {
        return 1;
      }
      if (rightAt == null) {
        return -1;
      }
      final byTime = rightAt.compareTo(leftAt);
      if (byTime != 0) {
        return byTime;
      }
      return right.jobId.compareTo(left.jobId);
    });
    return filtered;
  }

  WorkHistoryBoard execute({
    required WorkHistoryCatalog catalog,
    required WorkHistoryQuery query,
  }) {
    final filtered = matchedItems(catalog: catalog, query: query);
    final visibleCount = query.visibleCount < 0 ? 0 : query.visibleCount;
    final visibleRows = filtered.length <= visibleCount
        ? filtered
        : filtered.sublist(0, visibleCount);
    final nextPageToken = visibleRows.length < filtered.length ? 'more' : '';
    return WorkHistoryBoard(
      query: query,
      visibleRows: visibleRows,
      totalCount: filtered.length,
      nextPageToken: nextPageToken,
      projects: catalog.projects,
      workers: catalog.workers,
      equipments: catalog.equipments,
    );
  }

  bool _doesMatch(WorkHistoryItem item, WorkHistoryQuery query) {
    final keyQuery = query.commonKey.trim();
    if (keyQuery.isNotEmpty && !item.commonKey.contains(keyQuery)) {
      return false;
    }
    if (query.projectNo.isNotEmpty && item.projectNo != query.projectNo) {
      return false;
    }
    if (query.unitNo.isNotEmpty && item.unitNo != query.unitNo) {
      return false;
    }
    if (query.itemCode.isNotEmpty && item.itemCode != query.itemCode) {
      return false;
    }
    if (query.jointNo.isNotEmpty && item.jointNo != query.jointNo) {
      return false;
    }
    if (query.workerId.isNotEmpty && item.workerId != query.workerId) {
      return false;
    }
    if (query.equipmentId.isNotEmpty && item.equipmentId != query.equipmentId) {
      return false;
    }
    final workedAt = item.workedAt;
    final fromDate = query.fromDate;
    if (fromDate != null &&
        (workedAt == null ||
            _dateOnly(workedAt).isBefore(_dateOnly(fromDate)))) {
      return false;
    }
    final toDate = query.toDate;
    if (toDate != null &&
        (workedAt == null || _dateOnly(workedAt).isAfter(_dateOnly(toDate)))) {
      return false;
    }
    return true;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
