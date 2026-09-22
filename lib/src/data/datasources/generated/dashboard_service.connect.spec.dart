//
//  Generated code. Do not modify.
//  source: dashboard_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "dashboard_service.pb.dart" as dashboard_service;

/// 와이어프레임 프로토타입(serviceops/wireframe-prototype)의 data/*.csv를 postgres-db/dashboard로
/// 옮긴 것을 내려준다. 원본 CSV 테이블 그대로인 List* RPC와, wireframe-prototype/web/js/store.js의
/// 조회 로직(배정 겹침 필터, 이력 조인, 컨텍스트)을 SQL로 옮긴 조인/필터 RPC 두 종류가 있다.
/// 화면에 없는 조합은 안 만든다 — 필요해지면 그때 추가.
abstract final class DashboardService {
  /// Fully-qualified name of the DashboardService service.
  static const name = 'tacit.dashboard.v1.DashboardService';

  /// s0 장비 필터(체크박스)·라인 옵션, 필터 칩 라벨(id→이름) 용도가 대부분 — 콘텐츠 조회는
  /// equipment_name/line_name을 이미 조인해서 내려주는 ListCollectionEvents/
  /// ListEquipmentStatus/ListWorkHistory 쪽에서 처리한다.
  static const listEquipment = connect.Spec(
    '/$name/ListEquipment',
    connect.StreamType.unary,
    dashboard_service.ListEquipmentRequest.new,
    dashboard_service.ListEquipmentResponse.new,
  );

  /// 필터 드롭다운/칩 라벨 + 배정 정보 표시(인스펙터 패널)에 같이 쓰인다 — 드롭다운 전용 아님.
  static const listProjects = connect.Spec(
    '/$name/ListProjects',
    connect.StreamType.unary,
    dashboard_service.ListProjectsRequest.new,
    dashboard_service.ListProjectsResponse.new,
  );

  /// s0 드릴다운(프로젝트→작업자 옵션) 생성 + 인스펙터 패널의 "현재 배정" 판정(assignmentAt류)에
  /// 같이 쓰인다 — 드롭다운 전용 아님.
  static const listCollectionAssignments = connect.Spec(
    '/$name/ListCollectionAssignments',
    connect.StreamType.unary,
    dashboard_service.ListCollectionAssignmentsRequest.new,
    dashboard_service.ListCollectionAssignmentsResponse.new,
  );

  /// s0 타임라인/이벤트 로그. date/equipment/connection/line/project/worker/unassigned 필터.
  /// project_ids·worker_ids는 collection_assignments와 이벤트 구간이 겹치는지로 매칭한다
  /// (store.js eventMatchesAssignmentFilter). equipment 조인이라 equipment_name/line_name도
  /// 같이 옴. from/to("HH:MM")는 date로 고른 하루 안의 시:분 구간(s0 타임라인 확대 t0/t1).
  static const listCollectionEvents = connect.Spec(
    '/$name/ListCollectionEvents',
    connect.StreamType.unary,
    dashboard_service.ListCollectionEventsRequest.new,
    dashboard_service.ListCollectionEventsResponse.new,
  );

  /// s0 KPI 카드 + 실시간 수집 상태 표(s1도 필터 없이 그대로 재사용). equipment + collection_
  /// status(스냅샷) LEFT JOIN이라 상태 없는 장비도 포함. 필터는 ListCollectionEvents와 동일한
  /// 배정 겹침 규칙이지만 "그 날 하루" 단위로 겹치는지를 본다(store.js snapshotFiltered).
  static const listEquipmentStatus = connect.Spec(
    '/$name/ListEquipmentStatus',
    connect.StreamType.unary,
    dashboard_service.ListEquipmentStatusRequest.new,
    dashboard_service.ListEquipmentStatusResponse.new,
  );

  /// 필터 드롭다운 전용(s2 작업지시 선택) — work_order_no/title은 ListWorkHistory가 이미
  /// 조인해서 내려주므로 다른 곳에서 따로 안 부른다.
  static const listWorkOrders = connect.Spec(
    '/$name/ListWorkOrders',
    connect.StreamType.unary,
    dashboard_service.ListWorkOrdersRequest.new,
    dashboard_service.ListWorkOrdersResponse.new,
  );

  /// 필터 드롭다운 전용(s2d 조인트 선택) — joint_no/name도 ListWorkHistory가 이미 조인해서
  /// 내려주므로 다른 곳에서 따로 안 부른다.
  static const listJoints = connect.Spec(
    '/$name/ListJoints',
    connect.StreamType.unary,
    dashboard_service.ListJointsRequest.new,
    dashboard_service.ListJointsResponse.new,
  );

  /// 필터 드롭다운/칩 라벨 + 파형 범례 실명 표시(masterName/beginnerName)에 같이 쓰인다 —
  /// 드롭다운 전용 아님.
  static const listWorkers = connect.Spec(
    '/$name/ListWorkers',
    connect.StreamType.unary,
    dashboard_service.ListWorkersRequest.new,
    dashboard_service.ListWorkersResponse.new,
  );

  /// s2 검색/목록 표 + s2d 상세 헤더. work_orders/joints/workers/equipment 조인, passes/
  /// work_attachments 카운트(pass_count/attachment_count)까지 붙여서 내려주므로 행마다 별도
  /// 조회가 필요 없다. common_key는 부분 일치(substring), history_id는 정확히 일치(s2d 딥링크
  /// 단건 조회용).
  static const listWorkHistory = connect.Spec(
    '/$name/ListWorkHistory',
    connect.StreamType.unary,
    dashboard_service.ListWorkHistoryRequest.new,
    dashboard_service.ListWorkHistoryResponse.new,
  );

  /// s2 목록의 첨부 아이콘, s2d 첨부 탭(이미지/PDF/영상/오디오/텍스트) 목록·뷰어. 필터 없이
  /// 전체를 내려주면 FE가 history_id/file_type으로 골라 쓴다(store.js attachments()와 동일).
  /// 실 파일은 file_url(정적 /files/... 경로)로 받고, 이 응답 바디엔 바이트를 안 싣는다.
  static const listWorkAttachments = connect.Spec(
    '/$name/ListWorkAttachments',
    connect.StreamType.unary,
    dashboard_service.ListWorkAttachmentsRequest.new,
    dashboard_service.ListWorkAttachmentsResponse.new,
  );

  /// s3/s4 패스 선택 탭. common_key 필터(비우면 전체), pass_no 순으로 정렬해서 씀.
  static const listPasses = connect.Spec(
    '/$name/ListPasses',
    connect.StreamType.unary,
    dashboard_service.ListPassesRequest.new,
    dashboard_service.ListPassesResponse.new,
  );

  /// waveform_series 테이블 그대로(플랫 목록, 포인트당 한 행). pass_id 필터(비우면 전체 —
  /// 테이블이 12,000행대라 화면은 항상 pass_id를 넣어 씀). 화면 자체는 role별로 묶인
  /// GetPassWaveform을 쓰고 이 RPC는 안 부른다 — 원본 테이블 참조/디버그용으로 남겨둠.
  static const listWaveformSeries = connect.Spec(
    '/$name/ListWaveformSeries',
    connect.StreamType.unary,
    dashboard_service.ListWaveformSeriesRequest.new,
    dashboard_service.ListWaveformSeriesResponse.new,
  );

  /// s3 파형 비교 그래프(명장/초보자/로봇 겹쳐보기) + s4 파형 배경 그래프. mockup-data/
  /// API-컬럼매핑-연동명세.md의 GET /api/v1/passes/{pass_id}/waveform 계약을 그대로 gRPC로
  /// 옮긴 것 — normalize="raw"면 이 서비스 자신의 DB(passes/waveform_series)에서,
  /// "dtw"(normalized)면 aiops를 gRPC로 호출해 합쳐서 낸다(internal/data/aiops). FE는 이
  /// 하나만 보고 raw/dtw 차이는 모른다. roles 비우면 그 pass의 전체 role.
  static const getPassWaveform = connect.Spec(
    '/$name/GetPassWaveform',
    connect.StreamType.unary,
    dashboard_service.GetPassWaveformRequest.new,
    dashboard_service.GetPassWaveformResponse.new,
  );

  /// s4 품질 판정 카드(성적서/불량 항목). quality_results 테이블 그대로(item당 한 행, flat) —
  /// 같은 quality_result_id가 item마다 반복되고 FE가 그룹으로 묶어 쓴다(store.js
  /// qualityGroups()). 성적서 스캔 PDF·현장 영상(media, scan/video)도 quality_result_id당
  /// 0개 이상 같이 옴 — 별도 호출 불필요. common_key/pass_id 필터(둘 다 비우면 전체).
  static const listQualityResults = connect.Spec(
    '/$name/ListQualityResults',
    connect.StreamType.unary,
    dashboard_service.ListQualityResultsRequest.new,
    dashboard_service.ListQualityResultsResponse.new,
  );

  /// s4 파형 구간 ↔ 품질결과 연결선(회색 밴드, 클릭하면 좌측 품질 판정으로 스크롤). segment_id·
  /// segment_start_ms/end_ms로 파형의 어느 구간이 어느 품질결과에 대응하는지 알려준다.
  /// common_key/pass_id 필터(둘 다 비우면 전체).
  static const listQualityLinks = connect.Spec(
    '/$name/ListQualityLinks',
    connect.StreamType.unary,
    dashboard_service.ListQualityLinksRequest.new,
    dashboard_service.ListQualityLinksResponse.new,
  );

  /// s3/s4 상단 컨텍스트 바(공통키 → 작업지시/조인트/작업자/장비). work_history 중 worked_at
  /// 최신 1건 + work_order/joint/worker/equipment 조인(store.js context()). 그 common_key로
  /// work_history가 없으면 common_key만 채운 빈 결과(work_order_no|joint_no 파싱 fallback).
  static const getContext = connect.Spec(
    '/$name/GetContext',
    connect.StreamType.unary,
    dashboard_service.GetContextRequest.new,
    dashboard_service.GetContextResponse.new,
  );
}
