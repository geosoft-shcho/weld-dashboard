class WorkHistoryItemFilter {
  const WorkHistoryItemFilter({required this.itemCode, required this.jointNos});

  final String itemCode;
  final List<String> jointNos;
}

class WorkHistoryUnitFilter {
  const WorkHistoryUnitFilter({
    required this.unitNo,
    required this.itemCodes,
    this.items = const [],
  });

  final String unitNo;
  final List<String> itemCodes;
  final List<WorkHistoryItemFilter> items;
}

class WorkHistoryProjectFilter {
  const WorkHistoryProjectFilter({
    required this.projectNo,
    required this.projectName,
    required this.units,
  });

  final String projectNo;
  final String projectName;
  final List<WorkHistoryUnitFilter> units;
}
