# GetQueue 무클릭·목록 wait 표시

## 목표
적재 파이프라인에서 `postprocess.*`이고 `run.queueWaitLabel`(예: `후처리 · 앞 N건`)이 있는 **진행 중** 줄이 목록에 보이면, 여정 클릭 없이도 GetQueue **대기열 앞줄** UI가 나온다. 화면 검증 때 목록에 이벤트·wait가 안 보이던 표시 버그도 고친다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_list.dart`
5. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart`
6. `lib/src/domain/entities/tool_run.dart` `queueWaitLabel`
7. `docs/2026-11-17/GetQueue_화면검증.md`

## 현재 상태
- `pipeline_trace_list.dart`: 오른쪽 칸에 `pipelineEventLabel(lastEvent)`만 표시. `run.queueWaitLabel`을 그리지 않음.
- `pipeline_trace_view_model.dart`: `doesShowQueueFront`·`_refreshSelectedQueue`가 선택 + `run.queue` 비어 있지 않음일 때만 GetQueue. 미선택이면 `_clearQueueFront()`.
- `pipeline_trace_tab_body.dart`: `_QueueFrontPanel`은 `selected != null` 블록 안 + `doesShowQueueFront`일 때만.
- ListTraces/GetTrace 매핑은 이미 wait·queue를 담음. 표시·호출 조건이 원인.

## 바꿀 것
1. 목록 한 줄: `lastEvent` 원문 + `run?.queueWaitLabel`을 ` · `로 이어 표시.
2. 무클릭 GetQueue: 선택+queue 우선, 없으면 RUNNING+`run.queue` 첫 줄. 폴링마다 갱신. `doesShowQueueFront`·`selectedRunId`를 그 규칙에 맞춤.
3. `_QueueFrontPanel`을 선택 밖에서도 `doesShowQueueFront`면 표시. 선택 요약은 선택 시에만.
4. `GetQueue_화면검증.md` 시나리오·체크리스트를 무클릭 표시에 맞춤.
5. 테스트: 선택 없이 `refresh`만으로 GetQueue·앞줄. 기존 선택 테스트 유지.
6. `./scripts/agent_check.sh` + `test/pipeline_trace_view_model_get_queue_test.dart`.

## 유지할 것
- GetQueue는 `RunService`·`ToolRunUseCase.getQueue`만.
- queue 없는 선택·DONE만 있는 목록에서는 앞줄 숨김·GetQueue 안 침.
- 집계 스테퍼·칩·점등 로직, generated 수정 없음.
- 선택 시 요약·내 run ● 강조.

## 이번 작업에서 만들지 않음
- 새 화면·라우트·상태관리·카드 UI
- 상시 전체 대기열 폴링(진행 중 queue 줄/선택 없을 때 외)
- ListTraces/GetTrace 서버 계약 변경

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
- `./scripts/agent_check.sh test/pipeline_trace_view_model_get_queue_test.dart` 통과
- 목록 RUNNING 줄에 `postprocess.*` 원문과 wait(`후처리 · 앞 N건` 등)가 보임
- 그 줄이 있으면 클릭 없이 대기열 앞줄·GetQueue
- queue 줄이 없고 미선택이면 앞줄·GetQueue 없음
- 선택+queue는 기존처럼 앞줄·내 run 강조
