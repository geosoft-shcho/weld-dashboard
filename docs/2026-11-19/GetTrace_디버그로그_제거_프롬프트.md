# GetTrace·pipeline 디버그 로그 제거

## 목표
`remote_trace_repository.dart`와 `pipeline_trace_view_model.dart`의 `[GetTrace]`/`[pipeline]` 디버그 출력과 관련 `kDebugMode` 분기·`_debugLogLitCells`를 제거한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/data/repositories/remote_trace_repository.dart`
4. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
5. 없음

## 현재 상태
- repository `getTrace`에 `[GetTrace]` debugPrint
- ViewModel enrich/select/`_debugLogLitCells`에 `[GetTrace]`·`[pipeline]` debugPrint

## 바꿀 것
1. 위 디버그 분기·메서드·불필요해진 `foundation` import를 제거한다.
2. GetTrace·폴링·선택 동작은 유지한다.

## 유지할 것
- ListTraces / GetTrace / enrich / didSelectTrace 동작

## 이번 작업에서 만들지 않음
- 다른 파일 로그 정리, 로거 도입

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
- 해당 두 파일에 debugPrint/`[GetTrace]`/`[pipeline]` 없음
