# GetTrace 파이프라인 실시간 상태 연동

## 목표
가이드·화면검증의 FE 폴링 모델에 맞게, `ListTraces`만으로 목록을 유지하던 흐름에 기존 `TraceUseCase.getTrace`(TraceService GetTrace)를 붙여 **파이프라인(여정)별 실시간 상태(이벤트 포함)** 가 칩·스테퍼·목록·상세에 반영되게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-17/파이프라인 실시간 조회 가이드.md` (FE는 BE API 폴링; Redis 직접 조회 없음)
4. `docs/2026-11-17/수집모니터링_Trace파이프라인_화면검증.md` §9 데이터·폴링
5. `protos/mediatag/trace/v1/trace.proto` (ListTraces = 요약, GetTrace = Trace+events)
6. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
7. `lib/src/domain/use_cases/trace_use_case.dart`
8. `lib/src/data/repositories/remote_trace_repository.dart`

## 현재 상태
- 폴링(2초)마다 `listTraces(pageSize: 80)`만 목록 `_traces`에 넣는다. ListTraces는 events가 없다.
- `getTrace`는 **선택된** `traceId`에만 `_loadSelection`에서 호출된다. 미선택 RUNNING은 last_event 요약만으로 집계·경로를 그린다.
- `TraceUseCase` / `RemoteTraceRepository.getTrace` / `pollSignature`(events 포함)는 이미 있다.
- 가이드의 Redis live API는 이 앱 범위가 아니다. 지금 구현된 TraceService만 쓴다.

## 가정 (요청·가이드 기준)
- 실시간 상세는 GetTrace의 `events`로 본다. ListTraces는 여정 목록·상태 스냅샷용이다.
- GetTrace 대상은 **RUNNING 전부 + 현재 선택(있으면)** 이다. 미선택 DONE/FAILED는 ListTraces 요약으로 두고, 이미 GetTrace로 받아 둔 events가 있으면 같은 `traceId`에 한해 다음 폴링에서 유지한다(경로가 갑자기 비지 않게).
- 개별 GetTrace 실패는 그 건만 ListTraces(또는 직전 유지)로 두고 전체 폴링을 깨지 않는다.
- Redis / 별도 live HTTP API / SSE는 만들지 않는다.

## 바꿀 것
1. `PipelineTraceViewModel.refresh`: ListTraces 후 RUNNING(+선택)에 대해 기존 `_traceUseCase.getTrace`를 병렬 호출하고, 성공 결과를 `_traces`에 병합한다(같은 `traceId`는 GetTrace 스냅샷이 ListTraces보다 우선).
2. 선택 상세는 지금처럼 GetTrace + (queue 있으면) GetQueue를 유지한다. 목록 보강용 GetTrace와 중복 호출이 나도 새 추상 계층 없이 ViewModel 안에서만 처리한다(필요하면 한 번 받은 detail을 선택에도 재사용).
3. `pollSignature` 기반 `notifyListeners` 스킵은 유지한다. events가 바뀌면 갱신된다.
4. ViewModel 단위 테스트로 “ListTraces 후 RUNNING에 getTrace가 호출되고 events가 목록에 붙는지”를 고정한다(가짜 TraceUseCase/Repository).
5. `./scripts/agent_check.sh` (+관련 테스트) 통과.

## 유지할 것
- TraceService Connect·생성 코드·UseCase API 시그니처
- 폴링 주기 2초, pageSize 80, status 비움 ListTraces
- 가로 스테퍼·목록 UI 구조(이번 작업은 데이터 연동만)
- GetQueue는 선택 건·run.queue 있을 때만

## 이번 작업에서 만들지 않음
- Redis/live REST·SSE·WebSocket
- 새 Repository 메서드·배치 GetTraces RPC·추상 계층
- proto 재생성, UI 레이아웃 재설계
- DONE/FAILED 전체에 대한 매 폴링 GetTrace

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
- `./scripts/agent_check.sh test/pipeline_trace_view_model_get_trace_test.dart`(또는 동등 경로) 통과
- 폴링 시 RUNNING 여정마다 GetTrace가 나가고, 칩/스테퍼/목록이 events 기준 경로·상태를 쓴다
- 선택 시 상세 패널 events·대기열이 기존처럼 동작한다
