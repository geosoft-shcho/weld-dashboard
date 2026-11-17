# 타임라인 툴바 editTools·트랙 메뉴 파일 분리

## 목표
`timeline_board_toolbar.dart`에서 트랙 편집 줄(`_editTools`)과 트랙 목록 메뉴(`TimelineBoardTrackMenu`)를 책임별 형제 위젯 파일로 나눠 관리한다. 동작·문구는 바꾸지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `timeline_board_toolbar.dart`
4. `multimodal_timeline_board.dart` (TrackMenu import)

## 현재 상태
한 파일에 클립 툴바·`_editTools`·관계 배너·`ToolButton`/`ToolGroup`·`TimelineBoardTrackMenu`가 섞여 있다.

## 바꿀 것
1. `timeline_board_edit_tools.dart` — `TimelineBoardEditTools`
2. `timeline_board_track_menu.dart` — `TimelineBoardTrackMenu` 이동
3. `timeline_board_toolbar.dart` — EditTools 조립, TrackMenu 제거
4. `multimodal_timeline_board.dart` — track_menu import

## 유지할 것
- 트랙 목록 버튼·전체/개별 체크·dim
- `TimelineBoardToolbar` 생성자 인자
- Marker/Labels 위치

## 이번 작업에서 만들지 않음
- part/part of
- ViewModel·동작 변경
- Marker/Labels를 트랙 메뉴 파일로 옮기기
- 새 Coordinator·상태관리

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
- 트랙 추가/수정/삭제·트랙 목록 메뉴·전체 체크 동작 동일
- 새 파일이 `widgets/` 아래에만 추가됨
