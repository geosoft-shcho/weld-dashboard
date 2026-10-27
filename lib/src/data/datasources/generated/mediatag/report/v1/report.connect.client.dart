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
  /// job_id: 그 작업이 쓰는 세트 하나(Job.active_report_set_id, 없으면 빈 목록). common_key: 본인 품목이 그 값인 세트들.
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

  /// 세트 · 섹션의 칸 하나를 고친다(OCR 오독 바로잡기). 값은 그 행에 바로 들어가 GetReportSet · ListQualityResults에 나온다.
  /// 고치기 전 값은 확인 목록에 한 줄로 남는다(reason MANUAL, value = 전 값, corrected_value = 새 값). review_id를 주면 새 줄 대신
  /// 그 칸을 보정한 것으로 표시한다. 그 칸 하나만 바뀐다 — 작업 · 다른 칸은 그대로다. 같은 문서를 가리키는 다른 세트(품목 여럿을 묶은
  /// 표면처리 · 도장 문서)에도 같은 값이 보인다(문서는 하나다).
  /// 고칠 수 없는 칸(id · *_id · created_at · updated_at · page_start · page_end · common_key)이나 없는 표 · 칸은 InvalidArgument,
  /// 없는 행은 NotFound, 칸 형식(숫자 · 날짜 · 허용 값)에 안 맞으면 InvalidArgument.
  Future<mediatagreportv1report.UpdateReportFieldResponse> updateReportField(
    mediatagreportv1report.UpdateReportFieldRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ReportService.updateReportField,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업·이음부 기준 품질 결과: 검사 종류별 판정과 이음부별 UT·MT 표. 성적서 원문 전체는 GetReportSet.
  /// job_id(그 작업이 쓰는 세트, 그 작업의 이음부) 또는 common_key(+joint_no). 이음부를 안 주면 세트의 이음부 전체가 표로 온다.
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
