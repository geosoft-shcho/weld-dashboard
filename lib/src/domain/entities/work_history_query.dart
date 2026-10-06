class WorkHistoryQuery {
  const WorkHistoryQuery({
    required this.commonKey,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    this.jointNo = '',
    this.passNo = 0,
    required this.workerId,
    required this.equipmentId,
    required this.fromDate,
    required this.toDate,
    required this.selectedJobId,
    required this.visibleCount,
  });

  static const int BATCH_SIZE = 20;

  factory WorkHistoryQuery.initial() {
    return const WorkHistoryQuery(
      commonKey: '',
      projectNo: '',
      unitNo: '',
      itemCode: '',
      workerId: '',
      equipmentId: '',
      fromDate: null,
      toDate: null,
      selectedJobId: '',
      visibleCount: BATCH_SIZE,
    );
  }

  final String commonKey;
  final String projectNo;
  final String unitNo;
  final String itemCode;
  final String jointNo;
  final int passNo;
  final String workerId;
  final String equipmentId;
  final DateTime? fromDate;
  final DateTime? toDate;

  /// 선택한 작업. 값은 `job_id`다.
  final String selectedJobId;

  /// 로컬 카탈로그 슬라이스용. 서버 페이지는 page_token 을 쓴다.
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
        projectNo.isNotEmpty ||
        unitNo.isNotEmpty ||
        itemCode.isNotEmpty ||
        jointNo.isNotEmpty ||
        passNo != 0 ||
        workerId.isNotEmpty ||
        equipmentId.isNotEmpty ||
        fromDate != null ||
        toDate != null;
  }

  bool matchesDeferredFilters(WorkHistoryQuery other) {
    return commonKey.trim() == other.commonKey.trim() &&
        projectNo == other.projectNo &&
        unitNo == other.unitNo &&
        itemCode == other.itemCode &&
        jointNo == other.jointNo &&
        passNo == other.passNo &&
        workerId == other.workerId &&
        equipmentId == other.equipmentId &&
        _sameDay(fromDate, other.fromDate) &&
        _sameDay(toDate, other.toDate);
  }

  static bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null && b == null) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  WorkHistoryQuery copyWith({
    String? commonKey,
    String? projectNo,
    String? unitNo,
    String? itemCode,
    String? jointNo,
    int? passNo,
    String? workerId,
    String? equipmentId,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? toDate,
    bool clearToDate = false,
    String? selectedJobId,
    int? visibleCount,
  }) {
    return WorkHistoryQuery(
      commonKey: commonKey ?? this.commonKey,
      projectNo: projectNo ?? this.projectNo,
      unitNo: unitNo ?? this.unitNo,
      itemCode: itemCode ?? this.itemCode,
      jointNo: jointNo ?? this.jointNo,
      passNo: passNo ?? this.passNo,
      workerId: workerId ?? this.workerId,
      equipmentId: equipmentId ?? this.equipmentId,
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
      selectedJobId: selectedJobId ?? this.selectedJobId,
      visibleCount: visibleCount ?? this.visibleCount,
    );
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
