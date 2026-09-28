# (2026-09-28) 수집 모니터링 — 필터 포함 관계에 따른 타임라인 Y축 드릴다운

## 공통

- 대상: **weld-dashboard** 수집 모니터링 리소스 타임라인
- 목표: `ResourceTimelineView`의 Y축을 항상 「장비」로 두지 않고, `CollectionCommandBar` 필터의 **포함 관계(부모 → 자식)** 에서 **아직 고르지 않은 다음 단계**를 행으로 보여 준다. `resourceHeaderLabel`은 그 단계 이름으로 바뀐다.
- 가이드라인: https://github.com/geosoft-co-kr/guidelines.git 워킹 트리 밖 임시 클론만. 수정·클론 금지.
- 코드는 짧게. 주석은 “왜”만.
- **커밋은 사용자 요청 시에만.**
- **proto / RPC 추가·변경 금지.** 그룹핑은 이미 받은 카탈로그로 한다.

중심 파일:

- `lib/src/presentation/features/collection_monitoring/widgets/collection_resource_timeline_view.dart`
- `lib/src/presentation/features/collection_monitoring/widgets/collection_event_timeline_mapper.dart`
- `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart`
- `lib/src/presentation/features/collection_monitoring/collection_monitoring_view_model.dart`
- `lib/src/domain/use_cases/query_collection_board_use_case.dart`
- `lib/src/domain/entities/collection_timeline.dart`
- `lib/src/domain/entities/collection_board_query.dart`

**비범위:** KPI 카드, 실시간 상태 표(장비 행 유지), CommandBar 위젯 배치, 로드맵/하루 타임라인의 X축 의미, `ListCollectionEvents` 필드 추가, 작업 이력(s2) 화면.

---

## API (이미 있는 것)

`DashboardService` (`protos/dashboard_service.proto`)

| RPC | 드릴다운에 쓰는 필드 |
|-----|----------------------|
| `ListProjects` | `project_id`, `project_name` |
| `ListEquipment` | `equipment_id`, `equipment_name`, `line_name` |
| `ListWorkers` | 라벨만. Y축 단계가 아님 |
| `ListCollectionAssignments` | `equipment_id`, `project_id`, `worker_id`, `assigned_from`~`assigned_to` |
| `ListCollectionEvents` | `equipment_id`, `equipment_name`, `line_name`, `event_at`, `duration_sec`. **project_id / worker_id 없음** |
| `ListEquipmentStatus` | 표·KPI. 이번 Y축과 무관 |

이벤트 → 프로젝트는 `collection_assignments`와 **시간 겹침**으로만 붙인다. (`QueryCollectionBoardUseCase._eventMatchesAssignmentFilter` / `_assignmentAt` 과 같은 규칙)

---

## 포함 관계 (Y축에 쓰는 것 / 안 쓰는 것)

CommandBar 순서와 데이터 포함은 다르다. Y축은 아래 한 줄만 따른다.

```
프로젝트  ⊃  라인(equipment.line_name)  ⊃  장비  ⊃  (X축 막대 = collection_events)
```

배정은 “그 날짜에 프로젝트에 묶인 장비”를 정하고, 라인은 그 장비의 `line_name`이다.

| CommandBar | 역할 |
|------------|------|
| 일자 · 시작 · 종료 | X축 창. Y축 단계 아님 |
| 프로젝트 | 1단계 부모 |
| 라인 | 2단계 |
| 장비 | 3단계 (리프 행) |
| 작업자 | **축이 아님.** 배정을 좁히는 AND. 한 작업자가 장비 둘, 한 장비의 작업자는 시각마다 하나라 부모가 될 수 없음 |
| 연결 | 막대(이벤트)만 거름. 빈 행을 지우지 않음 |
| 새로고침 | 폴링. 그룹과 무관 |

미배정(`isUnassignedOnly`): 그 날짜 배정이 없는 장비. 프로젝트 단계의 「미배정」 한 칸. 그 아래는 **라인 → 장비** (프로젝트 행은 건너뜀).

---

## As-Is → To-Be

| 구분 | As-Is | To-Be |
|------|-------|-------|
| Y축 | `resources: tableRows`(장비), `resourceHeaderLabel: '장비'` 고정 | 아래 깊이 표의 **다음 자식**이 행. 헤더 문구가 단계마다 바뀜 |
| 섹션 | `_groupEquipment`가 프로젝트/라인 `TimelineSection`을 만들지만 타임라인 행에 안 씀. 위쪽 `_SectionButtons`만 클릭 | 그 그룹이 **리소스 행 자체**. 별도 섹션 버튼 줄은 제거 |
| 막대 | `resourceIds: {event.equipmentId}` | 현재 깊이 행 id에 붙임 (아래 id 규칙) |
| 드릴 | `didTapProjectSection` / `didTapLineSection`가 `notifyListeners`만 하고 `_applyQuery`를 안 부름 | 행 클릭 = 그 부모 1개로 필터를 좁히고 **반드시 `_applyQuery()`** (이미 로드된 카탈로그. `loadBoard`/RPC 재호출 없음) |
| 장비 1대 | `equipmentIds.length == 1`이면 day view | 유지. day view에는 resource 헤더 드릴을 넣지 않음 |

---

## 깊이 (헤더 = 지금 보이는 자식)

가장 깊게 **값이 정확히 1개**로 고정된 부모의 **다음 자식**을 행으로 둔다.  
같은 단계에 0개(전체) 또는 2개 이상이면 **그 단계에 머문다.** 자동으로 자식으로 내려가지 않는다.

| 조건 | 행 | `resourceHeaderLabel` | 행 탭 |
|------|----|------------------------|--------|
| 프로젝트 0개 또는 2개 이상, 미배정 아님 | 범위 안 프로젝트 + 배정 없는 장비가 있으면 「미배정」 | `프로젝트` | 그 `projectId` 1개. 라인·장비 필터는 비움. 미배정이면 `isUnassignedOnly` |
| 미배정, 라인 0개 또는 2개 이상 | 미배정 장비의 라인 | `라인` | 그 라인 1개. 장비 필터는 비움 |
| 프로젝트 1개, 라인 0개 또는 2개 이상 | 그 프로젝트 배정 장비의 라인 | `라인` | 같음 |
| 라인 1개, 장비 0개 또는 2개 이상 | 그 라인 장비 | `장비` | 선택 강조. **더블탭**만 기존처럼 장비 1대(day)로 |
| 장비 1개 | 기존 day view | (리소스 헤더 없음) | 변경 없음 |

작업자·연결·시간 창은 이 표를 바꾸지 않는다. 행 집합과 막대만 좁힌다.

여러 개 선택된 단계의 행은 **선택된 id만** 보여 준다. (프로젝트 2개면 그 2행, 헤더는 여전히 `프로젝트`)

---

## 행 id · 막대 붙이기

한 타임라인 안에서 id가 겹치지 않게 접두사를 둔다.

- 프로젝트: `project:{projectId}` / 미배정: `project:none` (`TimelineSection.UNASSIGNED_PROJECT_ID`)
- 라인: `line:{lineName}`
- 장비: `equipment:{equipmentId}` (지금 장비 id 그대로 써도 됨. 단계가 장비일 때만)

막대 `resourceIds`:

- 프로젝트 깊이: 이벤트 시각의 배정 `project_id`. 없으면 `project:none`
- 라인 깊이: `event.lineName`
- 장비 깊이: `event.equipmentId`

한 이벤트가 배정 경계를 넘으면 **시작 시각** 배정만 쓴다. (기존 `_assignmentAt`과 맞춤)

빈 행: 그 깊이에서 필터에 포함되는 부모는 **이벤트가 없어도** 남긴다. (와이어프레임 “빈 장비 행 유지”를 프로젝트·라인에도 적용)

정렬: 프로젝트는 카탈로그 프로젝트 순, 맨 끝 미배정. 라인·장비는 이름 오름차순.

행 라벨 / 서브타이틀:

- 프로젝트: 이름 / `사이트 또는 N대` (사이트 없으면 `N대`)
- 라인: 라인명 / `N대`
- 장비: 지금과 같음 — 이름 / `{equipmentId} · {lineName}`

`resourceColumnWidth`는 프로젝트명이 잘리면 단계별로만 늘린다. (장비 176 유지, 프로젝트·라인은 라벨이 들어가면 220 정도. 한 곳에서 상수)

---

## 위로 올라가기

타임라인 위 `_SectionButtons`를 없애고, 브레드크럼으로 바꾼다.

`공장 전체 › …현재 부모…`

- 공장 전체: 프로젝트·라인·장비·미배정 해제
- 프로젝트 토막: 라인·장비 해제 (프로젝트 1개 또는 미배정 유지)
- 라인 토막: 장비 해제

토막 클릭도 `_applyQuery()`. CommandBar 「조회」를 기다리지 않는다. CommandBar 콤보를 바꾸는 기존 동작(조회 전까지 서버 재호출 없음)은 유지. 드릴은 **이미 있는 카탈로그를 다시 거르는 것**이다.

---

## 구현 순서

1. 도메인에 깊이 enum (예: `CollectionResourceDepth.project | line | equipment`)과 “이 query의 깊이” 함수. `QueryCollectionBoardUseCase`가 `CollectionTimeline`에 `depth`, `resources`(그 깊이의 행), `resourceHeaderLabel`을 채운다. 상태 표 `board.rows`는 장비 스냅샷 그대로.
2. 이벤트는 필터(일자·시간·연결·배정·라인·장비)까지 기존 `_eventsFiltered`를 쓴 뒤, **표시용**으로만 현재 깊이 id에 매핑. 카탈로그 원본 이벤트는 수정하지 않는다.
3. `CollectionEventTimelineMapper.entryOf`가 깊이별 `resourceIds`를 받는다. `resourceOf`는 장비 전용 필드를 가정하지 않는다.
4. `CollectionResourceTimelineView`는 `resourceHeaderLabel`에 보드가 준 문자열을 넣고, 행 탭은 깊이에 따라 `didTapProjectSection` / `didTapLineSection` / `didSelectRow`로 보낸다. 장비 더블탭만 day.
5. `didTapProjectSection`·`didTapLineSection`·브레드크럼 핸들러는 `_applyQuery()`까지 호출.
6. `collection_timeline_host`의 섹션 버튼은 브레드크럼으로 교체.
7. 기존 `query_collection_board_use_case_test`에 깊이 케이스 추가:
   - 필터 없음 → 행이 프로젝트(와 미배정), 헤더 `프로젝트`, 막대는 장비 id가 아님
   - 프로젝트 1개 → 행이 라인, 헤더 `라인`
   - 라인 1개 → 행이 장비, 헤더 `장비`
   - 프로젝트 2개 → 여전히 프로젝트 행 2개
   - 작업자 필터는 헤더를 바꾸지 않고 행·막대만 줄어듦
   - 장비 1개 → day view (리소스 헤더 드릴 없음)

---

## 수용

- 조회 후 타임라인 왼쪽 머릿글이 상황에 따라 `프로젝트` / `라인` / `장비`.
- 프로젝트 행을 누르면 그 프로젝트의 라인 행으로 바뀌고, 라인 행을 누르면 장비 행으로 바뀐다.
- 장비 행 클릭은 선택만, 더블클릭은 지금처럼 하루 타임라인.
- 브레드크럼으로 상위 단계로 돌아가면 하위 필터가 비워지고 헤더가 부모 단계로 돌아간다.
- 상태 표·KPI는 장비 기준 그대로.
- 패스 프로파일·품질 이슈·작업 이력 화면 변화 없음.
