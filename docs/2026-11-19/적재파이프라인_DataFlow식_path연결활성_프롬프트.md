# 적재 파이프라인 DataFlow식 path 연결 활성

## 목표
적재 파이프라인 그래프를 DataFlowDiagram과 같은 **절대좌표 노드 + 연결선 캔버스**로 다시 그린다. 모든 이벤트 노드는 기본(골격) 연결선을 갖고, **실제로 들어온 이벤트 path의 연속 쌍만** 연결선을 활성화·흐름 표시한다. 여정마다 path가 다를 수 있으므로 “양끝 도달한 인접선 전부 점등”이 아니라 **path 간선만** 켠다. 예: `receive.* → register.stored → postprocess.props → done.*`이면 그 사이 연결만 활성.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/domain/entities/pipeline_trace_graph.dart`
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
5. `docs/2026-11-19/적재파이프라인_이벤트노드체인_프롬프트.md` (이전안 — 이번 작업이 대체)
6. `test/pipeline_trace_graph_test.dart`

## 현재 상태
- 그래프는 가로 밴드+인접 체인 UI다.
- `pipelineHighlightEdgeKeys`는 양끝 visual이 도달이면 골격 인접선을 모두 강조한다 → 스킵된 구간도 켜져 path와 어긋난다.
- DataFlow식 Stack/Positioned/Bezier/InteractiveViewer 캔버스가 아니다.

## 바꿀 것
1. **도메인**
   - 골격 엣지(`pipelineSkeletonEdges`)는 유지(기본 가이드선).
   - 활성 엣지는 `pipelinePathNodeIds`의 **연속 쌍**(visible 노드만). 스켈레톤 비인접이어도 path 쌍이면 활성(점프 연결).
   - 선택 시: 선택 Trace path만. 미선택: visibleTraces path 합집합.
   - `pipelineHighlightEdgeKeys`를 위 규칙으로 바꾸거나 path 전용 헬퍼로 교체하고 UI·테스트를 맞춘다.
   - live 흐름: 활성 엣지이면서 양끝 중 하나가 live visual.
2. **UI (`pipeline_trace_graph_view.dart`)**
   - DataFlow처럼: 요약 줄 + `InteractiveViewer` + 고정 크기 Stack.
   - 단계=열, 열 안 이벤트=세로 배치(절대 Offset). 단계 큰 원/가로 체인 밴드 제거.
   - CustomPaint(또는 동등): 골격 연결=흐린 베지어, 활성 path 연결=강조+입자.
   - 노드: 원+아이콘+라벨+상태, 탭 시 Trace 선택(현행 취지).
   - AppTheme/Fluent 아이콘/`PipelineNodeVisual` 유지. DataFlow 패키지 이식 없음.
3. **테스트**: path 점프 활성(예: stored→props), 골격만 있는 중간선은 비활성, done 분기 path만 활성.

## 유지할 것
- TabBody(칩·목록·큐), ViewModel·폴링, visibleStages(tool/embed), collect 규칙

## 이번 작업에서 만들지 않음
- notification-mobile-app / DataFlow 위젯 복사
- proto 변경, 새 상태관리·카드 UI
- 그룹 범례·체인 FAB

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- DataFlow식 캔버스(노드 절대배치 + 연결선)로 보인다
- 기본 골격 연결선이 있고, path에 없는 구간은 활성되지 않는다
- path 점프(예: register.stored→postprocess.props)만 활성 표시된다
