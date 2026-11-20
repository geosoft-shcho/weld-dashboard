# PipelineTrace o3d 상태 애니 보강

## 목표

Stage 노드·연결관(pipe)이 idle/running/done/error(/warning)에 따라 사용자가 바로 구분할 수 있게 색 대비와 점멸·발광 애니메이션을 강화한다.

## 먼저 읽을 것

1. `pipeline_o3d_full_bridge.dart`
2. `pipeline_trace_graph_o3d_view.dart`

## 바꿀 것

1. `pipeline_o3d_full_bridge.dart` — 상태별 RGBA/emissive 대비 강화, JS 적용 루프에서 running/error/pipe 점멸·발광 패턴 강화

## 유지할 것

- ViewModel 연동·페이로드 구조·GLB 이름 계약

## 이번 작업에서 만들지 않음

- GLB 재생성, Hotspot UI, 새 Provider

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
- running 점멸·done 고정 발광·error 적색 점멸·pipe 흐름 발광이 구분됨
