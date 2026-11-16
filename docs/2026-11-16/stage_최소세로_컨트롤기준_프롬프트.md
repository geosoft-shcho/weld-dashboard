# stage 최소 세로 (컨트롤 ellipsis 기준)

## 목표
타임라인 세로 드래그 시 stage가 데스크탑 컨트롤 시간 문구가 ellipsis 없이 필요한 가로만큼은 세로로 남게 한다.

## 바꿀 것
1. `MultimodalDesktopControls`: play·mute·시간(`00:00 / 00:00`)·fullscreen·패딩 합을 `minExtentWithoutTimeEllipsis`로 둔다.
2. `_StageBoardHost`: `maxHeight - 100` 대신 그 상수로 stage 최소 세로를 확보한 뒤 타임라인 `maxHeight`를 잡는다.
3. ViewModel에 `MIN_STAGE_HEIGHT`로 같은 값을 두어 드래그/레이아웃이 같은 기준을 쓴다.

## 유지할 것
- 컨트롤 Row의 Flexible ellipsis(가로가 더 좁을 때 안전망)
- MIN/MAX 타임라인 높이

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
- 타임라인 최대 확장 후에도 stage 세로 ≥ 기준값
