# PipelineTrace pipeline 아이소메트릭 입체 배치

## 목표

7 Stage·20 Node를 한 열/좌→우 일렬이 아니라, 중앙 데이터 흐름 기준 **입체 배치**로 `pipeline.glb`를 재구성한다. 카메라는 아이소메트릭. 흐름 상태는 **해당 Stage**에만 표시한다(노드 칩은 Flutter).

## 공간 배치

| 위치 | 오브젝트 | Stage 매핑 |
|------|----------|------------|
| 왼쪽 앞 | 모니터 | collect (+ receive 위성) |
| 중앙 왼쪽 위 | 초록 네트워크 | embed (+ tool 일부) |
| 중앙 오른쪽 | 보라 체인(세로) | postprocess (+ tool) |
| 오른쪽 뒤 | DB 원통 | register (+ done) |
| 바닥 | 곡선·분기 파이프 | Stage 연결 |

핵심: 높이 차등, 바닥 근처 곡선 튜브, 처리 오브젝트는 수직 상승, 카메라는 비스듬 위.

## 먼저 읽을 것

1. `scripts/generate_pipeline_full_glb.mjs`
2. `pipeline_trace_graph_o3d_view.dart`
3. `pipeline_o3d_full_bridge.dart`
4. `pipeline_status_mapper.dart`

## 바꿀 것

1. `generate_pipeline_full_glb.mjs` — 입체 배치·바닥 파이프·높이 차 · `pipeline.glb` 재생성
2. `pipeline_trace_graph_o3d_view.dart` — 아이소메트릭 카메라, Stage 상태→`mat__stage_*` JS 반영
3. bridge에 Stage 상태 페이로드 추가(노드 전량 불필요)

## 유지할 것

- O3D 단일 GLB MVP 컨트롤(play/rotate/preset)
- Flutter Stage/노드 칩
- 2D·Three

## 이번 작업에서 만들지 않음

- Blender 수동 파일
- 노드마다 독립 클립 애니

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
- O3D에서 입체 배치·아이소 카메라·Stage 상태색
