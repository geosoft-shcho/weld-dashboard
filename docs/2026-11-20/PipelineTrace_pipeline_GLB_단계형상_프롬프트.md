# PipelineTrace pipeline.glb 단계별 형상

## 목표

`pipeline.glb`의 통일 큐브 노드를 제거하고, 7 Stage 각각에 맞는 아이콘·형상(모니터·수신함·DB·기어·도구·임베딩망·서버)으로 20 Node를 배치한다. MVP 카메라·전체 애니·Flutter 칩은 유지한다.

## 먼저 읽을 것

1. `README.md` 목적 절
2. `scripts/generate_pipeline_full_glb.mjs`
3. `scripts/generate_pipeline_kit_glbs.mjs`
4. `docs/2026-11-20/PipelineTrace_o3d_pipeline_MVP_프롬프트.md`

## 현재 상태

- `pipeline.glb`: 모든 노드가 동일 BoxGeometry 큐브
- kit 개별 GLB에는 단계별 형상이 이미 있음

## 바꿀 것

1. `scripts/generate_pipeline_full_glb.mjs` — 단계별 kit 형상 + 노드용 아이콘 텍스처 평면, `mat__{node}` 유지, `pipeline.glb` 재생성
2. Dart UI는 에셋 경로 유지(`pipeline.glb`) — 뷰 로직 변경 최소화

## 유지할 것

- 메시/머티리얼 이름 계약 `node__*` / `mat__*`
- O3D MVP 카메라·애니 제어
- 2D·Three

## 이번 작업에서 만들지 않음

- Trace→노드 재질 Phase 2
- 유료/외부 이미지 에셋 다운로드
- kit 7파일 삭제

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
- `pipeline.glb`에 단계별 상이한 형상 배치
