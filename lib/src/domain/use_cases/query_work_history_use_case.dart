import '../entities/joint.dart';
import '../entities/work_history_board.dart';
import '../entities/work_history_catalog.dart';
import '../entities/work_history_item.dart';
import '../entities/work_history_query.dart';

class QueryWorkHistoryUseCase {
  WorkHistoryBoard execute({
    required WorkHistoryCatalog catalog,
    required WorkHistoryQuery query,
  }) {
    final joints = _jointsForOrder(catalog.joints, query.workOrderId);
    if (query.doesHaveInvalidDateRange) {
      return WorkHistoryBoard(
        query: query,
        visibleRows: const [],
        totalCount: 0,
        workOrders: catalog.workOrders,
        joints: joints,
        workers: catalog.workers,
        equipments: catalog.equipments,
      );
    }
    final filtered = [
      for (final item in catalog.items)
        if (_doesMatch(item, query)) item,
    ];
    filtered.sort((left, right) {
      final byTime = right.workedAt.compareTo(left.workedAt);
      if (byTime != 0) {
        return byTime;
      }
      return left.historyId.compareTo(right.historyId);
    });
    final visibleCount = query.visibleCount < 0 ? 0 : query.visibleCount;
    final visibleRows = filtered.length <= visibleCount
        ? filtered
        : filtered.sublist(0, visibleCount);
    return WorkHistoryBoard(
      query: query,
      visibleRows: visibleRows,
      totalCount: filtered.length,
      workOrders: catalog.workOrders,
      joints: joints,
      workers: catalog.workers,
      equipments: catalog.equipments,
    );
  }

  bool _doesMatch(WorkHistoryItem item, WorkHistoryQuery query) {
    final keyQuery = query.commonKey.trim();
    if (keyQuery.isNotEmpty && !item.commonKey.contains(keyQuery)) {
      return false;
    }
    if (query.workOrderId.isNotEmpty && item.workOrderId != query.workOrderId) {
      return false;
    }
    if (query.jointId.isNotEmpty && item.jointId != query.jointId) {
      return false;
    }
    if (query.workerId.isNotEmpty && item.workerId != query.workerId) {
      return false;
    }
    if (query.equipmentId.isNotEmpty && item.equipmentId != query.equipmentId) {
      return false;
    }
    final fromDate = query.fromDate;
    if (fromDate != null &&
        _dateOnly(item.workedAt).isBefore(_dateOnly(fromDate))) {
      return false;
    }
    final toDate = query.toDate;
    if (toDate != null && _dateOnly(item.workedAt).isAfter(_dateOnly(toDate))) {
      return false;
    }
    return true;
  }

  List<Joint> _jointsForOrder(List<Joint> joints, String workOrderId) {
    if (workOrderId.isEmpty) {
      return joints;
    }
    return [
      for (final joint in joints)
        if (joint.workOrderId == workOrderId) joint,
    ];
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
