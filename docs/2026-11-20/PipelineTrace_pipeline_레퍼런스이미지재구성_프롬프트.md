# PipelineTrace pipeline 레퍼런스 이미지 재구성

## 목표

첨부 레퍼런스(대각 주황 메인 파이프·분기 곡선 튜브·좌우 Stage 클러스터·아이소 구도)에 맞게 `pipeline.glb`를 전면 재구성한다. 연결선은 Node와 별도이며, 곡선 튜브용 발광 스트라이프 텍스처를 적용한다.

## 먼저 읽을 것

1. 레퍼런스 이미지
2. `scripts/generate_pipeline_full_glb.mjs`
3. `pipeline_o3d_full_bridge.dart`

## 바꿀 것

1. `assets/glb/pipeline/tex/` — 파이프·스테이지용 PNG 텍스처 생성
2. `generate_pipeline_full_glb.mjs` — 굵은 주황 백본·필렛 분기·리브/커플링·텍스처·Stage 클러스터 재배치 + `pipeline.glb`
3. 카메라 프리셋·pipe 맵이 새 이름과 맞으면 bridge/뷰 소량 수정

## 유지할 것

- `stage__*` / `node__*` / `mat__*` / `pipe__*` 분리 계약, Trace 상태 연동

## 이번 작업에서 만들지 않음

- Blender 수동 파일, Hotspot

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
- O3D에서 레퍼런스에 가까운 백본·분기·텍스처 확인
