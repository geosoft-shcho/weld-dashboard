//
//  Generated code. Do not modify.
//  source: mediatag/work/v1/work.proto
//

import "package:connectrpc/connect.dart" as connect;
import "work.pb.dart" as mediatagworkv1work;
import "work.connect.spec.dart" as specs;

/// 사용처: 대시보드(s0 수집 현황, s2 작업 이력·필터, s3 파형 비교, s3/s4 컨텍스트), 컴포즈(열 작업 고르기).
extension type WorkServiceClient (connect.Transport _transport) {
  Future<mediatagworkv1work.ListProjectsResponse> listProjects(
    mediatagworkv1work.ListProjectsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listProjects,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagworkv1work.ListWorkersResponse> listWorkers(
    mediatagworkv1work.ListWorkersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listWorkers,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagworkv1work.ListEquipmentResponse> listEquipment(
    mediatagworkv1work.ListEquipmentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listEquipment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업 목록(ListJobs) 필터의 드롭다운 값을 한 번에: 공사(호기·품목 포함)·작업자·장비.
  Future<mediatagworkv1work.ListJobFiltersResponse> listJobFilters(
    mediatagworkv1work.ListJobFiltersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listJobFilters,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업 목록. 행마다 표시용 이름·개수를 붙여 준다(행별 추가 조회 불필요).
  Future<mediatagworkv1work.ListJobsResponse> listJobs(
    mediatagworkv1work.ListJobsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listJobs,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업 + 패스 + 작업자 + 쓰인 장비
  Future<mediatagworkv1work.GetJobResponse> getJob(
    mediatagworkv1work.GetJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.getJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 수집 현황 계층을 한 단계씩 조회한다. 장비가 기록한 자료(원본과 원본을 대신하는 표준화본·잘라 낸 PDF)만 센다 —
  /// 도구 결과물(STT·포즈·잘라 낸 이미지·추출 JSON)은 작업 첨부(ListJobAssets)·타임라인에서 본다.
  Future<mediatagworkv1work.ListCollectionNodesResponse> listCollectionNodes(
    mediatagworkv1work.ListCollectionNodesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listCollectionNodes,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 패스 하나의 센서 파형. comparison_pass_id를 주면 그 패스의 파형도 함께 준다.
  /// 파형은 표준화 파생 CSV(operation=timeseries_normalize)에서 패스 구간만큼 잘라 낸다.
  Future<mediatagworkv1work.GetPassWaveformResponse> getPassWaveform(
    mediatagworkv1work.GetPassWaveformRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.getPassWaveform,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
