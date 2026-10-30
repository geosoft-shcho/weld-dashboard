# 녹화 클립 playhead 배치

## 목표
카메라 녹화 파일을 업로드해 타임라인 클립으로 넣을 때, 클립 시작이 현재 playhead 위치에 오도록 한다. 서버가 다른 트랙에 먼저 둔 클립을 녹화 트랙으로 옮길 때도 동일하다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`didPlaceUploadedRecording`, `playheadSeconds`, `updateTimelineClip`, `createTimelineClip`)
4. `docs/2026-10-30/녹화업로드_녹화트랙클립보장_프롬프트.md` (트랙 보장 규칙 유지)
5. `test/ask_question_test.dart` (녹화 배치 테스트)
6. 없음

## 현재 상태
- 신규 CreateClip: `startSeconds = playheadSeconds`(음수면 0), duration 있으면 그 길이, 없으면 5초.
- 다른 트랙에 이미 있는 클립 이동: `updateTimelineClip(clipId, trackId)`만 호출해 **시각은 서버 배치값 유지**.
- 이미 녹화 트랙에 있으면 return(위치 변경 없음).

## 바꿀 것
1. `didPlaceUploadedRecording`에서 playhead 기준 구간(startNs/endNs, source 0..duration 또는 빈 source, 5초 폴백) 계산을 한곳에서 쓰게 한다. 신규 생성과 이동에 같은 값을 쓴다.
2. 다른 트랙 → 녹화 트랙 이동 시 `updateTimelineClip`에 `trackId`와 함께 `startNs`/`endNs`를 넘긴다. (source는 UpdateClip API에 없으면 타임라인 구간만 playhead로 맞춘다. UpdateClip이 source를 받으면 유지·맞춤은 기존 create와 같게 한다.)
3. 이미 녹화 트랙에 같은 asset 클립이 있어도, 시작이 playhead와 다르면 playhead 구간으로 `updateTimelineClip`한다. 같으면 no-op.
4. 구간 계산·이동·생성 실패 시 기존처럼 `JobTimelineException` throw.
5. 테스트: 이동 케이스에서 playhead≠0이면 이동 후 start/end가 playhead 기준인지 확인. 신규 생성 테스트(playhead 0)는 유지.

## 유지할 것
- `녹화 영상`/`녹화 음성` 트랙 보장·이동 규칙
- 업로드·postprocess·`onRecordingPlaced` 연결
- 수동 드롭 배치 로직

## 이번 작업에서 만들지 않음
- `recorded_at` 기준 배치로 되돌리기
- 서버 자동 배치 변경
- pass_profile 스코프 연결
- playhead UI 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 신규 클립이 playhead에서 시작한다.
- video/audio에 있던 클립을 녹화 트랙으로 옮겨도 playhead에서 시작한다.
- 이미 녹화 트랙에 있어도 playhead와 어긋나면 playhead로 맞춘다.
- 관련 단위 테스트가 통과한다.
