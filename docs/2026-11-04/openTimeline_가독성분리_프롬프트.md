# openTimeline 가독성 리팩터

## 목표
`video_multimodal_view_model.dart` `openTimeline`을 짧게 읽어지게 한다. GetTimeline 블로킹 → 보드 → 백그라운드 순과 MM-LOAD 로그는 그대로다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `openTimeline`
4. 없음

## 현재 상태
- 한 메서드에 초기화·빈 job·GetTimeline try/catch·보드 페인트·`Future.wait`가 섞여 있다.
- `timelineOk` 플래그로 성공을 표시한다.

## 바꿀 것
1. `_fetchGetTimeline(MultimodalLoadApiLog log) → Future<bool>`
   - 현재 try/catch·`_getJobTimelineUseCase.execute`·`_workName`·에러 처리를 옮긴다.
   - 호출부에 `await _fetchGetTimeline(log)`로 GetTimeline이 보이게 한다.
2. `_loadOpenTimelineBackground()`
   - 기존 `Future.wait`(_loadSideAssets / `_ensureLabels` / `_restoreActiveToolRunInBackground`)와 `backgroundDone`을 옮긴다.
3. `openTimeline`은 아래 오케스트레이션만 남긴다.
   - begin / 로딩 리셋 / 빈 job 조기 return
   - `await _fetchGetTimeline` → `_isLoading=false` + notify + `blockingDone`
   - 실패·closed면 end return
   - `await _loadOpenTimelineBackground` 후 `_loadApiLog = null`

빈 job 분기는 짧아서 `openTimeline`에 둔다. 새 파일·추상 계층·UseCase 변경 없음.

## 유지할 것
- Compose GetTimeline 블로킹 후 첫 페인트
- 백그라운드 병렬 세 호출
- MM-LOAD step / blocking_done / background_done
- 화면·DI·다른 로드 경로

## 이번 작업에서 만들지 않음
- GetTimeline과 첨·라벨 병렬화
- ViewModel part 분리·이름 대정리
- 테스트/로그 클래스 개편

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
- `openTimeline`이 오케스트레이션만 하고 `_fetchGetTimeline` / `_loadOpenTimelineBackground`가 있다
- 진입 시 GetTimeline 후 보드, 이후 백그라운드 동작 동일
