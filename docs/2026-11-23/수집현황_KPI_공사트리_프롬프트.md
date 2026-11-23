# 수집 현황 KPI · 공사 트리 연동 (§1)

## 목표
수집 모니터링 KPI를 서버 `GetCollectionSummary`·`ListTraces.total_count`에 바인딩하고, 트리를 공사→품목→작업→파일로 옮기며, 날짜별 `ListAssetCounts`와 업로드 `fileModifiedAt`을 반영한다. 클라이언트에서 `ListCollectionNodes` 자식 summary를 더해 KPI를 만들던 로직과 유실률·지연·시각 동기 카드를 제거한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-23/README.md` §1
4. `docs/2026-11-23/수집 현황 KPI · 타임라인 변경 안내.md`
5. `protos/mediatag/work/v1/work.proto` (`GetCollectionSummary` · `CollectionSummary` · `ListAssetCounts` · `CollectionPath`)
6. `protos/mediatag/trace/v1/trace.proto` (`ListTracesResponse.total_count`)
7. `lib/src/presentation/features/collection_monitoring/**`
8. `lib/src/data/repositories/remote_collection_catalog_repository.dart`
9. `lib/src/domain/use_cases/present_collection_nodes_use_case.dart`

## 현재 상태
- KPI: `collection_kpi_cards.dart`가 `PresentCollectionNodesUseCase._kpiFrom`의 목업 집계를 표시(수집/수신/유실률/시각 동기).
- 생성 코드에는 `getCollectionSummary` · `listAssetCounts` · `CollectionSummary` 신규 필드 · Trace `totalCount`가 이미 있음.
- `remote_collection_catalog_repository.dart`의 `_pathToProto`/`_nodeFromProto`가 삭제된 `CollectionPath.equipmentId`·`workerId`·`COLLECTION_LEVEL_EQUIPMENT/WORKER`를 참조 — analyze 깨짐 가능.
- CommandBar에 장비/작업자 **보기**와 장비/작업자 **레벨** 콤보가 있음. proto는 `COLLECTION_VIEW_PROJECT` + 요청 `worker_id` 필터.
- Trace `listTraces`는 목록만 반환, `total_count` 미사용.
- 타임라인은 `durationSec < 1`이면 1초로 올려 그림 — 끝 없는 작업(길이 0) 점 표기 없음.
- 업로드 metadata에 `fileModifiedAt` 없음.

## 바꿀 것

### 1. Domain · Data — 경로·요약·건수
- `CollectedNodeView`를 `project` 단일(또는 view 필드 제거 후 항상 PROJECT)로 정리. `CollectedNodeLevel`에서 `equipment`·`worker` 제거.
- `CollectedNodePath`에서 path의 `equipmentId`·`workerId` 제거. 작업자 필터는 요청 파라미터 `workerId`로 분리.
- `CollectionCatalogRepository`에 `getCollectionSummary(parent?, workerId)` · `listAssetCounts(...)` 추가. `listCollectedNodes`에 `workerId` 전달.
- `RemoteCollectionCatalogRepository`: proto 매핑을 새 `CollectionPath`에 맞춤. KPI용 summary 도메인 엔티티로 `toDomain`.
- `TraceRepository.listTraces`가 `(traces, totalCount)` 또는 `countTraces(status)`를 반환하도록 확장. KPI는 `pageSize=1` + `totalCount`만 사용.
- UseCase: `GetCollectionSummaryUseCase`, Trace 건수용 얇은 use case(또는 기존 `TraceUseCase` 확장). ViewModel은 UseCase만 호출.

### 2. KPI 엔티티·카드 (구성 A)
`CollectionKpi`를 서버 필드로 교체. 표시 카드:

| 카드 | 값 |
|------|-----|
| 파일 수 · 용량 | `asset_count` · `total_size_bytes` |
| 작업 수 · 작업시간 | `job_count` · `work_duration_seconds` (부제: 자료 없는 작업 `job_without_asset_count`) |
| 용접시간 · 커버리지 | `weld_duration_seconds` + `coverage` 종류별 `% = covered/weld` (응답에 온 종류만, 고정 목록 금지) |
| 적재 진행 · 실패 | `ListTraces` RUNNING/FAILED `total_count` |

추가:
- 임베딩 진행: `embedded_clip_count / clip_count` (분모 0이면 `—`).
- 메타·코멘트: **분모>0이고 분자=0이면 「집계 준비 중」, 분모=0이면 숨김**.
- 시각 확인 필요: `time_unverified_asset_count`를 작은 카드/부제로 표시.
- 유실률·지연·시각 동기 카드·`KpiCardKind.loss/sync/connection` 기반 목업 필터 제거.
- `PresentCollectionNodesUseCase`의 `_kpiFrom` 및 자식 합산 KPI 코드 삭제. 보드 KPI는 ViewModel이 summary+trace 건수를 넣어 전달.

로드: 화면 진입·리셋·조회 시 `GetCollectionSummary`(parent 비움=전체) **한 번**. 노드 드릴다운마다 재호출하지 않음. 작업자 필터 변경 시에만 summary 재호출. Trace 건수는 자동갱신 주기와 맞춰 폴링 가능(page_size=1).

### 3. CommandBar · 트리 — 공사 보기
- 「보기」장비/작업자 콤보 제거. 루트는 항상 `COLLECTION_VIEW_PROJECT`.
- 레벨 콤보: 공사 → 품목 → 작업만 (장비/작업자 레벨 제거).
- 작업자: lookup 필터 콤보 → `ListCollectionNodesRequest.worker_id` / `GetCollectionSummary.worker_id`.
- `basis`·`segment_unit`·`worker_id` 변경 시 열린 조상 캐시 전부 비우고 재조회.
- 권장 segment: 공사·품목 단계 = `JOB`, 작업 단계(또는 강한 확대) = `PASS`. 기존 막대 단위 콤보를 유지하되 기본값을 단계에 맞게 맞춤.

### 4. 타임라인 — 길이 0 점
- `started_at == ended_at`(또는 duration 0) 이벤트를 1초 막대로 올리지 말고 ◆ 등 점으로 그림.

### 5. ListAssetCounts
- 타임라인 탭 또는 KPI 아래 단순 일자×종류 집계 패널(기존 Fluent/차트 패턴만 사용, 새 디자인 시스템·카드 UI 도입 금지).
- `basis` 수집/기록 전환 가능. `parent`·`worker_id`는 현재 트리 선택과 동일.
- 0인 칸은 서버가 안 줌 — 그대로 그리기.

### 6. 업로드 `fileModifiedAt`
- `remote_asset_upload_repository.dart` metadata JSON에 `fileModifiedAt: File.lastModified` ISO8601 추가(모든 업로드).

### 7. locator · 검증
- UseCase/Repository 등록 갱신.
- `./scripts/agent_check.sh` (+ 관련 테스트 있으면).

## 유지할 것
- 적재 파이프라인 탭·기존 Trace 그래프/폴링 본문(목록 폴링).
- MediaTag Connect 베이스 URL·생성 코드 직접 수정 금지.
- 로그인·Account·`created_by` 표시(§2·§3) — 이번 작업 밖.

## 이번 작업에서 만들지 않음
- Auth 로그인 화면·401 공통 처리·권한 관리
- Author 필드 UI
- SSE/WS
- 새 추상 계층·전략·팩토리·제네릭 헬퍼
- 공정 전용 이름·새 디자인 시스템

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- 관련 테스트가 있으면 `./scripts/agent_check.sh <test 경로…>` 통과
- KPI가 `GetCollectionSummary`(+ Trace total_count) 값으로 표시되고, 유실률·시각 동기 카드가 없음
- 트리가 공사→품목→작업→파일이고 장비/작업자 보기 콤보가 없음
- 작업자 필터가 `worker_id`로 전달됨
- 길이 0 작업이 점으로 보임
- ListAssetCounts 패널이 parent/worker와 맞춰 갱신됨
- 업로드 metadata에 `fileModifiedAt` 포함
