# openTimeline GetTimeline 인라인

## 목표
`openTimeline` 본문에서 Compose GetTimeline 호출이 바로 보이도록 `_loadTimelineBlocking`을 인라인하고 헬퍼를 제거한다. 블로킹→보드→백그라운드 순서는 유지한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `openTimeline`, `_loadTimelineBlocking`
4. 없음

## 현재 상태
- `openTimeline`이 `_loadTimelineBlocking`을 await한 뒤 `_isLoading=false`로 보드를 그리고, ListAssets·Labels·ListRuns는 백그라운드 `Future.wait`로 돌린다.
- `_loadTimelineBlocking`이 `_getJobTimelineUseCase.execute`로 GetTimeline을 호출한다.

## 바꿀 것
1. `_loadTimelineBlocking`의 try/catch·로그·`_timeline`/`_workName`/`_hasError` 처리를 `openTimeline` 안으로 옮긴다.
2. `_loadTimelineBlocking` 메서드를 삭제한다.
3. 성공 시 기존처럼 `_isLoading=false` + notify 후 백그라운드, 실패·빈 jobId 조기 return 흐름은 그대로 둔다.

## 유지할 것
- GetTimeline 블로킹 후 첫 페인트, 이후 백그라운드 병렬
- MM-LOAD step/stepDone phase=blocking 로그
- `GetJobTimelineUseCase` 경유 호출
- 화면·다른 로드 함수

## 이번 작업에서 만들지 않음
- GetTimeline과 ListAssets 등을 병렬로 합치기
- UseCase/Repository/로그 클래스 변경
- ViewModel 파일 분리·이름 정리

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- 관련 테스트가 있으면 `./scripts/agent_check.sh <test 경로…>` 통과
- `openTimeline`에 GetTimeline 호출이 직접 보이고 `_loadTimelineBlocking`이 없다
- 진입 시 GetTimeline 후 blocking_done, 이후 background 동작 유지
