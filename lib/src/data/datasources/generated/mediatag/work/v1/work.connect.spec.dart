//
//  Generated code. Do not modify.
//  source: mediatag/work/v1/work.proto
//

import "package:connectrpc/connect.dart" as connect;
import "work.pb.dart" as mediatagworkv1work;

/// 사용처: 대시보드(s0 수집 현황, s2 작업 이력·필터, s3 파형 비교, s3/s4 컨텍스트), 컴포즈(열 작업 고르기).
abstract final class WorkService {
  /// Fully-qualified name of the WorkService service.
  static const name = 'mediatag.work.v1.WorkService';

  static const listProjects = connect.Spec(
    '/$name/ListProjects',
    connect.StreamType.unary,
    mediatagworkv1work.ListProjectsRequest.new,
    mediatagworkv1work.ListProjectsResponse.new,
  );

  static const listWorkers = connect.Spec(
    '/$name/ListWorkers',
    connect.StreamType.unary,
    mediatagworkv1work.ListWorkersRequest.new,
    mediatagworkv1work.ListWorkersResponse.new,
  );

  static const listEquipment = connect.Spec(
    '/$name/ListEquipment',
    connect.StreamType.unary,
    mediatagworkv1work.ListEquipmentRequest.new,
    mediatagworkv1work.ListEquipmentResponse.new,
  );

  /// 작업 목록. 행마다 표시용 이름·개수를 붙여 준다(행별 추가 조회 불필요).
  static const listJobs = connect.Spec(
    '/$name/ListJobs',
    connect.StreamType.unary,
    mediatagworkv1work.ListJobsRequest.new,
    mediatagworkv1work.ListJobsResponse.new,
  );

  /// 작업 + 패스 + 작업자 + 쓰인 장비
  static const getJob = connect.Spec(
    '/$name/GetJob',
    connect.StreamType.unary,
    mediatagworkv1work.GetJobRequest.new,
    mediatagworkv1work.GetJobResponse.new,
  );

  /// 수집 현황 계층을 한 단계씩 조회한다. 장비가 기록한 자료(원본과 원본을 대신하는 표준화본·잘라 낸 PDF)만 센다 —
  /// 도구 결과물(STT·포즈·잘라 낸 이미지·추출 JSON)은 작업 첨부(ListJobAssets)·타임라인에서 본다.
  static const listCollectionNodes = connect.Spec(
    '/$name/ListCollectionNodes',
    connect.StreamType.unary,
    mediatagworkv1work.ListCollectionNodesRequest.new,
    mediatagworkv1work.ListCollectionNodesResponse.new,
  );

  /// 패스 하나의 센서 파형. comparison_pass_id를 주면 그 패스의 파형도 함께 준다.
  /// 파형은 표준화 파생 CSV(operation=timeseries_normalize)에서 패스 구간만큼 잘라 낸다.
  static const getPassWaveform = connect.Spec(
    '/$name/GetPassWaveform',
    connect.StreamType.unary,
    mediatagworkv1work.GetPassWaveformRequest.new,
    mediatagworkv1work.GetPassWaveformResponse.new,
  );
}
