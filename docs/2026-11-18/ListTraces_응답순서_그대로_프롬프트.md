# ListTraces 응답 순서 그대로 표시

## 목표
FE에서 RUNNING→FAILED→DONE으로 다시 쌓지 않고, `ListTraces`가 준 순서(새것부터) 그대로 UI에 그린다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart` `visibleTraces`
3. `test/list_traces_response_mapping_test.dart`
4. 계약: `protos/mediatag/trace/v1/trace.proto` ListTraces「새것부터」

## 현재 상태
- `visibleTraces`가 `_traces`를 running / failed / done으로 나눠 `[...running, ...failed, ...done]`으로 반환.
- `PipelineTraceList`·스테퍼 집계·단계 탭 시 `visibleTraces.first`가 이 순서를 사용.

## 바꿀 것
1. `pipeline_trace_view_model.dart`: `visibleTraces`를 `List.unmodifiable(_traces)`로 바꾸고 주석을「ListTraces 순서(새것부터)」로 수정. 상태별 버킷 재정렬 코드 제거.
2. `list_traces_response_mapping_test.dart`: DONE 포함 유지 테스트는 유지. 응답에 RUNNING이 DONE보다 뒤에 있어도 `visibleTraces`가 응답 인덱스 순서와 같음을 검증.

## 유지할 것
- `listTraces(pageSize: 80)` · GetTrace 보강 · `pollSignature` · `runningCount`/`doneCount`/`failedCount` 집계 필드
- 스테퍼의 상태 시각 우선순위(실패>진행>완료) — 목록 순서와 별개
- `PipelineTraceList` 위젯 자체 레이아웃

## 이번 작업에서 만들지 않음
- RUNNING 전용 API 필터 UI, 목록 위젯 디자인 변경, 광범위 리팩터

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh test/list_traces_response_mapping_test.dart` 통과
- 목록 위→아래가 ListTraces 응답과 같은 순서(새것부터)
- 칩·스테퍼 집계 숫자는 이전과 동일하게 동작
