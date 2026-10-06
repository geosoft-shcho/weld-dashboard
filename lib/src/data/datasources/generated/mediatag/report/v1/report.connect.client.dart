//
//  Generated code. Do not modify.
//  source: mediatag/report/v1/report.proto
//

import "package:connectrpc/connect.dart" as connect;
import "report.pb.dart" as mediatagreportv1report;
import "report.connect.spec.dart" as specs;

/// 사용처: 대시보드(s4 품질 판정 카드).
extension type ReportServiceClient (connect.Transport _transport) {
  /// 작업(job_id) 또는 품목(common_key)의 성적서 세트 목록. 섹션 본문은 빼고 준다.
  /// job_id를 주면 그 작업에 매칭된 세트와 그 작업의 품목에 매칭된 세트를 함께 준다.
  Future<mediatagreportv1report.ListReportSetsResponse> listReportSets(
    mediatagreportv1report.ListReportSetsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ReportService.listReportSets,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 세트 하나 + 섹션 본문 전체.
  Future<mediatagreportv1report.GetReportSetResponse> getReportSet(
    mediatagreportv1report.GetReportSetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ReportService.getReportSet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 확인 목록 한 칸을 확인·보정한다. corrected_value가 비면 "원문이 맞음"으로 확인만 한다.
  /// 섹션·세트의 값은 바꾸지 않는다(원문은 근거로 남기고 보정값은 여기) — 매칭은 보정값을 먼저 쓴다.
  Future<mediatagreportv1report.ResolveReviewResponse> resolveReview(
    mediatagreportv1report.ResolveReviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ReportService.resolveReview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 세트를 작업 또는 품목에 매칭한다. 잘라 낸 PDF(split_asset_id)를 같은 트랜잭션에서 첨부한다.
  ///   job_id: 그 작업에 매칭하고 세트의 common_key도 그 작업의 품목으로 채운다(PDF는 그 작업에 첨부).
  ///   common_key만: 품목에 매칭한다(PDF는 그 품목의 작업 모두에 첨부). 이음부 단위 작업은 이쪽을 쓴다.
  ///   둘 다 비면 매칭을 푼다(첨부는 그대로 — 필요하면 DetachAsset).
  Future<mediatagreportv1report.MatchReportSetResponse> matchReportSet(
    mediatagreportv1report.MatchReportSetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ReportService.matchReportSet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업·이음부 기준 품질 결과: 검사 종류별 판정과 이음부별 UT·MT 표. 성적서 원문 전체는 GetReportSet.
  /// job_id(그 작업의 이음부) 또는 common_key(+joint_no). 이음부를 안 주면 품목의 이음부 전체가 표로 온다.
  Future<mediatagreportv1report.ListQualityResultsResponse> listQualityResults(
    mediatagreportv1report.ListQualityResultsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ReportService.listQualityResults,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
