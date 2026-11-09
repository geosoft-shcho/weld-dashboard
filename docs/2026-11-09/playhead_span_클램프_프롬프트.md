# playhead를 타임라인 span에 맞춤

## 목표
보드 시계가 GetTimeline 클립 span(예: ~44초 → `0:00:44`) 기준으로 보이게 한다. `256:58:48`처럼 이전 세션에서 남은 playhead가 span 밖으로 표시되지 않게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart`
4. `lib/src/presentation/features/video_multimodal/timeline_playhead_clock.dart`
5. 계약·화면안: 없음

## 현재 상태
- `formatPlayheadClock`의 86400 clamp 제거 후, playhead가 ~925128초면 `256:58:48`로 보임
- `_fetchGetTimeline` / `_replaceTimelineFromServer` 성공 후에도 playhead를 `spanSeconds`에 clamp하지 않음
- 녹화 배치 `_recordingClipRangeAtPlayhead`가 clamp되지 않은 playhead에 클립을 둘 수 있음

## 바꿀 것
1. `_fetchGetTimeline`·`_replaceTimelineFromServer` 성공 직후 `_playhead.clampToSpan(spanSeconds)` 호출
2. `_recordingClipRangeAtPlayhead`에서 start를 `playheadSeconds.clamp(0, spanSeconds)`로 둠(span이 비면 0)
3. 단위 테스트 또는 기존 span 테스트에 “clamp 후 라벨이 span 안” 정도만 보강(가능하면 ViewModel 없이 clock 테스트)

## 유지할 것
- `formatPlayheadClock` 무클램프 H:MM:SS
- `spanSeconds`의 assetDur 보강
- GetTimeline 매핑

## 이번 작업에서 만들지 않음
- 서버 클립 절대좌표 정리 배치, 눈금 painter 개편

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
- 타임라인 로드·저장 후 playhead가 span 안으로 들어감
- ~44초 타임라인에서 `256:58:48` playhead 잔상이 없음
