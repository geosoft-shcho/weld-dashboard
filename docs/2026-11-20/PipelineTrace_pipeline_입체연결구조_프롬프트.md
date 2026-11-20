# PipelineTrace pipeline 입체 연결 구조

## 목표

첨부 이미지와 같이 **중앙 메인 파이프(백본) + 좌우 Stage 분기** 입체 연결을 `pipeline.glb`에 재배치한다. **연결선(pipe)은 Node와 완전 별도 메시·머티리얼**로 두어 Node 상태와 무관하게 디자인을 바꾸고, 이후 흐름 애니를 붙이기 쉽게 한다.

## 추천방안 (적용)

- 연결선 = Node와 별개 오브젝트 (`pipe__*`, `mat__pipe__*`)
- 메인 백본(굵은 관 + 커플링)과 Stage→백본 분기 튜브를 분리
- Stage 내부 노드 간 가는 로컬 연결도 별도 메시

## 먼저 읽을 것

1. 첨부 레퍼런스 이미지(아이소·중앙 고속도로·분기)
2. `scripts/generate_pipeline_full_glb.mjs`
3. `pipeline_o3d_full_bridge.dart`
4. `pipeline_trace_graph_o3d_view.dart`

## 바꿀 것

1. `generate_pipeline_full_glb.mjs` + `pipeline.glb` — 대각 백본·분기·로컬 파이프(노드 비포함), Stage/Node 이름 유지
2. `pipeline_o3d_full_bridge.dart` — pipe 맵을 백본/분기 계약에 맞춤, 상태 애니 유지
3. 필요 시 카메라 프리셋(백본이 프레임 중앙 대각)

## 유지할 것

- o3d 단일 뷰, ViewModel Trace 연동, 2D 모드

## 이번 작업에서 만들지 않음

- Blender 원본 파일, Hotspot UI, 새 Provider

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
- GLB에 `pipe__main_*` / `pipe__branch_*`가 `node__*`와 분리
- O3D에서 백본·분기 입체 구조 확인
