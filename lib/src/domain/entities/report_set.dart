class ReportSetSummary {
  const ReportSetSummary({
    required this.reportSetId,
    required this.commonKey,
    required this.jobId,
    required this.itemName,
    required this.unitNo,
    required this.projectNo,
    required this.pageStart,
    required this.pageEnd,
    required this.reviewCount,
    required this.sections,
  });

  final String reportSetId;
  final String commonKey;
  final String jobId;
  final String itemName;
  final String unitNo;
  final String projectNo;
  final int? pageStart;
  final int? pageEnd;
  final int reviewCount;
  final List<ReportSectionSummary> sections;

  bool get isUnmatched => jobId.isEmpty && commonKey.isEmpty;
}

class ReportSectionSummary {
  const ReportSectionSummary({
    required this.kindLabel,
    required this.overallResult,
    required this.pageStart,
    required this.pageEnd,
  });

  final String kindLabel;
  final String overallResult;
  final int? pageStart;
  final int? pageEnd;
}

class ReportSetDetail {
  const ReportSetDetail({
    required this.summary,
    required this.sections,
    required this.reviews,
    required this.pdfUrl,
  });

  final ReportSetSummary summary;
  final List<ReportSectionBody> sections;
  final List<ReportReviewRow> reviews;
  final String pdfUrl;
}

class ReportSectionBody {
  const ReportSectionBody({
    required this.kindLabel,
    required this.originalPageStart,
    required this.originalPageEnd,
    required this.splitPageStart,
    required this.fields,
  });

  final String kindLabel;
  final int? originalPageStart;
  final int? originalPageEnd;
  final int? splitPageStart;
  final List<ReportFieldLine> fields;
}

class ReportFieldLine {
  const ReportFieldLine({required this.key, required this.value});

  final String key;
  final String value;
}

class ReportReviewRow {
  const ReportReviewRow({
    required this.field,
    required this.value,
    required this.raw,
    required this.reason,
  });

  final String field;
  final String value;
  final String raw;
  final String reason;
}

class ReportSetNotFoundException implements Exception {
  const ReportSetNotFoundException();

  @override
  String toString() => '성적서를 찾을 수 없습니다.';
}
