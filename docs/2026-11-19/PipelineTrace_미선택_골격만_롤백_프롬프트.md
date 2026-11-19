# PipelineTrace 「미선택=골격만」롤백 + 정리

## 목표
미선택 시에도 RUNNING 업로드가 노드·path에 보이도록, 「미선택=골격만(idle·활성 path 없음)」구현을 **롤백**한다. 롤백하면서 path 합집합·시각 합산 코드를 중복 없이 정리한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/domain/entities/pipeline_trace_graph.dart` (HEAD의 합산·합집합 동작)
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
5. `test/pipeline_trace_graph_test.dart`
6. `docs/2026-11-19/PipelineTrace_미선택_골격만_프롬프트.md` (롤백 대상)

## 현재 상태
- 미선택 시 노드/단계 idle, 활성 path 빈 목록 → 실시간 업로드 점등·path가 안 보임
- 터미널에 `[pipeline] cells …`가 미선택 폴링에서 안 나옴

## 바꿀 것
1. `pipelineNodeVisual` / `pipelineStageVisual` / `pipelineHighlightStageIds`: 미선택 시 `visibleTraces` 합산 점등 복구 (`traces` 인자 복구).
2. `pipelineActivePathEdges` / `pipelineHighlightEdgeKeys` / `pipelineEdgeIsLive`: 미선택 시 path **합집합** 복구 (`traces` 인자 복구).
3. 정리: 선택 path / 미선택 합집합을 한 경로로 모으고, run→live visual 반복을 private 헬퍼 하나로 줄인다. 새 파일·추상 계층 없음.
4. `PipelineTraceGraphView`가 다시 `visibleTraces`를 visual·painter에 넘긴다.
5. 테스트를 합산·합집합 기대로 되돌린다.
6. `PipelineTrace_미선택_골격만_프롬프트.md` / 권장안 문구에 **롤백됨**을 표시한다. path합집합제거 권장안도 철회 표기.

## 유지할 것
- 목록 `didSelectTrace` / GetTrace
- 노드 탭 이벤트 스트립(`_focusedNodeId`) — 골격만과 무관
- 골격 가이드 선
- stageCounts / 칩

## 이번 작업에서 만들지 않음
- 미선택 자동 선택
- detail Struct 매핑
- 노드 탭 UX 재설계

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- 미선택 + RUNNING: 노드 점등·path 활성 보임
- 선택 시: 그 여정 path/visual
- 디버그 `[pipeline] cells`가 미선택 집계에서도 다시 찍힘
