class WorkHistoryQuery {
  const WorkHistoryQuery({
    required this.commonKey,
    required this.workOrderId,
    required this.jointId,
    required this.workerId,
    required this.equipmentId,
    required this.fromDate,
    required this.toDate,
    required this.selectedHistoryId,
    required this.visibleCount,
  });

  static const int BATCH_SIZE = 20;

  factory WorkHistoryQuery.initial() {
    return const WorkHistoryQuery(
      commonKey: '',
      workOrderId: '',
      jointId: '',
      workerId: '',
      equipmentId: '',
      fromDate: null,
      toDate: null,
      selectedHistoryId: '',
      visibleCount: BATCH_SIZE,
    );
  }

  final String commonKey;
  final String workOrderId;
  final String jointId;
  final String workerId;
  final String equipmentId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedHistoryId;
  final int visibleCount;

  bool get doesHaveInvalidDateRange {
    final fromDate = this.fromDate;
    final toDate = this.toDate;
    if (fromDate == null || toDate == null) {
      return false;
    }
    return _dateOnly(fromDate).isAfter(_dateOnly(toDate));
  }

  bool get doesHaveFilter {
    return commonKey.trim().isNotEmpty ||
        workOrderId.isNotEmpty ||
        jointId.isNotEmpty ||
        workerId.isNotEmpty ||
        equipmentId.isNotEmpty ||
        fromDate != null ||
        toDate != null;
  }

  WorkHistoryQuery copyWith({
    String? commonKey,
    String? workOrderId,
    String? jointId,
    String? workerId,
    String? equipmentId,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? toDate,
    bool clearToDate = false,
    String? selectedHistoryId,
    int? visibleCount,
  }) {
    return WorkHistoryQuery(
      commonKey: commonKey ?? this.commonKey,
      workOrderId: workOrderId ?? this.workOrderId,
      jointId: jointId ?? this.jointId,
      workerId: workerId ?? this.workerId,
      equipmentId: equipmentId ?? this.equipmentId,
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
      selectedHistoryId: selectedHistoryId ?? this.selectedHistoryId,
      visibleCount: visibleCount ?? this.visibleCount,
    );
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
