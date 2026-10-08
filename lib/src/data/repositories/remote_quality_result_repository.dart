import 'package:connectrpc/connect.dart';

import '../../domain/entities/quality_result_report.dart';
import '../../domain/repositories/quality_result_repository.dart';
import '../datasources/generated/mediatag/report/v1/report.pb.dart'
    as report_pb;
import '../datasources/generated/mediatag/report/v1/report.pbenum.dart';
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemoteQualityResultRepository implements QualityResultRepository {
  RemoteQualityResultRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<QualityResultReport>> listForJob(String jobId) async {
    if (jobId.isEmpty) {
      return const [];
    }
    try {
      final response = await _mediaTag.reportService.listQualityResults(
        report_pb.ListQualityResultsRequest(jobId: protoId(jobId)),
      );
      return [for (final report in response.reports) _reportFrom(report)];
    } on ConnectException catch (error) {
      if (error.code == Code.notFound) {
        throw const QualityResultNotFoundException();
      }
      rethrow;
    }
  }

  QualityResultReport _reportFrom(report_pb.QualityReport report) {
    return QualityResultReport(
      reportSetId: idText(report.reportSetId),
      inspections: [
        for (final inspection in report.inspections)
          _inspectionFrom(inspection),
      ],
      joints: [for (final joint in report.joints) _jointFrom(joint)],
    );
  }

  QualityInspectionRow _inspectionFrom(report_pb.QualityInspection inspection) {
    return QualityInspectionRow(
      kindLabel: _kindLabel(inspection.kind, inspection.method),
      reportNo: inspection.reportNo,
      reportDate: inspection.reportDate,
      result: inspection.result,
      agency: inspection.agency,
      pageStart: inspection.hasPageStart() ? inspection.pageStart : null,
      checks: [
        for (final check in inspection.checks)
          QualityCheckRow(
            name: check.name,
            criterion: check.criterion,
            actual: check.actual,
            result: check.result,
          ),
      ],
    );
  }

  QualityJointRow _jointFrom(report_pb.JointQuality joint) {
    final hasUt = joint.hasUt();
    return QualityJointRow(
      jointNo: joint.jointNo,
      jobIds: List<String>.from(joint.jobIds),
      hasUt: hasUt,
      utIndication: hasUt ? joint.ut.indication : '',
      utResult: hasUt ? joint.ut.result : '',
      mtIndication: joint.hasMt() ? joint.mt.indication : '',
      mtResult: joint.hasMt() ? joint.mt.result : '',
    );
  }

  String _kindLabel(SectionKind kind, String method) {
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
      return method.isEmpty ? 'NDT' : method;
    }
    if (kind == SectionKind.SECTION_KIND_APPROVALS) {
      return '결재';
    }
    return '';
  }
}
