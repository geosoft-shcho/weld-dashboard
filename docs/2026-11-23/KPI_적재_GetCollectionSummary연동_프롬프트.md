# KPI 적재 GetCollectionSummary 연동

## 목표
적재 진행·실패 KPI를 `GetCollectionSummaryResponse.trace_running_count` · `trace_failed_count`로 바인딩한다. ListTraces status별 total_count 호출을 KPI에서 제거한다.

## 먼저 읽을 것
- `protos/mediatag/work/v1/work.proto` `GetCollectionSummaryResponse`
- `lib/src/presentation/features/collection_monitoring/collection_monitoring_view_model.dart`
- `lib/src/data/repositories/remote_collection_catalog_repository.dart`

## 현재 상태
- KPI 적재는 ViewModel이 ListTraces(RUNNING/DONE/FAILED)를 세 번 호출한다.
- 생성 코드에 `traceRunningCount` · `traceFailedCount`가 이미 있다. repository는 `summary`만 반환한다.

## 바꿀 것
1. repository·use case가 summary와 함께 `traceRunningCount` · `traceFailedCount`를 반환(0이면 JSON 칸 없음 → proto 기본 0).
2. ViewModel KPI는 그 값만 쓰고 ListTraces 건수 호출·DONE 건수를 제거한다. TraceUseCase가 VM에서 더 안 쓰이면 DI에서 뺀다.
3. 카드: value=진행, subtitle=`실패 N`. DONE 문구 제거.
4. 실패 목록 UI는 기존처럼 ListTraces(FAILED) 유지(PipelineTrace).

## 유지할 것
- GetCollectionSummary 로드 타이밍(진입·리셋·작업자 변경·자동갱신)
- parent·worker_id는 summary용. 적재 건수는 서버가 늘 전체로 줌

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
- KPI 적재가 GetCollectionSummary 한 번으로 채워짐
