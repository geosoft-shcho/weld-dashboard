# TraceService 새로고침 주기 연동

## 목표
커맨드바 「새로고침 주기」에 맞춰 TraceService(ListTraces/GetTrace) 폴링이 돌게 한다. 별도 Trace 주기 UI는 만들지 않는다.

## 권장(채택)
- **기존 새로고침 주기 유지**: 수집 보드와 Trace가 같은 자동갱신 의미(끔/5초/1분).
- **기존 「새로고침」버튼**으로 보드+Trace 1회 동시 갱신(페이지 수동 갱신).
- Trace 전용 주기 ComboBox는 만들지 않음(컨트롤 중복·혼동).

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `collection_monitoring_view_model.dart` / `pipeline_trace_view_model.dart`
4. `collection_monitoring_screen.dart` / `collection_command_bar.dart`
5. 없음

## 현재 상태
- 보드: `refreshIntervalSeconds`로 Timer. 끔이면 자동 없음.
- Trace: 화면 진입 시 고정 2초 `startPolling`, 주기 필터와 무관.

## 바꿀 것
1. `PipelineTraceViewModel`: 고정 2초 제거. `applyRefreshInterval(seconds)` — `<=0`이면 폴링 중지(적용 시 1회 refresh는 유지), `>0`이면 그 초로 periodic.
2. 스크린에서 보드 `refreshIntervalSeconds` 변경을 Trace에 동기화(리스너/바인더). 생성 시 `startPolling()` 단독 호출 제거.
3. 커맨드바 「새로고침」: `didTapReload` + Trace `refresh()` 1회.
4. 관련 테스트·`./scripts/agent_check.sh` 통과.

## 유지할 것
- ComboBox 옵션(끔/5초/1분), 보드 `_restartTimer` 동작
- Trace GetTrace 보강 로직

## 이번 작업에서 만들지 않음
- Trace 전용 주기 UI, 새 상태관리, 보드·Trace VM 병합

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
- 주기 5초/1분이면 Trace도 같은 간격으로 조회, 끔이면 자동 폴링 중지
- 새로고침 버튼이 Trace도 1회 갱신한다
