# PipelineTrace pipeline CI/CD 수평 흐름 구조

## 목표

CI/CD 파이프라인 다이어그램(가로 백본 라인 + 단계 아이콘 + 라인 위 흐름 점 + CI/CD 그룹)을 참고해, `pipeline.glb`를 **수평 흐름 구조**로 재구성한다. 각 Stage의 흐름 상태(idle / 진행 점멸 / 완료 / 오류)가 아이콘·백본·노드 점에 명시적으로 나타나게 한다. 연결선(pipe)은 Node와 분리한다.

## 레퍼런스 구성

- 가로 보라 백본 라인이 화면을 가로지른다(좌→우 흐름).
- 각 Stage는 라인 위로 뻗은 수직 스텁으로 연결된 **아이콘**으로 표현한다.
  - collect=터미널(코드), receive=커밋 원, register=DB, postprocess=테스트 튜브, tool=렌치, embed=리뷰 돋보기, done=로켓
- 라인 위의 작은 점들 = 흐름 노드(주황/보라).
- 앞쪽 그룹(수집·처리)과 뒤쪽 그룹(배포·완료)을 얇은 점선형 프레임으로 묶는다(장식, 상태 미연동).
- 카메라는 거의 정면(수평) 구도로 백본이 가로로 보이게 한다.

## 먼저 읽을 것

1. 레퍼런스 CI/CD 이미지
2. `scripts/generate_pipeline_full_glb.mjs`
3. `pipeline_o3d_full_bridge.dart`, `pipeline_trace_graph_o3d_view.dart`

## 바꿀 것

1. `generate_pipeline_full_glb.mjs` + `pipeline.glb` — 수평 백본, 아이콘 Stage, 라인 위 노드 점, 수직 스텁 branch, CI/CD 프레임
2. `pipeline_trace_graph_o3d_view.dart` 카메라 프리셋을 정면 수평 구도로
3. `pipeline_o3d_full_bridge.dart` 메인 세그먼트 맵을 새 흐름 순서로 소량 수정

## 유지할 것

- `stage__*` / `node__*` / `mat__*` / `pipe__*` 분리 계약, Trace 상태 연동(상태별 점멸·발광)
- o3d 단일 뷰, 2D 모드, 상태 적용 JS(`pipelineO3dApplyStatusJs`)

## 이번 작업에서 만들지 않음

- Blender 수동 파일, Hotspot UI, 새 Provider, 텍스트 라벨(헤더 상태 텍스트로 대체)

## 복잡한 코드 제거 및 금지

- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯·ViewModel·UseCase가 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기·플래그·래퍼·죽은 코드는 제거한다.
- 모드 플래그 조합으로 경우를 늘리지 않는다.
- 새 상태관리·디자인 시스템·카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖 리팩터·이름 정리·스타일 통일을 끼워 넣지 않는다.

## 완료 확인

- `./scripts/agent_check.sh` 통과
- O3D에서 가로 백본·아이콘 단계·흐름 점·CI/CD 그룹이 레퍼런스에 근접
- 단계 상태가 아이콘·백본·노드 점에 명시적으로 반영(점멸/완료/오류)
