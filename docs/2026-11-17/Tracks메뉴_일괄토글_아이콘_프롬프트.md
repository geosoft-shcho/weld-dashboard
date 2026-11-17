# Tracks 메뉴 일괄 토글 아이콘

## 목표
Tracks 메뉴의 `전체 켜기` / `전체 끄기`를 텍스트 버튼 대신 아이콘(+Tooltip)으로 보이게 한다. 동작은 그대로다.

## 먼저 읽을 것
1. `timeline_board_toolbar.dart` `TimelineBoardTrackMenu`
2. 라벨 원형 버튼 톤(`timeline_board_track_labels.dart`)

## 현재 상태
- 메뉴 상단에 `TimelineBoardToolButton('전체 켜기'/'전체 끄기')` 텍스트 버튼이 있다.

## 바꿀 것
1. 텍스트 버튼을 Tooltip + 아이콘 버튼으로 교체한다.
   - 전체 켜기: `Icons.done_all` (또는 check 계열)
   - 전체 끄기: `Icons.remove_done` (또는 unchecked 계열)
2. 메뉴 최소 폭을 아이콘 줄에 맞게 조정한다.

## 유지할 것
- `didTapEnableAllTracks` / `didTapDisableAllTracks`
- 개별 체크 목록

## 이번 작업에서 만들지 않음
- 새 위젯 파일·추상 계층
- 일괄 토글 동작 변경

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
- 아이콘 호버 시 Tooltip, 탭 시 기존 일괄 토글
