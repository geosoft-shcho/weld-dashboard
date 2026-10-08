import 'package:connectrpc/connect.dart';

import '../../domain/entities/report_set.dart';
import '../../domain/repositories/report_set_repository.dart';
import '../datasources/generated/google/protobuf/struct.pb.dart';
import '../datasources/generated/mediatag/report/v1/report.pb.dart'
    as report_pb;
import '../datasources/generated/mediatag/report/v1/report.pbenum.dart';
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemoteReportSetRepository implements ReportSetRepository {
  RemoteReportSetRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<ReportSetSummary>> listForJob(String jobId) async {
    if (jobId.isEmpty) {
      return const [];
    }
    try {
      final response = await _mediaTag.reportService.listReportSets(
        report_pb.ListReportSetsRequest(jobId: protoId(jobId)),
      );
      return [for (final set in response.reportSets) _summaryFrom(set)];
    } on ConnectException catch (error) {
      if (error.code == Code.notFound) {
        throw const ReportSetNotFoundException();
      }
      rethrow;
    }
  }

  @override
  Future<ReportSetDetail> getSet(String reportSetId) async {
    if (reportSetId.isEmpty) {
      throw const ReportSetNotFoundException();
    }
    try {
      final response = await _mediaTag.reportService.getReportSet(
        report_pb.GetReportSetRequest(reportSetId: protoId(reportSetId)),
      );
      final set = response.reportSet;
      final summary = _summaryFrom(set);
      return ReportSetDetail(
        summary: summary,
        sections: [
          for (final section in response.sections)
            _sectionFrom(section, summary.pageStart),
        ],
        reviews: [for (final review in response.reviews) _reviewFrom(review)],
        pdfUrl: idText(set.splitAssetId).isEmpty
            ? ''
            : _mediaTag.resolveContentUrl(
                '/assets/${idText(set.splitAssetId)}/content',
              ),
      );
    } on ConnectException catch (error) {
      if (error.code == Code.notFound) {
        throw const ReportSetNotFoundException();
      }
      rethrow;
    }
  }

  ReportSetSummary _summaryFrom(report_pb.ReportSet set) {
    return ReportSetSummary(
      reportSetId: idText(set.reportSetId),
      commonKey: set.commonKey,
      jobId: idText(set.jobId),
      itemName: set.itemName,
      unitNo: set.unitNo,
      projectNo: set.projectNo,
      pageStart: set.hasPageStart() ? set.pageStart : null,
      pageEnd: set.hasPageEnd() ? set.pageEnd : null,
      reviewCount: set.reviewCount,
      sections: [
        for (final section in set.sections)
          ReportSectionSummary(
            kindLabel: _kindLabel(section.kind),
            overallResult: section.overallResult,
            pageStart: section.hasPageStart() ? section.pageStart : null,
            pageEnd: section.hasPageEnd() ? section.pageEnd : null,
          ),
      ],
    );
  }

  ReportSectionBody _sectionFrom(report_pb.Section section, int? setPageStart) {
    final originalPageStart = section.hasPageStart() ? section.pageStart : null;
    return ReportSectionBody(
      kindLabel: _kindLabel(section.kind),
      originalPageStart: originalPageStart,
      originalPageEnd: section.hasPageEnd() ? section.pageEnd : null,
      splitPageStart: _splitPage(originalPageStart, setPageStart),
      fields: _fieldLines(section.fields),
    );
  }

  ReportReviewRow _reviewFrom(report_pb.ReviewItem review) {
    return ReportReviewRow(
      field: review.field_3,
      value: review.hasValue() ? review.value : '',
      raw: review.raw,
      reason: _reasonLabel(review.reason),
    );
  }

  int? _splitPage(int? originalPage, int? setPageStart) {
    if (originalPage == null || setPageStart == null) {
      return null;
    }
    final page = originalPage - setPageStart + 1;
    return page < 1 ? 1 : page;
  }

  List<ReportFieldLine> _fieldLines(Struct struct) {
    final lines = <ReportFieldLine>[];
    _appendFields(struct, '', lines);
    return lines;
  }

  void _appendFields(
    Struct struct,
    String prefix,
    List<ReportFieldLine> lines,
  ) {
    for (final entry in struct.fields.entries) {
      final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
      _appendValue(key, entry.value, lines);
    }
  }

  void _appendValue(String key, Value value, List<ReportFieldLine> lines) {
    final kind = value.whichKind();
    if (kind == Value_Kind.structValue) {
      _appendFields(value.structValue, key, lines);
      return;
    }
    if (kind == Value_Kind.listValue) {
      final items = value.listValue.values;
      if (items.isEmpty) {
        lines.add(ReportFieldLine(key: key, value: ''));
        return;
      }
      for (var index = 0; index < items.length; index++) {
        _appendValue('$key[$index]', items[index], lines);
      }
      return;
    }
    lines.add(ReportFieldLine(key: key, value: _scalarText(value, kind)));
  }

  String _scalarText(Value value, Value_Kind kind) {
    switch (kind) {
      case Value_Kind.stringValue:
        return value.stringValue;
      case Value_Kind.numberValue:
        return value.numberValue.toString();
      case Value_Kind.boolValue:
        return value.boolValue.toString();
      case Value_Kind.nullValue:
      case Value_Kind.structValue:
      case Value_Kind.listValue:
      case Value_Kind.notSet:
        return '';
    }
  }

  String _kindLabel(SectionKind kind) {
    if (kind == SectionKind.SECTION_KIND_FITUP) {
      return '취부';
    }
    if (kind == SectionKind.SECTION_KIND_WELDING) {
      return '용접 외관';
    }
    if (kind == SectionKind.SECTION_KIND_DIMENSIONAL) {
      return '치수';
    }
    if (kind == SectionKind.SECTION_KIND_PRESSURE) {
      return '기밀';
    }
    if (kind == SectionKind.SECTION_KIND_NDT) {
      return 'NDT';
    }
    if (kind == SectionKind.SECTION_KIND_APPROVALS) {
      return '결재';
    }
    return '';
  }

  String _reasonLabel(ReviewReason reason) {
    if (reason == ReviewReason.REVIEW_REASON_LOW_CONFIDENCE) {
      return '낮은 신뢰';
    }
    if (reason == ReviewReason.REVIEW_REASON_VLM_RECHECKED) {
      return 'VLM 재확인';
    }
    if (reason == ReviewReason.REVIEW_REASON_SNAPPED) {
      return '허용 값으로 바꿈';
    }
    if (reason == ReviewReason.REVIEW_REASON_UNREADABLE) {
      return '읽지 못함';
    }
    return '';
  }
}
