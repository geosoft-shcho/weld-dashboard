# GetTrace 디버그 로그

## 목표
`TraceService/GetTrace` 호출·응답을 debug에서만 짧게 남겨, 목록 선택·폴링 enrich와 Network를 맞출 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/data/repositories/remote_trace_repository.dart`
4. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
5. 없음

## 현재 상태
- GetTrace 호출에 전용 debug 로그가 없다. 폴링 칸 로그(`[pipeline] id=… events=…`)만 있다.

## 바꿀 것
1. `remote_trace_repository.dart` `getTrace`: kDebugMode에서 요청 `traceId`, 성공 시 lastEvent·status·events 수·progress, 실패 시 메시지 한 줄 (`[GetTrace]`).
2. `pipeline_trace_view_model.dart`: GetTrace를 치는 경로(선택 / enrich)에서 reason과 id를 debug 한 줄.

## 유지할 것
- GetTrace 동작·선택 시 항상 호출·폴링 enrich

## 이번 작업에서 만들지 않음
- 로거 패키지, release print, ListTraces 전용 로그 확장

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
- debug 실행 시 GetTrace 요청/응답 로그가 보인다
