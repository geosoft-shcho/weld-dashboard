# PipelineTrace 노드 탭 → 이벤트 요약 (근처 여정 선택 제거)

## 목표
그래프 노드를 탭하면 임의 Trace를 고르지 않고, **선택된 여정의 해당 이벤트**(`name`/`status`/`at`/`runId`/`errorMessage`)를 그래프 근처에 보여 준다. 미선택이면 목록에서 여정을 고르라는 안내만 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-19/PipelineTrace_노드탭_이벤트상세_권장안.md`
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
5. `lib/src/domain/entities/upload_trace.dart` (`TraceEventSnapshot`)
6. `protos/mediatag/trace/v1/trace.proto` (`TraceEvent` — detail은 이번 범위 밖)

## 현재 상태
- `pipeline_trace_graph_view.dart`: 노드 `onTap` → `_selectNear` → `lastEvent`/같은 stage Trace의 `didSelectTrace` (없으면 `visibleTraces.first`)
- 여정 상세는 GetTrace/`selected.events`에 있음. 앱은 `detail` Struct를 매핑하지 않음
- 목록 `PipelineTraceList`의 `didSelectTrace`는 유지 대상

## 바꿀 것
1. `_selectNear` 및 노드 탭의 `didSelectTrace` 호출을 제거한다.
2. `PipelineTraceGraphView`에 `_focusedNodeId`를 두고, 탭 시 설정·같은 노드 재탭 시 해제한다.
3. `_focusedNodeId`가 있을 때 그래프 영역 하단(라이브 요약·캔버스 Column 안)에 짧은 요약 줄을 표시한다.
   - `selected == null`: 노드 라벨 + “목록에서 여정을 선택하면 이 노드 이벤트를 볼 수 있습니다.”
   - `selected != null`이고 `events`에 `name == nodeId`: 라벨·status·at(있으면)·runId(있으면)·errorMessage(있으면)
   - `selected != null`이고 일치 이벤트 없음: “이 여정에 이 이벤트 기록이 없습니다.”
4. 기존 Fluent/AppTheme 톤에 맞춘 단순 Text/Padding만 쓴다. 새 화면·Flyout 전용 파일·카드 UI 도입 없음.

## 유지할 것
- 목록 선택 → `didSelectTrace` → GetTrace
- skeleton / path 활성(`pipelineActivePathEdges`) · 노드 visual
- 우측 목록 패널 토글
- `TraceEventSnapshot.detail` 미매핑 상태

## 이번 작업에서 만들지 않음
- proto `detail` Struct 매핑·표시
- ViewModel에 focusedNodeId 추가
- 노드 탭으로 목록 필터
- 새 추상 계층·위젯 파일 분리(파일 내 private 위젯은 허용)

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
- 노드 탭이 Trace를 바꾸지 않는다
- 목록에서 여정 선택 후 노드 탭 시 해당 이벤트 요약이 보인다
- 미선택 노드 탭 시 강제 선택 없이 안내만 보인다
