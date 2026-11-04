# ViewModel `_logPlayheadCovering` 제거

## 목표
`video_multimodal_view_model.dart`에서 playhead covering 디버그 로그 호출을 없앤다. `playhead_covering_log.dart`의 `PlayheadCoveringLog` 클래스는 삭제하지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `video_multimodal_view_model.dart` (`_logPlayheadCovering`, `_playheadCoveringLog`, seek/play/tick 호출)
4. 없음

## 현재 상태
- ViewModel이 `playhead_covering_log.dart`를 import하고 `_playheadCoveringLog` 필드를 둔다.
- `didSeekToSeconds` / `didTapTogglePlayback` / `_syncCoveringSeek`에서 `_logPlayheadCovering`을 호출한다.
- `_logPlayheadCovering`이 `PlayheadCoveringLog.log`로 출력한다.
- `PlayheadCoveringLog` 파일은 다른 참조가 없다(ViewModel만 사용).

## 바꿀 것
1. `video_multimodal_view_model.dart`에서만 제거:
   - `import 'playhead_covering_log.dart';`
   - `final PlayheadCoveringLog _playheadCoveringLog = ...`
   - `_logPlayheadCovering(...)` 호출 5곳 (seek / pause / play / covering_changed / tick)
   - `_logPlayheadCovering` 메서드 본체
2. seek·재생·covering seek 동작(`_seekToken` 등)은 그대로 둔다.

## 유지할 것
- `lib/src/presentation/features/video_multimodal/playhead_covering_log.dart` 파일 전체
- playhead clock / covering seek / 재생 로직

## 이번 작업에서 만들지 않음
- `PlayheadCoveringLog` 삭제·다른 파일로 이전
- 다른 디버그 로그 정리
- 테스트 추가(기존 호출만 제거)

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` (관련 경로 analyze; 기존 warning만이면 OK)
- ViewModel에 `_logPlayheadCovering` / `_playheadCoveringLog` / `playhead_covering_log` import 없음
- `playhead_covering_log.dart` 파일 존재
