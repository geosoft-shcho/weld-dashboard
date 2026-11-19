# PipelineTrace 미선택 시 path 합집합 제거

> **롤백됨 (2026-11-19).** 골격만 정책과 함께 철회.  
> 복구: `docs/2026-11-19/PipelineTrace_미선택_골격만_롤백_프롬프트.md`

## 목표
그래프 활성 연결선은 **선택된 여정 path만** 켠다. 미선택이면 골격만 보이고, `visibleTraces` path 합집합은 쓰지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-19/PipelineTrace_미선택_path합집합제거_권장안.md`
4. `lib/src/domain/entities/pipeline_trace_graph.dart` (`pipelineHighlightEdgeKeys`, `pipelineActivePathEdges`)
5. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
6. `test/pipeline_trace_graph_test.dart`

## 현재 상태
- `pipelineActivePathEdges` / `pipelineHighlightEdgeKeys`: 선택 시 selected path, 미선택 시 traces path 합집합
- `PipelineTraceGraphView`가 위 헬퍼로 active 레이어를 그림
- 노드 visual 미선택 집계는 별도 로직(이번 범위에서 유지)

## 바꿀 것
1. `pipelineHighlightEdgeKeys` · `pipelineActivePathEdges`: `selected == null`이면 빈 Set/List. 합집합 분기와 불필요해진 `traces` 인자를 제거한다.
2. `PipelineTraceGraphView` 호출부를 새 시그니처에 맞춘다.
3. `test/pipeline_trace_graph_test.dart`: 미선택 시 active/highlight가 비는지 검증을 추가하고, 호출부에서 `traces`를 뺀다.

## 유지할 것
- 골격(`pipelineSkeletonEdges`) 항상 표시
- 선택 시 `pipelinePathEdges(selected)` path 활성·점프 규칙
- `pipelineEdgeIsLive`, 노드/단계 visual 미선택 집계
- 목록 `didSelectTrace` / GetTrace

## 이번 작업에서 만들지 않음
- 미선택 시 자동 선택·RUNNING 대표 path
- 노드 visual 집계 규칙 변경
- UI 레이아웃·노드 탭 스트립 변경

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
- `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- 미선택: 활성 path 선 없음(골격만)
- 목록에서 여정 선택 후: 그 path만 활성
