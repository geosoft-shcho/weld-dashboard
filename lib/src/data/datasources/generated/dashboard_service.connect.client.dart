//
//  Generated code. Do not modify.
//  source: dashboard_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "dashboard_service.pb.dart" as dashboard_service;
import "dashboard_service.connect.spec.dart" as specs;

/// 와이어프레임 프로토타입(serviceops/wireframe-prototype)의 data/*.csv를 postgres-db/dashboard로
/// 옮긴 것을 내려준다. 원본 CSV 테이블 그대로인 List* RPC와, wireframe-prototype/web/js/store.js의
/// 조회 로직(배정 겹침 필터, 이력 조인, 컨텍스트)을 SQL로 옮긴 조인/필터 RPC 두 종류가 있다.
/// 화면에 없는 조합은 안 만든다 — 필요해지면 그때 추가.
extension type DashboardServiceClient (connect.Transport _transport) {
  /// s0 장비 필터(체크박스)·라인 옵션, 필터 칩 라벨(id→이름) 용도가 대부분 — 콘텐츠 조회는
  /// equipment_name/line_name을 이미 조인해서 내려주는 ListCollectionEvents/
  /// ListEquipmentStatus/ListWorkHistory 쪽에서 처리한다.
  Future<dashboard_service.ListEquipmentResponse> listEquipment(
    dashboard_service.ListEquipmentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listEquipment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 필터 드롭다운/칩 라벨 + 배정 정보 표시(인스펙터 패널)에 같이 쓰인다 — 드롭다운 전용 아님.
  Future<dashboard_service.ListProjectsResponse> listProjects(
    dashboard_service.ListProjectsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listProjects,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s0 드릴다운(프로젝트→작업자 옵션) 생성 + 인스펙터 패널의 "현재 배정" 판정(assignmentAt류)에
  /// 같이 쓰인다 — 드롭다운 전용 아님.
  Future<dashboard_service.ListCollectionAssignmentsResponse> listCollectionAssignments(
    dashboard_service.ListCollectionAssignmentsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listCollectionAssignments,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s0 타임라인/이벤트 로그. date/equipment/connection/line/project/worker/unassigned 필터.
  /// project_ids·worker_ids는 collection_assignments와 이벤트 구간이 겹치는지로 매칭한다
  /// (store.js eventMatchesAssignmentFilter). equipment 조인이라 equipment_name/line_name도
  /// 같이 옴. from/to("HH:MM")는 date로 고른 하루 안의 시:분 구간(s0 타임라인 확대 t0/t1).
  Future<dashboard_service.ListCollectionEventsResponse> listCollectionEvents(
    dashboard_service.ListCollectionEventsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listCollectionEvents,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s0 KPI 카드 + 실시간 수집 상태 표(s1도 필터 없이 그대로 재사용). equipment + collection_
  /// status(스냅샷) LEFT JOIN이라 상태 없는 장비도 포함. 필터는 ListCollectionEvents와 동일한
  /// 배정 겹침 규칙이지만 "그 날 하루" 단위로 겹치는지를 본다(store.js snapshotFiltered).
  Future<dashboard_service.ListEquipmentStatusResponse> listEquipmentStatus(
    dashboard_service.ListEquipmentStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listEquipmentStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 필터 드롭다운 전용(s2 작업지시 선택) — work_order_no/title은 ListWorkHistory가 이미
  /// 조인해서 내려주므로 다른 곳에서 따로 안 부른다.
  Future<dashboard_service.ListWorkOrdersResponse> listWorkOrders(
    dashboard_service.ListWorkOrdersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listWorkOrders,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 필터 드롭다운 전용(s2d 조인트 선택) — joint_no/name도 ListWorkHistory가 이미 조인해서
  /// 내려주므로 다른 곳에서 따로 안 부른다.
  Future<dashboard_service.ListJointsResponse> listJoints(
    dashboard_service.ListJointsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listJoints,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 필터 드롭다운/칩 라벨 + 파형 범례 실명 표시(masterName/beginnerName)에 같이 쓰인다 —
  /// 드롭다운 전용 아님.
  Future<dashboard_service.ListWorkersResponse> listWorkers(
    dashboard_service.ListWorkersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listWorkers,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s2 검색/목록 표 + s2d 상세 헤더. work_orders/joints/workers/equipment 조인, passes/
  /// work_attachments 카운트(pass_count/attachment_count)까지 붙여서 내려주므로 행마다 별도
  /// 조회가 필요 없다. common_key는 부분 일치(substring), history_id는 정확히 일치(s2d 딥링크
  /// 단건 조회용).
  Future<dashboard_service.ListWorkHistoryResponse> listWorkHistory(
    dashboard_service.ListWorkHistoryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listWorkHistory,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s2 목록의 첨부 아이콘, s2d 첨부 탭(이미지/PDF/영상/오디오/텍스트) 목록·뷰어. 필터 없이
  /// 전체를 내려주면 FE가 history_id/file_type으로 골라 쓴다(store.js attachments()와 동일).
  /// 실 파일은 file_url(정적 /files/... 경로)로 받고, 이 응답 바디엔 바이트를 안 싣는다.
  Future<dashboard_service.ListWorkAttachmentsResponse> listWorkAttachments(
    dashboard_service.ListWorkAttachmentsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listWorkAttachments,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s3/s4 패스 선택 탭. common_key 필터(비우면 전체), pass_no 순으로 정렬해서 씀.
  Future<dashboard_service.ListPassesResponse> listPasses(
    dashboard_service.ListPassesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listPasses,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// waveform_series 테이블 그대로(플랫 목록, 포인트당 한 행). pass_id 필터(비우면 전체 —
  /// 테이블이 12,000행대라 화면은 항상 pass_id를 넣어 씀). 화면 자체는 role별로 묶인
  /// GetPassWaveform을 쓰고 이 RPC는 안 부른다 — 원본 테이블 참조/디버그용으로 남겨둠.
  Future<dashboard_service.ListWaveformSeriesResponse> listWaveformSeries(
    dashboard_service.ListWaveformSeriesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listWaveformSeries,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s3 파형 비교 그래프(명장/초보자/로봇 겹쳐보기) + s4 파형 배경 그래프. mockup-data/
  /// API-컬럼매핑-연동명세.md의 GET /api/v1/passes/{pass_id}/waveform 계약을 그대로 gRPC로
  /// 옮긴 것 — normalize="raw"면 이 서비스 자신의 DB(passes/waveform_series)에서,
  /// "dtw"(normalized)면 aiops를 gRPC로 호출해 합쳐서 낸다(internal/data/aiops). FE는 이
  /// 하나만 보고 raw/dtw 차이는 모른다. roles 비우면 그 pass의 전체 role.
  Future<dashboard_service.GetPassWaveformResponse> getPassWaveform(
    dashboard_service.GetPassWaveformRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getPassWaveform,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s4 품질 판정 카드(성적서/불량 항목). quality_results 테이블 그대로(item당 한 행, flat) —
  /// 같은 quality_result_id가 item마다 반복되고 FE가 그룹으로 묶어 쓴다(store.js
  /// qualityGroups()). 성적서 스캔 PDF·현장 영상(media, scan/video)도 quality_result_id당
  /// 0개 이상 같이 옴 — 별도 호출 불필요. common_key/pass_id 필터(둘 다 비우면 전체).
  Future<dashboard_service.ListQualityResultsResponse> listQualityResults(
    dashboard_service.ListQualityResultsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listQualityResults,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s4 파형 구간 ↔ 품질결과 연결선(회색 밴드, 클릭하면 좌측 품질 판정으로 스크롤). segment_id·
  /// segment_start_ms/end_ms로 파형의 어느 구간이 어느 품질결과에 대응하는지 알려준다.
  /// common_key/pass_id 필터(둘 다 비우면 전체).
  Future<dashboard_service.ListQualityLinksResponse> listQualityLinks(
    dashboard_service.ListQualityLinksRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.listQualityLinks,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// s3/s4 상단 컨텍스트 바(공통키 → 작업지시/조인트/작업자/장비). work_history 중 worked_at
  /// 최신 1건 + work_order/joint/worker/equipment 조인(store.js context()). 그 common_key로
  /// work_history가 없으면 common_key만 채운 빈 결과(work_order_no|joint_no 파싱 fallback).
  Future<dashboard_service.GetContextResponse> getContext(
    dashboard_service.GetContextRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DashboardService.getContext,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
