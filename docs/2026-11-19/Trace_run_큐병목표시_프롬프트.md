# Trace.run 큐 병목 표시 (GetQueue 제거)

## 목표
적재 파이프라인에서 `RunService/GetQueue`를 치지 않고, 이미 폴링하는 ListTraces/GetTrace의 `Trace.run`·`Trace.run.queue`로 큐별 병목(실행/대기 수)과 선택 여정의 같은 큐 앞 작업 진행률을 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `protos/mediatag/trace/v1/trace.proto` · `protos/mediatag/run/v1/run.proto` Run/RunWait
3. `pipeline_trace_view_model.dart` · `pipeline_trace_tab_body.dart` · `pipeline_trace_list.dart`
4. `tool_run.dart` `queueWaitLabel`

## 현재 상태
- VM이 폴링마다 GetQueue를 친다. 앞줄 UI는 제거됨.
- 목록/선택 요약은 `queueWaitLabel`만 표시.
- RUNNING enrich(GetTrace)로 `trace.run`은 이미 붙는다.

## 바꿀 것
1. VM에서 GetQueue 호출·`ToolRunUseCase` 의존·queue front 상태를 제거한다.
2. 도메인에 최근 Trace 목록의 `run.queue`로 큐별 running/waiting 집계·같은 큐 앞줄(오래된 순, 진행률) 헬퍼를 둔다.
3. 탭 본문에 GetQueue 없는 **큐 병목** 요약(큐별 진행/대기)과, 선택 시 같은 큐 in-progress의 진행률 목록을 표시한다.
4. 목록/요약은 `Trace.run` 기준 라벨(대기 wait · 진행 % )을 유지·보강한다.
5. GetQueue VM 테스트는 Trace.run 집계 테스트로 교체·정리. locator·관련 테스트 DI 정리.
6. `./scripts/agent_check.sh` + 관련 테스트.

## 유지할 것
- ListTraces + RUNNING GetTrace 폴링
- 스테퍼·칩·점등 로직
- UseCase/Repository의 getQueue API 자체(다른 곳용)는 삭제 강제하지 않음. 파이프라인에서는 호출하지 않음.

## 이번 작업에서 만들지 않음
- 새 GetQueue UI 복원
- 새 화면/라우트/상태관리
- generated 수정

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 파이프라인 폴링에 GetQueue 요청 없음
- 큐별 진행/대기 수가 Trace.run 집계로 보임
- 선택 시 같은 queue의 앞/동료 run 진행률이 보임
- `./scripts/agent_check.sh` (+테스트) 통과
