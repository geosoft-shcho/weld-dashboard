# CollectionCommandBar 폭 맞춤 · 반응형 줄바꿈

## 목표
`CollectionCommandBar`는 기본 1줄(`Row` + `Expanded` 비율)로 두고, 크롬 창 너비가 줄어 필드 최소 폭을 못 채우면 `Wrap`으로 줄바꿈한다.

## 먼저 읽을 것
- `collection_command_bar.dart`
- `command_bar_widget_item.dart`

## 바꿀 것
1. `LayoutBuilder`로 가용 폭을 받는다.
2. 넓을 때: 필드는 `Expanded(flex: …)`, 버튼(조회·초기화·새로고침)은 intrinsic 폭 유지한 1줄 `Row`.
3. 좁을 때(`maxWidth < 필드최소폭×개수 + 버튼 예약`): `Wrap`으로 필드를 균등 폭으로 배치하고 버튼은 끝에 붙인다.
4. Fluent `CommandBar` wrap에 묶이지 않으면 `Row`/`Wrap`으로 단순화한다(새 디자인 시스템 도입 금지).

## 유지할 것
- 필드 종류·콜백·InfoLabel 구조

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
- 넓을 때 1줄, 좁을 때 줄바꿈
