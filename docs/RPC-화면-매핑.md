# RPC ↔ 화면 매핑

`wireframe-prototype/web`(정적 CSV 프로토타입)의 각 화면이 `DashboardService`의 어느 RPC로
대체되는지 정리한 것. `proto/tacit/dashboard/v1/dashboard_service.proto`는
`wireframe-prototype/web/js/store.js`의 조회 로직을 그대로 gRPC로 옮긴 것이므로, 아래 매핑은
`store.js` 함수 호출 지점(`screens.js`)을 기준으로 뽑았다.

## 엔드포인트

- **주소**: `http://192.168.100.3:33201` — `0.0.0.0:33201`로 바인딩(`main.go`)이라 로컬은 `http://localhost:33201`, 같은 LAN에서는 이 IP로도 접근 가능. 포트는 env `PORT`로 변경(기본 33201). IP는 이 서버가 뜬 머신(`eno1`) 기준이라 배포 환경이 바뀌면 갱신 필요
- **프로토콜**: [Connect](https://connectrpc.com/)(`connectrpc.com/connect`) — 같은 핸들러가 Connect(JSON/HTTP1.1)·gRPC·gRPC-Web을 동시에 서빙. 브라우저(Flutter Web)에서 JSON POST로 바로 호출 가능, grpc-web 프록시 불필요
- **서비스 풀네임**: `tacit.dashboard.v1.DashboardService`
- **RPC 경로 패턴**: `POST /tacit.dashboard.v1.DashboardService/<RPC명>` (Connect 프로토콜 규약)
- **헬스체크**: 표준 gRPC Health Checking Protocol(`grpchealth`), `tacit.dashboard.v1.DashboardService`를 체크 대상으로 등록
- **첨부/미디어 정적 파일**: `GET /files/<파일명>` — Range 요청 지원(영상 시킹·PDF 부분 로드용). `WorkAttachment.file_url`/`QualityMedia.url`이 이 경로를 가리키고, RPC 응답 바디엔 바이트를 안 싣는다
- **CORS**: 기본 전체 허용(`*`), env `CORS_ORIGINS`(콤마 구분)로 좁힘
- **DB**: `DASHBOARD_DB_DSN`(기본 로컬 `tacit-metadata-test` 컨테이너, `postgres-db/dashboard` 스키마)
- **aiops(파형 dtw) 연동 주소**: `AIOPS_WAVEFORM_GRPC_ADDR`(기본 `http://127.0.0.1:50060`, 현재 서버 없음 — `GetPassWaveform(normalize=dtw)`만 이걸 탐)

### RPC별 경로

| RPC | 경로 |
|---|---|
| `ListEquipment` | `POST /tacit.dashboard.v1.DashboardService/ListEquipment` |
| `ListProjects` | `POST /tacit.dashboard.v1.DashboardService/ListProjects` |
| `ListCollectionAssignments` | `POST /tacit.dashboard.v1.DashboardService/ListCollectionAssignments` |
| `ListCollectionEvents` | `POST /tacit.dashboard.v1.DashboardService/ListCollectionEvents` |
| `ListEquipmentStatus` | `POST /tacit.dashboard.v1.DashboardService/ListEquipmentStatus` |
| `ListWorkOrders` | `POST /tacit.dashboard.v1.DashboardService/ListWorkOrders` |
| `ListJoints` | `POST /tacit.dashboard.v1.DashboardService/ListJoints` |
| `ListWorkers` | `POST /tacit.dashboard.v1.DashboardService/ListWorkers` |
| `ListWorkHistory` | `POST /tacit.dashboard.v1.DashboardService/ListWorkHistory` |
| `ListWorkAttachments` | `POST /tacit.dashboard.v1.DashboardService/ListWorkAttachments` |
| `ListPasses` | `POST /tacit.dashboard.v1.DashboardService/ListPasses` |
| `ListWaveformSeries` | `POST /tacit.dashboard.v1.DashboardService/ListWaveformSeries` |
| `GetPassWaveform` | `POST /tacit.dashboard.v1.DashboardService/GetPassWaveform` |
| `ListQualityResults` | `POST /tacit.dashboard.v1.DashboardService/ListQualityResults` |
| `ListQualityLinks` | `POST /tacit.dashboard.v1.DashboardService/ListQualityLinks` |
| `GetContext` | `POST /tacit.dashboard.v1.DashboardService/GetContext` |

예시(Connect JSON, 필터 없이 전체):
```
curl -X POST http://localhost:33201/tacit.dashboard.v1.DashboardService/ListEquipment -d '{}'
```

| 화면 (`screens.js`) | UI 부분 | `store.js` 함수 | 대응 RPC |
|---|---|---|---|
| **s0** 수집 모니터링 | 상단 KPI 카드(연결/단절/오류, 손실률, 시간동기) | `snapshotFiltered` + `snapshotStats` | `ListEquipmentStatus`(필터: `AssignmentFilter`). `snapshotStats`는 응답을 받은 뒤 클라이언트에서 집계 |
| | 타임라인 / 이벤트 로그(장비명·노선 표시, 시:분 확대) | `eventsFiltered` + `eventsOverlap`(t0/t1) | `ListCollectionEvents`(응답에 `equipment_name`·`line_name` 포함. `from`/`to`는 `date`로 고른 하루 안의 "HH:MM" 시:분 구간 — s0의 타임라인 확대(t0/t1)를 서버 필터로 뺀 것, `SUBSTRING(event_at,12,5)` 비교) |
| | 필터 드롭다운(프로젝트/작업자/장비/노선) | `projectName`/`workerName`/`by.equipment` 등 | `ListProjects`, `ListWorkers`, `ListEquipment`, `ListCollectionAssignments` |
| **s1** 실시간 수집 상태 | 장비 상태 표 | `equipmentRows` | `ListEquipment` + `ListEquipmentStatus`(필터 없이 전체) |
| **s2** 작업 이력 조회 | 검색/목록 테이블(패스 수·첨부 건수 열 포함) | `historyFiltered` + 행별 `attachments().length` | `ListWorkHistory`(조인 + `pass_count`·`attachment_count` 포함 응답이라 행마다 별도 조회 불필요) |
| | 검색 필터바(작업지시/조인트/작업자 드롭다운) | `filterBar`: `Store.tables.work_orders`, `jointsForOrder`, `Store.tables.workers` | `ListWorkOrders`, `ListJoints`(작업지시 선택 시 `jointsForOrder`로 클라이언트 필터), `ListWorkers` |
| **s2d** 작업 상세 | 헤더(작업지시/이음/작업자/장비/패스 수) | `historyJob`(wireframe 원본은 `historyFiltered({})` 무필터 조회 후 클라이언트에서 `history_id`로 검색) | `ListWorkHistory(history_id=…)` — 단건 필터 추가돼 있음 |
| | 첨부 탭(이미지/PDF/영상/오디오/텍스트) 목록·뷰어·탭별 건수 | `attachments` | `ListWorkAttachments`(실 파일은 `file_url`로 정적 서빙, gRPC 응답 바디엔 안 실림) |
| **s3** 패스별 파라미터 프로파일 | 컨텍스트 바(공통키 → 작업지시/조인트/작업자/장비) | `context` | `GetContext` |
| | 패스 선택 탭 | `passes` | `ListPasses` |
| | 파형 비교 그래프(명장/초보자/로봇 겹쳐보기, raw/dtw) | `mastersForPass` + `seriesForPass` | `GetPassWaveform`(`normalize=raw\|dtw`, `roles` 필터). `ListWaveformSeries`는 원본 테이블 전체 덤프용이라 화면에서는 안 씀 |
| | 편차 통계(평균/최대 diff) | `compareStats` | 없음 — `GetPassWaveform` 응답을 받아 클라이언트에서 계산 |
| | 명장 표시명 | `masterName` | `ListWorkers`(`is_master` 플래그) |
| **s4** 품질 이슈 연계 | 컨텍스트/패스 선택(s3와 공유) | `context`, `passes` | `GetContext`, `ListPasses` |
| | 품질 판정 카드(성적서/불량 항목) | `qualityGroups` | `ListQualityResults`(미디어 `scan`/`video`까지 같이 옴, 별도 호출 불필요) |
| | 파형 구간 ↔ 품질결과 연결선 | `links` | `ListQualityLinks` |
| | 파형 배경 그래프 | `seriesForPass` | `GetPassWaveform` |

## 필터 드롭다운 전용 RPC

콘텐츠(화면 본문)엔 안 쓰이고 필터 UI(드롭다운·체크박스·선택값 칩 라벨)만 위해 호출되는
RPC를 구분한 것. 콘텐츠 쪽 이름/코드는 `ListWorkHistory`/`ListCollectionEvents`/
`ListEquipmentStatus`가 이미 조인해서 내려주기 때문에 겹치지 않는다.

| RPC | 순수 드롭다운 전용? | 근거 |
|---|---|---|
| `ListWorkOrders` | **예** | s2 필터바 "작업지시" `<select>`에서만 쓰임. work_order_no/title은 `ListWorkHistory`가 이미 조인해서 내려줌 |
| `ListJoints` | **예** | s2d 필터바 "조인트" `<select>`에서만 쓰임(`jointsForOrder`로 작업지시별 필터). joint_no/name도 `ListWorkHistory`가 이미 조인해서 내려줌 |
| `ListEquipment` | 사실상 예 | s0 장비 체크박스·라인 옵션·필터 칩 라벨(id→이름)에만 쓰임. 콘텐츠(이벤트/상태)는 이제 자체 응답에 `equipment_name`/`line_name`이 있어서 이 RPC가 없어도 됨 |
| `ListProjects` | 아니오 | 드롭다운/칩에도 쓰이지만, s0 인스펙터 패널의 "현재 배정 프로젝트" 표시(콘텐츠)에도 씀 |
| `ListWorkers` | 아니오 | 드롭다운/칩 외에 인스펙터 패널 "배정 작업자" 표시, s3 파형 범례 실명(`masterName`/`workerName`) 등 콘텐츠에도 씀 |
| `ListCollectionAssignments` | 아니오 | s0 드릴다운 옵션 생성에 쓰이지만, 인스펙터 패널 "현재 배정" 판정(`assignmentAt`류)과 타임라인/스냅샷 필터 로직 자체의 데이터 소스이기도 함 |

## 참고

- `ListWorkOrders`는 s2 필터 드롭다운(작업지시 선택)에서 직접 쓰이고, s2/s2d 화면 자체는
  `ListWorkHistory`가 이미 조인해서 내려주므로 그쪽에서 따로 호출할 필요는 없다.
- 화면에 없는 조합의 RPC는 만들지 않는다는 원칙이라(`dashboard_service.proto` 상단 주석
  참고), 이 표에 없는 RPC는 없다.
- **s2d 딥링크**: `ListWorkHistoryRequest.history_id`(필드 8)로 단건 조회 가능. wireframe
  원본(`historyJob`)은 무필터 전체 조회 후 클라이언트에서 `history_id`로 찾는 방식이었는데,
  s2d를 단독으로 여는 경로(새로고침, 알림 링크 등)에서 전체 테이블을 매번 받는 게 낭비라
  필터를 추가했다. s2 목록 화면은 그대로 무필터로 전체를 받는다.
- **`ListCollectionEventsRequest.from`/`to`는 날짜 범위가 아니라 시:분 범위다** — `date`가
  하루를 고르고, `from`/`to`(`"HH:MM"`)는 그 하루 안에서 s0 타임라인 확대(`t0`/`t1`)에 대응.
  wireframe 원본은 하루치 이벤트를 전부 받은 뒤 클라이언트에서 `eventsOverlap(t0m, t1m)`으로
  잘랐는데, 그걸 서버 필터로 옮긴 것. `ListEquipmentStatus`(KPI/표)는 스냅샷 한 시점만 보는
  화면이라 `t0`/`t1` 개념 자체가 없고, 그래서 이 필드가 없다 — 처음에 실수로 넣었다가(날짜
  범위로 잘못 해석) 되돌렸다.

### 동일 `common_key`가 여러 `history_id`를 가질 때

`work_history.common_key`는 유니크하지 않다(재작업 등으로 같은 공통키에 세션이 여러 번 생길
수 있음). 반면 `passes`/`quality_results`/`quality_links`/`waveform_series`는 전부
`history_id`가 아니라 `common_key`로만 묶여 있다(`Pass`에 `history_id` 필드 자체가 없음) —
즉 같은 공통키의 세션이 여러 개여도 파형·품질 데이터는 세션 구분 없이 전부 공유된다. 어느
RPC도 이걸 막지 않고, 각자 "최신 것 하나를 대표로 고르는" 규칙으로 해소한다(전부 wireframe
`store.js` 그대로 이식):

| RPC/함수 | 중복 처리 방식 |
|---|---|
| `ListWorkHistory` | 안 합친다 — `history_id`별로 행이 그대로 나온다(s2 목록에 재작업 이력이 여러 줄로 보이는 게 의도). `pass_count`는 `common_key` 기준 집계라 같은 공통키의 모든 행이 같은 값을 보여준다. `attachment_count`는 `history_id` 기준이라 행마다 다르다 — 이 둘의 집계 단위가 다르다는 점에 주의. |
| `GetContext(common_key)` | 그 공통키의 `work_history` 중 `worked_at` 최신 1건만 골라 헤더(작업지시/조인트/작업자/장비)로 쓴다. 여러 세션 중 마지막 것만 대표로 노출된다. |
| s0→s3/s4 기본 이력 선택(`hydrateWorkDefault`/`defaultHistoryAtSnapshot`, 현재는 RPC로 안 옮겨짐 — FE가 `ListWorkHistory(equipment_id=…)` 받아 클라이언트에서 계산) | `worked_at <= 진입 시점 스냅샷` 조건까지 걸어 그 시점 기준 최신 1건을 고른다. `GetContext`보다 좁은 조건이라 타임라인의 특정 시각에서 들어왔을 때 나중 재작업 세션이 아니라 그 시점 세션으로 매칭된다. |

패스/품질이 세션이 아니라 공통키 단위로만 존재하는 건 원본 CSV 모델의 한계 — 고치려면
스키마에 `history_id`를 새로 심어야 하는 큰 변경이라 지금 구조에서는 손대지 않는다.
