class WorkHistoryUnitFilter {
  const WorkHistoryUnitFilter({
    required this.unitNo,
    required this.itemCodes,
  });

  final String unitNo;
  final List<String> itemCodes;
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
