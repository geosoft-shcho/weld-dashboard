# PipelineTrace 미선택 = 골격만 (노드 점등 집계 제거)

> **롤백됨 (2026-11-19).** 미선택 시 실시간 업로드 점등이 사라져  
> `docs/2026-11-19/PipelineTrace_미선택_골격만_롤백_프롬프트.md` 로 합산·path 합집합을 복구했다.

## 목표
미선택일 때 활성 path 선뿐 아니라 **노드·단계 visual도 idle**로 두어, 그래프가 회색 골격만 보이게 한다. 여정 점등·path는 목록에서 `selected`를 고른 뒤에만 켠다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-19/PipelineTrace_미선택_path합집합제거_권장안.md` (활성 선은 이미 빈 결과)
4. `lib/src/domain/entities/pipeline_trace_graph.dart` (`pipelineNodeVisual`, `pipelineStageVisual`, `pipelineHighlightStageIds`)
5. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
6. `test/pipeline_trace_graph_test.dart`

## 현재 상태
- `pipelineActivePathEdges` / `pipelineHighlightEdgeKeys`: 미선택 → 빈 결과 (완료)
- `pipelineNodeVisual` / `pipelineStageVisual`: 미선택 시 `visibleTraces` 합산 점등 → 골격만으로 안 보임
- `pipelineHighlightStageIds`: 미선택 시 non-idle 단계 합산

## 바꿀 것
1. `pipelineNodeVisual`: `selected == null`이면 곧바로 `PipelineNodeVisual.idle` (traces 합산 분기 제거).
2. `pipelineStageVisual`: `selected == null`이면 `idle` (합산 분기 제거).
3. `pipelineHighlightStageIds`: `selected == null`이면 빈 목록.
4. `test/pipeline_trace_graph_test.dart`: 미선택 집계 기대를 idle/empty로 맞춘다. 선택 시 visual·path 테스트는 유지.
5. 권장안 문서의 “노드 visual 유지” 문구를 “미선택 idle”로 고친다.

## 유지할 것
- 선택 시 `_visualForSelected` / path 활성 선
- 단계 칩의 count·failed (visual과 무관)
- 목록 GetTrace / 노드 탭 이벤트 스트립
- `pipelineListHasToolStage` / `pipelineListHasEmbedStage` / stageCounts

## 이번 작업에서 만들지 않음
- 미선택 자동 선택
- 칩 UI 변경
- detail Struct 매핑

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
- 미선택: 회색 골격 선 + idle 노드
- 선택 후: 그 여정 path·노드 상태만 점등
