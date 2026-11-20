# PipelineTrace pipeline 상태 시각화 재구현

## 목표

구현 순서에 따라 `pipeline.glb`를 재구성하고(바닥·모니터·네트워크·체인·DB·곡선 발광 튜브·7 Stage·20 Node 이름), o3d로 표시한 뒤 기존 ViewModel(Trace) 상태에 따라 **개별 Node 재질**이 바뀌게 한다.

## 구현 순서 (이번 범위)

1. 절차적 GLB(Blender 대체): 바닥·모니터·네트워크·체인·DB + Stage 대표 오브젝트·곡선 튜브(emissive)
2. GLB 내부 이름: `stage__{id}`, `node__{key}`, `mat__stage_*`, `mat__{key}`, `pipe_*`
3. o3d 표시 + 아이소 카메라 구도
4. 기존 Provider ViewModel ↔ Trace 상태 → Node 재질 JS 제어

## 먼저 읽을 것

1. `scripts/generate_pipeline_full_glb.mjs`
2. `pipeline_trace_graph_o3d_view.dart`
3. `pipeline_o3d_full_bridge.dart`
4. `pipeline_status_mapper.dart`
5. `pipeline_trace_view_model.dart`

## 바꿀 것

1. `generate_pipeline_full_glb.mjs` + `pipeline.glb` 재생성
2. `pipeline_o3d_full_bridge.dart` — Node(+Stage) 상태 페이로드
3. `pipeline_trace_graph_o3d_view.dart` — 카메라 구도, Node 상태 동기화

## 유지할 것

- 2D 모드, ViewModel/TraceService 기존 연결, o3d 단일 뷰

## 이번 작업에서 만들지 않음

- 실제 Blender 파일, 새 Provider, Hotspot UI 전면

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
- O3D에서 상태 변화 시 노드/스테이지 색·발광 반영
