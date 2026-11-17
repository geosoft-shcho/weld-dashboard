# Tracks 메뉴 일괄 토글

## 목표
Tracks 메뉴를 유지하고, 라벨 체크에는 없는 일괄 켜기/끄기를 메뉴에만 둔다. 개별 체크는 지금과 같다(행 유지 + dim).

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `timeline_board_toolbar.dart` `TimelineBoardTrackMenu`
4. `video_multimodal_view_model.dart` `didTapToggleTrackVisibility` / `_hiddenTrackIds`

## 현재 상태
- Tracks 메뉴·라벨 체크 모두 개별 `didTapToggleTrackVisibility`만 있다.
- 비활성은 행 유지 + dim(`isEnabled`)이다.

## 바꿀 것
1. ViewModel: `didTapEnableAllTracks()`, `didTapDisableAllTracks()` 추가 후 `notifyListeners()`.
2. `TimelineBoardTrackMenu` 목록 위에 `전체 켜기` / `전체 끄기` 버튼 추가.
3. 개별 체크·라벨·보드 dim은 유지.

## 유지할 것
- 라벨 체크, `isEnabled` dim UI
- Tracks 버튼·오버레이 열기/닫기
- mute/모니터/차트

## 이번 작업에서 만들지 않음
- 전체 반전, 필터/검색
- ViewModel rename
- 라벨 쪽 일괄 버튼
- 새 추상 계층

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
- Tracks에서 전체 끄기 → 모든 행 unchecked+dim / 전체 켜기 → 전부 활성
- 개별 체크는 기존과 동일
