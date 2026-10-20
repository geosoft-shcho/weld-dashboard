class WorkHistoryJointFilter {
  const WorkHistoryJointFilter({required this.jointNo, required this.passNos});

  final String jointNo;
  final List<int> passNos;
}

class WorkHistoryItemFilter {
  const WorkHistoryItemFilter({
    required this.itemCode,
    required this.jointNos,
    this.joints = const [],
    this.itemName = '',
    this.projectItemId = '',
  });

  final String itemCode;
  final List<String> jointNos;
  final List<WorkHistoryJointFilter> joints;
  final String itemName;
  final String projectItemId;
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
    this.projectId = '',
    this.siteName = '',
    this.customer = '',
    this.jobCount = 0,
  });

  final String projectId;
  final String projectNo;
  final String projectName;
  final String siteName;
  final String customer;
  final List<WorkHistoryUnitFilter> units;
  final int jobCount;
}
