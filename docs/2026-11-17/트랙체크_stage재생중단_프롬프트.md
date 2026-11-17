# 트랙 체크 끄기 시 stage 영상·음성 재생 중단

## 목표
타임라인 트랙 체크를 끄면(행 dim), 그 시각에 stage에 올라가던 **해당 트랙의 영상·음성**은 covering에서 제외되어 재생되지 않는다. 다시 켜면 기존 covering 규칙으로 재생된다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `_activeVideoClip` / `_coveringVideoOnTrack` / `_coveringAudioAt` / `didTapToggleTrackVisibility`
4. `docs/2026-11-17/트랙_체크_비활성UI_프롬프트.md` (당시 재생 파이프라인은 범위 밖이었음)

## 현재 상태
- `_hiddenTrackIds` / `isTrackVisible`는 보드·라벨 dim·`_stageBoardKey`에만 쓰임.
- `_coveringVideoOnTrack`·`_coveringAudioAt`·`_activeVideoClip`의 `_playbackVideoClip`/`_retainedStageVideoClip`은 **숨김 트랙을 거르지 않음** → 체크 꺼도 stage가 그 트랙 영상·음성을 재생할 수 있음.

## 바꿀 것
파일: `video_multimodal_view_model.dart`만.

1. `_coveringVideoOnTrack`: `!isTrackVisible(trackId)`이면 즉시 `null`.
2. `_coveringAudioAt`: `!isTrackVisible(clip.trackId)`인 클립은 covering 후보에서 제외.
3. `_activeVideoClip`: `_playbackVideoClip` / `_retainedStageVideoClip`을 쓸 때도 해당 `trackId`가 visible일 때만 반환.
4. `didTapToggleTrackVisibility` / `didTapEnableAllTracks` / `didTapDisableAllTracks` / `didTapToggleAllTracks`(있으면): `_coveringVideoClipId = ''` 후 `notifyListeners` (기존과 같이). stage 키에 숨김 id가 이미 있어 rebuild는 됨.

가정: 모니터 칸도 숨긴 트랙이면 covering null → 재생 안 함. mute API·모니터 목록 자체는 바꾸지 않음.

## 유지할 것
- 체크 UI(행 유지·dim)·Tracks 메뉴 토글 API 이름
- mute(`_mutedTrackIds`)와 체크(`_hiddenTrackIds`) 분리
- stage 위젯·보드 라벨 구조

## 이번 작업에서 만들지 않음
- 숨김 시 모니터 목록에서 자동 제거
- ViewModel 필드 rename
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
- 영상 트랙 체크 끄기 → 그 시각 stage에서 해당 영상 재생 안 됨(배너/빈 칸)
- 음성만 덮는 트랙 체크 끄기 → covering audio URL 비어 재생 안 됨
- 다시 체크 → covering 규칙대로 재생 가능
