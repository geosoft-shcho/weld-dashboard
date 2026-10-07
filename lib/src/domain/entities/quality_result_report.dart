class QualityResultReport {
  const QualityResultReport({
    required this.reportSetId,
    required this.inspections,
    required this.joints,
  });

  final String reportSetId;
  final List<QualityInspectionRow> inspections;
  final List<QualityJointRow> joints;
}

class QualityScanPdf {
  const QualityScanPdf({
    required this.reportSetId,
    required this.url,
    required this.setPageStart,
  });

  final String reportSetId;
  final String url;
  final int? setPageStart;
}

class QualityInspectionRow {
  const QualityInspectionRow({
    required this.kindLabel,
    required this.reportNo,
    required this.reportDate,
    required this.result,
    required this.agency,
    required this.pageStart,
    required this.checks,
  });

  final String kindLabel;
  final String reportNo;
  final String reportDate;
  final String result;
  final String agency;
  final int? pageStart;
  final List<QualityCheckRow> checks;
}

class QualityCheckRow {
  const QualityCheckRow({
    required this.name,
    required this.criterion,
    required this.actual,
    required this.result,
  });

  final String name;
  final String criterion;
  final String actual;
  final String result;
}

class QualityJointRow {
  const QualityJointRow({
    required this.jointNo,
    required this.jobIds,
    required this.hasUt,
    required this.utIndication,
    required this.utResult,
    required this.mtIndication,
    required this.mtResult,
  });

  final String jointNo;
  final List<String> jobIds;
  final bool hasUt;
  final String utIndication;
  final String utResult;
  final String mtIndication;
  final String mtResult;

  bool get isShortWeld => jobIds.isEmpty && !hasUt;

  String get jobLabel {
    if (isShortWeld) {
      return '짧은 용접';
    }
    return jobIds.join(', ');
  }
}

class QualityResultNotFoundException implements Exception {
  const QualityResultNotFoundException();

  @override
  String toString() => '작업을 찾을 수 없습니다.';
}
