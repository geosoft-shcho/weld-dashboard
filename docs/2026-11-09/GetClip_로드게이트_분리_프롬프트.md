# GetClip 로드 게이트 분리

## 목표
GetClip 네트워크 동시 1개·연타 시 최신 pending만 ViewModel에서 빼 `ClipDetailLoadGate`로 두고, 캐시·UI·apply는 ViewModel에 남긴다.

## 바꿀 것
1. `clip_detail_load_gate.dart`에 busy + pending latest-wins만 둔다.
2. ViewModel은 게이트로 tryBegin / takePending / end / clearPending만 쓴다.
3. 빈 `if (_clipDetail?.isPose == true) {}` 잔여를 제거한다.

## 유지할 것
- ClipDetailCache, `_fetchClipDetailNetwork`, `_applyLoadedClipDetail`, selectedClipId 가드

## 이번 작업에서 만들지 않음
- 제네릭 큐·전략·Coordinator로 apply까지 이사

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
- GetClip 동시 1·최신 pending 동작 유지
