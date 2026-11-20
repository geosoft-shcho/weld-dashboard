# PipelineTrace 아이콘 단계 상태 애니메이션·인터랙션

## 목표

CI/CD 수평 흐름 구조에서 **아이콘 단계**가 진행 흐름 상태(idle 대기 / running 진행 / done 완료 / error 오류 / warning)에 따라 뚜렷한 애니메이션을 보이고, 사용자 **클릭 인터랙션**에 반응하도록 보강한다. 모두 기존 material 구동 JS(`pipelineO3dApplyStatusJs`)에서 처리한다.

## 바꿀 것

1. `pipeline_o3d_full_bridge.dart`
   - 흐름 순서 `pipelineO3dStageOrder` 추가, 페이로드에 `o`(순서) 포함
   - `pipelineO3dApplyStatusJs` 보강:
     - running: 아이콘 강한 심장박동 + 색 시머, 파이프는 흐름 방향 광띠(좌→우 위상)
     - done: 밝게 정착 + 은은한 숨쉬기(아이콘 더 밝게)
     - error: 긴급 적색 스트로브(아이콘 강조)
     - idle: 대기 아이콘은 꺼지지 않고 느린 미세 글로우
     - 클릭(pointerdown): 파이프라인을 따라 번지는 흐름 스윕(ripple) 인터랙션
2. `pipeline_trace_graph_o3d_view.dart` 헤더 힌트에 "클릭=흐름 스윕" 추가

## 유지할 것

- `stage__*` / `node__*` / `pipe__*` / `mat__*` 분리 계약, Trace 실시간 연동
- GLB 지오메트리(수평 CI/CD 구조) 그대로, JS만 보강

## 이번 작업에서 만들지 않음

- GLB 재생성, 새 Provider, 노드 피킹(개별 아이콘 레이캐스트), Hotspot UI

## 복잡한 코드 제거 및 금지

- 새 추상 계층·전략·팩토리·제네릭 헬퍼 금지. 기존 JS 경로에만 더한다.
- 모드 플래그 조합으로 경우를 늘리지 않는다.
- 새 상태관리·디자인 시스템·카드 UI 금지.
- 범위 밖 리팩터·이름 정리 금지.

## 완료 확인

- `./scripts/agent_check.sh` 통과
- 아이콘이 상태별로 또렷이 애니메이션(대기 미세 글로우 / 진행 박동 / 완료 정착 / 오류 스트로브)
- 뷰 클릭 시 좌→우 흐름 스윕이 번짐
