# PipelineTrace 2D 그래프 가로 레일 + 상태 접기

## 목표

대분류(`PipelineStageDef` id/label) · 소분류(`nodeIds`)를 **가로 레일**로 배치해 파이프라인 흐름을 좌→우로 읽게 한다. 성공·대기 Stage는 소분류를 **접고**, 실패·진행 Stage는 소분류를 **펼쳐** 문제가 한눈에 보이게 한다.

## 권장 선택

- **2안(가로 레일)을 기본**으로 채택한다. 세로 열 배치는 흐름보다 “표”처럼 보이고, 후처리처럼 소분류가 많은 Stage에서 높이가 커진다.
- **1안의 상태 접기/펼치기를 보강**한다. 완료·대기·스킵은 대분류 캡슐만 두고, 실패·진행·대기열·활성은 소분류 노드를 레일 위에 펼친다. 완료 Stage는 탭으로 수동 펼침 가능.

## 먼저 읽을 것

1. `pipeline_trace_graph_view.dart` — `_CellLayout`, 노드 빌드, `_PipelineFlowPainter`, 줌/팬
2. `pipeline_trace_graph.dart` — `PipelineStageDef`, `pipelineStageVisual`

## 바꿀 것

1. `_CellLayout`을 가로 레일 레이아웃으로 교체(Stage 좌→우, 펼친 Stage의 nodeIds도 좌→우).
2. Stage 시각에 따라 자동 펼침: `failed|running|queued|active` → expand, `done|skipped|idle` → collapse.
3. 접힌 Stage는 대분류 캡슐만 표시. 탭 시 수동 펼침/접기(실패·진행은 강제 펼침 유지).
4. 연결선은 레일 위 연속 앵커(펼친 노드 또는 접힌 캡슐)를 잇는다.
5. 기존 InteractiveViewer 줌·팬 유지.

## 유지할 것

- ViewModel·상태 mapper·포커스 스트립·O3D 경로

## 이번 작업에서 만들지 않음

- 새 상태관리, domain StageDef 구조 변경, O3D 연동

## 복잡한 코드 제거 및 금지

- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 세로 열 `needsScroll`/행 높이 로직은 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 새 상태관리·디자인 시스템·카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖 리팩터·이름 정리·스타일 통일을 끼워 넣지 않는다.

## 완료 확인

- `./scripts/agent_check.sh` 통과
- 그래프가 가로 레일로 흐르고, 완료 Stage는 접히며 실패/진행 Stage는 소분류가 펼쳐진다
- 줌·팬·노드 탭이 동작한다
