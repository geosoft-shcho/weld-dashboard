# Trace 최근 창 + 상태 필터

## 목표
적재 파이프라인 목록은 **최근 80건 창**만 폴링하고 페이지네이션은 넣지 않는다. **전체·진행·완료·실패** 상태 필터를 ListTraces `status`로 넘겨, 진행 모니터와 완료/실패 조회를 같은 목록에서 바꾼다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인은 워킹 트리 밖 읽기만)
3. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
4. `lib/src/data/repositories/remote_trace_repository.dart` / `lib/src/domain/use_cases/trace_use_case.dart` / `lib/src/domain/repositories/trace_repository.dart`
5. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart` / `pipeline_trace_list.dart`
6. `protos/mediatag/trace/v1/trace.proto` ListTraces (`status`, `page_size`, `page_token`)
7. `test/list_traces_response_mapping_test.dart`

## 현재 상태
- VM: `listTraces(pageSize: 80)`, `next_page_token` 미사용, `visibleTraces` = API 순서.
- Repository: `ListTracesRequest(pageSize: size)`만 설정. `status` 미전달.
- 목록 UI: 높이 168px `PipelineTraceList`, 상태 필터 UI 없음.
- 칩은 파이프라인 **단계** 집계용이며 TraceStatus 필터가 아님.

## 바꿀 것
1. **최근 창 고정** — `pageSize = 80`을 VM 상수(`recentPageSize`)로 두고, 폴링은 계속 `pageToken` 없이 1페이지만 교체. `next_page_token`/loadMore/무한스크롤 **추가하지 않음**.
2. **상태 필터 → API** — Repository·UseCase·`listTraces`에 `UploadTraceStatus? status`(null=전체) 추가. proto `TRACE_STATUS_RUNNING/DONE/FAILED` 매핑. null이면 status 필드 비움(전부).
3. **ViewModel** — `statusFilter`(null|running|done|failed), `didSelectStatusFilter`. 변경 시 즉시 `refresh()`. 필터 후 선택 trace가 목록에 없으면 선택 유지 시도는 하되 GetTrace 실패/부재면 기존 `_loadSelection` 동작. 집계·목록은 필터된 `_traces` 기준(현재와 동일).
4. **UI** — `pipeline_trace_tab_body.dart` 목록 위에 한 줄: `ComboBox` **전체·진행·완료·실패** + 문구 `최근 80건`(상수와 동일). 기존 Fluent ComboBox 패턴(`collection_command_bar.dart`) 재사용. 기본값 **전체**.
5. **테스트** — fake `listTraces`에 `status` 인자 반영. 필터 변경 시 repository에 넘긴 status가 맞는지(또는 refresh 후 목록) 검증 추가. 기존 순서 테스트 유지.

## 유지할 것
- GetTrace 보강(RUNNING+선택), `pollSignature`, 폴링/`applyRefreshInterval`
- ListTraces 응답 순서, 단계 칩·스테퍼
- `PipelineTraceList` 행 UI(필터·캡션은 tab_body)

## 이번 작업에서 만들지 않음
- `page_token` 페이지네이션·loadMore·히스토리 append
- RUNNING 전용 기본값으로 바꾸기(기본은 전체)
- 새 추상 계층·별도 히스토리 화면·단계 칩을 상태 필터로 전용

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh test/list_traces_response_mapping_test.dart` 통과
- 필터 전체=status 미설정, 진행/완료/실패=해당 proto status로 ListTraces 호출
- 목록·칩이 필터된 최근 80건 기준, 페이지네이션 UI 없음
- 「최근 80건」표시와 `recentPageSize` 일치
