# 타임라인 트랙 체크 → 비활성 UI (행 유지)

## 목표
타임라인 라벨 체크박스를 해제해도 트랙 행이 사라지지 않는다. Tracks 메뉴와 동일한 `didTapToggleTrackVisibility`로 체크만 바뀌고, 보드·라벨은 disable(dim) UI만 적용한다. Tracks 메뉴에서도 같은 의미로 보드에 행이 남는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/timeline_board_helpers.dart` `buildTimelineBoardRows`
4. `lib/src/presentation/features/video_multimodal/widgets/timeline_board_track_labels.dart`
5. `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_board.dart` `_track`
6. `lib/src/presentation/features/video_multimodal/widgets/timeline_board_toolbar.dart` Tracks 메뉴 체크

## 현재 상태
- Tracks 메뉴·라벨 체크 모두 `didTapToggleTrackVisibility` → `_hiddenTrackIds` / `isTrackVisible`.
- `buildTimelineBoardRows`가 `!isTrackVisible`이면 `continue`로 행 자체를 빼서 타임라인에서 사라짐.
- 라벨 체크 아이콘은 항상 `Icons.check_box`(숨긴 트랙은 목록에 없어 unchecked가 안 보임).
- `isTrackVisible`은 보드/메뉴 UI에만 쓰임(재생 mute와 무관).

## 바꿀 것
1. `buildTimelineBoardRows`: 숨김 트랙 `continue` 제거. 모든 `timelineTracks`를 행으로 만든다.
2. `TimelineBoardRow`: `isEnabled`(`=isTrackVisible`) 필드 추가해 라벨·트랙 위젯에 전달.
3. `timeline_board_track_labels.dart`:
   - 체크 아이콘: enabled → `check_box`, disabled → `check_box_outline_blank`.
   - Tooltip: 켜짐 `트랙 끄기`, 꺼짐 `트랙 켜기`.
   - disabled일 때 라벨 행 본문은 낮은 opacity; 체크 제스처는 계속 동작.
4. `multimodal_timeline_board.dart` `_track`:
   - disabled면 클립/포즈 영역을 `Opacity`(약 0.4) + `IgnorePointer`로 비활성 표시.
   - 서버 트랙 `DragTarget`은 disabled일 때 받지 않음.
5. ViewModel API 이름(`isTrackVisible` / `didTapToggleTrackVisibility`)은 유지. `_stageBoardKey`의 숨김 id 항목은 유지.

## 유지할 것
- Tracks 메뉴 목록·체크 토글 콜백
- mute/모니터/차트 토글 API
- 스크롤 동기·룰러·편집 State

## 이번 작업에서 만들지 않음
- ViewModel 필드 rename (`hidden`→`disabled`)
- 재생/모니터 파이프라인 변경
- 새 추상 계층·디자인 시스템

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
- 타임라인·Tracks 메뉴에서 체크 해제 → 행 유지, unchecked + dim
- 다시 체크 → 정상 활성 UI·클립 조작 가능
