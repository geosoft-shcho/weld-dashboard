# [POSE] 디버그 로그 분리

## 목표
`video_multimodal_view_model.dart`의 `[POSE]` `debugPrint`를 `playhead_covering_log.dart`와 같은 전용 클래스로 분리한다. 로그 문구는 유지하고 ViewModel은 호출만 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `playhead_covering_log.dart`
3. ViewModel `_startPosePlayback` · `_failPose` · `_loadClipDetail` 포즈 실패 분기
4. 계약·화면안: 없음

## 현재 상태
- `[POSE]`는 ViewModel 안에 `debugPrint`로 흩어져 있다(시작·타깃·비겹침·로딩·stale·loaded·overlay ready·draw source·failed).
- `[PLAYHEAD]`는 이미 `PlayheadCoveringLog` + `print`로 분리됨.

## 바꿀 것
1. `lib/src/presentation/features/video_multimodal/pose_playback_log.dart` 추가.
   - 클래스 `PosePlaybackLog`.
   - `print` 사용(`debugPrint` 쓰로틀 회피, Playhead와 동일). `// ignore: avoid_print`.
   - 메서드: `begin` / `target` / `alignToVideoStart` / `loadingContent` / `staleIgnored` / `contentLoaded` / `overlayReady` / `drawSource` / `failed`.
2. ViewModel에 `final PosePlaybackLog _posePlaybackLog = PosePlaybackLog();`를 두고 위 호출로 교체.
3. `_failPose`와 `_loadClipDetail` 포즈 실패도 `_posePlaybackLog.failed(...)` 사용.

## 유지할 것
- 포즈 재생·ensure·캐시 동작
- `[POSE]` 접두·필드 문자열
- PlayheadCoveringLog·MM-LOAD
- `login_screen.dart` 비커밋

## 이번 작업에서 만들지 않음
- PLAYHEAD/MM-LOAD 추가 리팩터
- 로그 레벨·원격 수집
- 포즈 재생 로직 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `dart analyze` on `video_multimodal`
- ViewModel에 `[POSE]` `debugPrint` 잔존 없음
- `test/job_timeline_edit_test.dart` 포즈 관련 통과
