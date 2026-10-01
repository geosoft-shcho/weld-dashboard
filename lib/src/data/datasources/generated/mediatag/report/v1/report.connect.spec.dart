//
//  Generated code. Do not modify.
//  source: mediatag/report/v1/report.proto
//

import "package:connectrpc/connect.dart" as connect;
import "report.pb.dart" as mediatagreportv1report;

/// 사용처: 대시보드(s4 품질 판정 카드).
abstract final class ReportService {
  /// Fully-qualified name of the ReportService service.
  static const name = 'mediatag.report.v1.ReportService';

  /// 작업의 성적서 세트 목록. 섹션 본문은 빼고 준다.
  static const listReportSets = connect.Spec(
    '/$name/ListReportSets',
    connect.StreamType.unary,
    mediatagreportv1report.ListReportSetsRequest.new,
    mediatagreportv1report.ListReportSetsResponse.new,
  );

  /// 세트 하나 + 섹션 본문 전체.
  static const getReportSet = connect.Spec(
    '/$name/GetReportSet',
    connect.StreamType.unary,
    mediatagreportv1report.GetReportSetRequest.new,
    mediatagreportv1report.GetReportSetResponse.new,
  );

  /// 확인 목록 한 칸을 확인·보정한다. corrected_value가 비면 "원문이 맞음"으로 확인만 한다.
  /// 섹션·세트의 값은 바꾸지 않는다(원문은 근거로 남기고 보정값은 여기) — 매칭은 보정값을 먼저 쓴다.
  static const resolveReview = connect.Spec(
    '/$name/ResolveReview',
    connect.StreamType.unary,
    mediatagreportv1report.ResolveReviewRequest.new,
    mediatagreportv1report.ResolveReviewResponse.new,
  );

  /// 세트를 작업에 매칭한다. 잘라 낸 PDF(split_asset_id)를 그 작업에 같은 트랜잭션에서 첨부한다.
  /// job_id가 비면 매칭을 푼다(첨부는 그대로 — 필요하면 DetachAsset).
  static const matchReportSet = connect.Spec(
    '/$name/MatchReportSet',
    connect.StreamType.unary,
    mediatagreportv1report.MatchReportSetRequest.new,
    mediatagreportv1report.MatchReportSetResponse.new,
  );
}
